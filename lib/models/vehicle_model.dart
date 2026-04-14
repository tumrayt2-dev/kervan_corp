import 'enums.dart';

enum VehicleType { smallTruck, bigTruck, ship, airCargo, train }

enum VehiclePhase { idle, loading, travelling, unloading }

class VehicleRoute {
  final String sourceId;
  final String destinationId;
  final ProductType? productType;

  const VehicleRoute({
    required this.sourceId,
    required this.destinationId,
    this.productType,
  });

  Map<String, dynamic> toJson() => {
    'sourceId': sourceId,
    'destinationId': destinationId,
    'productType': productType?.name,
  };

  factory VehicleRoute.fromJson(Map<String, dynamic> json) => VehicleRoute(
    sourceId: json['sourceId'] as String,
    destinationId: json['destinationId'] as String,
    productType: json['productType'] != null
        ? ProductType.values.byName(json['productType'] as String)
        : null,
  );
}

class VehicleModel {
  final String id;
  final VehicleType type;
  int level;
  double capacity;
  double speedMultiplier;
  VehicleRoute? assignedRoute;
  VehiclePhase phase;
  double progressSec;
  double loadedQty;
  ProductType? loadedProduct;

  VehicleModel({
    required this.id,
    required this.type,
    this.level = 1,
    required this.capacity,
    required this.speedMultiplier,
    this.assignedRoute,
    this.phase = VehiclePhase.idle,
    this.progressSec = 0,
    this.loadedQty = 0,
    this.loadedProduct,
  });

  bool get hasRoute => assignedRoute != null;

  VehicleModel copyWith({
    int? level,
    double? capacity,
    VehicleRoute? assignedRoute,
    VehiclePhase? phase,
    double? progressSec,
    double? loadedQty,
    ProductType? loadedProduct,
  }) {
    return VehicleModel(
      id: id,
      type: type,
      level: level ?? this.level,
      capacity: capacity ?? this.capacity,
      speedMultiplier: speedMultiplier,
      assignedRoute: assignedRoute ?? this.assignedRoute,
      phase: phase ?? this.phase,
      progressSec: progressSec ?? this.progressSec,
      loadedQty: loadedQty ?? this.loadedQty,
      loadedProduct: loadedProduct ?? this.loadedProduct,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'level': level,
    'capacity': capacity,
    'speedMultiplier': speedMultiplier,
    'assignedRoute': assignedRoute?.toJson(),
    'phase': phase.name,
    'progressSec': progressSec,
    'loadedQty': loadedQty,
    'loadedProduct': loadedProduct?.name,
  };

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    id: json['id'] as String,
    type: VehicleType.values.byName(json['type'] as String),
    level: json['level'] as int,
    capacity: (json['capacity'] as num).toDouble(),
    speedMultiplier: (json['speedMultiplier'] as num).toDouble(),
    assignedRoute: json['assignedRoute'] != null
        ? VehicleRoute.fromJson(json['assignedRoute'] as Map<String, dynamic>)
        : null,
    phase: VehiclePhase.values.byName(json['phase'] as String),
    progressSec: (json['progressSec'] as num).toDouble(),
    loadedQty: (json['loadedQty'] as num).toDouble(),
    loadedProduct: json['loadedProduct'] != null
        ? ProductType.values.byName(json['loadedProduct'] as String)
        : null,
  );
}
