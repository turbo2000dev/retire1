// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_projection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$YearlyProjectionImpl _$$YearlyProjectionImplFromJson(
  Map<String, dynamic> json,
) => _$YearlyProjectionImpl(
  year: (json['year'] as num).toInt(),
  yearsFromStart: (json['yearsFromStart'] as num).toInt(),
  primaryAge: (json['primaryAge'] as num?)?.toInt(),
  spouseAge: (json['spouseAge'] as num?)?.toInt(),
  totalIncome: (json['totalIncome'] as num).toDouble(),
  totalExpenses: (json['totalExpenses'] as num).toDouble(),
  netCashFlow: (json['netCashFlow'] as num).toDouble(),
  assetsStartOfYear: (json['assetsStartOfYear'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  assetsEndOfYear: (json['assetsEndOfYear'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  netWorthStartOfYear: (json['netWorthStartOfYear'] as num).toDouble(),
  netWorthEndOfYear: (json['netWorthEndOfYear'] as num).toDouble(),
  eventsOccurred: (json['eventsOccurred'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$YearlyProjectionImplToJson(
  _$YearlyProjectionImpl instance,
) => <String, dynamic>{
  'year': instance.year,
  'yearsFromStart': instance.yearsFromStart,
  'primaryAge': instance.primaryAge,
  'spouseAge': instance.spouseAge,
  'totalIncome': instance.totalIncome,
  'totalExpenses': instance.totalExpenses,
  'netCashFlow': instance.netCashFlow,
  'assetsStartOfYear': instance.assetsStartOfYear,
  'assetsEndOfYear': instance.assetsEndOfYear,
  'netWorthStartOfYear': instance.netWorthStartOfYear,
  'netWorthEndOfYear': instance.netWorthEndOfYear,
  'eventsOccurred': instance.eventsOccurred,
};
