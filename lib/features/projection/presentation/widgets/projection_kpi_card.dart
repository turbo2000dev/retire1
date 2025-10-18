import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A card displaying a single KPI metric with icon, label, and value
class ProjectionKpiCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? subtitle;
  final Color? color;
  final KpiStatus status;

  const ProjectionKpiCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.subtitle,
    this.color,
    this.status = KpiStatus.neutral,
  });

  /// Factory for currency KPI
  factory ProjectionKpiCard.currency({
    required IconData icon,
    required String label,
    required double amount,
    String? subtitle,
    KpiStatus status = KpiStatus.neutral,
  }) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    return ProjectionKpiCard(
      icon: icon,
      label: label,
      value: currencyFormat.format(amount),
      subtitle: subtitle,
      status: status,
    );
  }

  /// Factory for percentage KPI
  factory ProjectionKpiCard.percentage({
    required IconData icon,
    required String label,
    required double rate,
    String? subtitle,
    KpiStatus status = KpiStatus.neutral,
  }) {
    final percentFormat = NumberFormat.percentPattern()
      ..maximumFractionDigits = 1;
    return ProjectionKpiCard(
      icon: icon,
      label: label,
      value: percentFormat.format(rate),
      subtitle: subtitle,
      status: status,
    );
  }

  /// Factory for year KPI
  factory ProjectionKpiCard.year({
    required IconData icon,
    required String label,
    required int? year,
    String? subtitle,
    KpiStatus status = KpiStatus.neutral,
  }) {
    return ProjectionKpiCard(
      icon: icon,
      label: label,
      value: year?.toString() ?? 'Never',
      subtitle: subtitle,
      status: status,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine color based on status
    Color effectiveColor;
    switch (status) {
      case KpiStatus.good:
        effectiveColor = Colors.green;
        break;
      case KpiStatus.warning:
        effectiveColor = Colors.amber;
        break;
      case KpiStatus.critical:
        effectiveColor = theme.colorScheme.error;
        break;
      case KpiStatus.neutral:
        effectiveColor = color ?? theme.colorScheme.primary;
        break;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon and label row
            Row(
              children: [
                Icon(icon, color: effectiveColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Value
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveColor,
              ),
            ),
            // Optional subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Status of a KPI for color coding
enum KpiStatus { good, neutral, warning, critical }
