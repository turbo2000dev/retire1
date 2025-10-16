/// Income calculation constants for 2025
///
/// This file contains hardcoded 2025 values for RRQ (Quebec Pension Plan),
/// PSV (Old Age Security), RRIF/CRI minimum withdrawals, and RRPE
/// (Régime de retraite du personnel d'encadrement).
library;

/// 2025 Maximum RRQ (Régime de rentes du Québec) annual benefit
///
/// This is the maximum benefit at age 65 for someone who contributed
/// the maximum amount throughout their career.
const double kMaxRRQBenefit2025 = 16000.0;

/// RRQ early start penalty
///
/// Penalty per month for starting RRQ before age 65.
/// Formula: -0.6% per month = -7.2% per year
const double kRRQEarlyPenaltyPerMonth = 0.006; // 0.6%

/// RRQ late start bonus
///
/// Bonus per month for delaying RRQ after age 65.
/// Formula: +0.7% per month = +8.4% per year
const double kRRQLateBonusPerMonth = 0.007; // 0.7%

/// 2025 PSV (Pension de la Sécurité de la vieillesse / Old Age Security) base amount
///
/// This is the base OAS pension amount per year (approximately $8,500).
/// The actual amount is adjusted quarterly for inflation.
const double kPSVBaseAmount2025 = 8500.0;

/// PSV clawback threshold
///
/// Income threshold above which PSV benefits start to be clawed back.
/// For 2025, approximately $90,000 in net income.
const double kPSVClawbackThreshold2025 = 90000.0;

/// PSV clawback rate
///
/// Rate at which PSV is reduced for income above the threshold.
/// 15% of income above threshold is clawed back.
const double kPSVClawbackRate = 0.15;

/// RRIF/CRI minimum withdrawal percentages by age
///
/// These are the minimum percentages that must be withdrawn annually
/// from RRIF (Registered Retirement Income Fund) or CRI (Compte de
/// retraite immobilisé) accounts based on the account holder's age.
///
/// Source: Canada Revenue Agency RRIF minimum withdrawal schedule
const Map<int, double> kRRIFMinimumWithdrawalRates = {
  65: 0.0400, // 4.00%
  66: 0.0417, // 4.17%
  67: 0.0435, // 4.35%
  68: 0.0455, // 4.55%
  69: 0.0476, // 4.76%
  70: 0.0500, // 5.00%
  71: 0.0528, // 5.28%
  72: 0.0540, // 5.40%
  73: 0.0553, // 5.53%
  74: 0.0567, // 5.67%
  75: 0.0582, // 5.82%
  76: 0.0598, // 5.98%
  77: 0.0617, // 6.17%
  78: 0.0636, // 6.36%
  79: 0.0658, // 6.58%
  80: 0.0682, // 6.82%
  81: 0.0708, // 7.08%
  82: 0.0738, // 7.38%
  83: 0.0771, // 7.71%
  84: 0.0808, // 8.08%
  85: 0.0851, // 8.51%
  86: 0.0899, // 8.99%
  87: 0.0955, // 9.55%
  88: 0.1021, // 10.21%
  89: 0.1099, // 10.99%
  90: 0.1192, // 11.92%
  91: 0.1306, // 13.06%
  92: 0.1449, // 14.49%
  93: 0.1634, // 16.34%
  94: 0.1879, // 18.79%
  95: 0.2000, // 20.00%
};

/// Get RRIF minimum withdrawal rate for a given age
///
/// Returns the minimum withdrawal percentage for the specified age.
/// For ages below 65, returns 0 (no minimum withdrawal required).
/// For ages 95 and above, returns 20% (the maximum rate).
double getRRIFMinimumWithdrawalRate(int age) {
  if (age < 65) return 0.0;
  if (age >= 95) return 0.20;
  return kRRIFMinimumWithdrawalRates[age] ?? 0.0;
}

/// RRPE (Régime de retraite du personnel d'encadrement) constants

/// 2024 MGA (Maximum pensionable earnings / Maximum des gains admissibles)
///
/// This is the income ceiling for RRPE calculations. The MGA is used
/// in the reduction formula for RRPE pensions at age 65+.
/// The MGA is indexed to inflation annually.
const double kRRPEMGA2024 = 68500.0;

/// RRPE pension accrual rate
///
/// The annual pension is calculated as:
/// years of service × average salary of last 5 years × 2%
const double kRRPEPensionAccrualRate = 0.02; // 2%

/// RRPE reduction rate at age 65
///
/// Starting at age 65, RRPE pension is reduced by:
/// 0.7% × number of service years (max 35) × lower of (average salary, MGA)
const double kRRPEReductionRate = 0.007; // 0.7%

/// RRPE maximum service years for reduction calculation
///
/// The reduction at age 65 is capped at 35 years of service.
const int kRRPEMaxServiceYearsForReduction = 35;
