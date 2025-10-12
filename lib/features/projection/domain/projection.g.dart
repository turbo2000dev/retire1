// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectionImpl _$$ProjectionImplFromJson(Map<String, dynamic> json) =>
    _$ProjectionImpl(
      scenarioId: json['scenarioId'] as String,
      projectId: json['projectId'] as String,
      startYear: (json['startYear'] as num).toInt(),
      endYear: (json['endYear'] as num).toInt(),
      useConstantDollars: json['useConstantDollars'] as bool,
      inflationRate: (json['inflationRate'] as num).toDouble(),
      years: (json['years'] as List<dynamic>)
          .map((e) => YearlyProjection.fromJson(e as Map<String, dynamic>))
          .toList(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
    );

Map<String, dynamic> _$$ProjectionImplToJson(_$ProjectionImpl instance) =>
    <String, dynamic>{
      'scenarioId': instance.scenarioId,
      'projectId': instance.projectId,
      'startYear': instance.startYear,
      'endYear': instance.endYear,
      'useConstantDollars': instance.useConstantDollars,
      'inflationRate': instance.inflationRate,
      'years': instance.years.map((e) => e.toJson()).toList(),
      'calculatedAt': instance.calculatedAt.toIso8601String(),
    };
