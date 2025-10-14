import 'package:freezed_annotation/freezed_annotation.dart';

import 'annual_income.dart';

part 'yearly_projection.freezed.dart';
part 'yearly_projection.g.dart';

/// Projection data for a single year
@freezed
class YearlyProjection with _$YearlyProjection {
  const factory YearlyProjection({
    /// Calendar year
    required int year,

    /// Years from start of projection (0-indexed)
    required int yearsFromStart,

    /// Age of primary individual at start of year
    required int? primaryAge,

    /// Age of spouse at start of year (if applicable)
    required int? spouseAge,

    /// Income by individual (keyed by individual ID)
    @Default({}) Map<String, AnnualIncome> incomeByIndividual,

    /// Total income for the year (household)
    required double totalIncome,

    /// Total taxable income for the year (household)
    @Default(0.0) double taxableIncome,

    /// Federal tax owing for the year (household)
    @Default(0.0) double federalTax,

    /// Quebec provincial tax owing for the year (household)
    @Default(0.0) double quebecTax,

    /// Total tax owing for the year (household, federal + Quebec)
    @Default(0.0) double totalTax,

    /// After-tax income (total income - total tax)
    @Default(0.0) double afterTaxIncome,

    /// Total expenses for the year
    required double totalExpenses,

    /// Expenses by category (keyed by category name)
    /// Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
    @Default({}) Map<String, double> expensesByCategory,

    /// Net cash flow (income - expenses - taxes)
    required double netCashFlow,

    /// Assets at start of year
    required Map<String, double> assetsStartOfYear,

    /// Assets at end of year
    required Map<String, double> assetsEndOfYear,

    /// Total net worth at start of year
    required double netWorthStartOfYear,

    /// Total net worth at end of year
    required double netWorthEndOfYear,

    /// Events that occurred during this year
    required List<String> eventsOccurred,
  }) = _YearlyProjection;

  factory YearlyProjection.fromJson(Map<String, dynamic> json) =>
      _$YearlyProjectionFromJson(json);
}
