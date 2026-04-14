import 'enums.dart';

class SaleChannelInfo {
  final SaleChannel channel;
  final double multiplier;

  const SaleChannelInfo({required this.channel, required this.multiplier});

  Map<String, dynamic> toJson() => {
    'channel': channel.name,
    'multiplier': multiplier,
  };

  factory SaleChannelInfo.fromJson(Map<String, dynamic> json) => SaleChannelInfo(
    channel: SaleChannel.values.byName(json['channel'] as String),
    multiplier: (json['multiplier'] as num).toDouble(),
  );
}

class ProductModel {
  final String id;
  final ProductType type;
  final ProductCategory category;
  final String nameKey;
  final double baseValue;
  final double weight;
  final double maxStackInInventory;
  final List<SaleChannelInfo> availableSaleChannels;

  const ProductModel({
    required this.id,
    required this.type,
    required this.category,
    required this.nameKey,
    required this.baseValue,
    required this.weight,
    required this.maxStackInInventory,
    required this.availableSaleChannels,
  });

  double salePrice(SaleChannel channel, {double multiplier = 1.0}) {
    final channelInfo = availableSaleChannels
        .where((c) => c.channel == channel)
        .firstOrNull;
    return baseValue * (channelInfo?.multiplier ?? 1.0) * multiplier;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'category': category.name,
    'nameKey': nameKey,
    'baseValue': baseValue,
    'weight': weight,
    'maxStackInInventory': maxStackInInventory,
    'availableSaleChannels': availableSaleChannels.map((c) => c.toJson()).toList(),
  };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] as String,
    type: ProductType.values.byName(json['type'] as String),
    category: ProductCategory.values.byName(json['category'] as String),
    nameKey: json['nameKey'] as String,
    baseValue: (json['baseValue'] as num).toDouble(),
    weight: (json['weight'] as num).toDouble(),
    maxStackInInventory: (json['maxStackInInventory'] as num).toDouble(),
    availableSaleChannels: (json['availableSaleChannels'] as List)
        .map((e) => SaleChannelInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
