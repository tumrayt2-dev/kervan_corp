import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/enums.dart';
import '../services/production_service.dart';
import '../services/inventory_service.dart';
import 'game_provider.dart';
import 'inventory_provider.dart';

// Kalıcı ProductionService — uygulama boyunca tek instance
final productionServiceProvider = Provider<ProductionService>((ref) {
  return ProductionService();
});

// Toplam gelir/saat tahmini
final incomePerHourProvider = Provider<double>((ref) {
  final buildings = ref.watch(gameProvider).buildings;
  final service = ref.watch(productionServiceProvider);
  double total = 0;
  for (final b in buildings.values) {
    if (b.isUnlocked) total += service.getProductionRatePerHour(b);
  }
  return total;
});

// Bina progress'i (0.0 – 1.0)
double getBuildingProgress(WidgetRef ref, String buildingId) {
  return ref.read(productionServiceProvider).getProgress(buildingId);
}

// Manuel tetikleme — artık sadece timer'ı başlatır, üretim tick'te tamamlanır
BuildingStatus manualTrigger(WidgetRef ref, String buildingId) {
  final building = ref.read(gameProvider).buildings[buildingId];
  if (building == null) return BuildingStatus.idle;

  final service = ref.read(productionServiceProvider);
  final inventory = ref.read(inventoryProvider);
  final invService = InventoryService(inventory);

  final result = service.manualTrigger(building, invService);
  // Durumu güncelle (producing / waitingInput / storageFull)
  ref.read(gameProvider.notifier).updateBuilding(
        buildingId,
        building.copyWith(status: result),
      );
  return result;
}

// Game loop tick — GameScreen'den her frame çağrılır
void productionTick(WidgetRef ref, double deltaTime) {
  final gameNotifier = ref.read(gameProvider.notifier);
  final buildings = ref.read(gameProvider).buildings;
  final inventory = ref.read(inventoryProvider);
  final service = ref.read(productionServiceProvider);
  final invService = InventoryService(inventory);

  final changes = service.tick(buildings, invService, deltaTime);

  bool inventoryChanged = false;
  for (final entry in changes.entries) {
    final building = buildings[entry.key];
    if (building != null) {
      gameNotifier.updateBuilding(entry.key, building.copyWith(status: entry.value));
      if (entry.value == BuildingStatus.producing) inventoryChanged = true;
    }
  }

  if (inventoryChanged) {
    ref.read(inventoryProvider.notifier).notifyChanged();
  }
}
