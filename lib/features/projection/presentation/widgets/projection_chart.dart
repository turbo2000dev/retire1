import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:intl/intl.dart';

/// Widget for displaying projection data as a line chart
class ProjectionChart extends StatelessWidget {
  final Projection projection;

  const ProjectionChart({
    super.key,
    required this.projection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Prepare data for chart
    final spots = projection.years
        .map((year) => FlSpot(
              year.yearsFromStart.toDouble(),
              year.netWorthEndOfYear,
            ))
        .toList();

    // Calculate min and max for Y axis
    final minY = projection.years.map((y) => y.netWorthEndOfYear).reduce(
          (a, b) => a < b ? a : b,
        );
    final maxY = projection.years.map((y) => y.netWorthEndOfYear).reduce(
          (a, b) => a > b ? a : b,
        );

    // Add some padding to the range
    final range = maxY - minY;
    final paddedMin = minY - (range * 0.1);
    final paddedMax = maxY + (range * 0.1);

    // Calculate interval with protection against division by zero
    // Ensure interval is always positive and non-zero for fl_chart
    final calculatedInterval = (paddedMax - paddedMin) / 5;
    final safeInterval = max(calculatedInterval, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Net Worth Over Time',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 400,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: safeInterval,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: theme.colorScheme.outlineVariant,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
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
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= projection.years.length) {
                            return const Text('');
                          }
                          final year = projection.startYear + value.toInt();
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
                  minX: 0,
                  maxX: (projection.years.length - 1).toDouble(),
                  minY: paddedMin,
                  maxY: paddedMax,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: false,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final year = projection.years[spot.x.toInt()];
                          return LineTooltipItem(
                            'Year ${year.year}\n${currencyFormat.format(year.netWorthEndOfYear)}',
                            theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          );
                        }).toList();
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
