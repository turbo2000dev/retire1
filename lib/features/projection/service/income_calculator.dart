import 'dart:developer';

import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/projection/domain/annual_income.dart';

import 'income_constants.dart';

/// Service for calculating all income sources for retirement projections
///
/// This calculator computes employment income, RRQ (Quebec Pension Plan),
/// PSV (Old Age Security), RRIF/CRI minimum withdrawals, and RRPE
/// (Régime de retraite du personnel d'encadrement) for each year in the projection.
class IncomeCalculator {
  /// Calculate all income sources for an individual for a specific year
  ///
  /// Parameters:
  /// - [individual]: The individual whose income is being calculated
  /// - [year]: The projection year (calendar year)
  /// - [yearsFromStart]: Years from start of projection
  /// - [age]: Individual's age during this year
  /// - [events]: List of lifecycle events (that have occurred so far)
  /// - [criBalance]: Current CRI/RRIF account balance (for RRIF calculation)
  /// - [allIndividuals]: All individuals in the project (for survivor benefit calculation)
  /// - [inflationRate]: Annual inflation rate (defaults to 2%)
  ///
  /// Returns an [AnnualIncome] object with all income sources
  AnnualIncome calculateIncome({
    required Individual individual,
    required int year,
    required int yearsFromStart,
    required int age,
    required List<Event> events,
    double criBalance = 0.0,
    List<Individual> allIndividuals = const [],
    double inflationRate = 0.02,
  }) {
    final projectionStartYear = year - yearsFromStart;
    log('IncomeCalculator.calculateIncome: year=$year, age=$age, individual=${individual.name}',
        name: 'IncomeCalculator');

    // Check if individual is deceased (death event occurred)
    final isDeceased = _isIndividualDeceased(
      individual: individual,
      events: events,
    );

    if (isDeceased) {
      log('IncomeCalculator: Individual ${individual.name} is deceased - no income',
          name: 'IncomeCalculator');
      return const AnnualIncome(
        employment: 0.0,
        rrq: 0.0,
        psv: 0.0,
        rrif: 0.0,
        rrpe: 0.0,
        other: 0.0,
      );
    }

    // Calculate each income source
    final employment = _calculateEmploymentIncome(
      individual: individual,
      year: year,
      yearsFromStart: yearsFromStart,
      events: events,
      inflationRate: inflationRate,
    );

    final rrq = _calculateRRQ(
      individual: individual,
      age: age,
      inflationRate: inflationRate,
    );

    final psv = _calculatePSV(
      individual: individual,
      age: age,
      totalOtherIncome: employment + rrq, // PSV clawback based on total income
      inflationRate: inflationRate,
    );

    final rrif = _calculateRRIF(
      age: age,
      criBalance: criBalance,
    );

    final rrpe = _calculateRRPE(
      individual: individual,
      age: age,
      year: year,
      projectionStartYear: projectionStartYear,
      events: events,
      inflationRate: inflationRate,
    );

    // Calculate survivor benefits from deceased spouses
    final survivorBenefits = _calculateSurvivorBenefits(
      individual: individual,
      allIndividuals: allIndividuals,
      events: events,
      year: year,
      inflationRate: inflationRate,
    );

    final income = AnnualIncome(
      employment: employment,
      rrq: rrq,
      psv: psv,
      rrif: 0.0, // TEMPORARILY DISABLED - will fix RRIF calculations later
      rrpe: rrpe,
      other: survivorBenefits, // Survivor benefits go in 'other'
    );

    log('IncomeCalculator: Total income=${income.total} '
        '(employment=$employment, rrq=$rrq, psv=$psv, rrif=$rrif, rrpe=$rrpe, survivor=$survivorBenefits)',
        name: 'IncomeCalculator');

    return income;
  }

  /// Check if an individual is deceased based on death events that have occurred
  bool _isIndividualDeceased({
    required Individual individual,
    required List<Event> events,
  }) {
    // Check if death event exists for this individual in events that have occurred
    final deathEvent = events.where((event) {
      return event.when(
        death: (id, individualId, timing) => individualId == individual.id,
        retirement: (id, individualId, timing) => false,
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            false,
      );
    }).firstOrNull;

    return deathEvent != null;
  }

  /// Calculate survivor benefits from deceased spouses
  ///
  /// Simplified survivor benefit calculation:
  /// - Survivor receives 60% of deceased spouse's RRQ and PSV benefits
  /// - This is a simplified model (actual RRQ/QPP survivor rules are complex)
  double _calculateSurvivorBenefits({
    required Individual individual,
    required List<Individual> allIndividuals,
    required List<Event> events,
    required int year,
    required double inflationRate,
  }) {
    double totalSurvivorBenefits = 0.0;

    // Find all deceased individuals (potential spouses)
    for (final otherIndividual in allIndividuals) {
      // Skip self
      if (otherIndividual.id == individual.id) continue;

      // Check if this individual is deceased
      final isDeceased = _isIndividualDeceased(
        individual: otherIndividual,
        events: events,
      );

      if (!isDeceased) continue;

      // Calculate what their RRQ and PSV would have been
      final deceasedAge = _calculateAgeAtYear(otherIndividual.birthdate, year);

      // Calculate deceased's RRQ (if they were receiving it)
      double deceasedRRQ = 0.0;
      if (deceasedAge >= otherIndividual.rrqStartAge) {
        deceasedRRQ = _calculateRRQ(
          individual: otherIndividual,
          age: deceasedAge,
          inflationRate: inflationRate,
        );
      }

      // Calculate deceased's PSV (if they were receiving it)
      double deceasedPSV = 0.0;
      if (deceasedAge >= otherIndividual.psvStartAge) {
        // For survivor benefit calculation, assume no clawback on deceased's PSV
        // (simplified model) but still apply inflation indexing
        final yearsSinceStart = deceasedAge - otherIndividual.psvStartAge;
        double inflationMultiplier = 1.0;
        for (int i = 0; i < yearsSinceStart; i++) {
          inflationMultiplier *= (1 + inflationRate);
        }
        deceasedPSV = kPSVBaseAmount2025 * inflationMultiplier;
      }

      // Survivor receives 60% of RRQ and PSV
      const survivorBenefitRate = 0.60;
      final survivorBenefit = (deceasedRRQ + deceasedPSV) * survivorBenefitRate;

      log('IncomeCalculator._calculateSurvivorBenefits: ${individual.name} receives '
          '\$$survivorBenefit from deceased ${otherIndividual.name} '
          '(RRQ: \$$deceasedRRQ, PSV: \$$deceasedPSV)',
          name: 'IncomeCalculator');

      totalSurvivorBenefits += survivorBenefit;
    }

    return totalSurvivorBenefits;
  }

  /// Helper to calculate age at a specific year
  int _calculateAgeAtYear(DateTime birthdate, int year) {
    int age = year - birthdate.year;
    return age;
  }

  /// Calculate employment income for the year
  ///
  /// Employment income:
  /// - Grows with inflation each year: baseIncome * (1 + inflationRate)^yearsFromStart
  /// - Continues until retirement event occurs
  /// - After retirement, employment income is zero
  double _calculateEmploymentIncome({
    required Individual individual,
    required int year,
    required int yearsFromStart,
    required List<Event> events,
    required double inflationRate,
  }) {
    // Check if individual has retired by checking for retirement event in events that have occurred
    final hasRetired = events.any((event) {
      return event.when(
        retirement: (id, individualId, timing) => individualId == individual.id,
        death: (id, individualId, timing) => false,
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            false,
      );
    });

    if (hasRetired) {
      // Retirement event has occurred - no more employment income
      log('IncomeCalculator._calculateEmploymentIncome: ${individual.name} is retired - no employment income',
          name: 'IncomeCalculator');
      return 0.0;
    }

    // Calculate inflation-adjusted employment income
    // Base income grows each year: baseIncome * (1 + inflationRate)^yearsFromStart
    final baseIncome = individual.employmentIncome;

    if (yearsFromStart == 0) {
      return baseIncome;
    }

    // Apply compound inflation
    double inflationMultiplier = 1.0;
    for (int i = 0; i < yearsFromStart; i++) {
      inflationMultiplier *= (1 + inflationRate);
    }

    final adjustedIncome = baseIncome * inflationMultiplier;

    log('IncomeCalculator._calculateEmploymentIncome: ${individual.name} '
        'baseIncome=\$$baseIncome, yearsFromStart=$yearsFromStart, '
        'inflationRate=$inflationRate, adjustedIncome=\$$adjustedIncome',
        name: 'IncomeCalculator');

    return adjustedIncome;
  }

  /// Calculate RRQ (Régime de rentes du Québec / Quebec Pension Plan) benefit
  ///
  /// RRQ benefits:
  /// - Start at the age specified in individual.rrqStartAge (60-70)
  /// - User provides projected amounts at age 60 and 65
  /// - For ages between 60-65: linear interpolation
  /// - For ages > 65: apply 0.7% per month bonus from age 65 amount
  /// - Benefits are indexed to inflation each year after starting
  double _calculateRRQ({
    required Individual individual,
    required int age,
    required double inflationRate,
  }) {
    // No RRQ if not yet at start age
    if (age < individual.rrqStartAge) {
      return 0.0;
    }

    final startAge = individual.rrqStartAge;
    double baseBenefit = 0.0;

    if (startAge <= 60) {
      // Starting at 60 or before: use projected amount at 60
      baseBenefit = individual.projectedRrqAt60;
    } else if (startAge >= 65) {
      // Starting at 65 or later: use projected amount at 65 plus late bonus
      baseBenefit = individual.projectedRrqAt65;

      if (startAge > 65) {
        // Apply late start bonus: 0.7% per month after 65
        final monthsLate = (startAge - 65) * 12;
        final bonusRate = monthsLate * kRRQLateBonusPerMonth;
        baseBenefit = baseBenefit * (1.0 + bonusRate);
      }
    } else {
      // Starting between 60 and 65: linear interpolation
      final progressRatio = (startAge - 60) / 5.0; // 0.0 at 60, 1.0 at 65
      baseBenefit = individual.projectedRrqAt60 +
                (individual.projectedRrqAt65 - individual.projectedRrqAt60) * progressRatio;
    }

    // Apply inflation indexing for years since benefit started
    final yearsSinceStart = age - startAge;
    double inflationMultiplier = 1.0;
    for (int i = 0; i < yearsSinceStart; i++) {
      inflationMultiplier *= (1 + inflationRate);
    }
    final indexedBenefit = baseBenefit * inflationMultiplier;

    log('IncomeCalculator._calculateRRQ: age=$age, startAge=$startAge, '
        'baseBenefit=\$$baseBenefit, yearsSinceStart=$yearsSinceStart, '
        'inflationMultiplier=$inflationMultiplier, indexedBenefit=\$$indexedBenefit',
        name: 'IncomeCalculator');

    return indexedBenefit;
  }

  /// Calculate PSV (Pension de la Sécurité de la vieillesse / Old Age Security) benefit
  ///
  /// PSV (OAS):
  /// - Starts at age specified in individual.psvStartAge (typically 65-70)
  /// - Base amount is ~$8,500/year (2025)
  /// - Clawback: 15% of income over $90,000 threshold
  /// - Benefits are indexed to inflation each year after starting
  /// - Benefit cannot go negative
  double _calculatePSV({
    required Individual individual,
    required int age,
    required double totalOtherIncome,
    required double inflationRate,
  }) {
    // No PSV if not yet at start age
    if (age < individual.psvStartAge) {
      return 0.0;
    }

    final startAge = individual.psvStartAge;

    // Base PSV amount (indexed for inflation)
    double basePsvAmount = kPSVBaseAmount2025;

    // Apply inflation indexing for years since benefit started
    final yearsSinceStart = age - startAge;
    double inflationMultiplier = 1.0;
    for (int i = 0; i < yearsSinceStart; i++) {
      inflationMultiplier *= (1 + inflationRate);
    }
    basePsvAmount = basePsvAmount * inflationMultiplier;

    // Apply clawback if income exceeds threshold (threshold also indexed)
    double indexedThreshold = kPSVClawbackThreshold2025 * inflationMultiplier;
    double psvAmount = basePsvAmount;

    if (totalOtherIncome > indexedThreshold) {
      final excessIncome = totalOtherIncome - indexedThreshold;
      final clawback = excessIncome * kPSVClawbackRate;
      psvAmount -= clawback;
    }

    // PSV cannot go negative
    final finalAmount = psvAmount.clamp(0.0, double.infinity);

    log('IncomeCalculator._calculatePSV: age=$age, startAge=$startAge, '
        'basePsvAmount=\$$basePsvAmount, yearsSinceStart=$yearsSinceStart, '
        'inflationMultiplier=$inflationMultiplier, otherIncome=$totalOtherIncome, '
        'finalAmount=$finalAmount',
        name: 'IncomeCalculator');

    return finalAmount;
  }

  /// Calculate RRIF/CRI minimum required withdrawal
  ///
  /// RRIF/CRI accounts have minimum withdrawal requirements based on age:
  /// - No minimum before age 65
  /// - Percentage increases with age (4% at 65 to 20% at 95+)
  /// - Withdrawal is calculated as percentage of account balance
  double _calculateRRIF({
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

    log('IncomeCalculator._calculateRRIF: age=$age, balance=$criBalance, '
        'rate=$withdrawalRate, withdrawal=$withdrawal',
        name: 'IncomeCalculator');

    return withdrawal;
  }

  /// Calculate RRPE (Régime de retraite du personnel d'encadrement) pension
  ///
  /// RRPE is a Quebec management pension plan with the following formula:
  /// - Years of service = retirement year - participation start year
  /// - Average salary = average of salary for last 5 years before retirement (or fewer if < 5 years service)
  /// - Base annual pension = years of service × average salary × 2%
  /// - Before age 65: pension is indexed with inflation each year
  /// - At age 65+: pension is reduced by 7% × service years (max 35) × MGA (indexed to inflation)
  ///
  /// Parameters:
  /// - [individual]: The individual (must have hasRrpe=true and rrpeParticipationStartDate)
  /// - [age]: Individual's current age
  /// - [year]: Current projection year
  /// - [projectionStartYear]: The year the projection started
  /// - [events]: List of events (to detect retirement and find retirement year)
  /// - [inflationRate]: Annual inflation rate
  double _calculateRRPE({
    required Individual individual,
    required int age,
    required int year,
    required int projectionStartYear,
    required List<Event> events,
    required double inflationRate,
  }) {
    // No RRPE if individual doesn't participate
    if (!individual.hasRrpe || individual.rrpeParticipationStartDate == null) {
      return 0.0;
    }

    // Find retirement event for this individual
    Event? retirementEvent;
    for (final event in events) {
      final isRetirement = event.maybeWhen(
        retirement: (id, individualId, timing) => individualId == individual.id,
        orElse: () => false,
      );
      if (isRetirement) {
        retirementEvent = event;
        break;
      }
    }

    // RRPE pension starts at retirement
    if (retirementEvent == null) {
      return 0.0;
    }

    // Calculate retirement year from the retirement event
    // We need to resolve the timing to get the actual calendar year
    final retirementTiming = retirementEvent.when(
      retirement: (id, individualId, timing) => timing,
      death: (id, individualId, timing) => null,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          null,
    );

    if (retirementTiming == null) {
      return 0.0;
    }

    // Resolve timing to calendar year
    final retirementYear = retirementTiming.when(
      relative: (yearsFromStart) {
        // We don't have startYear here, so we need to derive it from current year and individual's age
        // This is a workaround - ideally startYear would be passed as a parameter
        // For now, estimate: if retirement is relative, we can't determine exact year without more context
        // Use the individual's birthdate and retirement age to estimate
        return individual.birthdate.year + age; // Approximation
      },
      absolute: (calendarYear) => calendarYear,
      age: (individualId, targetAge) {
        // Retirement at specific age - calculate calendar year
        return individual.birthdate.year + targetAge;
      },
      eventRelative: (eventId, boundary) {
        // Can't easily resolve without more context - use current year as fallback
        return year;
      },
      projectionEnd: () => year,
    );

    final participationStartDate = individual.rrpeParticipationStartDate!;
    final participationStartYear = participationStartDate.year;

    // Calculate years of service (from participation start to retirement)
    final yearsOfService = retirementYear - participationStartYear;

    // Calculate average salary for last 5 years before retirement
    final salaryYearsCount = yearsOfService < 5 ? yearsOfService : 5;

    if (salaryYearsCount <= 0) {
      return 0.0; // No service years
    }

    // Calculate average salary of the last 5 years before retirement
    // The employment income in the Individual is the base salary at projection start
    // We need to inflate it to retirement year, then average the last 5 years
    double totalSalary = 0.0;
    final baseSalary = individual.employmentIncome;

    // Calculate the inflation-adjusted salary at retirement year
    // Base salary is at projection start, inflate it to retirement year
    final yearsToRetirement = retirementYear - projectionStartYear;
    double salaryAtRetirement = baseSalary;
    for (int i = 0; i < yearsToRetirement; i++) {
      salaryAtRetirement *= (1 + inflationRate);
    }

    // Now calculate average of last salaryYearsCount years before retirement
    for (int i = 0; i < salaryYearsCount; i++) {
      // i=0 is the year of retirement, i=1 is one year before retirement, etc.
      double yearSalary = salaryAtRetirement;
      // Deflate salary for each year back from retirement
      for (int j = 0; j < i; j++) {
        yearSalary /= (1 + inflationRate);
      }
      totalSalary += yearSalary;
    }

    final averageSalary = totalSalary / salaryYearsCount;

    // Calculate base annual pension: years of service × average salary × 2%
    final basePension = yearsOfService * averageSalary * kRRPEPensionAccrualRate;

    // The pension starts at retirement and is indexed to inflation each year
    final yearsFromRetirement = year - retirementYear;

    double indexedPension = basePension;
    for (int i = 0; i < yearsFromRetirement; i++) {
      indexedPension *= (1 + inflationRate);
    }

    // Apply age 65+ reduction if applicable
    double finalPension = indexedPension;
    if (age >= 65) {
      // Calculate MGA indexed to inflation from 2024
      final yearsFrom2024 = year - 2024;
      double indexedMGA = kRRPEMGA2024;
      for (int i = 0; i < yearsFrom2024; i++) {
        indexedMGA *= (1 + inflationRate);
      }

      // The reduction uses the LOWER of: average salary or MGA
      // This prevents excessive reduction for lower-paid employees
      final reductionBase = averageSalary < indexedMGA ? averageSalary : indexedMGA;

      // Calculate reduction: 0.7% × service years (max 35) × reductionBase
      final serviceYearsForReduction = yearsOfService > kRRPEMaxServiceYearsForReduction
          ? kRRPEMaxServiceYearsForReduction
          : yearsOfService;
      final reduction = kRRPEReductionRate * serviceYearsForReduction * reductionBase;

      finalPension = (indexedPension - reduction).clamp(0.0, double.infinity);

      log('IncomeCalculator._calculateRRPE: age=$age (≥65), reduction=\$$reduction '
          '(serviceYears=$serviceYearsForReduction, reductionBase=\$$reductionBase, '
          'averageSalary=\$$averageSalary, MGA=\$$indexedMGA)',
          name: 'IncomeCalculator');
    }

    log('IncomeCalculator._calculateRRPE: age=$age, retirementYear=$retirementYear, '
        'yearsOfService=$yearsOfService, yearsFromRetirement=$yearsFromRetirement, '
        'averageSalary=\$$averageSalary, basePension=\$$basePension, '
        'finalPension=\$$finalPension',
        name: 'IncomeCalculator');

    return finalPension;
  }
}
