import '../l10n/app_localizations.dart';
import '../models/enums.dart';

String buildingName(AppLocalizations l, String typeOrKey) {
  return switch (typeOrKey) {
    'farm'               => l.building_farm,
    'mine'               => l.building_mine,
    'forest'             => l.building_forest,
    'ranch'              => l.building_ranch,
    'quarry'             => l.building_quarry,
    'mill'               => l.building_mill,
    'ironFactory'        => l.building_ironFactory,
    'woodProcessing'     => l.building_woodProcessing,
    'dairyFactory'       => l.building_dairyFactory,
    'textileFactory'     => l.building_textileFactory,
    'bakery'             => l.building_bakery,
    'steelFactory'       => l.building_steelFactory,
    'furnitureFactory'   => l.building_furnitureFactory,
    'clothingFactory'    => l.building_clothingFactory,
    'readyFoodFactory'   => l.building_readyFoodFactory,
    'machineFactory'     => l.building_machineFactory,
    'market'             => l.building_market,
    'supermarket'        => l.building_supermarket,
    'furnitureStore'     => l.building_furnitureStore,
    'clothingStore'      => l.building_clothingStore,
    'industrialStore'    => l.building_industrialStore,
    'warehouse'          => l.building_warehouse,
    'truckGarage'        => l.building_truckGarage,
    'port'               => l.building_port,
    'airCargoTerminal'   => l.building_airCargoTerminal,
    _                    => typeOrKey,
  };
}

String productName(AppLocalizations l, ProductType type) {
  return switch (type) {
    ProductType.wheat          => l.product_wheat,
    ProductType.sugarCane      => l.product_sugarCane,
    ProductType.cotton         => l.product_cotton,
    ProductType.corn           => l.product_corn,
    ProductType.milk           => l.product_milk,
    ProductType.wool           => l.product_wool,
    ProductType.meat           => l.product_meat,
    ProductType.egg            => l.product_egg,
    ProductType.ironOre        => l.product_ironOre,
    ProductType.copperOre      => l.product_copperOre,
    ProductType.sand           => l.product_sand,
    ProductType.coal           => l.product_coal,
    ProductType.stone          => l.product_stone,
    ProductType.timber         => l.product_timber,
    ProductType.flour          => l.product_flour,
    ProductType.cornFlour      => l.product_cornFlour,
    ProductType.sugar          => l.product_sugar,
    ProductType.cheese         => l.product_cheese,
    ProductType.yogurt         => l.product_yogurt,
    ProductType.fabric         => l.product_fabric,
    ProductType.rawIron        => l.product_rawIron,
    ProductType.copper         => l.product_copper,
    ProductType.steel          => l.product_steel,
    ProductType.glass          => l.product_glass,
    ProductType.processedWood  => l.product_processedWood,
    ProductType.bread          => l.product_bread,
    ProductType.cake           => l.product_cake,
    ProductType.machine        => l.product_machine,
    ProductType.electronic     => l.product_electronic,
    ProductType.furniture      => l.product_furniture,
    ProductType.premiumFurniture => l.product_premiumFurniture,
    ProductType.clothing       => l.product_clothing,
    ProductType.smartClothing  => l.product_smartClothing,
    ProductType.burger         => l.product_burger,
    ProductType.pizza          => l.product_pizza,
  };
}

/// Ürün emojisi
String productEmoji(ProductType type) => switch (type) {
  ProductType.wheat          => '🌾',
  ProductType.sugarCane      => '🎋',
  ProductType.cotton         => '🌿',
  ProductType.corn           => '🌽',
  ProductType.milk           => '🥛',
  ProductType.wool           => '🧶',
  ProductType.meat           => '🥩',
  ProductType.egg            => '🥚',
  ProductType.ironOre        => '🪨',
  ProductType.copperOre      => '🟠',
  ProductType.sand           => '⏳',
  ProductType.coal           => '⬛',
  ProductType.stone          => '🪵',
  ProductType.timber         => '🌲',
  ProductType.flour          => '🫙',
  ProductType.cornFlour      => '🌽',
  ProductType.sugar          => '🍬',
  ProductType.cheese         => '🧀',
  ProductType.yogurt         => '🥣',
  ProductType.fabric         => '🧵',
  ProductType.rawIron        => '🔩',
  ProductType.copper         => '🟤',
  ProductType.steel          => '⚙️',
  ProductType.glass          => '🪟',
  ProductType.processedWood  => '🪵',
  ProductType.bread          => '🍞',
  ProductType.cake           => '🎂',
  ProductType.machine        => '🤖',
  ProductType.electronic     => '💻',
  ProductType.furniture      => '🪑',
  ProductType.premiumFurniture => '🛋️',
  ProductType.clothing       => '👗',
  ProductType.smartClothing  => '🧥',
  ProductType.burger         => '🍔',
  ProductType.pizza          => '🍕',
};

/// Üretim hızını uygun birimde göster
/// 60/saat'ten fazlaysa dk, değilse saat bazında
String formatRate(double perHour, AppLocalizations l) {
  if (perHour >= 60) {
    final perMin = perHour / 60;
    return '${perMin.toStringAsFixed(1)} ${l.perMinute}';
  }
  return '${perHour.toStringAsFixed(1)} ${l.perHour}';
}
