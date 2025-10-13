// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HousingExpenseImpl _$$HousingExpenseImplFromJson(Map<String, dynamic> json) =>
    _$HousingExpenseImpl(
      id: json['id'] as String,
      startTiming: EventTiming.fromJson(
        json['startTiming'] as Map<String, dynamic>,
      ),
      endTiming: json['endTiming'] == null
          ? null
          : EventTiming.fromJson(json['endTiming'] as Map<String, dynamic>),
      annualAmount: (json['annualAmount'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$HousingExpenseImplToJson(
  _$HousingExpenseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'startTiming': instance.startTiming.toJson(),
  'endTiming': instance.endTiming?.toJson(),
  'annualAmount': instance.annualAmount,
  'runtimeType': instance.$type,
};

_$TransportExpenseImpl _$$TransportExpenseImplFromJson(
  Map<String, dynamic> json,
) => _$TransportExpenseImpl(
  id: json['id'] as String,
  startTiming: EventTiming.fromJson(
    json['startTiming'] as Map<String, dynamic>,
  ),
  endTiming: json['endTiming'] == null
      ? null
      : EventTiming.fromJson(json['endTiming'] as Map<String, dynamic>),
  annualAmount: (json['annualAmount'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$TransportExpenseImplToJson(
  _$TransportExpenseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'startTiming': instance.startTiming.toJson(),
  'endTiming': instance.endTiming?.toJson(),
  'annualAmount': instance.annualAmount,
  'runtimeType': instance.$type,
};

_$DailyLivingExpenseImpl _$$DailyLivingExpenseImplFromJson(
  Map<String, dynamic> json,
) => _$DailyLivingExpenseImpl(
  id: json['id'] as String,
  startTiming: EventTiming.fromJson(
    json['startTiming'] as Map<String, dynamic>,
  ),
  endTiming: json['endTiming'] == null
      ? null
      : EventTiming.fromJson(json['endTiming'] as Map<String, dynamic>),
  annualAmount: (json['annualAmount'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$DailyLivingExpenseImplToJson(
  _$DailyLivingExpenseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'startTiming': instance.startTiming.toJson(),
  'endTiming': instance.endTiming?.toJson(),
  'annualAmount': instance.annualAmount,
  'runtimeType': instance.$type,
};

_$RecreationExpenseImpl _$$RecreationExpenseImplFromJson(
  Map<String, dynamic> json,
) => _$RecreationExpenseImpl(
  id: json['id'] as String,
  startTiming: EventTiming.fromJson(
    json['startTiming'] as Map<String, dynamic>,
  ),
  endTiming: json['endTiming'] == null
      ? null
      : EventTiming.fromJson(json['endTiming'] as Map<String, dynamic>),
  annualAmount: (json['annualAmount'] as num).toDouble(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$RecreationExpenseImplToJson(
  _$RecreationExpenseImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'startTiming': instance.startTiming.toJson(),
  'endTiming': instance.endTiming?.toJson(),
  'annualAmount': instance.annualAmount,
  'runtimeType': instance.$type,
};

_$HealthExpenseImpl _$$HealthExpenseImplFromJson(Map<String, dynamic> json) =>
    _$HealthExpenseImpl(
      id: json['id'] as String,
      startTiming: EventTiming.fromJson(
        json['startTiming'] as Map<String, dynamic>,
      ),
      endTiming: json['endTiming'] == null
          ? null
          : EventTiming.fromJson(json['endTiming'] as Map<String, dynamic>),
      annualAmount: (json['annualAmount'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$HealthExpenseImplToJson(_$HealthExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTiming': instance.startTiming.toJson(),
      'endTiming': instance.endTiming?.toJson(),
      'annualAmount': instance.annualAmount,
      'runtimeType': instance.$type,
    };

_$FamilyExpenseImpl _$$FamilyExpenseImplFromJson(Map<String, dynamic> json) =>
    _$FamilyExpenseImpl(
      id: json['id'] as String,
      startTiming: EventTiming.fromJson(
        json['startTiming'] as Map<String, dynamic>,
      ),
      endTiming: json['endTiming'] == null
          ? null
          : EventTiming.fromJson(json['endTiming'] as Map<String, dynamic>),
      annualAmount: (json['annualAmount'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FamilyExpenseImplToJson(_$FamilyExpenseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startTiming': instance.startTiming.toJson(),
      'endTiming': instance.endTiming?.toJson(),
      'annualAmount': instance.annualAmount,
      'runtimeType': instance.$type,
    };
