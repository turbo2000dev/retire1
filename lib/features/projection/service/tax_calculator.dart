import 'dart:developer';

import '../domain/tax_calculation.dart';
import 'tax_constants.dart';

/// Service for calculating Canadian federal and Quebec provincial taxes
///
/// This calculator uses 2025 tax brackets and credits to compute tax owing
/// for a given income amount. It applies progressive tax brackets correctly
/// and uses exact tax credit calculation.
///
/// Tax credits are calculated by multiplying the credit amount by the lowest
/// marginal tax rate (15% federal, 14% Quebec), which reduces the tax owing
/// directly rather than reducing taxable income.
///
/// Note: This implementation does not yet handle:
/// - RRSP deductions (will be added in Phase 28)
/// - Pension income splitting (will be added in Phase 28)
class TaxCalculator {
  /// Calculates total tax owing for the given income and age
  ///
  /// Parameters:
  /// - [grossIncome]: Total income before any deductions
  /// - [age]: Age of the individual (for age credit eligibility)
  /// - [rrspDeduction]: RRSP contributions to deduct (not used until Phase 28)
  ///
  /// Returns a [TaxCalculation] with federal, Quebec, and total tax amounts
  TaxCalculation calculateTax({
    required double grossIncome,
    required int age,
    double rrspDeduction = 0.0, // Not used until Phase 28
  }) {
    log('TaxCalculator.calculateTax: grossIncome=$grossIncome, age=$age',
        name: 'TaxCalculator');

    // For now, taxable income equals gross income
    // In Phase 28, we'll subtract RRSP deductions here
    final taxableIncome = grossIncome;

    // Calculate federal tax
    final federalTax = _calculateFederalTax(
      taxableIncome: taxableIncome,
      age: age,
    );

    // Calculate Quebec tax
    final quebecTax = _calculateQuebecTax(
      taxableIncome: taxableIncome,
      age: age,
    );

    // Total tax
    final totalTax = federalTax + quebecTax;

    // Effective tax rate (avoid division by zero)
    final effectiveRate =
        grossIncome > 0 ? (totalTax / grossIncome * 100) : 0.0;

    log('TaxCalculator.calculateTax: federalTax=$federalTax, '
        'quebecTax=$quebecTax, totalTax=$totalTax, '
        'effectiveRate=${effectiveRate.toStringAsFixed(2)}%',
        name: 'TaxCalculator');

    return TaxCalculation(
      grossIncome: grossIncome,
      taxableIncome: taxableIncome,
      federalTax: federalTax,
      quebecTax: quebecTax,
      totalTax: totalTax,
      effectiveRate: effectiveRate,
    );
  }

  /// Calculates federal tax owing after applying credits
  double _calculateFederalTax({
    required double taxableIncome,
    required int age,
  }) {
    // Calculate tax using progressive brackets
    final taxBeforeCredits = _calculateTaxFromBrackets(
      taxableIncome: taxableIncome,
      brackets: kFederalTaxBrackets2025,
    );

    // Calculate total tax credits
    double totalCreditAmount = kFederalBasicPersonalAmount2025;

    // Add age credit if eligible (65+)
    if (age >= 65) {
      totalCreditAmount += kFederalAgeAmount2025;
    }

    // Apply credits: credit amount × lowest rate
    final creditReduction = totalCreditAmount * kFederalTaxCreditRate;

    // Tax owing = tax before credits - credit reduction (cannot be negative)
    final taxOwing = (taxBeforeCredits - creditReduction).clamp(0.0, double.infinity);

    return taxOwing;
  }

  /// Calculates Quebec provincial tax owing after applying credits
  double _calculateQuebecTax({
    required double taxableIncome,
    required int age,
  }) {
    // Calculate tax using progressive brackets
    final taxBeforeCredits = _calculateTaxFromBrackets(
      taxableIncome: taxableIncome,
      brackets: kQuebecTaxBrackets2025,
    );

    // Calculate total tax credits
    double totalCreditAmount = kQuebecBasicPersonalAmount2025;

    // Add age credit if eligible (65+)
    if (age >= 65) {
      totalCreditAmount += kQuebecAgeAmount2025;
    }

    // Apply credits: credit amount × lowest rate
    final creditReduction = totalCreditAmount * kQuebecTaxCreditRate;

    // Tax owing = tax before credits - credit reduction (cannot be negative)
    final taxOwing = (taxBeforeCredits - creditReduction).clamp(0.0, double.infinity);

    return taxOwing;
  }

  /// Calculates tax using progressive bracket system
  ///
  /// This method applies marginal tax rates correctly:
  /// - Income in the first bracket is taxed at the first rate
  /// - Income in the second bracket is taxed at the second rate
  /// - And so on for each bracket
  ///
  /// Example with brackets [0: 15%, 50000: 20%, 100000: 26%]:
  /// - Income of $75,000:
  ///   - First $50,000 taxed at 15% = $7,500
  ///   - Next $25,000 taxed at 20% = $5,000
  ///   - Total tax = $12,500
  double _calculateTaxFromBrackets({
    required double taxableIncome,
    required List<TaxBracket> brackets,
  }) {
    if (taxableIncome <= 0) return 0.0;

    double totalTax = 0.0;

    for (int i = 0; i < brackets.length; i++) {
      final bracket = brackets[i];
      final nextBracket = i < brackets.length - 1 ? brackets[i + 1] : null;

      // Determine the income range for this bracket
      final bracketStart = bracket.threshold;
      final bracketEnd = nextBracket?.threshold ?? double.infinity;

      // Calculate income within this bracket
      if (taxableIncome > bracketStart) {
        final incomeInBracket = (taxableIncome - bracketStart).clamp(
          0.0,
          bracketEnd - bracketStart,
        );

        // Calculate tax for this bracket
        final taxInBracket = incomeInBracket * bracket.rate;
        totalTax += taxInBracket;
      }
    }

    return totalTax;
  }
}
