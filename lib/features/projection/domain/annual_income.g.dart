// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annual_income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnnualIncomeImpl _$$AnnualIncomeImplFromJson(Map<String, dynamic> json) =>
    _$AnnualIncomeImpl(
      employment: (json['employment'] as num?)?.toDouble() ?? 0.0,
      rrq: (json['rrq'] as num?)?.toDouble() ?? 0.0,
      psv: (json['psv'] as num?)?.toDouble() ?? 0.0,
      rrif: (json['rrif'] as num?)?.toDouble() ?? 0.0,
      rrpe: (json['rrpe'] as num?)?.toDouble() ?? 0.0,
      other: (json['other'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AnnualIncomeImplToJson(_$AnnualIncomeImpl instance) =>
    <String, dynamic>{
      'employment': instance.employment,
      'rrq': instance.rrq,
      'psv': instance.psv,
      'rrif': instance.rrif,
      'rrpe': instance.rrpe,
      'other': instance.other,
    };
