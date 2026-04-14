import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/game_state.dart';
import '../models/inventory_model.dart';
import '../models/enums.dart';
import '../data/json_loader.dart';

class SaveService {
  static const _playerKey = 'game_state';
  static const _inventoryKey = 'inventory';
  static const _playerBackupKey = 'game_state_backup';
  static const _inventoryBackupKey = 'inventory_backup';

  static Box get _playerBox => Hive.box('player');
  static Box get _inventoryBox => Hive.box('inventory');

  static bool get hasSave => _playerBox.containsKey(_playerKey);

  static GameState createNewGame() {
    return GameState(
      money: 10000.0,
      buildings: {},
      activeSectors: [SectorType.agriculture],
      warehouseLevel: 0,
    );
  }

  static Inventory createNewInventory() {
    final config = JsonLoader.inventoryConfig;
    final slots = <ProductType, InventorySlot>{};

    for (final product in JsonLoader.products) {
      final defaultCap = config != null
          ? (config.defaultSlotCapacities[product.category.name] ?? 500.0)
          : 500.0;
      slots[product.type] = InventorySlot(
        productType: product.type,
        maxCapacity: defaultCap,
      );
    }

    return Inventory(
      slots: slots,
      maxTotalWeight: config?.startingMaxTotalWeight ?? 10000,
    );
  }

  static Future<void> saveAll(GameState state, Inventory inventory) async {
    await backup();
    await _playerBox.put(_playerKey, jsonEncode(state.toJson()));
    await _inventoryBox.put(_inventoryKey, jsonEncode(inventory.toJson()));
  }

  static Future<void> backup() async {
    final existing = _playerBox.get(_playerKey);
    final existingInv = _inventoryBox.get(_inventoryKey);
    if (existing != null) await _playerBox.put(_playerBackupKey, existing);
    if (existingInv != null) await _inventoryBox.put(_inventoryBackupKey, existingInv);
  }

  static (GameState, Inventory)? loadGame() {
    try {
      final stateRaw = _playerBox.get(_playerKey) as String?;
      final invRaw = _inventoryBox.get(_inventoryKey) as String?;
      if (stateRaw == null || invRaw == null) return null;

      final state = GameState.fromJson(jsonDecode(stateRaw) as Map<String, dynamic>);
      final inventory = Inventory.fromJson(jsonDecode(invRaw) as Map<String, dynamic>);
      return (state, inventory);
    } catch (e) {
      if (kDebugMode) debugPrint('SaveService.loadGame hata: $e');
      return null;
    }
  }

  static Future<void> deleteSave() async {
    await _playerBox.clear();
    await _inventoryBox.clear();
  }
}
