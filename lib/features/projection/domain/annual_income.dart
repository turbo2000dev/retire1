import 'package:freezed_annotation/freezed_annotation.dart';

part 'annual_income.freezed.dart';
part 'annual_income.g.dart';

/// Annual income breakdown for an individual
///
/// This model represents all income sources for a single individual
/// for one year in the projection.
@freezed
class AnnualIncome with _$AnnualIncome {
  const AnnualIncome._();

  const factory AnnualIncome({
    /// Employment income (salary/wages)
    @Default(0.0) double employment,

    /// RRQ (Régime de rentes du Québec / Quebec Pension Plan) benefit
    @Default(0.0) double rrq,

    /// PSV (Pension de la Sécurité de la vieillesse / Old Age Security) benefit
    @Default(0.0) double psv,

    /// RRIF/CRI minimum withdrawal (formerly called rrpe)
    @Default(0.0) double rrif,

    /// RRPE (Régime de retraite du personnel d'encadrement) pension
    @Default(0.0) double rrpe,

    /// Other income sources (dividends, rental income, survivor benefits, etc.)
    @Default(0.0) double other,
  }) = _AnnualIncome;

  factory AnnualIncome.fromJson(Map<String, dynamic> json) =>
      _$AnnualIncomeFromJson(json);

  /// Calculate total income from all sources
  double get total => employment + rrq + psv + rrif + rrpe + other;

  /// Check if individual has any income this year
  bool get hasIncome => total > 0;
}
