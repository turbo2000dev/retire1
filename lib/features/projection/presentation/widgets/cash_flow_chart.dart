import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/projection/domain/projection.dart';

/// Bar chart showing cash flow over time with positive/negative indicators
class CashFlowChart extends StatelessWidget {
  final Projection projection;

  const CashFlowChart({
    super.key,
    required this.projection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Filter years to show every 5 years
    final filteredYears = projection.years
        .where((year) => year.yearsFromStart % 5 == 0)
        .toList();

    if (filteredYears.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate min and max Y for scaling (allow negative)
    double minY = 0;
    double maxY = 0;

    for (final year in filteredYears) {
      if (year.netCashFlow < minY) minY = year.netCashFlow;
      if (year.netCashFlow > maxY) maxY = year.netCashFlow;
    }

    // Add padding
    final range = maxY - minY;
    final paddedMin = minY - (range * 0.1);
    final paddedMax = maxY + (range * 0.1);

    // Ensure zero is visible
    final finalMin = paddedMin > 0 ? 0.0 : paddedMin;
    final finalMax = paddedMax < 0 ? 0.0 : paddedMax;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.waterfall_chart,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Net Cash Flow Over Time',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Legend
            Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Surplus',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Deficit',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.warning,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 6),
                Text(
                  'Shortfall',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 350,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: finalMax,
                  minY: finalMin,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      // Highlight zero line
                      if (value == 0) {
                        return FlLine(
                          color: theme.colorScheme.outline,
                          strokeWidth: 2,
                        );
                      }
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
                        interval: (finalMax - finalMin) / 5,
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
                    final cashFlow = year.netCashFlow;
                    final hasShortfall = year.hasShortfall;

                    // Determine color based on positive/negative
                    Color barColor;
                    if (hasShortfall) {
                      barColor = Colors.amber; // Warning color for shortfall
                    } else if (cashFlow >= 0) {
                      barColor = Colors.green; // Positive cash flow
                    } else {
                      barColor = Colors.red; // Negative cash flow
                    }

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: cashFlow,
                          color: barColor,
                          width: 30,
                          borderRadius: cashFlow >= 0
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                )
                              : const BorderRadius.only(
                                  bottomLeft: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
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
                        final buffer = StringBuffer();
                        buffer.writeln('Year ${year.year}');
                        buffer.writeln('Cash Flow: ${currencyFormat.format(year.netCashFlow)}');

                        if (year.hasShortfall) {
                          buffer.write(
                              '⚠️ Shortfall: ${currencyFormat.format(year.shortfallAmount)}');
                        }

                        return BarTooltipItem(
                          buffer.toString(),
                          theme.textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      // Zero line
                      HorizontalLine(
                        y: 0,
                        color: theme.colorScheme.outline,
                        strokeWidth: 2,
                        dashArray: [5, 5],
                      ),
                    ],
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
