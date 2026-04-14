import 'dart:math';
import 'enums.dart';

class BuildingModel {
  final String id;
  final BuildingType type;
  int level;
  ManagerLevel managerLevel;
  bool isUnlocked;
  double localStock;
  double localMaxStock;
  BuildingStatus status;
  bool autoSaleEnabled;
  String? autoSaleChannelId;
  String? selectedRecipeId;

  BuildingModel({
    required this.id,
    required this.type,
    this.level = 1,
    this.managerLevel = ManagerLevel.none,
    this.isUnlocked = false,
    this.localStock = 0,
    this.localMaxStock = 200,
    this.status = BuildingStatus.idle,
    this.autoSaleEnabled = false,
    this.autoSaleChannelId,
    this.selectedRecipeId,
  });

  double upgradeCost(double baseCost) => baseCost * pow(1.15, level - 1);

  double get managerMultiplier {
    switch (managerLevel) {
      case ManagerLevel.none:     return 1.0;
      case ManagerLevel.intern:   return 1.0;
      case ManagerLevel.expert:   return 1.5;
      case ManagerLevel.manager:  return 2.0;
      case ManagerLevel.director: return 3.0;
      case ManagerLevel.ceo:      return 5.0;
    }
  }

  bool get hasManager => managerLevel != ManagerLevel.none;

  BuildingModel copyWith({
    int? level,
    ManagerLevel? managerLevel,
    bool? isUnlocked,
    double? localStock,
    double? localMaxStock,
    BuildingStatus? status,
    bool? autoSaleEnabled,
    String? autoSaleChannelId,
    String? selectedRecipeId,
    bool clearRecipe = false,
  }) {
    return BuildingModel(
      id: id,
      type: type,
      level: level ?? this.level,
      managerLevel: managerLevel ?? this.managerLevel,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      localStock: localStock ?? this.localStock,
      localMaxStock: localMaxStock ?? this.localMaxStock,
      status: status ?? this.status,
      autoSaleEnabled: autoSaleEnabled ?? this.autoSaleEnabled,
      autoSaleChannelId: autoSaleChannelId ?? this.autoSaleChannelId,
      selectedRecipeId: clearRecipe ? null : (selectedRecipeId ?? this.selectedRecipeId),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'level': level,
    'managerLevel': managerLevel.name,
    'isUnlocked': isUnlocked,
    'localStock': localStock,
    'localMaxStock': localMaxStock,
    'status': status.name,
    'autoSaleEnabled': autoSaleEnabled,
    'autoSaleChannelId': autoSaleChannelId,
    'selectedRecipeId': selectedRecipeId,
  };

  factory BuildingModel.fromJson(Map<String, dynamic> json) => BuildingModel(
    id: json['id'] as String,
    type: BuildingType.values.byName(json['type'] as String),
    level: json['level'] as int,
    managerLevel: ManagerLevel.values.byName(json['managerLevel'] as String),
    isUnlocked: json['isUnlocked'] as bool,
    localStock: (json['localStock'] as num).toDouble(),
    localMaxStock: (json['localMaxStock'] as num).toDouble(),
    status: BuildingStatus.values.byName(json['status'] as String),
    autoSaleEnabled: json['autoSaleEnabled'] as bool,
    autoSaleChannelId: json['autoSaleChannelId'] as String?,
    selectedRecipeId: json['selectedRecipeId'] as String?,
  );
}
