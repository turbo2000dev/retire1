// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IndividualImpl _$$IndividualImplFromJson(
  Map<String, dynamic> json,
) => _$IndividualImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  birthdate: _dateTimeFromJson(json['birthdate']),
  employmentIncome: (json['employmentIncome'] as num?)?.toDouble() ?? 0.0,
  rrqStartAge: (json['rrqStartAge'] as num?)?.toInt() ?? 65,
  psvStartAge: (json['psvStartAge'] as num?)?.toInt() ?? 65,
  projectedRrqAt60: (json['projectedRrqAt60'] as num?)?.toDouble() ?? 12000.0,
  projectedRrqAt65: (json['projectedRrqAt65'] as num?)?.toDouble() ?? 16000.0,
  initialCeliRoom: (json['initialCeliRoom'] as num?)?.toDouble() ?? 0.0,
  hasRrpe: json['hasRrpe'] as bool? ?? false,
  rrpeParticipationStartDate: _dateTimeFromJsonNullable(
    json['rrpeParticipationStartDate'],
  ),
);

Map<String, dynamic> _$$IndividualImplToJson(_$IndividualImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthdate': _dateTimeToJson(instance.birthdate),
      'employmentIncome': instance.employmentIncome,
      'rrqStartAge': instance.rrqStartAge,
      'psvStartAge': instance.psvStartAge,
      'projectedRrqAt60': instance.projectedRrqAt60,
      'projectedRrqAt65': instance.projectedRrqAt65,
      'initialCeliRoom': instance.initialCeliRoom,
      'hasRrpe': instance.hasRrpe,
      'rrpeParticipationStartDate': _dateTimeToJsonNullable(
        instance.rrpeParticipationStartDate,
      ),
    };
