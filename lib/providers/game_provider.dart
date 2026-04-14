import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/enums.dart';
import '../models/building_model.dart';
import '../data/json_loader.dart';

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(super.initialState);

  // --- Dev mode ---
  bool _devMode = false;
  bool get devMode => _devMode;

  void setDevMode(bool enabled) {
    _devMode = enabled;
    if (enabled) {
      state = state.copyWith(money: 999999999);
    }
  }

  void addMoney(double amount) {
    state = state.copyWith(
      money: state.money + amount,
      totalEarned: state.totalEarned + (amount > 0 ? amount : 0),
    );
    checkSectorUnlock();
  }

  bool spendMoney(double amount) {
    if (_devMode) return true; // dev: para hiç düşmesin
    if (state.money < amount) return false;
    state = state.copyWith(money: state.money - amount);
    return true;
  }

  void addDiamonds(int amount) {
    state = state.copyWith(diamonds: state.diamonds + amount);
  }

  bool spendDiamonds(int amount) {
    if (state.diamonds < amount) return false;
    state = state.copyWith(diamonds: state.diamonds - amount);
    return true;
  }

  /// Kaç adet sahip olunduğuna göre satın alma maliyeti
  double purchaseCostFor(String buildingType) {
    final data = JsonLoader.getBuildingData(buildingType);
    if (data == null) return 0;
    final owned = state.buildings.values
        .where((b) => b.type.name == buildingType)
        .length;
    return data.purchaseCost(owned);
  }

  /// Belirli tarifte kaç bina çalışıyorsa ona göre tarif maliyeti
  double recipeCostFor(String recipeId) {
    final recipe = JsonLoader.recipes
        .where((r) => r.recipeId == recipeId)
        .firstOrNull;
    if (recipe == null || recipe.recipeCost <= 0) return 0;
    final usingCount = state.buildings.values
        .where((b) => b.selectedRecipeId == recipeId)
        .length;
    return recipe.recipeCost * math.pow(1.5, usingCount);
  }

  /// Bina satın al — ID döndürür, hata durumunda null
  String? purchaseBuilding(String buildingType) {
    final data = JsonLoader.getBuildingData(buildingType);
    if (data == null) return null;
    final cost = purchaseCostFor(buildingType);
    if (!spendMoney(cost)) return null;

    final id = '${buildingType}_${DateTime.now().millisecondsSinceEpoch}';
    final updated = Map<String, BuildingModel>.from(state.buildings);
    updated[id] = BuildingModel(
      id: id,
      type: BuildingType.values.byName(buildingType),
      level: 1,
      isUnlocked: true,
      localMaxStock: data.baseLocalStock,
    );
    state = state.copyWith(buildings: updated);
    return id;
  }

  /// Binaya tarif ata (para öder, refund yok)
  bool assignRecipe(String buildingId, String recipeId) {
    final building = state.buildings[buildingId];
    if (building == null) return false;
    final cost = recipeCostFor(recipeId);
    if (cost > 0 && !spendMoney(cost)) return false;

    final updated = Map<String, BuildingModel>.from(state.buildings);
    updated[buildingId] = building.copyWith(
      selectedRecipeId: recipeId,
      status: BuildingStatus.idle,
    );
    state = state.copyWith(buildings: updated);
    return true;
  }

  /// Depoyu yükselt
  bool upgradeWarehouse() {
    final cost = state.nextWarehouseUpgradeCost;
    if (cost == null) return false;
    if (!spendMoney(cost)) return false;
    state = state.copyWith(warehouseLevel: state.warehouseLevel + 1);
    return true;
  }

  bool unlockBuilding(String buildingId, BuildingType type) {
    final buildingData = JsonLoader.getBuildingData(type.name);
    if (buildingData == null) return false;
    if (!spendMoney(buildingData.baseCost)) return false;

    final updated = Map<String, BuildingModel>.from(state.buildings);
    updated[buildingId] = BuildingModel(
      id: buildingId,
      type: type,
      level: 1,
      isUnlocked: true,
      localMaxStock: buildingData.baseLocalStock,
    );
    state = state.copyWith(buildings: updated);
    return true;
  }

  bool upgradeBuilding(String buildingId) {
    final building = state.buildings[buildingId];
    if (building == null) return false;
    final buildingData = JsonLoader.getBuildingData(building.type.name);
    if (buildingData == null) return false;

    final cost = building.upgradeCost(buildingData.baseCost);
    if (!spendMoney(cost)) return false;

    final updated = Map<String, BuildingModel>.from(state.buildings);
    updated[buildingId] = building.copyWith(level: building.level + 1);
    state = state.copyWith(buildings: updated);
    return true;
  }

  bool assignManager(String buildingId, ManagerLevel level) {
    final building = state.buildings[buildingId];
    if (building == null) return false;

    final updated = Map<String, BuildingModel>.from(state.buildings);
    updated[buildingId] = building.copyWith(managerLevel: level);
    state = state.copyWith(buildings: updated);
    return true;
  }

  void checkSectorUnlock() {
    final thresholds = {
      SectorType.production:  50000.0,
      SectorType.logistics:   500000.0,
      SectorType.trade:       5000000.0,
      SectorType.finance:     50000000.0,
      SectorType.technology:  500000000.0,
    };

    final current = List<SectorType>.from(state.activeSectors);
    bool changed = false;
    for (final entry in thresholds.entries) {
      if (!current.contains(entry.key) && state.totalEarned >= entry.value) {
        current.add(entry.key);
        changed = true;
      }
    }
    if (changed) state = state.copyWith(activeSectors: current);
  }

  void updateBuilding(String id, BuildingModel updated) {
    final buildings = Map<String, BuildingModel>.from(state.buildings);
    buildings[id] = updated;
    state = state.copyWith(buildings: buildings);
  }

  void setOfflineStart(DateTime time) {
    state = state.copyWith(offlineStartTime: time);
  }

  void loadState(GameState loaded) {
    state = loaded;
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier(GameState());
});
