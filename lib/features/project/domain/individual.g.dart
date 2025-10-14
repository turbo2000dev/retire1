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
      employmentIncome: (json['employmentIncome'] as num?)?.toDouble() ?? 0.0,
      rrqStartAge: (json['rrqStartAge'] as num?)?.toInt() ?? 65,
      psvStartAge: (json['psvStartAge'] as num?)?.toInt() ?? 65,
      rrqAnnualBenefit:
          (json['rrqAnnualBenefit'] as num?)?.toDouble() ?? 16000.0,
    );

Map<String, dynamic> _$$IndividualImplToJson(_$IndividualImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthdate': instance.birthdate.toIso8601String(),
      'employmentIncome': instance.employmentIncome,
      'rrqStartAge': instance.rrqStartAge,
      'psvStartAge': instance.psvStartAge,
      'rrqAnnualBenefit': instance.rrqAnnualBenefit,
    };
