// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kervan Corp';

  @override
  String get appTitleShort => 'Kervan';

  @override
  String get companySuffix => 'Corp';

  @override
  String get play => 'Play';

  @override
  String get settings => 'Settings';

  @override
  String get exit => 'Exit';

  @override
  String get newGame => 'New Game';

  @override
  String get continueGame => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get buy => 'Buy';

  @override
  String get unlock => 'Unlock';

  @override
  String get newGameConfirmTitle => 'New Game';

  @override
  String get newGameConfirmBody =>
      'Current save will be deleted. Are you sure?';

  @override
  String get tabProduction => 'Production';

  @override
  String get tabInventory => 'Inventory';

  @override
  String get tabTransport => 'Transport';

  @override
  String get tabContracts => 'Contracts';

  @override
  String get tabResearch => 'Research';

  @override
  String get language => 'Language';

  @override
  String get languageTr => 'Turkish';

  @override
  String get languageEn => 'English';

  @override
  String get sound => 'Sound';

  @override
  String get music => 'Music';

  @override
  String get version => 'Version';

  @override
  String get money => 'Money';

  @override
  String get diamonds => 'Diamonds';

  @override
  String get prestigePoints => 'Prestige';

  @override
  String get perHour => '/hr';

  @override
  String get comingSoon => 'Coming soon...';

  @override
  String get sectorAgriculture => 'Raw Mat.';

  @override
  String get sectorProduction => 'Production';

  @override
  String get sectorLogistics => 'Logistics';

  @override
  String get sectorTrade => 'Trade';

  @override
  String get sectorFinance => 'Finance';

  @override
  String get sectorTechnology => 'Technology';

  @override
  String get sectorLocked => 'Locked';

  @override
  String get statusProducing => 'Producing';

  @override
  String get statusIdle => 'Idle';

  @override
  String get statusWaitingInput => 'Waiting Input';

  @override
  String get statusStorageFull => 'Storage Full';

  @override
  String get statusNoEnergy => 'No Energy';

  @override
  String get produce => 'Produce';

  @override
  String get selectRecipe => 'Select recipe';

  @override
  String get upgradeTimeLabel => 'Time';

  @override
  String get upgradeCostLabel => 'Cost';

  @override
  String get upgrade => 'Upgrade';

  @override
  String upgradeTo(int level) {
    return 'Make Lv.$level';
  }

  @override
  String get level => 'Lv.';

  @override
  String get manager => 'Manager';

  @override
  String get managerNone => 'No Manager (Manual)';

  @override
  String get managerIntern => 'Intern';

  @override
  String get managerExpert => 'Expert';

  @override
  String get managerManager => 'Manager';

  @override
  String get managerDirector => 'Director';

  @override
  String get managerCEO => 'CEO';

  @override
  String get assignManager => 'Assign Manager';

  @override
  String managerSpeed(String mult) {
    return '×$mult speed';
  }

  @override
  String get sell => 'Sell';

  @override
  String sellAll(String qty) {
    return 'Sell All ($qty)';
  }

  @override
  String get estimatedRevenue => 'Estimated Revenue';

  @override
  String get available => 'Available';

  @override
  String get reserved => 'Reserved';

  @override
  String get insufficientStock => 'Insufficient stock';

  @override
  String get insufficientFunds => 'Insufficient funds';

  @override
  String get storageFull => 'Storage full — sell first';

  @override
  String get filterAll => 'All';

  @override
  String get filterRawAgri => '🌾 Agri';

  @override
  String get filterRawAnimal => '🐄 Animal';

  @override
  String get filterRawMining => '⛏️ Mining';

  @override
  String get filterRawForest => '🌲 Forest';

  @override
  String get filterProcessed => '⚙️ Processed';

  @override
  String get filterManufactured => '📦 Products';

  @override
  String get inventoryTotalValue => 'Total';

  @override
  String get inventoryCapacity => 'Capacity';

  @override
  String reservedNote(String qty) {
    return '$qty contract reserve';
  }

  @override
  String get channelLocked => '🔒 Building required';

  @override
  String get unitPrice => 'Unit';

  @override
  String get perMinute => '/min';

  @override
  String get hideZeroStock => 'Hide Empty';

  @override
  String get showZeroStock => 'Show Empty';

  @override
  String get sortByQuantity => 'Qty';

  @override
  String get sortByValue => 'Value';

  @override
  String get sortByName => 'Name';

  @override
  String warehouseLv(int level) {
    return 'Wh. Lv.$level';
  }

  @override
  String get warehouseMaxLv => 'Max Level';

  @override
  String get upgradeWarehouseBtn => 'Upgrade';

  @override
  String waitingForInput(String product) {
    return '⚠️ Waiting for $product';
  }

  @override
  String get building_farm => 'Farm';

  @override
  String get building_mine => 'Mine';

  @override
  String get building_forest => 'Forest';

  @override
  String get building_ranch => 'Ranch';

  @override
  String get building_quarry => 'Quarry';

  @override
  String get building_mill => 'Mill';

  @override
  String get building_ironFactory => 'Iron Factory';

  @override
  String get building_woodProcessing => 'Wood Processing';

  @override
  String get building_dairyFactory => 'Dairy Factory';

  @override
  String get building_textileFactory => 'Textile Factory';

  @override
  String get building_bakery => 'Bakery';

  @override
  String get building_steelFactory => 'Steel Factory';

  @override
  String get building_furnitureFactory => 'Furniture Factory';

  @override
  String get building_clothingFactory => 'Clothing Factory';

  @override
  String get building_readyFoodFactory => 'Ready Food Factory';

  @override
  String get building_machineFactory => 'Machine Factory';

  @override
  String get building_market => 'Market';

  @override
  String get building_supermarket => 'Supermarket';

  @override
  String get building_furnitureStore => 'Furniture Store';

  @override
  String get building_clothingStore => 'Clothing Store';

  @override
  String get building_industrialStore => 'Industrial Store';

  @override
  String get building_warehouse => 'Warehouse';

  @override
  String get building_truckGarage => 'Truck Garage';

  @override
  String get building_port => 'Port';

  @override
  String get building_airCargoTerminal => 'Air Cargo Terminal';

  @override
  String get product_wheat => 'Wheat';

  @override
  String get product_sugarCane => 'Sugar Cane';

  @override
  String get product_cotton => 'Cotton';

  @override
  String get product_corn => 'Corn';

  @override
  String get product_milk => 'Milk';

  @override
  String get product_wool => 'Wool';

  @override
  String get product_meat => 'Meat';

  @override
  String get product_egg => 'Egg';

  @override
  String get product_ironOre => 'Iron Ore';

  @override
  String get product_copperOre => 'Copper Ore';

  @override
  String get product_sand => 'Sand';

  @override
  String get product_coal => 'Coal';

  @override
  String get product_stone => 'Stone';

  @override
  String get product_timber => 'Timber';

  @override
  String get product_flour => 'Flour';

  @override
  String get product_cornFlour => 'Corn Flour';

  @override
  String get product_sugar => 'Sugar';

  @override
  String get product_cheese => 'Cheese';

  @override
  String get product_yogurt => 'Yogurt';

  @override
  String get product_fabric => 'Fabric';

  @override
  String get product_rawIron => 'Raw Iron';

  @override
  String get product_copper => 'Copper';

  @override
  String get product_steel => 'Steel';

  @override
  String get product_glass => 'Glass';

  @override
  String get product_processedWood => 'Processed Wood';

  @override
  String get product_bread => 'Bread';

  @override
  String get product_cake => 'Cake';

  @override
  String get product_machine => 'Machine';

  @override
  String get product_electronic => 'Electronic';

  @override
  String get product_furniture => 'Furniture';

  @override
  String get product_premiumFurniture => 'Premium Furniture';

  @override
  String get product_clothing => 'Clothing';

  @override
  String get product_smartClothing => 'Smart Clothing';

  @override
  String get product_burger => 'Burger';

  @override
  String get product_pizza => 'Pizza';

  @override
  String get channel_market => 'Market';

  @override
  String get channel_supermarket => 'Supermarket';

  @override
  String get channel_furnitureStore => 'Furniture Store';

  @override
  String get channel_clothingStore => 'Clothing Store';

  @override
  String get channel_electronicStore => 'Electronics Store';

  @override
  String get channel_industrialStore => 'Industrial';

  @override
  String get channel_restaurant => 'Restaurant';

  @override
  String get channel_port => 'Port Export';

  @override
  String get channel_airCargoTerminal => 'Air Cargo';

  @override
  String get vehicle_smallTruck => 'Small Truck';

  @override
  String get vehicle_bigTruck => 'Big Truck';

  @override
  String get vehicle_ship => 'Ship';

  @override
  String get vehicle_airCargo => 'Air Cargo';

  @override
  String get vehicle_train => 'Train';

  @override
  String get contract_cityOrder => 'City Order';

  @override
  String get contract_b2bOrder => 'B2B Order';

  @override
  String get contract_vipOrder => 'VIP Client';

  @override
  String get contract_exportContract => 'Export Contract';

  @override
  String get contract_urgentOrder => 'Urgent Order';

  @override
  String get research_fertileSoil => 'Fertile Soil';

  @override
  String get research_fertileSoil_desc => 'Farm production +20%';

  @override
  String get research_irrigation => 'Irrigation System';

  @override
  String get research_irrigation_desc => 'Farm speed +15%';

  @override
  String get research_miningDrill => 'Mining Drill';

  @override
  String get research_miningDrill_desc => 'Mine production +25%';

  @override
  String get research_assemblyLine => 'Assembly Line';

  @override
  String get research_assemblyLine_desc => 'All production +10%';

  @override
  String get research_qualityControl => 'Quality Control';

  @override
  String get research_qualityControl_desc => 'All production +15%';

  @override
  String get research_logisticsSoftware => 'Logistics Software';

  @override
  String get research_logisticsSoftware_desc => 'Contract slot +1';

  @override
  String get research_vehicleUpgrade => 'Vehicle Upgrade';

  @override
  String get research_vehicleUpgrade_desc => 'Vehicle capacity +20%';

  @override
  String get research_exportNetwork => 'Export Network';

  @override
  String get research_exportNetwork_desc => 'Export profit +20%';

  @override
  String get research_fastSale => 'Fast Sale';

  @override
  String get research_fastSale_desc => 'Auto-sale interval 30→20s';

  @override
  String get research_warehouseOrg => 'Warehouse Organization';

  @override
  String get research_warehouseOrg_desc => 'All product capacity +25%';

  @override
  String get research_smartShelf => 'Smart Shelf System';

  @override
  String get research_smartShelf_desc => 'Global weight capacity +30%';

  @override
  String get research_marketConnect => 'Market Connect';

  @override
  String get research_marketConnect_desc => 'Auto-sale interval 20→15s';

  @override
  String get research_smartReserve => 'Smart Reserve';

  @override
  String get research_smartReserve_desc =>
      'Contract reserve doesn\'t stop production';

  @override
  String get research_passiveIncome => 'Passive Income';

  @override
  String get research_passiveIncome_desc => '+0.5% interest income per hour';

  @override
  String get research_automation => 'Automation';

  @override
  String get research_automation_desc => 'All production +30%';

  @override
  String get prestige_headStart => 'Head Start';

  @override
  String get prestige_headStart_desc => '+50,000₺ at start';

  @override
  String get prestige_productionMastery => 'Production Mastery';

  @override
  String get prestige_productionMastery_desc => 'All production +25%';

  @override
  String get prestige_heritageStorage => 'Heritage Storage';

  @override
  String get prestige_heritageStorage_desc => '20% of top 3 products kept';

  @override
  String get prestige_veteranManager => 'Veteran Manager';

  @override
  String get prestige_veteranManager_desc => 'Managers persist after prestige';

  @override
  String get prestige_researchCarry => 'Research Legacy';

  @override
  String get prestige_researchCarry_desc => '50% of research carries over';

  @override
  String get prestige_diamondBonus => 'Diamond Bonus';

  @override
  String get prestige_diamondBonus_desc => 'Diamond gain +20%';

  @override
  String get offlineEarnings => 'Offline Earnings';

  @override
  String offlineEarningsBody(String duration, String summary) {
    return 'You were offline for $duration.\n$summary';
  }

  @override
  String sectorUnlocked(String sector) {
    return '$sector Sector Unlocked!';
  }

  @override
  String get units => 'units';

  @override
  String get capacity => 'Capacity';

  @override
  String get totalValue => 'Total Value';

  @override
  String get fillPercent => 'Fill';
}
