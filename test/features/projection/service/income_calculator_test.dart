import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/projection/service/income_calculator.dart';
import 'package:retire1/features/projection/service/income_constants.dart';

void main() {
  late IncomeCalculator calculator;

  setUp(() {
    calculator = IncomeCalculator();
  });

  group('IncomeCalculator', () {
    group('RRQ Calculation', () {
      test('returns zero before RRQ start age', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          rrqStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2024,
          yearsFromStart: 0,
          age: 64, // Before RRQ start
          events: [],
        );

        expect(income.rrq, 0.0);
      });

      test('calculates RRQ at age 65 with no adjustment', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          rrqStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 1,
          age: 65, // At RRQ start age
          events: [],
        );

        // At age 65, benefit = base with no adjustment
        expect(income.rrq, 16000.0);
      });

      test('uses projected amount at age 60', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          rrqStartAge: 60,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2020,
          yearsFromStart: 0,
          age: 60,
          events: [],
        );

        // Starting at 60: use projectedRrqAt60
        expect(income.rrq, 12000.0);
      });

      test('applies late start bonus at age 70', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          rrqStartAge: 70, // 5 years late
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2030,
          yearsFromStart: 0,
          age: 70,
          events: [],
        );

        // 5 years late = 60 months × 0.7% = 42% bonus
        // Benefit = 16000 × (1 + 0.42) = 16000 × 1.42 = 22,720
        expect(income.rrq, closeTo(22720, 0.01));
      });

      test('interpolates benefit between ages 60 and 65', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          rrqStartAge: 62, // Between 60 and 65
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2022,
          yearsFromStart: 0,
          age: 62,
          events: [],
        );

        // Linear interpolation: (62-60)/5 = 0.4 progress
        // Benefit = 12000 + (16000 - 12000) × 0.4 = 12000 + 1600 = 13,600
        expect(income.rrq, closeTo(13600, 0.01));
      });
    });

    group('PSV Calculation', () {
      test('returns zero before PSV start age', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          psvStartAge: 65,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2024,
          yearsFromStart: 0,
          age: 64, // Before PSV start
          events: [],
        );

        expect(income.psv, 0.0);
      });

      test('calculates full PSV at age 65 with low income', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 0, // No employment income
          rrqStartAge: 65,
          psvStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000, // Only RRQ income
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 1,
          age: 65,
          events: [],
        );

        // Total other income = 0 (employment) + 16000 (RRQ) = 16000
        // Below clawback threshold, so full PSV
        expect(income.psv, kPSVBaseAmount2025);
      });

      test('applies clawback for high income', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 100000, // High employment income
          rrqStartAge: 65,
          psvStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 1,
          age: 65,
          events: [],
        );

        // Total other income = 100000 (employment) + 16000 (RRQ) = 116000
        // Excess over threshold = 116000 - 90000 = 26000
        // Clawback = 26000 × 15% = 3900
        // PSV = 8500 - 3900 = 4600
        expect(income.psv, closeTo(4600, 0.01));
      });

      test('PSV goes to zero with very high income', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 150000, // Very high employment income
          rrqStartAge: 65,
          psvStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 1,
          age: 65,
          events: [],
        );

        // Total other income = 150000 + 16000 = 166000
        // Excess = 166000 - 90000 = 76000
        // Clawback = 76000 × 15% = 11400
        // PSV = 8500 - 11400 = -2900 → clamped to 0
        expect(income.psv, 0.0);
      });

      test('calculates PSV at exact clawback threshold', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 74000, // Exactly at threshold with RRQ
          rrqStartAge: 65,
          psvStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 1,
          age: 65,
          events: [],
        );

        // Total other income = 74000 + 16000 = 90000 (exactly at threshold)
        // No clawback
        expect(income.psv, kPSVBaseAmount2025);
      });
    });

    group('RRPE (RRIF Withdrawal) Calculation', () {
      test('returns zero with no CRI balance', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 0,
          age: 70,
          events: [],
          criBalance: 0.0, // No CRI balance
        );

        expect(income.rrpe, 0.0);
      });

      test('returns zero before age 65', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2024,
          yearsFromStart: 0,
          age: 64,
          events: [],
          criBalance: 100000,
        );

        // No minimum withdrawal required before age 65
        expect(income.rrpe, 0.0);
      });

      test('calculates minimum withdrawal at age 65', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 0,
          age: 65,
          events: [],
          criBalance: 100000,
        );

        // At age 65: 4% minimum withdrawal
        // Withdrawal = 100000 × 0.04 = 4000
        expect(income.rrpe, closeTo(4000, 0.01));
      });

      test('calculates minimum withdrawal at age 70', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2030,
          yearsFromStart: 0,
          age: 70,
          events: [],
          criBalance: 100000,
        );

        // At age 70: 5% minimum withdrawal
        // Withdrawal = 100000 × 0.05 = 5000
        expect(income.rrpe, closeTo(5000, 0.01));
      });

      test('calculates minimum withdrawal at age 80', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2040,
          yearsFromStart: 0,
          age: 80,
          events: [],
          criBalance: 100000,
        );

        // At age 80: 6.82% minimum withdrawal
        // Withdrawal = 100000 × 0.0682 = 6820
        expect(income.rrpe, closeTo(6820, 0.01));
      });

      test('calculates minimum withdrawal at age 95+', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2055,
          yearsFromStart: 0,
          age: 95,
          events: [],
          criBalance: 100000,
        );

        // At age 95+: 20% minimum withdrawal
        // Withdrawal = 100000 × 0.20 = 20000
        expect(income.rrpe, closeTo(20000, 0.01));
      });
    });

    group('Income Constants', () {
      test('verifies RRQ constants', () {
        expect(kMaxRRQBenefit2025, 16000.0);
        expect(kRRQEarlyPenaltyPerMonth, 0.006);
        expect(kRRQLateBonusPerMonth, 0.007);
      });

      test('verifies PSV constants', () {
        expect(kPSVBaseAmount2025, 8500.0);
        expect(kPSVClawbackThreshold2025, 90000.0);
        expect(kPSVClawbackRate, 0.15);
      });

      test('verifies RRIF withdrawal rates at key ages', () {
        expect(getRRIFMinimumWithdrawalRate(64), 0.0);
        expect(getRRIFMinimumWithdrawalRate(65), 0.04);
        expect(getRRIFMinimumWithdrawalRate(70), 0.05);
        expect(getRRIFMinimumWithdrawalRate(80), 0.0682);
        expect(getRRIFMinimumWithdrawalRate(95), 0.20);
        expect(getRRIFMinimumWithdrawalRate(100), 0.20); // Capped at 20%
      });
    });

    group('Combined Income', () {
      test('calculates total income from all sources', () {
        final individual = Individual(
          id: 'test-1',
          name: 'Test Person',
          birthdate: DateTime(1960, 1, 1),
          employmentIncome: 50000,
          rrqStartAge: 65,
          psvStartAge: 65,
          projectedRrqAt60: 12000,
          projectedRrqAt65: 16000,
        );

        final income = calculator.calculateIncome(
          individual: individual,
          year: 2025,
          yearsFromStart: 0,
          age: 65,
          events: [],
          criBalance: 100000,
        );

        // Employment: 50000 (simplified for now)
        // RRQ: 16000
        // PSV: clawback on (50000 + 16000) = 66000, no clawback = 8500
        // RRPE: 100000 × 0.04 = 4000
        expect(income.employment, 50000);
        expect(income.rrq, 16000);
        expect(income.psv, 8500);
        expect(income.rrpe, 4000);
        expect(income.total, 78500);
      });
    });
  });
}
