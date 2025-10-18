import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/projection/service/withdrawal_strategy.dart';

void main() {
  group('WithdrawalStrategy', () {
    late WithdrawalStrategy strategy;

    setUp(() {
      strategy = WithdrawalStrategy();
    });

    /// Helper to create asset map
    Map<String, Asset> createAssetMap(List<Asset> assets) {
      return {
        for (final asset in assets)
          asset.when(
            realEstate: (id, type, value, setAtStart, customReturnRate) => id,
            rrsp:
                (
                  id,
                  individualId,
                  value,
                  customReturnRate,
                  annualContribution,
                ) => id,
            celi:
                (
                  id,
                  individualId,
                  value,
                  customReturnRate,
                  annualContribution,
                ) => id,
            cri:
                (
                  id,
                  individualId,
                  value,
                  contributionRoom,
                  customReturnRate,
                  annualContribution,
                ) => id,
            cash:
                (
                  id,
                  individualId,
                  value,
                  customReturnRate,
                  annualContribution,
                ) => id,
          ): asset,
      };
    }

    group('calculateCriMinimums', () {
      test('should return empty map when no CRI accounts', () {
        final assets = {
          'asset-1': Asset.cash(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
        };
        final assetBalances = {'asset-1': 50000.0};
        final individualAges = {'ind-1': 65};

        final minimums = strategy.calculateCriMinimums(
          year: 2024,
          assets: assets,
          assetBalances: assetBalances,
          individualAges: individualAges,
        );

        expect(minimums, isEmpty);
      });

      test('should calculate minimum withdrawal for CRI account', () {
        final assets = {
          'asset-1': Asset.cri(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
        };
        final assetBalances = {'asset-1': 100000.0};
        final individualAges = {'ind-1': 71}; // RRIF minimum at 71 is 5.28%

        final minimums = strategy.calculateCriMinimums(
          year: 2024,
          assets: assets,
          assetBalances: assetBalances,
          individualAges: individualAges,
        );

        expect(minimums.length, 1);
        expect(minimums['asset-1'], greaterThan(0));

        // At age 71, minimum is 5.28% of 100000 = 5280
        expect(minimums['asset-1'], closeTo(5280, 100));
      });

      test('should return zero for depleted CRI account', () {
        final assets = {
          'asset-1': Asset.cri(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
        };
        final assetBalances = {'asset-1': 0.0}; // Depleted
        final individualAges = {'ind-1': 71};

        final minimums = strategy.calculateCriMinimums(
          year: 2024,
          assets: assets,
          assetBalances: assetBalances,
          individualAges: individualAges,
        );

        // Should skip depleted accounts (no entry)
        expect(minimums.containsKey('asset-1'), false);
      });

      test('should handle multiple CRI accounts', () {
        final assets = {
          'asset-1': Asset.cri(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
          'asset-2': Asset.cri(
            id: 'asset-2',
            individualId: 'ind-2',
            value: 150000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
        };
        final assetBalances = {'asset-1': 100000.0, 'asset-2': 150000.0};
        final individualAges = {'ind-1': 71, 'ind-2': 75};

        final minimums = strategy.calculateCriMinimums(
          year: 2024,
          assets: assets,
          assetBalances: assetBalances,
          individualAges: individualAges,
        );

        expect(minimums.length, 2);
        expect(minimums['asset-1'], greaterThan(0));
        expect(minimums['asset-2'], greaterThan(0));

        // Age 75 has higher minimum rate than age 71
        final rate71 = minimums['asset-1']! / 100000;
        final rate75 = minimums['asset-2']! / 150000;
        expect(rate75, greaterThan(rate71));
      });
    });

    group('determineWithdrawals', () {
      test('should return empty map when no shortfall', () {
        final assets = createAssetMap([
          Asset.cash(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {'asset-1': 50000.0};

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 0,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        expect(withdrawals, isEmpty);
      });

      test('should withdraw from CELI first', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 30000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.rrsp(
            id: 'asset-rrsp',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {
          'asset-celi': 50000.0,
          'asset-cash': 30000.0,
          'asset-rrsp': 100000.0,
        };

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 20000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        // Should withdraw 20000 from CELI only
        expect(withdrawals['asset-celi'], 20000);
        expect(withdrawals.containsKey('asset-cash'), false);
        expect(withdrawals.containsKey('asset-rrsp'), false);
      });

      test('should cascade to Cash when CELI insufficient', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 30000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {'asset-celi': 10000.0, 'asset-cash': 30000.0};

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 25000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        // Should withdraw 10000 from CELI and 15000 from Cash
        expect(withdrawals['asset-celi'], 10000);
        expect(withdrawals['asset-cash'], 15000);
      });

      test('should cascade to CRI after Cash', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 5000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cri(
            id: 'asset-cri',
            individualId: 'ind-1',
            value: 50000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {
          'asset-celi': 10000.0,
          'asset-cash': 5000.0,
          'asset-cri': 50000.0,
        };
        final criMinimums = {'asset-cri': 2000.0}; // Already withdrew 2000

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 25000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: criMinimums,
        );

        // Should withdraw 10000 from CELI, 5000 from Cash, 10000 from CRI
        expect(withdrawals['asset-celi'], 10000);
        expect(withdrawals['asset-cash'], 5000);
        expect(withdrawals['asset-cri'], 10000);

        final total = withdrawals.values.fold(0.0, (a, b) => a + b);
        expect(total, 25000);
      });

      test('should cascade to REER last', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 5000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.rrsp(
            id: 'asset-rrsp',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {'asset-celi': 5000.0, 'asset-rrsp': 100000.0};

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 20000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        // Should withdraw 5000 from CELI and 15000 from RRSP
        expect(withdrawals['asset-celi'], 5000);
        expect(withdrawals['asset-rrsp'], 15000);
      });

      test('should handle complete account depletion', () {
        final assets = createAssetMap([
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {'asset-cash': 10000.0};

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 50000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        // Should withdraw all available (10000) but shortfall remains
        expect(withdrawals['asset-cash'], 10000);

        final total = withdrawals.values.fold(0.0, (a, b) => a + b);
        expect(total, lessThan(50000)); // Couldn't cover full shortfall
      });

      test('should respect CRI minimum already withdrawn', () {
        final assets = createAssetMap([
          Asset.cri(
            id: 'asset-cri',
            individualId: 'ind-1',
            value: 50000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {'asset-cri': 50000.0};
        final criMinimums = {'asset-cri': 3000.0}; // Already withdrew 3000

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 10000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: criMinimums,
        );

        // Should only withdraw 10000 more (not 13000 total)
        expect(withdrawals['asset-cri'], 10000);
        // Available was 50000 - 3000 = 47000, withdrew 10000
      });

      test('should handle multiple accounts of same type', () {
        final assets = createAssetMap([
          Asset.cash(
            id: 'asset-cash-1',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash-2',
            individualId: 'ind-1',
            value: 20000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {
          'asset-cash-1': 10000.0,
          'asset-cash-2': 20000.0,
        };

        final withdrawals = strategy.determineWithdrawals(
          shortfall: 25000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        // Should withdraw from first cash account fully, then second
        expect(withdrawals['asset-cash-1'], 10000);
        expect(withdrawals['asset-cash-2'], 15000);

        final total = withdrawals.values.fold(0.0, (a, b) => a + b);
        expect(total, 25000);
      });
    });

    group('determineContributions', () {
      test('should return empty map when no surplus', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 0,
          assets: assets,
          celiRoomAvailable: 10000,
        );

        expect(contributions, isEmpty);
      });

      test('should contribute to CELI up to available room', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 5000,
          assets: assets,
          celiRoomAvailable: 10000,
        );

        // Should contribute all 5000 to CELI (room available)
        expect(contributions['asset-celi'], 5000);
        expect(contributions.containsKey('asset-cash'), false);
      });

      test('should contribute to CELI then Cash when surplus exceeds room', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 15000,
          assets: assets,
          celiRoomAvailable: 8000,
        );

        // Should contribute 8000 to CELI and 7000 to Cash
        expect(contributions['asset-celi'], 8000);
        expect(contributions['asset-cash'], 7000);
      });

      test('should contribute to Cash only when no CELI room', () {
        final assets = createAssetMap([
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 5000,
          assets: assets,
          celiRoomAvailable: 0,
        );

        // Should contribute all to Cash
        expect(contributions['asset-cash'], 5000);
      });

      test('should contribute to Cash when no CELI account exists', () {
        final assets = createAssetMap([
          Asset.rrsp(
            id: 'asset-rrsp',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 5000,
          assets: assets,
          celiRoomAvailable: 10000,
        );

        // Should contribute to Cash (no CELI account)
        expect(contributions['asset-cash'], 5000);
      });

      test('should contribute to first CELI account found', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi-1',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.celi(
            id: 'asset-celi-2',
            individualId: 'ind-2',
            value: 40000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 5000,
          assets: assets,
          celiRoomAvailable: 10000,
        );

        // Should contribute to first CELI only
        expect(contributions.length, 1);
        expect(
          contributions.containsKey('asset-celi-1') ||
              contributions.containsKey('asset-celi-2'),
          true,
        );

        final total = contributions.values.fold(0.0, (a, b) => a + b);
        expect(total, 5000);
      });

      test('should handle large surplus with limited CELI room', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);

        final contributions = strategy.determineContributions(
          surplus: 100000,
          assets: assets,
          celiRoomAvailable: 7000,
        );

        // Should max out CELI room, rest to Cash
        expect(contributions['asset-celi'], 7000);
        expect(contributions['asset-cash'], 93000);

        final total = contributions.values.fold(0.0, (a, b) => a + b);
        expect(total, 100000);
      });
    });

    group('Withdrawal Priority Integration', () {
      test('should follow priority: CELI -> Cash -> CRI -> REER', () {
        final assets = createAssetMap([
          Asset.celi(
            id: 'asset-celi',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 8000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cri(
            id: 'asset-cri',
            individualId: 'ind-1',
            value: 50000,
            contributionRoom: 0,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.rrsp(
            id: 'asset-rrsp',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ]);
        final assetBalances = {
          'asset-celi': 10000.0,
          'asset-cash': 8000.0,
          'asset-cri': 50000.0,
          'asset-rrsp': 100000.0,
        };

        // Shortfall that requires all 4 account types
        final withdrawals = strategy.determineWithdrawals(
          shortfall: 30000,
          assets: assets,
          assetBalances: assetBalances,
          criMinimumsAlreadyWithdrawn: {},
        );

        // CELI fully depleted
        expect(withdrawals['asset-celi'], 10000);

        // Cash fully depleted
        expect(withdrawals['asset-cash'], 8000);

        // CRI partially withdrawn
        expect(withdrawals['asset-cri'], 12000);

        // REER not touched yet
        expect(withdrawals.containsKey('asset-rrsp'), false);

        final total = withdrawals.values.fold(0.0, (a, b) => a + b);
        expect(total, 30000);
      });
    });
  });
}
