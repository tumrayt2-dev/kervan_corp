import '../models/building_model.dart';
import '../models/enums.dart';
import '../data/json_loader.dart';
import 'inventory_service.dart';

class BuildingTimer {
  double elapsed = 0;
  double processingTime;
  String? activeRecipeId;

  BuildingTimer({required this.processingTime, this.activeRecipeId});
}

class ProductionService {
  // Kalıcı timer state — dışarıdan erişilebilir
  final Map<String, BuildingTimer> timers = {};

  // --- Timer yönetimi ---

  void ensureTimer(BuildingModel building) {
    if (timers.containsKey(building.id)) return;
    final time = calcProcessingTime(building);
    final recipe = getFirstRecipe(building);
    timers[building.id] = BuildingTimer(
      processingTime: time,
      activeRecipeId: recipe?.recipeId,
    );
  }

  double getProgress(String buildingId) {
    final t = timers[buildingId];
    if (t == null || t.processingTime <= 0) return 0;
    return (t.elapsed / t.processingTime).clamp(0.0, 1.0);
  }

  double getProductionRatePerHour(BuildingModel building) {
    final recipe = getFirstRecipe(building);
    if (recipe == null) return 0;
    final time = calcProcessingTime(building);
    if (time <= 0) return 0;
    final batchesPerHour = 3600 / time;
    return batchesPerHour * recipe.outputs.fold(0.0, (s, o) => s + o.quantity);
  }

  /// Seçili tarife göre ürün adını döndürür (tek output varsayılır)
  ProductType? getOutputProduct(BuildingModel building) {
    final recipe = getFirstRecipe(building);
    if (recipe == null || recipe.outputs.isEmpty) return null;
    return recipe.outputs.first.productType;
  }

  // --- Ana tick ---
  /// Döndürür: bina durumu değişiklikleri (buildingId → yeni status)
  Map<String, BuildingStatus> tick(
    Map<String, BuildingModel> buildings,
    InventoryService invService,
    double deltaTime,
  ) {
    final changes = <String, BuildingStatus>{};

    for (final entry in buildings.entries) {
      final building = entry.value;
      if (!building.isUnlocked) continue;

      if (!building.hasManager) {
        if (building.status != BuildingStatus.idle) {
          changes[building.id] = BuildingStatus.idle;
        }
        continue;
      }

      ensureTimer(building);
      final timer = timers[building.id]!;

      // Süreyi level değişimiyle güncelle
      final currentTime = calcProcessingTime(building);
      if ((currentTime - timer.processingTime).abs() > 0.01) {
        timer.processingTime = currentTime;
      }

      timer.elapsed += deltaTime;

      if (timer.elapsed < timer.processingTime) {
        if (building.status != BuildingStatus.producing) {
          changes[building.id] = BuildingStatus.producing;
        }
        continue;
      }

      final newStatus = tryProduce(building, timer, invService);
      if (newStatus != building.status) changes[building.id] = newStatus;
      if (newStatus == BuildingStatus.producing) timer.elapsed = 0;
    }

    return changes;
  }

  // --- Manuel tetikleme ---
  BuildingStatus manualTrigger(
      BuildingModel building, InventoryService invService) {
    ensureTimer(building);
    final timer = timers[building.id]!;
    final result = tryProduce(building, timer, invService);
    if (result == BuildingStatus.producing) timer.elapsed = 0;
    return result;
  }

  // --- Offline hesaplama ---
  Map<String, double> calculateOffline(
    Map<String, BuildingModel> buildings,
    InventoryService invService,
    Duration elapsed,
  ) {
    const maxOffline = Duration(hours: 12);
    final effectiveSec = elapsed > maxOffline
        ? maxOffline.inSeconds.toDouble()
        : elapsed.inSeconds.toDouble();

    final totals = <String, double>{};

    for (final building in buildings.values) {
      if (!building.isUnlocked || !building.hasManager) continue;
      final recipe = getFirstRecipe(building);
      if (recipe == null) continue;
      final time = calcProcessingTime(building);
      if (time <= 0) continue;

      int batches = (effectiveSec / time).floor();
      if (batches <= 0) continue;

      if (recipe.inputs.isEmpty) {
        for (final out in recipe.outputs) {
          final maxAdd =
              invService.inventory.slots[out.productType]?.available ?? 0;
          final produced = (out.quantity * batches).clamp(0.0, maxAdd);
          if (produced > 0) {
            invService.addToInventory(out.productType, produced);
            totals[out.productType.name] =
                (totals[out.productType.name] ?? 0) + produced;
          }
        }
      } else {
        for (final inp in recipe.inputs) {
          final maxBatches =
              (invService.getAvailableQty(inp.productType) / inp.quantity)
                  .floor();
          if (maxBatches < batches) batches = maxBatches;
        }
        if (batches <= 0) continue;
        for (final inp in recipe.inputs) {
          invService.removeFromInventory(
              inp.productType, inp.quantity * batches);
        }
        for (final out in recipe.outputs) {
          final qty = out.quantity * batches;
          invService.addToInventory(out.productType, qty);
          totals[out.productType.name] =
              (totals[out.productType.name] ?? 0) + qty;
        }
      }
    }

    return totals;
  }

  // --- Yardımcı ---

  BuildingStatus tryProduce(
    BuildingModel building,
    BuildingTimer timer,
    InventoryService invService,
  ) {
    final recipe = getFirstRecipe(building);
    if (recipe == null) return BuildingStatus.idle;

    for (final inp in recipe.inputs) {
      if (invService.getAvailableQty(inp.productType) < inp.quantity) {
        return BuildingStatus.waitingInput;
      }
    }

    for (final inp in recipe.inputs) {
      invService.removeFromInventory(inp.productType, inp.quantity);
    }

    for (final out in recipe.outputs) {
      final ok = invService.addToInventory(out.productType, out.quantity);
      if (!ok) {
        for (final inp in recipe.inputs) {
          invService.addToInventory(inp.productType, inp.quantity);
        }
        return BuildingStatus.storageFull;
      }
    }

    return BuildingStatus.producing;
  }

  double calcProcessingTime(BuildingModel building) {
    final data = JsonLoader.getBuildingData(building.type.name);
    if (data == null) return 10;
    final speedBonus = 1 + (building.level - 1) * data.levelBonus;
    return data.baseProductionTimeSec / speedBonus / building.managerMultiplier;
  }

  ProductionRecipe? getFirstRecipe(BuildingModel building) {
    final recipes = JsonLoader.getRecipesForBuilding(building.type.name);
    if (recipes.isEmpty) return null;
    if (building.selectedRecipeId != null) {
      final match = recipes.where((r) => r.recipeId == building.selectedRecipeId).firstOrNull;
      if (match != null) return match;
    }
    return recipes.first;
  }
}
