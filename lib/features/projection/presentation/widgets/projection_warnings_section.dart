import 'package:flutter/material.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/projection_kpis.dart';
import 'package:intl/intl.dart';

/// Widget displaying warnings based on projection KPIs and detailed projection data
class ProjectionWarningsSection extends StatelessWidget {
  final ProjectionKpis kpis;
  final Projection? projection; // Optional: for enhanced warnings
  final VoidCallback? onMoneyRunsOutTap;

  const ProjectionWarningsSection({
    super.key,
    required this.kpis,
    this.projection,
    this.onMoneyRunsOutTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warnings = _generateWarnings();

    if (warnings.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'No warnings - your projection looks healthy!',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 12),
                Text(
                  'Warnings',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...warnings.map((warning) => _buildWarningItem(context, warning)),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningItem(BuildContext context, _Warning warning) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: warning.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: warning.severity == _WarningSeverity.critical
                ? theme.colorScheme.errorContainer.withOpacity(0.3)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                warning.icon,
                color: warning.severity == _WarningSeverity.critical
                    ? theme.colorScheme.error
                    : Colors.amber.shade700,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      warning.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (warning.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        warning.subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (warning.onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<_Warning> _generateWarnings() {
    final warnings = <_Warning>[];
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Warning: Money runs out
    if (kpis.yearMoneyRunsOut != null) {
      // Count consecutive shortfall years
      int shortfallYears = 0;
      double totalShortfall = 0;
      if (projection != null) {
        for (final year in projection!.years) {
          if (year.hasShortfall) {
            shortfallYears++;
            totalShortfall += year.shortfallAmount;
          }
        }
      }

      final subtitle = shortfallYears > 1
          ? '$shortfallYears years with shortfalls totaling ${currencyFormat.format(totalShortfall)}. Consider reducing expenses, delaying retirement, or increasing savings.'
          : 'Consider reducing expenses or increasing income';

      warnings.add(_Warning(
        icon: Icons.money_off,
        title: 'Money runs out in year ${kpis.yearMoneyRunsOut}',
        subtitle: subtitle,
        severity: _WarningSeverity.critical,
        onTap: onMoneyRunsOutTap,
      ));
    }

    // Warning: High average tax rate
    if (kpis.averageTaxRate > 0.45) {
      final suggestions = <String>[];
      if (projection != null && projection!.years.isNotEmpty) {
        // Check for high RRSP/REER withdrawals
        final avgReerWithdrawals = projection!.years
            .map((y) => y.withdrawalsByAccount.entries
                .where((e) => e.key.contains('reer') || e.key.contains('rrsp'))
                .fold(0.0, (sum, e) => sum + e.value))
            .reduce((a, b) => a + b) /
            projection!.years.length;

        if (avgReerWithdrawals > 50000) {
          suggestions.add('High REER withdrawals detected. Consider withdrawing from CELI first (tax-free).');
        }
      }

      final subtitle = suggestions.isNotEmpty
          ? suggestions.join(' ')
          : 'Consider tax optimization strategies like income splitting or adjusting withdrawal order';

      warnings.add(_Warning(
        icon: Icons.account_balance,
        title: 'High average tax rate: ${(kpis.averageTaxRate * 100).toStringAsFixed(1)}%',
        subtitle: subtitle,
        severity: _WarningSeverity.warning,
      ));
    }

    // Warning: Low final net worth
    if (kpis.finalNetWorth < 100000 && kpis.yearMoneyRunsOut == null) {
      final subtitle = kpis.finalNetWorth < 50000
          ? 'Ending with ${currencyFormat.format(kpis.finalNetWorth)} provides very little cushion for unexpected expenses'
          : 'Ending with less than \$100,000 may limit flexibility';

      warnings.add(_Warning(
        icon: Icons.trending_down,
        title: 'Low final net worth',
        subtitle: subtitle,
        severity: _WarningSeverity.warning,
      ));
    }

    // Warning: Negative lowest net worth
    if (kpis.lowestNetWorth < 0) {
      warnings.add(_Warning(
        icon: Icons.warning,
        title: 'Net worth goes negative in year ${kpis.yearOfLowestNetWorth}',
        subtitle: 'Projection shows a shortfall period of ${currencyFormat.format(kpis.lowestNetWorth.abs())}',
        severity: _WarningSeverity.critical,
      ));
    }

    // NEW WARNING: Large negative cash flow years
    if (projection != null) {
      final negativeYears = projection!.years
          .where((y) => y.netCashFlow < -50000 && !y.hasShortfall)
          .toList();

      if (negativeYears.isNotEmpty) {
        final worstYear = negativeYears.reduce(
          (a, b) => a.netCashFlow < b.netCashFlow ? a : b,
        );
        warnings.add(_Warning(
          icon: Icons.trending_down,
          title: 'High spending years detected',
          subtitle: '${negativeYears.length} years with cash flow below -\$50k. Worst: ${currencyFormat.format(worstYear.netCashFlow)} in ${worstYear.year}',
          severity: _WarningSeverity.warning,
        ));
      }
    }

    // NEW WARNING: Account depletion (specific account runs out)
    if (projection != null && projection!.years.length > 1) {
      final Map<String, int> depletedAccounts = {};

      for (int i = 1; i < projection!.years.length; i++) {
        final prevYear = projection!.years[i - 1];
        final currYear = projection!.years[i];

        // Find accounts that had balance but now are zero
        for (final entry in prevYear.assetsEndOfYear.entries) {
          if (entry.value > 1000 && // Had meaningful balance
              (currYear.assetsEndOfYear[entry.key] ?? 0) < 100) { // Now depleted
            if (!depletedAccounts.containsKey(entry.key)) {
              depletedAccounts[entry.key] = currYear.year;
            }
          }
        }
      }

      if (depletedAccounts.isNotEmpty && kpis.yearMoneyRunsOut == null) {
        final firstDepleted = depletedAccounts.entries.first;
        final accountType = firstDepleted.key.contains('celi') ? 'CELI'
            : firstDepleted.key.contains('cash') ? 'Cash'
            : firstDepleted.key.contains('reer') || firstDepleted.key.contains('rrsp') ? 'REER'
            : firstDepleted.key.contains('cri') ? 'CRI'
            : 'Account';

        warnings.add(_Warning(
          icon: Icons.account_balance_wallet,
          title: '$accountType account depletes in ${firstDepleted.value}',
          subtitle: depletedAccounts.length > 1
              ? '${depletedAccounts.length} accounts will be fully withdrawn during projection'
              : 'This is normal if other accounts still have funds',
          severity: _WarningSeverity.warning,
        ));
      }
    }

    // NEW WARNING: No survivor income after death
    if (projection != null) {
      // Check if projection has death events with individuals
      final deathYears = projection!.years
          .where((y) => y.eventsOccurred.any((e) => e.contains('death')))
          .toList();

      if (deathYears.isNotEmpty) {
        final firstDeathYear = deathYears.first;
        // Check if survivor has income after death
        final yearsAfterDeath = projection!.years
            .where((y) => y.year > firstDeathYear.year)
            .toList();

        if (yearsAfterDeath.isNotEmpty) {
          final avgSurvivorIncome = yearsAfterDeath
              .map((y) => y.totalIncome)
              .reduce((a, b) => a + b) / yearsAfterDeath.length;

          if (avgSurvivorIncome < 20000) {
            warnings.add(_Warning(
              icon: Icons.favorite,
              title: 'Low survivor income detected',
              subtitle: 'Average income after death: ${currencyFormat.format(avgSurvivorIncome)}/year. Verify survivor benefits are configured.',
              severity: _WarningSeverity.warning,
            ));
          }
        }
      }
    }

    return warnings;
  }
}

class _Warning {
  final IconData icon;
  final String title;
  final String? subtitle;
  final _WarningSeverity severity;
  final VoidCallback? onTap;

  const _Warning({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.severity,
    this.onTap,
  });
}

enum _WarningSeverity {
  warning,
  critical,
}
