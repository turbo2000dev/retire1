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
  incomeByIndividual:
      (json['incomeByIndividual'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, AnnualIncome.fromJson(e as Map<String, dynamic>)),
      ) ??
      const {},
  totalIncome: (json['totalIncome'] as num).toDouble(),
  taxableIncome: (json['taxableIncome'] as num?)?.toDouble() ?? 0.0,
  federalTax: (json['federalTax'] as num?)?.toDouble() ?? 0.0,
  quebecTax: (json['quebecTax'] as num?)?.toDouble() ?? 0.0,
  totalTax: (json['totalTax'] as num?)?.toDouble() ?? 0.0,
  afterTaxIncome: (json['afterTaxIncome'] as num?)?.toDouble() ?? 0.0,
  totalExpenses: (json['totalExpenses'] as num).toDouble(),
  expensesByCategory:
      (json['expensesByCategory'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  withdrawalsByAccount:
      (json['withdrawalsByAccount'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  contributionsByAccount:
      (json['contributionsByAccount'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
  totalWithdrawals: (json['totalWithdrawals'] as num?)?.toDouble() ?? 0.0,
  totalContributions: (json['totalContributions'] as num?)?.toDouble() ?? 0.0,
  celiContributionRoom:
      (json['celiContributionRoom'] as num?)?.toDouble() ?? 0.0,
  netCashFlow: (json['netCashFlow'] as num).toDouble(),
  assetsStartOfYear: (json['assetsStartOfYear'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  assetsEndOfYear: (json['assetsEndOfYear'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, (e as num).toDouble()),
  ),
  assetReturns:
      (json['assetReturns'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ) ??
      const {},
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
  'incomeByIndividual': instance.incomeByIndividual.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
  'totalIncome': instance.totalIncome,
  'taxableIncome': instance.taxableIncome,
  'federalTax': instance.federalTax,
  'quebecTax': instance.quebecTax,
  'totalTax': instance.totalTax,
  'afterTaxIncome': instance.afterTaxIncome,
  'totalExpenses': instance.totalExpenses,
  'expensesByCategory': instance.expensesByCategory,
  'withdrawalsByAccount': instance.withdrawalsByAccount,
  'contributionsByAccount': instance.contributionsByAccount,
  'totalWithdrawals': instance.totalWithdrawals,
  'totalContributions': instance.totalContributions,
  'celiContributionRoom': instance.celiContributionRoom,
  'netCashFlow': instance.netCashFlow,
  'assetsStartOfYear': instance.assetsStartOfYear,
  'assetsEndOfYear': instance.assetsEndOfYear,
  'assetReturns': instance.assetReturns,
  'netWorthStartOfYear': instance.netWorthStartOfYear,
  'netWorthEndOfYear': instance.netWorthEndOfYear,
  'eventsOccurred': instance.eventsOccurred,
};
