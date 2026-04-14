import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/product_model.dart';
import '../models/enums.dart';

class RecipeInput {
  final ProductType productType;
  final double quantity;
  const RecipeInput({required this.productType, required this.quantity});

  factory RecipeInput.fromJson(Map<String, dynamic> json) => RecipeInput(
    productType: ProductType.values.byName(json['productType'] as String),
    quantity: (json['quantity'] as num).toDouble(),
  );
}

class RecipeOutput {
  final ProductType productType;
  final double quantity;
  const RecipeOutput({required this.productType, required this.quantity});

  factory RecipeOutput.fromJson(Map<String, dynamic> json) => RecipeOutput(
    productType: ProductType.values.byName(json['productType'] as String),
    quantity: (json['quantity'] as num).toDouble(),
  );
}

class ProductionRecipe {
  final String buildingType;
  final String recipeId;
  final double processingTimeSec;
  final List<RecipeInput> inputs;
  final List<RecipeOutput> outputs;

  const ProductionRecipe({
    required this.buildingType,
    required this.recipeId,
    required this.processingTimeSec,
    required this.inputs,
    required this.outputs,
  });

  factory ProductionRecipe.fromJson(Map<String, dynamic> json) => ProductionRecipe(
    buildingType: json['buildingType'] as String,
    recipeId: json['recipeId'] as String,
    processingTimeSec: (json['processingTimeSec'] as num).toDouble(),
    inputs: (json['inputs'] as List)
        .map((e) => RecipeInput.fromJson(e as Map<String, dynamic>))
        .toList(),
    outputs: (json['outputs'] as List)
        .map((e) => RecipeOutput.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class BuildingData {
  final String id;
  final String type;
  final String nameKey;
  final double baseCost;
  final double costMultiplier;
  final double baseProductionTimeSec;
  final double baseLocalStock;
  final double localStockMultiplier;
  final double levelBonus;
  final String sector;
  final int layer;
  final double energyConsumption;
  final bool isUnlockedByDefault;

  const BuildingData({
    required this.id,
    required this.type,
    required this.nameKey,
    required this.baseCost,
    required this.costMultiplier,
    required this.baseProductionTimeSec,
    required this.baseLocalStock,
    required this.localStockMultiplier,
    required this.levelBonus,
    required this.sector,
    required this.layer,
    required this.energyConsumption,
    required this.isUnlockedByDefault,
  });

  factory BuildingData.fromJson(Map<String, dynamic> json) => BuildingData(
    id: json['id'] as String,
    type: json['type'] as String,
    nameKey: json['nameKey'] as String,
    baseCost: (json['baseCost'] as num).toDouble(),
    costMultiplier: (json['costMultiplier'] as num).toDouble(),
    baseProductionTimeSec: (json['baseProductionTimeSec'] as num).toDouble(),
    baseLocalStock: (json['baseLocalStock'] as num).toDouble(),
    localStockMultiplier: (json['localStockMultiplier'] as num).toDouble(),
    levelBonus: (json['levelBonus'] as num).toDouble(),
    sector: json['sector'] as String,
    layer: json['layer'] as int,
    energyConsumption: (json['energyConsumption'] as num).toDouble(),
    isUnlockedByDefault: json['isUnlockedByDefault'] as bool? ?? false,
  );
}

class InventoryConfig {
  final double startingMaxTotalWeight;
  final double weightUpgradePerDepoLevel;
  final double autoSaleIntervalSeconds;
  final Map<String, double> defaultSlotCapacities;

  const InventoryConfig({
    required this.startingMaxTotalWeight,
    required this.weightUpgradePerDepoLevel,
    required this.autoSaleIntervalSeconds,
    required this.defaultSlotCapacities,
  });

  factory InventoryConfig.fromJson(Map<String, dynamic> json) => InventoryConfig(
    startingMaxTotalWeight: (json['startingMaxTotalWeight'] as num).toDouble(),
    weightUpgradePerDepoLevel: (json['weightUpgradePerDepoLevel'] as num).toDouble(),
    autoSaleIntervalSeconds: (json['autoSaleIntervalSeconds'] as num).toDouble(),
    defaultSlotCapacities: (json['defaultSlotCapacities'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, (v as num).toDouble())),
  );
}

class JsonLoader {
  static List<ProductModel> products = [];
  static List<BuildingData> buildings = [];
  static List<ProductionRecipe> recipes = [];
  static InventoryConfig? inventoryConfig;

  static Future<void> loadAll() async {
    await Future.wait([
      _loadProducts(),
      _loadBuildings(),
      _loadChains(),
      _loadInventoryConfig(),
    ]);

    if (kDebugMode) {
      debugPrint('JsonLoader: ${products.length} ürün, '
          '${buildings.length} bina, '
          '${recipes.length} tarif yüklendi.');
    }
  }

  static Future<void> _loadProducts() async {
    final raw = await rootBundle.loadString('assets/data/products.json');
    final list = jsonDecode(raw) as List;
    products = list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> _loadBuildings() async {
    final raw = await rootBundle.loadString('assets/data/buildings.json');
    final list = jsonDecode(raw) as List;
    buildings = list.map((e) => BuildingData.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> _loadChains() async {
    final raw = await rootBundle.loadString('assets/data/chains.json');
    final list = jsonDecode(raw) as List;
    recipes = list.map((e) => ProductionRecipe.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<void> _loadInventoryConfig() async {
    final raw = await rootBundle.loadString('assets/data/inventory.json');
    inventoryConfig = InventoryConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  static ProductModel? getProduct(ProductType type) {
    return products.where((p) => p.type == type).firstOrNull;
  }

  static BuildingData? getBuildingData(String buildingType) {
    return buildings.where((b) => b.type == buildingType).firstOrNull;
  }

  static List<ProductionRecipe> getRecipesForBuilding(String buildingType) {
    return recipes.where((r) => r.buildingType == buildingType).toList();
  }

  static double getDefaultCapacity(ProductCategory category) {
    final config = inventoryConfig;
    if (config == null) return 500;
    return config.defaultSlotCapacities[category.name] ?? 500;
  }
}
