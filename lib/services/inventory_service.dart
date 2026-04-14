import '../models/inventory_model.dart';
import '../models/enums.dart';
import '../data/json_loader.dart';

class InventoryService {
  final Inventory inventory;

  InventoryService(this.inventory);

  bool addToInventory(ProductType type, double qty) {
    final product = JsonLoader.getProduct(type);
    if (product == null) return false;
    return inventory.addProduct(type, qty, product.weight);
  }

  bool removeFromInventory(ProductType type, double qty) {
    return inventory.removeProduct(type, qty);
  }

  double sellFromInventory(ProductType type, double qty, SaleChannel channel) {
    final product = JsonLoader.getProduct(type);
    if (product == null) return 0;
    if (!removeFromInventory(type, qty)) return 0;
    final revenue = product.salePrice(channel) * qty;
    _recalcTotalWeight();
    return revenue;
  }

  bool reserveForContract(ProductType type, double qty) {
    return inventory.reserveForContract(type, qty);
  }

  void releaseReserve(ProductType type, double qty) {
    inventory.releaseReserve(type, qty);
  }

  double getAvailableQty(ProductType type) {
    return inventory.slots[type]?.available ?? 0;
  }

  double getTotalValue() {
    final prices = {
      for (final p in JsonLoader.products) p.type: p.baseValue
    };
    return inventory.getTotalValue(prices);
  }

  double getFillPercent() {
    _recalcTotalWeight();
    return inventory.getFillPercent();
  }

  void _recalcTotalWeight() {
    double total = 0;
    for (final entry in inventory.slots.entries) {
      final product = JsonLoader.getProduct(entry.key);
      if (product != null) {
        total += entry.value.quantity * product.weight;
      }
    }
    inventory.totalWeight = total;
  }
}
