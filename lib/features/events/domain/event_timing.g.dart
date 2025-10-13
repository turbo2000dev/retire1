// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_timing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelativeTimingImpl _$$RelativeTimingImplFromJson(Map<String, dynamic> json) =>
    _$RelativeTimingImpl(
      yearsFromStart: (json['yearsFromStart'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RelativeTimingImplToJson(
  _$RelativeTimingImpl instance,
) => <String, dynamic>{
  'yearsFromStart': instance.yearsFromStart,
  'runtimeType': instance.$type,
};

_$AbsoluteTimingImpl _$$AbsoluteTimingImplFromJson(Map<String, dynamic> json) =>
    _$AbsoluteTimingImpl(
      calendarYear: (json['calendarYear'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AbsoluteTimingImplToJson(
  _$AbsoluteTimingImpl instance,
) => <String, dynamic>{
  'calendarYear': instance.calendarYear,
  'runtimeType': instance.$type,
};

_$AgeTimingImpl _$$AgeTimingImplFromJson(Map<String, dynamic> json) =>
    _$AgeTimingImpl(
      individualId: json['individualId'] as String,
      age: (json['age'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AgeTimingImplToJson(_$AgeTimingImpl instance) =>
    <String, dynamic>{
      'individualId': instance.individualId,
      'age': instance.age,
      'runtimeType': instance.$type,
    };

_$EventRelativeTimingImpl _$$EventRelativeTimingImplFromJson(
  Map<String, dynamic> json,
) => _$EventRelativeTimingImpl(
  eventId: json['eventId'] as String,
  boundary: $enumDecode(_$EventBoundaryEnumMap, json['boundary']),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$EventRelativeTimingImplToJson(
  _$EventRelativeTimingImpl instance,
) => <String, dynamic>{
  'eventId': instance.eventId,
  'boundary': _$EventBoundaryEnumMap[instance.boundary]!,
  'runtimeType': instance.$type,
};

const _$EventBoundaryEnumMap = {
  EventBoundary.start: 'start',
  EventBoundary.end: 'end',
};
