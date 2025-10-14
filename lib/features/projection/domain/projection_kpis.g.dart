// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projection_kpis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectionKpisImpl _$$ProjectionKpisImplFromJson(Map<String, dynamic> json) =>
    _$ProjectionKpisImpl(
      yearMoneyRunsOut: (json['yearMoneyRunsOut'] as num?)?.toInt(),
      lowestNetWorth: (json['lowestNetWorth'] as num).toDouble(),
      yearOfLowestNetWorth: (json['yearOfLowestNetWorth'] as num).toInt(),
      finalNetWorth: (json['finalNetWorth'] as num).toDouble(),
      totalTaxesPaid: (json['totalTaxesPaid'] as num).toDouble(),
      totalWithdrawals: (json['totalWithdrawals'] as num).toDouble(),
      averageTaxRate: (json['averageTaxRate'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProjectionKpisImplToJson(
  _$ProjectionKpisImpl instance,
) => <String, dynamic>{
  'yearMoneyRunsOut': instance.yearMoneyRunsOut,
  'lowestNetWorth': instance.lowestNetWorth,
  'yearOfLowestNetWorth': instance.yearOfLowestNetWorth,
  'finalNetWorth': instance.finalNetWorth,
  'totalTaxesPaid': instance.totalTaxesPaid,
  'totalWithdrawals': instance.totalWithdrawals,
  'averageTaxRate': instance.averageTaxRate,
};
