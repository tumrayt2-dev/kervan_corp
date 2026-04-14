import 'enums.dart';

class InventorySlot {
  final ProductType productType;
  double quantity;
  double maxCapacity;
  double reservedQty;

  InventorySlot({
    required this.productType,
    this.quantity = 0,
    required this.maxCapacity,
    this.reservedQty = 0,
  });

  double get available => quantity - reservedQty;
  bool get isFull => quantity >= maxCapacity;
  double get fillPercent => maxCapacity > 0 ? quantity / maxCapacity : 0;

  InventorySlot copyWith({
    double? quantity,
    double? maxCapacity,
    double? reservedQty,
  }) {
    return InventorySlot(
      productType: productType,
      quantity: quantity ?? this.quantity,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      reservedQty: reservedQty ?? this.reservedQty,
    );
  }

  Map<String, dynamic> toJson() => {
    'productType': productType.name,
    'quantity': quantity,
    'maxCapacity': maxCapacity,
    'reservedQty': reservedQty,
  };

  factory InventorySlot.fromJson(Map<String, dynamic> json) => InventorySlot(
    productType: ProductType.values.byName(json['productType'] as String),
    quantity: (json['quantity'] as num).toDouble(),
    maxCapacity: (json['maxCapacity'] as num).toDouble(),
    reservedQty: (json['reservedQty'] as num).toDouble(),
  );
}

class Inventory {
  final Map<ProductType, InventorySlot> slots;
  double maxTotalWeight;

  Inventory({
    required this.slots,
    this.maxTotalWeight = 10000,
  });

  bool addProduct(ProductType type, double qty, double weight) {
    final slot = slots[type];
    if (slot == null) return false;
    if (slot.quantity + qty > slot.maxCapacity) return false;
    if (totalWeight + qty * weight > maxTotalWeight) return false;
    slot.quantity += qty;
    return true;
  }

  bool removeProduct(ProductType type, double qty) {
    final slot = slots[type];
    if (slot == null) return false;
    if (slot.available < qty) return false;
    slot.quantity -= qty;
    return true;
  }

  bool reserveForContract(ProductType type, double qty) {
    final slot = slots[type];
    if (slot == null) return false;
    if (slot.available < qty) return false;
    slot.reservedQty += qty;
    return true;
  }

  void releaseReserve(ProductType type, double qty) {
    final slot = slots[type];
    if (slot == null) return;
    slot.reservedQty = (slot.reservedQty - qty).clamp(0, double.infinity);
  }

  double totalWeight = 0;

  double getTotalValue(Map<ProductType, double> basePrices) {
    double total = 0;
    for (final entry in slots.entries) {
      total += entry.value.quantity * (basePrices[entry.key] ?? 0);
    }
    return total;
  }

  double getFillPercent() {
    return maxTotalWeight > 0 ? totalWeight / maxTotalWeight : 0;
  }

  Map<String, dynamic> toJson() => {
    'slots': slots.map((k, v) => MapEntry(k.name, v.toJson())),
    'maxTotalWeight': maxTotalWeight,
    'totalWeight': totalWeight,
  };

  factory Inventory.fromJson(Map<String, dynamic> json) {
    final slotsJson = json['slots'] as Map<String, dynamic>;
    final slots = <ProductType, InventorySlot>{};
    for (final entry in slotsJson.entries) {
      final type = ProductType.values.byName(entry.key);
      slots[type] = InventorySlot.fromJson(entry.value as Map<String, dynamic>);
    }
    return Inventory(
      slots: slots,
      maxTotalWeight: (json['maxTotalWeight'] as num).toDouble(),
    )..totalWeight = (json['totalWeight'] as num).toDouble();
  }
}
