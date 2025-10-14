import 'package:freezed_annotation/freezed_annotation.dart';

part 'tax_calculation.freezed.dart';
part 'tax_calculation.g.dart';

/// Tax calculation result for a given income amount
///
/// This model represents the complete tax calculation for federal and Quebec
/// provincial taxes, including the effective tax rate.
@freezed
class TaxCalculation with _$TaxCalculation {
  const factory TaxCalculation({
    /// Total income before any deductions
    required double grossIncome,

    /// Income subject to tax (after deductions like RRSP)
    required double taxableIncome,

    /// Federal tax owing (after credits applied)
    required double federalTax,

    /// Quebec provincial tax owing (after credits applied)
    required double quebecTax,

    /// Total tax owing (federal + Quebec)
    required double totalTax,

    /// Effective tax rate as a percentage (totalTax / grossIncome * 100)
    required double effectiveRate,
  }) = _TaxCalculation;

  factory TaxCalculation.fromJson(Map<String, dynamic> json) =>
      _$TaxCalculationFromJson(json);
}
