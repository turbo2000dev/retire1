import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/projection/domain/projection_kpis.dart';

/// Displays a single KPI metric compared across multiple scenarios
class KpiComparisonCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<ScenarioKpiData> scenariosData;
  final KpiComparisonType type;

  const KpiComparisonCard({
    super.key,
    required this.label,
    required this.icon,
    required this.scenariosData,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Base scenario is always first
    final baseValue = scenariosData.first.value;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and label
            Row(
              children: [
                Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Scenario values
            ...scenariosData.map((data) => _buildScenarioRow(
                  context,
                  theme,
                  data,
                  isBase: data == scenariosData.first,
                  baseValue: baseValue,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioRow(
    BuildContext context,
    ThemeData theme,
    ScenarioKpiData data, {
    required bool isBase,
    required double? baseValue,
  }) {
    final formattedValue = _formatValue(data.value);
    final delta = _calculateDelta(data.value, baseValue);
    final deltaText = _formatDelta(delta);
    final deltaColor = _getDeltaColor(theme, delta);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Scenario name
          Expanded(
            flex: 2,
            child: Text(
              data.scenarioName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isBase ? FontWeight.w600 : FontWeight.normal,
                color: isBase
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Value
          Expanded(
            flex: 2,
            child: Text(
              formattedValue,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 12),
          // Delta (not shown for base)
          SizedBox(
            width: 80,
            child: isBase
                ? Text(
                    'Base',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.right,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        delta > 0
                            ? Icons.arrow_upward
                            : delta < 0
                                ? Icons.arrow_downward
                                : Icons.remove,
                        size: 14,
                        color: deltaColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        deltaText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: deltaColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  String _formatValue(double? value) {
    if (value == null) {
      return 'Never';
    }

    switch (type) {
      case KpiComparisonType.currency:
        final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
        return formatter.format(value);
      case KpiComparisonType.percentage:
        final formatter = NumberFormat.percentPattern();
        formatter.maximumFractionDigits = 1;
        return formatter.format(value);
      case KpiComparisonType.year:
        return value.toInt().toString();
    }
  }

  double _calculateDelta(double? value, double? baseValue) {
    if (value == null || baseValue == null) return 0;
    if (baseValue == 0) return value != 0 ? double.infinity : 0;
    return ((value - baseValue) / baseValue.abs()) * 100;
  }

  String _formatDelta(double delta) {
    if (delta == 0) return '0%';
    if (delta.isInfinite) return '∞';
    return '${delta.abs().toStringAsFixed(1)}%';
  }

  Color _getDeltaColor(ThemeData theme, double delta) {
    // For "Money Runs Out" year, lower is worse (money runs out sooner)
    // For most other metrics, higher is better
    // This is a simplified heuristic - could be made configurable
    if (label.contains('Money Runs Out')) {
      // For money runs out: later is better (green), sooner is worse (red)
      if (delta > 0) return Colors.green; // Later year = better
      if (delta < 0) return theme.colorScheme.error; // Earlier year = worse
    } else {
      // For most KPIs: higher is better
      if (delta > 0) return Colors.green; // Higher = better
      if (delta < 0) return theme.colorScheme.error; // Lower = worse
    }
    return theme.colorScheme.onSurfaceVariant; // No change
  }
}

/// Data for a single scenario's KPI value
class ScenarioKpiData {
  final String scenarioName;
  final double? value;

  const ScenarioKpiData({
    required this.scenarioName,
    required this.value,
  });
}

/// Type of KPI comparison for formatting
enum KpiComparisonType {
  currency,
  percentage,
  year,
}
