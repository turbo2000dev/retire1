// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RealEstateAssetImpl _$$RealEstateAssetImplFromJson(
  Map<String, dynamic> json,
) => _$RealEstateAssetImpl(
  id: json['id'] as String,
  type: $enumDecode(_$RealEstateTypeEnumMap, json['type']),
  value: (json['value'] as num).toDouble(),
  setAtStart: json['setAtStart'] as bool? ?? false,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RealEstateAssetImplToJson(
  _$RealEstateAssetImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': _$RealEstateTypeEnumMap[instance.type]!,
  'value': instance.value,
  'setAtStart': instance.setAtStart,
  'runtimeType': instance.$type,
};

const _$RealEstateTypeEnumMap = {
  RealEstateType.house: 'house',
  RealEstateType.condo: 'condo',
  RealEstateType.cottage: 'cottage',
  RealEstateType.land: 'land',
  RealEstateType.commercial: 'commercial',
  RealEstateType.other: 'other',
};

_$RRSPAccountImpl _$$RRSPAccountImplFromJson(Map<String, dynamic> json) =>
    _$RRSPAccountImpl(
      id: json['id'] as String,
      individualId: json['individualId'] as String,
      value: (json['value'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RRSPAccountImplToJson(_$RRSPAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'individualId': instance.individualId,
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$CELIAccountImpl _$$CELIAccountImplFromJson(Map<String, dynamic> json) =>
    _$CELIAccountImpl(
      id: json['id'] as String,
      individualId: json['individualId'] as String,
      value: (json['value'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CELIAccountImplToJson(_$CELIAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'individualId': instance.individualId,
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$CashAccountImpl _$$CashAccountImplFromJson(Map<String, dynamic> json) =>
    _$CashAccountImpl(
      id: json['id'] as String,
      individualId: json['individualId'] as String,
      value: (json['value'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$CashAccountImplToJson(_$CashAccountImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'individualId': instance.individualId,
      'value': instance.value,
      'runtimeType': instance.$type,
    };
