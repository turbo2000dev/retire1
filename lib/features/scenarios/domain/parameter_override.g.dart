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

_$ExpenseAmountOverrideImpl _$$ExpenseAmountOverrideImplFromJson(
  Map<String, dynamic> json,
) => _$ExpenseAmountOverrideImpl(
  expenseId: json['expenseId'] as String,
  overrideAmount: (json['overrideAmount'] as num?)?.toDouble(),
  amountMultiplier: (json['amountMultiplier'] as num?)?.toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ExpenseAmountOverrideImplToJson(
  _$ExpenseAmountOverrideImpl instance,
) => <String, dynamic>{
  'expenseId': instance.expenseId,
  'overrideAmount': instance.overrideAmount,
  'amountMultiplier': instance.amountMultiplier,
  'runtimeType': instance.$type,
};

_$ExpenseTimingOverrideImpl _$$ExpenseTimingOverrideImplFromJson(
  Map<String, dynamic> json,
) => _$ExpenseTimingOverrideImpl(
  expenseId: json['expenseId'] as String,
  overrideStartTiming: json['overrideStartTiming'] == null
      ? null
      : EventTiming.fromJson(
          json['overrideStartTiming'] as Map<String, dynamic>,
        ),
  overrideEndTiming: json['overrideEndTiming'] == null
      ? null
      : EventTiming.fromJson(json['overrideEndTiming'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ExpenseTimingOverrideImplToJson(
  _$ExpenseTimingOverrideImpl instance,
) => <String, dynamic>{
  'expenseId': instance.expenseId,
  'overrideStartTiming': instance.overrideStartTiming?.toJson(),
  'overrideEndTiming': instance.overrideEndTiming?.toJson(),
  'runtimeType': instance.$type,
};
