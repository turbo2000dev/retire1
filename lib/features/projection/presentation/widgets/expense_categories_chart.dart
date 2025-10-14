import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/projection/domain/projection.dart';

/// Stacked bar chart showing expense categories over time
class ExpenseCategoriesChart extends StatefulWidget {
  final Projection projection;
  final bool useConstantDollars;

  const ExpenseCategoriesChart({
    super.key,
    required this.projection,
    required this.useConstantDollars,
  });

  @override
  State<ExpenseCategoriesChart> createState() => _ExpenseCategoriesChartState();
}

class _ExpenseCategoriesChartState extends State<ExpenseCategoriesChart> {
  // Track which categories are visible
  final Map<String, bool> _categoryVisibility = {
    'Housing': true,
    'Transport': true,
    'Daily Living': true,
    'Recreation': true,
    'Health': true,
    'Family': true,
  };

  /// Apply dollar mode conversion to a value
  double _applyDollarMode(double value, int yearsFromStart) {
    if (!widget.useConstantDollars || yearsFromStart == 0) {
      return value;
    }

    // Calculate inflation multiplier
    double multiplier = 1.0;
    for (int i = 0; i < yearsFromStart; i++) {
      multiplier *= (1 + widget.projection.inflationRate);
    }

    return value / multiplier;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Filter years to show every 5 years
    final filteredYears = widget.projection.years
        .where((year) => year.yearsFromStart % 5 == 0)
        .toList();

    if (filteredYears.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate max Y for scaling (using converted values)
    double maxY = 0;
    for (final year in filteredYears) {
      final convertedExpenses = _applyDollarMode(year.totalExpenses, year.yearsFromStart);
      if (convertedExpenses > maxY) maxY = convertedExpenses;
    }

    // Add padding to max Y
    final paddedMaxY = maxY * 1.1;

    // Calculate interval with protection against division by zero
    // Ensure interval is always positive and non-zero for fl_chart
    final calculatedInterval = paddedMaxY / 5;
    final safeInterval = max(calculatedInterval, 1.0);

    // Define colors for each expense category
    final colors = {
      'Housing': Colors.blue,
      'Transport': Colors.green,
      'Daily Living': Colors.orange,
      'Recreation': Colors.purple,
      'Health': Colors.red,
      'Family': Colors.teal,
    };

    // Category key mapping (display name -> storage key)
    final categoryKeys = {
      'Housing': 'housing',
      'Transport': 'transport',
      'Daily Living': 'dailyLiving',
      'Recreation': 'recreation',
      'Health': 'health',
      'Family': 'family',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Expense Categories Over Time ${widget.useConstantDollars ? "(Constant \$)" : "(Current \$)"}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Legend with toggle capability
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: _categoryVisibility.keys.map((category) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _categoryVisibility[category] =
                          !_categoryVisibility[category]!;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _categoryVisibility[category]!
                              ? colors[category]
                              : colors[category]!.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: _categoryVisibility[category]!
                              ? null
                              : TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 350,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: paddedMaxY,
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= filteredYears.length) {
                            return const Text('');
                          }
                          final year = filteredYears[index].year;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              year.toString(),
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        interval: safeInterval,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              currencyFormat.format(value),
                              style: theme.textTheme.bodySmall,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: theme.colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  barGroups: filteredYears.asMap().entries.map((entry) {
                    final index = entry.key;
                    final year = entry.value;
                    final expenses = year.expensesByCategory;

                    // Build stacked bar sections
                    final barRods = <BarChartRodStackItem>[];
                    double cumulative = 0;

                    // Add each category in order
                    for (final categoryEntry in categoryKeys.entries) {
                      final displayName = categoryEntry.key;
                      final storageKey = categoryEntry.value;

                      if (!_categoryVisibility[displayName]!) continue;

                      final amount = expenses[storageKey] ?? 0.0;
                      final convertedAmount = _applyDollarMode(amount, year.yearsFromStart);
                      if (convertedAmount > 0) {
                        barRods.add(BarChartRodStackItem(
                          cumulative,
                          cumulative + convertedAmount,
                          colors[displayName]!,
                        ));
                        cumulative += convertedAmount;
                      }
                    }

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: cumulative,
                          rodStackItems: barRods,
                          width: 30,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        if (groupIndex < 0 || groupIndex >= filteredYears.length) {
                          return null;
                        }

                        final year = filteredYears[groupIndex];
                        final expenses = year.expensesByCategory;

                        // Build tooltip text
                        final buffer = StringBuffer();
                        buffer.writeln('Year ${year.year}');

                        for (final categoryEntry in categoryKeys.entries) {
                          final displayName = categoryEntry.key;
                          final storageKey = categoryEntry.value;
                          final amount = expenses[storageKey] ?? 0.0;

                          if (amount > 0) {
                            buffer.writeln(
                                '$displayName: ${currencyFormat.format(amount)}');
                          }
                        }

                        buffer.write('Total: ${currencyFormat.format(year.totalExpenses)}');

                        return BarTooltipItem(
                          buffer.toString(),
                          theme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
