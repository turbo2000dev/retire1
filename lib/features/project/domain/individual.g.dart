// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndividualImpl _$$IndividualImplFromJson(Map<String, dynamic> json) =>
    _$IndividualImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
    );

Map<String, dynamic> _$$IndividualImplToJson(_$IndividualImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthdate': instance.birthdate.toIso8601String(),
    };
