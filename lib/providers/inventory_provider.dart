import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/inventory_model.dart';
import '../models/enums.dart';
import '../services/inventory_service.dart';

class InventoryNotifier extends StateNotifier<Inventory> {
  late InventoryService _service;

  InventoryNotifier(super.initialState) {
    _service = InventoryService(state);
  }

  bool addToInventory(ProductType type, double qty) {
    final result = _service.addToInventory(type, qty);
    state = Inventory(slots: state.slots, maxTotalWeight: state.maxTotalWeight)
      ..totalWeight = state.totalWeight;
    return result;
  }

  bool removeFromInventory(ProductType type, double qty) {
    final result = _service.removeFromInventory(type, qty);
    _refresh();
    return result;
  }

  double sellFromInventory(ProductType type, double qty, SaleChannel channel) {
    final revenue = _service.sellFromInventory(type, qty, channel);
    _refresh();
    return revenue;
  }

  bool reserveForContract(ProductType type, double qty) {
    final result = _service.reserveForContract(type, qty);
    _refresh();
    return result;
  }

  void releaseReserve(ProductType type, double qty) {
    _service.releaseReserve(type, qty);
    _refresh();
  }

  double getAvailableQty(ProductType type) => _service.getAvailableQty(type);
  double getTotalValue() => _service.getTotalValue();
  double getFillPercent() => _service.getFillPercent();

  void loadInventory(Inventory loaded) {
    state = loaded;
    _service = InventoryService(state);
  }

  void updateMaxCapacity(double newMax) {
    state = Inventory(slots: state.slots, maxTotalWeight: newMax)
      ..totalWeight = state.totalWeight;
    _service = InventoryService(state);
  }

  /// Dışarıdan (üretim motoru gibi) inventory mutasyonu yapıldıktan
  /// sonra Riverpod'u yeniden tetiklemek için çağrılır.
  void notifyChanged() => _refresh();

  // Riverpod'u yeni state nesnesiyle tetikle
  void _refresh() {
    state = Inventory(slots: state.slots, maxTotalWeight: state.maxTotalWeight)
      ..totalWeight = state.totalWeight;
  }
}

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, Inventory>((ref) {
  return InventoryNotifier(Inventory(slots: {}));
});
