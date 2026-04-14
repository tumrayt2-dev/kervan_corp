import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_state.dart';
import '../models/enums.dart';
import '../models/building_model.dart';
import '../data/json_loader.dart';

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(super.initialState);

  void addMoney(double amount) {
    state = state.copyWith(
      money: state.money + amount,
      totalEarned: state.totalEarned + (amount > 0 ? amount : 0),
    );
    checkSectorUnlock();
  }

  bool spendMoney(double amount) {
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
