import 'enums.dart';

class ContractReward {
  final double money;
  final int diamonds;
  final int prestigePoints;

  const ContractReward({
    required this.money,
    this.diamonds = 0,
    this.prestigePoints = 0,
  });

  Map<String, dynamic> toJson() => {
    'money': money,
    'diamonds': diamonds,
    'prestigePoints': prestigePoints,
  };

  factory ContractReward.fromJson(Map<String, dynamic> json) => ContractReward(
    money: (json['money'] as num).toDouble(),
    diamonds: json['diamonds'] as int? ?? 0,
    prestigePoints: json['prestigePoints'] as int? ?? 0,
  );
}

class ContractModel {
  final String id;
  final ContractType type;
  ContractStatus status;
  final ProductType requiredProduct;
  final double requiredQty;
  final ContractReward reward;
  final int durationSeconds;
  double elapsedSeconds;

  ContractModel({
    required this.id,
    required this.type,
    this.status = ContractStatus.available,
    required this.requiredProduct,
    required this.requiredQty,
    required this.reward,
    required this.durationSeconds,
    this.elapsedSeconds = 0,
  });

  double get remainingSeconds =>
      (durationSeconds - elapsedSeconds).clamp(0, double.infinity);
  double get progress => durationSeconds > 0
      ? (elapsedSeconds / durationSeconds).clamp(0, 1)
      : 0;
  bool get isExpired => elapsedSeconds >= durationSeconds;

  ContractModel copyWith({
    ContractStatus? status,
    double? elapsedSeconds,
  }) {
    return ContractModel(
      id: id,
      type: type,
      status: status ?? this.status,
      requiredProduct: requiredProduct,
      requiredQty: requiredQty,
      reward: reward,
      durationSeconds: durationSeconds,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'status': status.name,
    'requiredProduct': requiredProduct.name,
    'requiredQty': requiredQty,
    'reward': reward.toJson(),
    'durationSeconds': durationSeconds,
    'elapsedSeconds': elapsedSeconds,
  };

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
    id: json['id'] as String,
    type: ContractType.values.byName(json['type'] as String),
    status: ContractStatus.values.byName(json['status'] as String),
    requiredProduct: ProductType.values.byName(json['requiredProduct'] as String),
    requiredQty: (json['requiredQty'] as num).toDouble(),
    reward: ContractReward.fromJson(json['reward'] as Map<String, dynamic>),
    durationSeconds: json['durationSeconds'] as int,
    elapsedSeconds: (json['elapsedSeconds'] as num).toDouble(),
  );
}
