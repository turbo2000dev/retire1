import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/projection/domain/projection.dart';

/// Stacked area chart showing income sources over time
class IncomeSourcesChart extends StatefulWidget {
  final Projection projection;

  const IncomeSourcesChart({
    super.key,
    required this.projection,
  });

  @override
  State<IncomeSourcesChart> createState() => _IncomeSourcesChartState();
}

class _IncomeSourcesChartState extends State<IncomeSourcesChart> {
  // Track which series are visible
  final Map<String, bool> _seriesVisibility = {
    'Employment': true,
    'RRQ': true,
    'PSV': true,
    'RRPE': true,
    'Other': true,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Filter years to show every 5 years for readability
    final filteredYears = widget.projection.years
        .where((year) => year.yearsFromStart % 5 == 0)
        .toList();

    if (filteredYears.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate household totals for each income source
    final employmentData = <FlSpot>[];
    final rrqData = <FlSpot>[];
    final psvData = <FlSpot>[];
    final rrpeData = <FlSpot>[];
    final otherData = <FlSpot>[];

    for (final year in filteredYears) {
      final x = year.yearsFromStart.toDouble();

      // Aggregate income across all individuals
      double employment = 0, rrq = 0, psv = 0, rrpe = 0, other = 0;

      for (final income in year.incomeByIndividual.values) {
        employment += income.employment;
        rrq += income.rrq;
        psv += income.psv;
        rrpe += income.rrpe;
        other += income.other;
      }

      employmentData.add(FlSpot(x, employment));
      rrqData.add(FlSpot(x, rrq));
      psvData.add(FlSpot(x, psv));
      rrpeData.add(FlSpot(x, rrpe));
      otherData.add(FlSpot(x, other));
    }

    // Calculate max Y for scaling
    double maxY = 0;
    for (final year in filteredYears) {
      double total = 0;
      for (final income in year.incomeByIndividual.values) {
        total += income.total;
      }
      if (total > maxY) maxY = total;
    }

    // Add padding to max Y
    final paddedMaxY = maxY * 1.1;

    // Define colors for each income source
    final colors = {
      'Employment': theme.colorScheme.primary,
      'RRQ': theme.colorScheme.secondary,
      'PSV': theme.colorScheme.tertiary,
      'RRPE': Colors.orange,
      'Other': Colors.purple,
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
                  Icons.attach_money,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Income Sources Over Time',
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
              children: _seriesVisibility.keys.map((series) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _seriesVisibility[series] = !_seriesVisibility[series]!;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: _seriesVisibility[series]!
                              ? colors[series]
                              : colors[series]!.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        series,
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: _seriesVisibility[series]!
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
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
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
                          final index = filteredYears.indexWhere(
                              (y) => y.yearsFromStart.toDouble() == value);
                          if (index == -1) return const Text('');

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
                        interval: paddedMaxY / 5,
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
                  minX: filteredYears.first.yearsFromStart.toDouble(),
                  maxX: filteredYears.last.yearsFromStart.toDouble(),
                  minY: 0,
                  maxY: paddedMaxY,
                  lineBarsData: [
                    // Employment (bottom layer)
                    if (_seriesVisibility['Employment']!)
                      LineChartBarData(
                        spots: employmentData,
                        isCurved: true,
                        color: colors['Employment'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['Employment']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // RRQ (stacked on employment)
                    if (_seriesVisibility['RRQ']!)
                      LineChartBarData(
                        spots: _stackData(employmentData, rrqData),
                        isCurved: true,
                        color: colors['RRQ'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['RRQ']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // PSV (stacked on RRQ)
                    if (_seriesVisibility['PSV']!)
                      LineChartBarData(
                        spots: _stackData(
                          _stackData(employmentData, rrqData),
                          psvData,
                        ),
                        isCurved: true,
                        color: colors['PSV'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['PSV']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // RRPE (stacked on PSV)
                    if (_seriesVisibility['RRPE']!)
                      LineChartBarData(
                        spots: _stackData(
                          _stackData(
                            _stackData(employmentData, rrqData),
                            psvData,
                          ),
                          rrpeData,
                        ),
                        isCurved: true,
                        color: colors['RRPE'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['RRPE']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // Other (top layer)
                    if (_seriesVisibility['Other']!)
                      LineChartBarData(
                        spots: _stackData(
                          _stackData(
                            _stackData(
                              _stackData(employmentData, rrqData),
                              psvData,
                            ),
                            rrpeData,
                          ),
                          otherData,
                        ),
                        isCurved: true,
                        color: colors['Other'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['Other']!.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        if (touchedSpots.isEmpty) return [];

                        final spot = touchedSpots.first;
                        final yearIndex = filteredYears.indexWhere(
                            (y) => y.yearsFromStart.toDouble() == spot.x);

                        if (yearIndex == -1) return [];

                        final year = filteredYears[yearIndex];

                        // Aggregate all income
                        double employment = 0, rrq = 0, psv = 0, rrpe = 0, other = 0;
                        for (final income in year.incomeByIndividual.values) {
                          employment += income.employment;
                          rrq += income.rrq;
                          psv += income.psv;
                          rrpe += income.rrpe;
                          other += income.other;
                        }

                        final total = employment + rrq + psv + rrpe + other;

                        return [
                          LineTooltipItem(
                            'Year ${year.year}\n'
                            '${employment > 0 ? 'Employment: ${currencyFormat.format(employment)}\n' : ''}'
                            '${rrq > 0 ? 'RRQ: ${currencyFormat.format(rrq)}\n' : ''}'
                            '${psv > 0 ? 'PSV: ${currencyFormat.format(psv)}\n' : ''}'
                            '${rrpe > 0 ? 'RRPE: ${currencyFormat.format(rrpe)}\n' : ''}'
                            '${other > 0 ? 'Other: ${currencyFormat.format(other)}\n' : ''}'
                            'Total: ${currencyFormat.format(total)}',
                            theme.textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ];
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

  /// Helper to stack two data series
  List<FlSpot> _stackData(List<FlSpot> base, List<FlSpot> addition) {
    final result = <FlSpot>[];
    for (int i = 0; i < base.length && i < addition.length; i++) {
      result.add(FlSpot(base[i].x, base[i].y + addition[i].y));
    }
    return result;
  }
}
