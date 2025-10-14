import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/projection/service/tax_calculator.dart';
import 'package:retire1/features/projection/service/tax_constants.dart';

void main() {
  late TaxCalculator calculator;

  setUp(() {
    calculator = TaxCalculator();
  });

  group('TaxCalculator', () {
    group('Federal Tax Calculation', () {
      test('calculates zero tax for zero income', () {
        final result = calculator.calculateTax(
          grossIncome: 0,
          age: 40,
        );

        expect(result.federalTax, 0.0);
        expect(result.quebecTax, 0.0);
        expect(result.totalTax, 0.0);
        expect(result.effectiveRate, 0.0);
      });

      test('applies basic personal amount credit correctly', () {
        // Income: $20,000 (within first bracket at 15%)
        // Tax before credits: $20,000 × 15% = $3,000
        // Basic personal credit: $15,705 × 15% = $2,355.75
        // Federal tax: $3,000 - $2,355.75 = $644.25
        final result = calculator.calculateTax(
          grossIncome: 20000,
          age: 40,
        );

        expect(result.grossIncome, 20000);
        expect(result.taxableIncome, 20000);
        expect(result.federalTax, closeTo(644.25, 0.01));
      });

      test('applies age credit for individuals 65+', () {
        // Income: $30,000 (within first bracket at 15%)
        // Tax before credits: $30,000 × 15% = $4,500
        // Basic personal: $15,705 × 15% = $2,355.75
        // Age credit: $8,790 × 15% = $1,318.50
        // Total credits: $3,674.25
        // Federal tax: $4,500 - $3,674.25 = $825.75
        final result = calculator.calculateTax(
          grossIncome: 30000,
          age: 65,
        );

        expect(result.federalTax, closeTo(825.75, 0.01));
      });

      test('calculates progressive tax across multiple brackets', () {
        // Income: $100,000
        // First bracket: $55,867 × 15% = $8,380.05
        // Second bracket: ($100,000 - $55,867) × 20.5% = $44,133 × 20.5% = $9,047.27
        // Tax before credits: $17,427.32
        // Basic personal credit: $15,705 × 15% = $2,355.75
        // Federal tax: $17,427.32 - $2,355.75 = $15,071.57
        final result = calculator.calculateTax(
          grossIncome: 100000,
          age: 40,
        );

        expect(result.federalTax, closeTo(15071.57, 0.01));
      });

      test('handles high income in top bracket', () {
        // Income: $300,000
        // First bracket: $55,867 × 15% = $8,380.05
        // Second bracket: $55,866 × 20.5% = $11,452.53
        // Third bracket: $61,472 × 26% = $15,982.72
        // Fourth bracket: $73,547 × 29% = $21,328.63
        // Fifth bracket: ($300,000 - $246,752) × 33% = $53,248 × 33% = $17,571.84
        // Tax before credits: $74,715.77
        // Basic personal credit: $15,705 × 15% = $2,355.75
        // Federal tax: $74,715.77 - $2,355.75 = $72,360.02
        final result = calculator.calculateTax(
          grossIncome: 300000,
          age: 40,
        );

        expect(result.federalTax, closeTo(72360.02, 0.01));
      });
    });

    group('Quebec Tax Calculation', () {
      test('applies basic personal amount credit correctly', () {
        // Income: $20,000 (within first bracket at 14%)
        // Tax before credits: $20,000 × 14% = $2,800
        // Basic personal credit: $18,056 × 14% = $2,527.84
        // Quebec tax: $2,800 - $2,527.84 = $272.16
        final result = calculator.calculateTax(
          grossIncome: 20000,
          age: 40,
        );

        expect(result.quebecTax, closeTo(272.16, 0.01));
      });

      test('applies age credit for individuals 65+', () {
        // Income: $30,000 (within first bracket at 14%)
        // Tax before credits: $30,000 × 14% = $4,200
        // Basic personal: $18,056 × 14% = $2,527.84
        // Age credit: $3,458 × 14% = $484.12
        // Total credits: $3,011.96
        // Quebec tax: $4,200 - $3,011.96 = $1,188.04
        final result = calculator.calculateTax(
          grossIncome: 30000,
          age: 65,
        );

        expect(result.quebecTax, closeTo(1188.04, 0.01));
      });

      test('calculates progressive tax across multiple brackets', () {
        // Income: $100,000
        // First bracket: $51,780 × 14% = $7,249.20
        // Second bracket: ($100,000 - $51,780) × 19% = $48,220 × 19% = $9,161.80
        // Tax before credits: $16,411.00
        // Basic personal credit: $18,056 × 14% = $2,527.84
        // Quebec tax: $16,411.00 - $2,527.84 = $13,883.16
        final result = calculator.calculateTax(
          grossIncome: 100000,
          age: 40,
        );

        expect(result.quebecTax, closeTo(13883.16, 0.01));
      });
    });

    group('Combined Federal and Quebec Tax', () {
      test('calculates total tax correctly', () {
        final result = calculator.calculateTax(
          grossIncome: 100000,
          age: 40,
        );

        // Federal: $15,071.57 (from previous test)
        // Quebec: $13,883.16 (from previous test)
        // Total: $28,954.73
        expect(result.totalTax, closeTo(28954.73, 0.01));
      });

      test('calculates effective tax rate correctly', () {
        final result = calculator.calculateTax(
          grossIncome: 100000,
          age: 40,
        );

        // Total tax: $28,954.73
        // Effective rate: $28,954.73 / $100,000 × 100 = 28.95%
        expect(result.effectiveRate, closeTo(28.95, 0.01));
      });

      test('handles low income with credits exceeding tax owing', () {
        // Income: $10,000
        // Federal tax before credits: $10,000 × 15% = $1,500
        // Federal credits: $15,705 × 15% = $2,355.75 (exceeds tax)
        // Federal tax: $0 (clamped to zero)

        // Quebec tax before credits: $10,000 × 14% = $1,400
        // Quebec credits: $18,056 × 14% = $2,527.84 (exceeds tax)
        // Quebec tax: $0 (clamped to zero)
        final result = calculator.calculateTax(
          grossIncome: 10000,
          age: 40,
        );

        expect(result.federalTax, 0.0);
        expect(result.quebecTax, 0.0);
        expect(result.totalTax, 0.0);
        expect(result.effectiveRate, 0.0);
      });
    });

    group('Tax Brackets Integration', () {
      test('uses 2025 federal tax brackets correctly', () {
        // Verify bracket thresholds are used correctly
        expect(kFederalTaxBrackets2025.length, 5);
        expect(kFederalTaxBrackets2025[0].threshold, 0);
        expect(kFederalTaxBrackets2025[0].rate, 0.15);
        expect(kFederalTaxBrackets2025[1].threshold, 55867);
        expect(kFederalTaxBrackets2025[4].rate, 0.33);
      });

      test('uses 2025 Quebec tax brackets correctly', () {
        // Verify bracket thresholds are used correctly
        expect(kQuebecTaxBrackets2025.length, 4);
        expect(kQuebecTaxBrackets2025[0].threshold, 0);
        expect(kQuebecTaxBrackets2025[0].rate, 0.14);
        expect(kQuebecTaxBrackets2025[1].threshold, 51780);
        expect(kQuebecTaxBrackets2025[3].rate, 0.2575);
      });

      test('applies federal credits at correct rate', () {
        expect(kFederalTaxCreditRate, 0.15);
        expect(kFederalBasicPersonalAmount2025, 15705.0);
        expect(kFederalAgeAmount2025, 8790.0);
      });

      test('applies Quebec credits at correct rate', () {
        expect(kQuebecTaxCreditRate, 0.14);
        expect(kQuebecBasicPersonalAmount2025, 18056.0);
        expect(kQuebecAgeAmount2025, 3458.0);
      });
    });

    group('Edge Cases', () {
      test('handles exact bracket boundary income', () {
        // Income exactly at second bracket threshold
        final result = calculator.calculateTax(
          grossIncome: 55867,
          age: 40,
        );

        // All income in first bracket: $55,867 × 15% = $8,380.05
        // Basic personal credit: $15,705 × 15% = $2,355.75
        // Federal tax: $8,380.05 - $2,355.75 = $6,024.30
        expect(result.federalTax, closeTo(6024.30, 0.01));
      });

      test('handles very high income', () {
        // Income: $1,000,000
        final result = calculator.calculateTax(
          grossIncome: 1000000,
          age: 65,
        );

        // Should have federal and Quebec tax calculated
        expect(result.federalTax, greaterThan(0));
        expect(result.quebecTax, greaterThan(0));
        expect(result.totalTax, greaterThan(0));
        expect(result.effectiveRate, greaterThan(0));
        expect(result.effectiveRate, lessThan(100)); // Sanity check
      });

      test('age credit only applies at 65+', () {
        final result64 = calculator.calculateTax(
          grossIncome: 50000,
          age: 64,
        );

        final result65 = calculator.calculateTax(
          grossIncome: 50000,
          age: 65,
        );

        // Tax at 65 should be lower due to age credit
        expect(result65.totalTax, lessThan(result64.totalTax));
      });
    });
  });
}
