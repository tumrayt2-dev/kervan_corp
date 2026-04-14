import 'enums.dart';
import 'building_model.dart';
import 'vehicle_model.dart';
import 'contract_model.dart';

class GameState {
  double money;
  int diamonds;
  int prestigePoints;
  double totalEarned;
  Map<String, BuildingModel> buildings;
  List<VehicleModel> vehicles;
  List<ContractModel> activeContracts;
  List<String> researchUnlocked;
  List<SectorType> activeSectors;
  DateTime? offlineStartTime;
  int prestigeCount;
  int warehouseLevel;

  /// Depo kapasitesi — her seviye için sabit tablo
  static const List<int> warehouseCapacities = [
    5000, 7500, 11000, 16500, 25000, 37000, 55000, 82000, 125000, 185000, 280000
  ];
  static const List<double> warehouseUpgradeCosts = [
    0, 1500, 3500, 8000, 18000, 42000, 95000, 215000, 480000, 1100000, 2500000
  ];

  int get maxInventoryCapacity => warehouseCapacities[warehouseLevel.clamp(0, 10)];
  double? get nextWarehouseUpgradeCost => warehouseLevel < 10
      ? warehouseUpgradeCosts[warehouseLevel + 1]
      : null;

  GameState({
    this.money = 10000,
    this.diamonds = 0,
    this.prestigePoints = 0,
    this.totalEarned = 0,
    Map<String, BuildingModel>? buildings,
    List<VehicleModel>? vehicles,
    List<ContractModel>? activeContracts,
    List<String>? researchUnlocked,
    List<SectorType>? activeSectors,
    this.offlineStartTime,
    this.prestigeCount = 0,
    this.warehouseLevel = 0,
  })  : buildings = buildings ?? {},
        vehicles = vehicles ?? [],
        activeContracts = activeContracts ?? [],
        researchUnlocked = researchUnlocked ?? [],
        activeSectors = activeSectors ?? [SectorType.agriculture];

  GameState copyWith({
    double? money,
    int? diamonds,
    int? prestigePoints,
    double? totalEarned,
    Map<String, BuildingModel>? buildings,
    List<VehicleModel>? vehicles,
    List<ContractModel>? activeContracts,
    List<String>? researchUnlocked,
    List<SectorType>? activeSectors,
    DateTime? offlineStartTime,
    int? prestigeCount,
    int? warehouseLevel,
  }) {
    return GameState(
      money: money ?? this.money,
      diamonds: diamonds ?? this.diamonds,
      prestigePoints: prestigePoints ?? this.prestigePoints,
      totalEarned: totalEarned ?? this.totalEarned,
      buildings: buildings ?? this.buildings,
      vehicles: vehicles ?? this.vehicles,
      activeContracts: activeContracts ?? this.activeContracts,
      researchUnlocked: researchUnlocked ?? this.researchUnlocked,
      activeSectors: activeSectors ?? this.activeSectors,
      offlineStartTime: offlineStartTime ?? this.offlineStartTime,
      prestigeCount: prestigeCount ?? this.prestigeCount,
      warehouseLevel: warehouseLevel ?? this.warehouseLevel,
    );
  }

  Map<String, dynamic> toJson() => {
    'money': money,
    'diamonds': diamonds,
    'prestigePoints': prestigePoints,
    'totalEarned': totalEarned,
    'buildings': buildings.map((k, v) => MapEntry(k, v.toJson())),
    'vehicles': vehicles.map((v) => v.toJson()).toList(),
    'activeContracts': activeContracts.map((c) => c.toJson()).toList(),
    'researchUnlocked': researchUnlocked,
    'activeSectors': activeSectors.map((s) => s.name).toList(),
    'offlineStartTime': offlineStartTime?.toIso8601String(),
    'prestigeCount': prestigeCount,
    'warehouseLevel': warehouseLevel,
  };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
    money: (json['money'] as num).toDouble(),
    diamonds: json['diamonds'] as int,
    prestigePoints: json['prestigePoints'] as int,
    totalEarned: (json['totalEarned'] as num).toDouble(),
    buildings: (json['buildings'] as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, BuildingModel.fromJson(v as Map<String, dynamic>)),
    ),
    vehicles: (json['vehicles'] as List)
        .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    activeContracts: (json['activeContracts'] as List)
        .map((e) => ContractModel.fromJson(e as Map<String, dynamic>))
        .toList(),
    researchUnlocked: List<String>.from(json['researchUnlocked'] as List),
    activeSectors: (json['activeSectors'] as List)
        .map((s) => SectorType.values.byName(s as String))
        .toList(),
    offlineStartTime: json['offlineStartTime'] != null
        ? DateTime.parse(json['offlineStartTime'] as String)
        : null,
    prestigeCount: json['prestigeCount'] as int,
    warehouseLevel: json['warehouseLevel'] as int? ?? 0,
  );
}
