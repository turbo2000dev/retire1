import 'dart:developer';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/projection/service/income_constants.dart';

/// Asset ID extractor helper
String _getAssetIndividualId(Asset asset) {
  return asset.when(
    realEstate: (id, type, value, setAtStart, customReturnRate) => '',
    rrsp: (id, individualId, value, customReturnRate, annualContribution) =>
        individualId,
    celi: (id, individualId, value, customReturnRate, annualContribution) =>
        individualId,
    cri:
        (
          id,
          individualId,
          value,
          contributionRoom,
          customReturnRate,
          annualContribution,
        ) => individualId,
    cash: (id, individualId, value, customReturnRate, annualContribution) =>
        individualId,
  );
}

/// Service for determining optimal withdrawals and contributions
class WithdrawalStrategy {
  /// Calculate CRI/FRV minimum withdrawals for the year
  ///
  /// Returns map of asset ID to minimum withdrawal amount
  Map<String, double> calculateCriMinimums({
    required int year,
    required Map<String, Asset> assets,
    required Map<String, double> assetBalances,
    required Map<String, int> individualAges,
  }) {
    final criMinimums = <String, double>{};

    for (final entry in assets.entries) {
      final assetId = entry.key;
      final asset = entry.value;

      // Only process CRI/FRV accounts
      final isCri = asset.maybeWhen(
        cri:
            (
              id,
              individualId,
              value,
              contributionRoom,
              customReturnRate,
              annualContribution,
            ) => true,
        orElse: () => false,
      );
      if (!isCri) continue;

      final balance = assetBalances[assetId] ?? 0.0;
      if (balance <= 0) continue;

      // Get individual's age
      final individualId = _getAssetIndividualId(asset);
      final age = individualAges[individualId];
      if (age == null) {
        log(
          'Warning: Could not find age for individual $individualId',
          level: 900,
        );
        continue;
      }

      // Calculate minimum withdrawal percentage based on age
      final minWithdrawalRate = getRRIFMinimumWithdrawalRate(age);
      final minWithdrawal = balance * minWithdrawalRate;

      log(
        'CRI minimum withdrawal for asset $assetId: \$$minWithdrawal (age $age, rate ${(minWithdrawalRate * 100).toStringAsFixed(2)}%)',
      );

      criMinimums[assetId] = minWithdrawal;
    }

    return criMinimums;
  }

  /// Determine withdrawals to cover a cash shortfall
  ///
  /// Priority: CELI → Cash → CRI → REER
  /// Returns map of asset ID to withdrawal amount
  Map<String, double> determineWithdrawals({
    required double shortfall,
    required Map<String, Asset> assets,
    required Map<String, double> assetBalances,
    required Map<String, double> criMinimumsAlreadyWithdrawn,
  }) {
    if (shortfall <= 0) return {};

    log('Determining withdrawals to cover shortfall of \$$shortfall');

    final withdrawals = <String, double>{};
    double remaining = shortfall;

    // Priority 1: CELI (tax-free)
    remaining = _withdrawFromAccountType(
      accountType: 'CELI',
      remaining: remaining,
      assets: assets,
      assetBalances: assetBalances,
      withdrawals: withdrawals,
      filter: (asset) => asset.maybeWhen(
        celi: (id, individualId, value, customReturnRate, annualContribution) =>
            true,
        orElse: () => false,
      ),
    );

    if (remaining <= 0) return withdrawals;

    // Priority 2: Cash
    remaining = _withdrawFromAccountType(
      accountType: 'Cash',
      remaining: remaining,
      assets: assets,
      assetBalances: assetBalances,
      withdrawals: withdrawals,
      filter: (asset) => asset.maybeWhen(
        cash: (id, individualId, value, customReturnRate, annualContribution) =>
            true,
        orElse: () => false,
      ),
    );

    if (remaining <= 0) return withdrawals;

    // Priority 3: CRI (after minimum already withdrawn)
    remaining = _withdrawFromAccountType(
      accountType: 'CRI',
      remaining: remaining,
      assets: assets,
      assetBalances: assetBalances,
      withdrawals: withdrawals,
      filter: (asset) => asset.maybeWhen(
        cri:
            (
              id,
              individualId,
              value,
              contributionRoom,
              customReturnRate,
              annualContribution,
            ) => true,
        orElse: () => false,
      ),
      alreadyWithdrawn: criMinimumsAlreadyWithdrawn,
    );

    if (remaining <= 0) return withdrawals;

    // Priority 4: REER (taxed on withdrawal)
    remaining = _withdrawFromAccountType(
      accountType: 'REER',
      remaining: remaining,
      assets: assets,
      assetBalances: assetBalances,
      withdrawals: withdrawals,
      filter: (asset) => asset.maybeWhen(
        rrsp: (id, individualId, value, customReturnRate, annualContribution) =>
            true,
        orElse: () => false,
      ),
    );

    if (remaining > 0.01) {
      log(
        'Warning: Unable to fully cover shortfall. Remaining: \$$remaining',
        level: 900,
      );
    }

    return withdrawals;
  }

  /// Helper to withdraw from accounts of a specific type
  double _withdrawFromAccountType({
    required String accountType,
    required double remaining,
    required Map<String, Asset> assets,
    required Map<String, double> assetBalances,
    required Map<String, double> withdrawals,
    required bool Function(Asset) filter,
    Map<String, double>? alreadyWithdrawn,
  }) {
    log('Attempting to withdraw from $accountType accounts...');

    for (final entry in assets.entries) {
      if (remaining <= 0) break;

      final assetId = entry.key;
      final asset = entry.value;

      if (!filter(asset)) continue;

      final balance = assetBalances[assetId] ?? 0.0;
      final previouslyWithdrawn = alreadyWithdrawn?[assetId] ?? 0.0;
      final availableBalance = balance - previouslyWithdrawn;

      if (availableBalance <= 0) continue;

      final withdrawal = remaining < availableBalance
          ? remaining
          : availableBalance;
      withdrawals[assetId] = (withdrawals[assetId] ?? 0.0) + withdrawal;
      remaining -= withdrawal;

      log(
        'Withdrawing \$$withdrawal from $accountType account $assetId (balance: \$$balance, previously withdrawn: \$$previouslyWithdrawn)',
      );
    }

    return remaining;
  }

  /// Determine contributions from surplus (after retirement only)
  ///
  /// Priority: CELI (up to room) → Cash
  /// Returns map of asset ID to contribution amount
  Map<String, double> determineContributions({
    required double surplus,
    required Map<String, Asset> assets,
    required double celiRoomAvailable,
  }) {
    if (surplus <= 0) return {};

    log(
      'Determining contributions for surplus of \$$surplus (CELI room: \$$celiRoomAvailable)',
    );

    final contributions = <String, double>{};
    double remaining = surplus;

    // Priority 1: CELI (up to contribution room)
    if (celiRoomAvailable > 0) {
      for (final entry in assets.entries) {
        if (remaining <= 0) break;

        final assetId = entry.key;
        final asset = entry.value;

        final isCeli = asset.maybeWhen(
          celi:
              (id, individualId, value, customReturnRate, annualContribution) =>
                  true,
          orElse: () => false,
        );

        if (!isCeli) continue;

        // Contribute up to available room
        final contribution = remaining < celiRoomAvailable
            ? remaining
            : celiRoomAvailable;
        contributions[assetId] = contribution;
        remaining -= contribution;

        log('Contributing \$$contribution to CELI account $assetId');
        break; // Only contribute to first CELI account found
      }
    }

    // Priority 2: Cash (no limit)
    if (remaining > 0) {
      for (final entry in assets.entries) {
        final assetId = entry.key;
        final asset = entry.value;

        final isCash = asset.maybeWhen(
          cash:
              (id, individualId, value, customReturnRate, annualContribution) =>
                  true,
          orElse: () => false,
        );

        if (!isCash) continue;

        contributions[assetId] = remaining;
        log('Contributing \$$remaining to Cash account $assetId');
        remaining = 0;
        break; // Only contribute to first Cash account found
      }
    }

    return contributions;
  }
}
