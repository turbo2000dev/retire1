import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/projection/domain/projection.dart';

/// Chart displaying multiple scenario projections for comparison
class MultiScenarioProjectionChart extends StatefulWidget {
  final List<ScenarioProjectionData> scenarioProjections;

  const MultiScenarioProjectionChart({
    super.key,
    required this.scenarioProjections,
  });

  @override
  State<MultiScenarioProjectionChart> createState() =>
      _MultiScenarioProjectionChartState();
}

class _MultiScenarioProjectionChartState
    extends State<MultiScenarioProjectionChart> {
  final Set<int> _hiddenScenarioIndices = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter visible scenarios
    final visibleScenarios = widget.scenarioProjections
        .asMap()
        .entries
        .where((entry) => !_hiddenScenarioIndices.contains(entry.key))
        .map((entry) => entry.value)
        .toList();

    if (visibleScenarios.isEmpty) {
      return SizedBox(
        height: 400,
        child: Center(
          child: Text(
            'Select at least one scenario to view chart',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // Calculate global min/max across all visible scenarios
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (final scenarioData in visibleScenarios) {
      if (scenarioData.projection.years.isEmpty) continue;

      for (final year in scenarioData.projection.years) {
        if (year.netWorthEndOfYear < minY) {
          minY = year.netWorthEndOfYear;
        }
        if (year.netWorthEndOfYear > maxY) {
          maxY = year.netWorthEndOfYear;
        }
      }
    }

    // Add padding to Y-axis range
    final range = maxY - minY;
    final padding = range * 0.1;
    minY = minY - padding;
    maxY = maxY + padding;

    // Ensure non-zero range
    if (minY == maxY) {
      minY -= 100000;
      maxY += 100000;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        _buildLegend(theme),
        const SizedBox(height: 16),
        // Chart
        SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 16),
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                lineBarsData: _buildLineBarsData(visibleScenarios, theme),
                titlesData: _buildTitlesData(theme),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                lineTouchData: _buildTouchData(visibleScenarios, theme),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: widget.scenarioProjections.asMap().entries.map((entry) {
        final index = entry.key;
        final scenario = entry.value;
        final isHidden = _hiddenScenarioIndices.contains(index);
        final color = _getScenarioColor(theme, index);
        final lineStyle = _getScenarioLineStyle(index);

        return InkWell(
          onTap: () {
            setState(() {
              if (isHidden) {
                _hiddenScenarioIndices.remove(index);
              } else {
                _hiddenScenarioIndices.add(index);
              }
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Line indicator
                CustomPaint(
                  size: const Size(24, 2),
                  painter: _LinePainter(
                    color: isHidden
                        ? theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.3,
                          )
                        : color,
                    dashArray: lineStyle,
                  ),
                ),
                const SizedBox(width: 8),
                // Scenario name
                Text(
                  scenario.scenarioName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isHidden
                        ? theme.colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          )
                        : theme.colorScheme.onSurface,
                    decoration: isHidden ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<LineChartBarData> _buildLineBarsData(
    List<ScenarioProjectionData> visibleScenarios,
    ThemeData theme,
  ) {
    return visibleScenarios.asMap().entries.map((entry) {
      final scenarioData = entry.value;
      final index = widget.scenarioProjections.indexOf(scenarioData);
      final color = _getScenarioColor(theme, index);
      final dashArray = _getScenarioLineStyle(index);

      final spots = scenarioData.projection.years
          .map((year) => FlSpot(year.year.toDouble(), year.netWorthEndOfYear))
          .toList();

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 2,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        dashArray: dashArray,
      );
    }).toList();
  }

  FlTitlesData _buildTitlesData(ThemeData theme) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 80,
          getTitlesWidget: (value, meta) {
            final formatter = NumberFormat.compact();
            return Text(
              '\$${formatter.format(value)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 32,
          interval: 5,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                value.toInt().toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  LineTouchData _buildTouchData(
    List<ScenarioProjectionData> visibleScenarios,
    ThemeData theme,
  ) {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) =>
            theme.colorScheme.surfaceContainerHighest,
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            final scenarioData = visibleScenarios[spot.barIndex];
            final formatter = NumberFormat.currency(
              symbol: '\$',
              decimalDigits: 0,
            );

            return LineTooltipItem(
              '${scenarioData.scenarioName}\n',
              theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: 'Year ${spot.x.toInt()}\n',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: formatter.format(spot.y),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          }).toList();
        },
      ),
    );
  }

  Color _getScenarioColor(ThemeData theme, int index) {
    switch (index) {
      case 0:
        return theme.colorScheme.primary;
      case 1:
        return theme.colorScheme.secondary;
      case 2:
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.outline;
    }
  }

  List<int>? _getScenarioLineStyle(int index) {
    switch (index) {
      case 0:
        return null; // Solid line
      case 1:
        return [8, 4]; // Dashed line
      case 2:
        return [2, 4]; // Dotted line
      default:
        return null;
    }
  }
}

/// Custom painter for legend line indicators
class _LinePainter extends CustomPainter {
  final Color color;
  final List<int>? dashArray;

  _LinePainter({required this.color, this.dashArray});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (dashArray == null) {
      // Solid line
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    } else {
      // Dashed line
      _drawDashedLine(
        canvas,
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
        dashArray!,
      );
    }
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
    List<int> dashArray,
  ) {
    final path = Path();
    double distance = 0;
    bool draw = true;
    int dashIndex = 0;

    final totalDistance = (end - start).distance;
    final direction = (end - start) / totalDistance;

    while (distance < totalDistance) {
      final dashLength = dashArray[dashIndex % dashArray.length].toDouble();
      final nextDistance = distance + dashLength;

      if (draw) {
        path.moveTo(
          start.dx + direction.dx * distance,
          start.dy + direction.dy * distance,
        );
        path.lineTo(
          start.dx + direction.dx * nextDistance.clamp(0, totalDistance),
          start.dy + direction.dy * nextDistance.clamp(0, totalDistance),
        );
      }

      distance = nextDistance;
      draw = !draw;
      dashIndex++;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LinePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dashArray != dashArray;
  }
}

/// Data for a single scenario's projection
class ScenarioProjectionData {
  final String scenarioName;
  final Projection projection;

  const ScenarioProjectionData({
    required this.scenarioName,
    required this.projection,
  });
}
