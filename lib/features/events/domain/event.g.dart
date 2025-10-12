// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RetirementEventImpl _$$RetirementEventImplFromJson(
  Map<String, dynamic> json,
) => _$RetirementEventImpl(
  id: json['id'] as String,
  individualId: json['individualId'] as String,
  timing: EventTiming.fromJson(json['timing'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RetirementEventImplToJson(
  _$RetirementEventImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'individualId': instance.individualId,
  'timing': instance.timing.toJson(),
  'runtimeType': instance.$type,
};

_$DeathEventImpl _$$DeathEventImplFromJson(Map<String, dynamic> json) =>
    _$DeathEventImpl(
      id: json['id'] as String,
      individualId: json['individualId'] as String,
      timing: EventTiming.fromJson(json['timing'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$DeathEventImplToJson(_$DeathEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'individualId': instance.individualId,
      'timing': instance.timing.toJson(),
      'runtimeType': instance.$type,
    };

_$RealEstateTransactionEventImpl _$$RealEstateTransactionEventImplFromJson(
  Map<String, dynamic> json,
) => _$RealEstateTransactionEventImpl(
  id: json['id'] as String,
  timing: EventTiming.fromJson(json['timing'] as Map<String, dynamic>),
  assetSoldId: json['assetSoldId'] as String?,
  assetPurchasedId: json['assetPurchasedId'] as String?,
  withdrawAccountId: json['withdrawAccountId'] as String,
  depositAccountId: json['depositAccountId'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RealEstateTransactionEventImplToJson(
  _$RealEstateTransactionEventImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'timing': instance.timing.toJson(),
  'assetSoldId': instance.assetSoldId,
  'assetPurchasedId': instance.assetPurchasedId,
  'withdrawAccountId': instance.withdrawAccountId,
  'depositAccountId': instance.depositAccountId,
  'runtimeType': instance.$type,
};
