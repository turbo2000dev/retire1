import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/projection/domain/projection.dart';

/// Stacked area chart showing asset allocation over time with net worth overlay
class AssetAllocationChart extends StatefulWidget {
  final Projection projection;
  final List<Asset> assets;

  const AssetAllocationChart({
    super.key,
    required this.projection,
    required this.assets,
  });

  @override
  State<AssetAllocationChart> createState() => _AssetAllocationChartState();
}

class _AssetAllocationChartState extends State<AssetAllocationChart> {
  // Track which asset types are visible
  final Map<String, bool> _assetTypeVisibility = {
    'Real Estate': true,
    'RRSP': true,
    'CELI': true,
    'CRI': true,
    'Cash': true,
    'Net Worth': true,
  };

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

    // Create asset ID to type mapping
    final assetTypeMap = <String, String>{};
    for (final asset in widget.assets) {
      assetTypeMap[asset.map(
        realEstate: (a) => a.id,
        rrsp: (a) => a.id,
        celi: (a) => a.id,
        cri: (a) => a.id,
        cash: (a) => a.id,
      )] = asset.map(
        realEstate: (_) => 'Real Estate',
        rrsp: (_) => 'RRSP',
        celi: (_) => 'CELI',
        cri: (_) => 'CRI',
        cash: (_) => 'Cash',
      );
    }

    // Aggregate asset balances by type for each year
    final realEstateData = <FlSpot>[];
    final rrspData = <FlSpot>[];
    final celiData = <FlSpot>[];
    final criData = <FlSpot>[];
    final cashData = <FlSpot>[];
    final netWorthData = <FlSpot>[];

    for (final year in filteredYears) {
      final x = year.yearsFromStart.toDouble();

      double realEstate = 0, rrsp = 0, celi = 0, cri = 0, cash = 0;

      // Aggregate by asset type
      for (final entry in year.assetsEndOfYear.entries) {
        final assetId = entry.key;
        final balance = entry.value;
        final assetType = assetTypeMap[assetId];

        switch (assetType) {
          case 'Real Estate':
            realEstate += balance;
            break;
          case 'RRSP':
            rrsp += balance;
            break;
          case 'CELI':
            celi += balance;
            break;
          case 'CRI':
            cri += balance;
            break;
          case 'Cash':
            cash += balance;
            break;
        }
      }

      realEstateData.add(FlSpot(x, realEstate));
      rrspData.add(FlSpot(x, rrsp));
      celiData.add(FlSpot(x, celi));
      criData.add(FlSpot(x, cri));
      cashData.add(FlSpot(x, cash));
      netWorthData.add(FlSpot(x, year.netWorthEndOfYear));
    }

    // Calculate max Y for scaling
    double maxY = 0;
    for (final year in filteredYears) {
      if (year.netWorthEndOfYear > maxY) maxY = year.netWorthEndOfYear;
    }

    // Add padding to max Y
    final paddedMaxY = maxY * 1.1;

    // Define colors for each asset type
    final colors = {
      'Real Estate': Colors.brown,
      'RRSP': theme.colorScheme.primary,
      'CELI': theme.colorScheme.secondary,
      'CRI': Colors.deepOrange,
      'Cash': Colors.green,
      'Net Worth': theme.colorScheme.tertiary,
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
                  Icons.pie_chart,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Asset Allocation Over Time',
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
              children: _assetTypeVisibility.keys.map((assetType) {
                final isNetWorth = assetType == 'Net Worth';
                return InkWell(
                  onTap: () {
                    setState(() {
                      _assetTypeVisibility[assetType] =
                          !_assetTypeVisibility[assetType]!;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isNetWorth)
                        Container(
                          width: 16,
                          height: 2,
                          decoration: BoxDecoration(
                            color: _assetTypeVisibility[assetType]!
                                ? colors[assetType]
                                : colors[assetType]!.withValues(alpha: 0.3),
                          ),
                        )
                      else
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _assetTypeVisibility[assetType]!
                                ? colors[assetType]
                                : colors[assetType]!.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      const SizedBox(width: 6),
                      Text(
                        assetType,
                        style: theme.textTheme.bodySmall?.copyWith(
                          decoration: _assetTypeVisibility[assetType]!
                              ? null
                              : TextDecoration.lineThrough,
                          fontWeight:
                              isNetWorth ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 400,
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
                    // Real Estate (bottom layer)
                    if (_assetTypeVisibility['Real Estate']!)
                      LineChartBarData(
                        spots: realEstateData,
                        isCurved: true,
                        color: colors['Real Estate'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['Real Estate']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // RRSP (stacked on real estate)
                    if (_assetTypeVisibility['RRSP']!)
                      LineChartBarData(
                        spots: _stackData(realEstateData, rrspData),
                        isCurved: true,
                        color: colors['RRSP'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['RRSP']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // CELI (stacked on RRSP)
                    if (_assetTypeVisibility['CELI']!)
                      LineChartBarData(
                        spots: _stackData(
                          _stackData(realEstateData, rrspData),
                          celiData,
                        ),
                        isCurved: true,
                        color: colors['CELI'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['CELI']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // CRI (stacked on CELI)
                    if (_assetTypeVisibility['CRI']!)
                      LineChartBarData(
                        spots: _stackData(
                          _stackData(
                            _stackData(realEstateData, rrspData),
                            celiData,
                          ),
                          criData,
                        ),
                        isCurved: true,
                        color: colors['CRI'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['CRI']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // Cash (top layer)
                    if (_assetTypeVisibility['Cash']!)
                      LineChartBarData(
                        spots: _stackData(
                          _stackData(
                            _stackData(
                              _stackData(realEstateData, rrspData),
                              celiData,
                            ),
                            criData,
                          ),
                          cashData,
                        ),
                        isCurved: true,
                        color: colors['Cash'],
                        barWidth: 0,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: colors['Cash']!.withValues(alpha: 0.5),
                        ),
                      ),
                    // Net Worth line (overlay)
                    if (_assetTypeVisibility['Net Worth']!)
                      LineChartBarData(
                        spots: netWorthData,
                        isCurved: true,
                        color: colors['Net Worth'],
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
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

                        // Aggregate balances by type
                        double realEstate = 0, rrsp = 0, celi = 0, cri = 0, cash = 0;

                        for (final entry in year.assetsEndOfYear.entries) {
                          final assetId = entry.key;
                          final balance = entry.value;
                          final assetType = assetTypeMap[assetId];

                          switch (assetType) {
                            case 'Real Estate':
                              realEstate += balance;
                              break;
                            case 'RRSP':
                              rrsp += balance;
                              break;
                            case 'CELI':
                              celi += balance;
                              break;
                            case 'CRI':
                              cri += balance;
                              break;
                            case 'Cash':
                              cash += balance;
                              break;
                          }
                        }

                        return [
                          LineTooltipItem(
                            'Year ${year.year}\n'
                            '${realEstate > 0 ? 'Real Estate: ${currencyFormat.format(realEstate)}\n' : ''}'
                            '${rrsp > 0 ? 'RRSP: ${currencyFormat.format(rrsp)}\n' : ''}'
                            '${celi > 0 ? 'CELI: ${currencyFormat.format(celi)}\n' : ''}'
                            '${cri > 0 ? 'CRI: ${currencyFormat.format(cri)}\n' : ''}'
                            '${cash > 0 ? 'Cash: ${currencyFormat.format(cash)}\n' : ''}'
                            'Net Worth: ${currencyFormat.format(year.netWorthEndOfYear)}',
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
