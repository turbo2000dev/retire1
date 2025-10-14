import 'package:flutter/material.dart';
import 'package:retire1/features/projection/domain/projection_kpis.dart';

/// Widget displaying warnings based on projection KPIs
class ProjectionWarningsSection extends StatelessWidget {
  final ProjectionKpis kpis;
  final VoidCallback? onMoneyRunsOutTap;

  const ProjectionWarningsSection({
    super.key,
    required this.kpis,
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

    // Warning: Money runs out
    if (kpis.yearMoneyRunsOut != null) {
      warnings.add(_Warning(
        icon: Icons.money_off,
        title: 'Money runs out in year ${kpis.yearMoneyRunsOut}',
        subtitle: 'Consider reducing expenses or increasing income',
        severity: _WarningSeverity.critical,
        onTap: onMoneyRunsOutTap,
      ));
    }

    // Warning: High average tax rate
    if (kpis.averageTaxRate > 0.45) {
      warnings.add(_Warning(
        icon: Icons.account_balance,
        title: 'High average tax rate: ${(kpis.averageTaxRate * 100).toStringAsFixed(1)}%',
        subtitle: 'Consider tax optimization strategies',
        severity: _WarningSeverity.warning,
      ));
    }

    // Warning: Low final net worth
    if (kpis.finalNetWorth < 100000 && kpis.yearMoneyRunsOut == null) {
      warnings.add(_Warning(
        icon: Icons.trending_down,
        title: 'Low final net worth',
        subtitle: 'Ending with less than \$100,000 may limit flexibility',
        severity: _WarningSeverity.warning,
      ));
    }

    // Warning: Negative lowest net worth
    if (kpis.lowestNetWorth < 0) {
      warnings.add(_Warning(
        icon: Icons.warning,
        title: 'Net worth goes negative in year ${kpis.yearOfLowestNetWorth}',
        subtitle: 'Projection shows a shortfall period',
        severity: _WarningSeverity.critical,
      ));
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
