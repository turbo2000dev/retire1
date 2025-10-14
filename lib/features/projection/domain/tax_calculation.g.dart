// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_calculation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaxCalculationImpl _$$TaxCalculationImplFromJson(Map<String, dynamic> json) =>
    _$TaxCalculationImpl(
      grossIncome: (json['grossIncome'] as num).toDouble(),
      taxableIncome: (json['taxableIncome'] as num).toDouble(),
      federalTax: (json['federalTax'] as num).toDouble(),
      quebecTax: (json['quebecTax'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      effectiveRate: (json['effectiveRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$TaxCalculationImplToJson(
  _$TaxCalculationImpl instance,
) => <String, dynamic>{
  'grossIncome': instance.grossIncome,
  'taxableIncome': instance.taxableIncome,
  'federalTax': instance.federalTax,
  'quebecTax': instance.quebecTax,
  'totalTax': instance.totalTax,
  'effectiveRate': instance.effectiveRate,
};
