// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameter_override.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetValueOverrideImpl _$$AssetValueOverrideImplFromJson(
  Map<String, dynamic> json,
) => _$AssetValueOverrideImpl(
  assetId: json['assetId'] as String,
  value: (json['value'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$AssetValueOverrideImplToJson(
  _$AssetValueOverrideImpl instance,
) => <String, dynamic>{
  'assetId': instance.assetId,
  'value': instance.value,
  'runtimeType': instance.$type,
};

_$EventTimingOverrideImpl _$$EventTimingOverrideImplFromJson(
  Map<String, dynamic> json,
) => _$EventTimingOverrideImpl(
  eventId: json['eventId'] as String,
  yearsFromStart: (json['yearsFromStart'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$EventTimingOverrideImplToJson(
  _$EventTimingOverrideImpl instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'yearsFromStart': instance.yearsFromStart,
  'runtimeType': instance.$type,
};
