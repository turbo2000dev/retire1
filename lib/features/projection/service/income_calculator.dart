import 'dart:developer';

import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/projection/domain/annual_income.dart';

import 'income_constants.dart';

/// Service for calculating all income sources for retirement projections
///
/// This calculator computes employment income, RRQ (Quebec Pension Plan),
/// PSV (Old Age Security), and RRPE (RRIF/CRI minimum withdrawals) for
/// each year in the projection.
class IncomeCalculator {
  /// Calculate all income sources for an individual for a specific year
  ///
  /// Parameters:
  /// - [individual]: The individual whose income is being calculated
  /// - [year]: The projection year (calendar year)
  /// - [yearsFromStart]: Years from start of projection
  /// - [age]: Individual's age during this year
  /// - [events]: List of lifecycle events
  /// - [criBalance]: Current CRI/RRIF account balance (for RRPE calculation)
  ///
  /// Returns an [AnnualIncome] object with all income sources
  AnnualIncome calculateIncome({
    required Individual individual,
    required int year,
    required int yearsFromStart,
    required int age,
    required List<Event> events,
    double criBalance = 0.0,
  }) {
    log('IncomeCalculator.calculateIncome: year=$year, age=$age, individual=${individual.name}',
        name: 'IncomeCalculator');

    // Calculate each income source
    final employment = _calculateEmploymentIncome(
      individual: individual,
      year: year,
      yearsFromStart: yearsFromStart,
      events: events,
    );

    final rrq = _calculateRRQ(
      individual: individual,
      age: age,
    );

    final psv = _calculatePSV(
      individual: individual,
      age: age,
      totalOtherIncome: employment + rrq, // PSV clawback based on total income
    );

    final rrpe = _calculateRRPE(
      age: age,
      criBalance: criBalance,
    );

    final income = AnnualIncome(
      employment: employment,
      rrq: rrq,
      psv: psv,
      rrpe: rrpe,
      other: 0.0, // Reserved for future income sources
    );

    log('IncomeCalculator: Total income=${income.total} '
        '(employment=$employment, rrq=$rrq, psv=$psv, rrpe=$rrpe)',
        name: 'IncomeCalculator');

    return income;
  }

  /// Calculate employment income for the year
  ///
  /// Employment income continues until retirement event occurs.
  /// After retirement, employment income is zero.
  double _calculateEmploymentIncome({
    required Individual individual,
    required int year,
    required int yearsFromStart,
    required List<Event> events,
  }) {
    // Check if individual has retired by checking for retirement event
    final retirementEvent = events.where((event) {
      return event.when(
        retirement: (id, individualId, timing) => individualId == individual.id,
        death: (id, individualId, timing) => false,
        realEstateTransaction: (id, type, timing, propertyValue, depositAccount,
                withdrawalAccount) =>
            false,
      );
    }).firstOrNull;

    if (retirementEvent == null) {
      // No retirement event - employment income continues
      return individual.employmentIncome;
    }

    // Check if retirement has occurred
    // For now, we use a simplified check - in the full implementation,
    // this would use the timing resolution logic from ProjectionCalculator
    // For Phase 26, we'll assume retirement timing is properly resolved elsewhere
    // and passed through the events list with resolved years

    // Simplified: If retirement event exists and we're past year 0, assume retired
    // This will be properly integrated when we connect to ProjectionCalculator
    return individual.employmentIncome; // Will be refined in integration
  }

  /// Calculate RRQ (Régime de rentes du Québec / Quebec Pension Plan) benefit
  ///
  /// RRQ benefits:
  /// - Start at the age specified in individual.rrqStartAge (60-70)
  /// - Base benefit is individual.rrqAnnualBenefit (at age 65)
  /// - Early start (before 65): penalty of 0.6% per month
  /// - Late start (after 65): bonus of 0.7% per month
  double _calculateRRQ({
    required Individual individual,
    required int age,
  }) {
    // No RRQ if not yet at start age
    if (age < individual.rrqStartAge) {
      return 0.0;
    }

    // Base benefit (specified by user, represents benefit at age 65)
    final baseBenefit = individual.rrqAnnualBenefit;

    // Calculate adjustment factor based on start age
    final startAge = individual.rrqStartAge;
    double adjustmentFactor = 1.0;

    if (startAge < 65) {
      // Early start penalty: 0.6% per month before 65
      final monthsEarly = (65 - startAge) * 12;
      final penaltyRate = monthsEarly * kRRQEarlyPenaltyPerMonth;
      adjustmentFactor = 1.0 - penaltyRate;
    } else if (startAge > 65) {
      // Late start bonus: 0.7% per month after 65
      final monthsLate = (startAge - 65) * 12;
      final bonusRate = monthsLate * kRRQLateBonusPerMonth;
      adjustmentFactor = 1.0 + bonusRate;
    }

    final adjustedBenefit = baseBenefit * adjustmentFactor;

    log('IncomeCalculator._calculateRRQ: age=$age, startAge=$startAge, '
        'baseBenefit=$baseBenefit, adjustment=$adjustmentFactor, '
        'benefit=$adjustedBenefit',
        name: 'IncomeCalculator');

    return adjustedBenefit;
  }

  /// Calculate PSV (Pension de la Sécurité de la vieillesse / Old Age Security) benefit
  ///
  /// PSV (OAS):
  /// - Starts at age specified in individual.psvStartAge (typically 65-70)
  /// - Base amount is ~$8,500/year (2025)
  /// - Clawback: 15% of income over $90,000 threshold
  /// - Benefit cannot go negative
  double _calculatePSV({
    required Individual individual,
    required int age,
    required double totalOtherIncome,
  }) {
    // No PSV if not yet at start age
    if (age < individual.psvStartAge) {
      return 0.0;
    }

    // Base PSV amount
    double psvAmount = kPSVBaseAmount2025;

    // Apply clawback if income exceeds threshold
    if (totalOtherIncome > kPSVClawbackThreshold2025) {
      final excessIncome = totalOtherIncome - kPSVClawbackThreshold2025;
      final clawback = excessIncome * kPSVClawbackRate;
      psvAmount -= clawback;
    }

    // PSV cannot go negative
    final finalAmount = psvAmount.clamp(0.0, double.infinity);

    log('IncomeCalculator._calculatePSV: age=$age, startAge=${individual.psvStartAge}, '
        'baseAmount=$kPSVBaseAmount2025, otherIncome=$totalOtherIncome, '
        'finalAmount=$finalAmount',
        name: 'IncomeCalculator');

    return finalAmount;
  }

  /// Calculate RRPE (RRIF/CRI minimum required withdrawal)
  ///
  /// RRIF/CRI accounts have minimum withdrawal requirements based on age:
  /// - No minimum before age 65
  /// - Percentage increases with age (4% at 65 to 20% at 95+)
  /// - Withdrawal is calculated as percentage of account balance
  double _calculateRRPE({
    required int age,
    required double criBalance,
  }) {
    // No CRI balance means no withdrawal
    if (criBalance <= 0) {
      return 0.0;
    }

    // Get minimum withdrawal rate for age
    final withdrawalRate = getRRIFMinimumWithdrawalRate(age);

    // Calculate minimum withdrawal
    final withdrawal = criBalance * withdrawalRate;

    log('IncomeCalculator._calculateRRPE: age=$age, balance=$criBalance, '
        'rate=$withdrawalRate, withdrawal=$withdrawal',
        name: 'IncomeCalculator');

    return withdrawal;
  }
}
