/// Tax constants for 2025 tax calculations
///
/// This file contains hardcoded 2025 federal and Quebec tax brackets,
/// credits, and limits for Canadian tax calculations.
library;

/// Tax bracket definition with threshold and rate
class TaxBracket {
  const TaxBracket({required this.threshold, required this.rate});

  /// Income threshold where this bracket starts
  final double threshold;

  /// Tax rate for this bracket (as decimal, e.g., 0.15 for 15%)
  final double rate;
}

/// 2025 Federal tax brackets
///
/// Source: Canada Revenue Agency 2025 tax rates
/// Note: These are the marginal tax rates for each income bracket
const List<TaxBracket> kFederalTaxBrackets2025 = [
  TaxBracket(threshold: 0, rate: 0.15), // 15% on first $55,867
  TaxBracket(threshold: 55867, rate: 0.205), // 20.5% on next $55,866
  TaxBracket(threshold: 111733, rate: 0.26), // 26% on next $61,472
  TaxBracket(threshold: 173205, rate: 0.29), // 29% on next $73,547
  TaxBracket(threshold: 246752, rate: 0.33), // 33% on remainder
];

/// 2025 Quebec provincial tax brackets
///
/// Source: Revenu Québec 2025 tax rates
/// Note: These are the marginal tax rates for each income bracket
const List<TaxBracket> kQuebecTaxBrackets2025 = [
  TaxBracket(threshold: 0, rate: 0.14), // 14% on first $51,780
  TaxBracket(threshold: 51780, rate: 0.19), // 19% on next $51,765
  TaxBracket(threshold: 103545, rate: 0.24), // 24% on next $22,455
  TaxBracket(threshold: 126000, rate: 0.2575), // 25.75% on remainder
];

/// 2025 Federal basic personal amount
///
/// This is the amount of income that can be earned tax-free.
/// The actual tax credit is this amount multiplied by the lowest tax rate.
const double kFederalBasicPersonalAmount2025 = 15705.0;

/// 2025 Quebec basic personal amount
///
/// This is the amount of income that can be earned tax-free.
/// The actual tax credit is this amount multiplied by the lowest tax rate.
const double kQuebecBasicPersonalAmount2025 = 18056.0;

/// 2025 Federal age amount (for individuals 65+)
///
/// Additional credit available for seniors.
/// The actual tax credit is this amount multiplied by the lowest tax rate.
const double kFederalAgeAmount2025 = 8790.0;

/// 2025 Quebec age amount (for individuals 65+)
///
/// Additional credit available for seniors.
/// The actual tax credit is this amount multiplied by the lowest tax rate.
const double kQuebecAgeAmount2025 = 3458.0;

/// Federal tax credit rate
///
/// Tax credits are applied by multiplying the credit amount by this rate.
const double kFederalTaxCreditRate = 0.15;

/// Quebec tax credit rate
///
/// Tax credits are applied by multiplying the credit amount by this rate.
const double kQuebecTaxCreditRate = 0.14;

// RRSP contribution limits (for reference only - not used until Phase 28)
// These constants are defined here for completeness but won't be used in
// tax calculations until RRSP deduction tracking is implemented.

/// Maximum RRSP contribution room as percentage of previous year's income
const double kRRSPContributionRateLimit = 0.18; // 18%

/// Maximum RRSP contribution dollar limit for 2025
const double kRRSPContributionDollarLimit2025 = 32490.0;
