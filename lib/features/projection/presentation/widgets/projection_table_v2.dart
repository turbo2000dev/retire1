import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/yearly_projection.dart';
import 'package:intl/intl.dart';

/// Enhanced projection table using DataTable2 with sticky headers and fixed columns
class ProjectionTableV2 extends StatelessWidget {
  final Projection projection;
  final List<Event> events;
  final List<Individual> individuals;
  final bool useConstantDollars;
  final Function(int year)? onYearTap;

  const ProjectionTableV2({
    super.key,
    required this.projection,
    required this.events,
    required this.individuals,
    required this.useConstantDollars,
    this.onYearTap,
  });

  /// Apply dollar mode conversion to a value
  double _applyDollarMode(double value, int yearsFromStart) {
    if (!useConstantDollars || yearsFromStart == 0) {
      return value;
    }

    // Calculate inflation multiplier
    double multiplier = 1.0;
    for (int i = 0; i < yearsFromStart; i++) {
      multiplier *= (1 + projection.inflationRate);
    }

    return value / multiplier;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    final hasPrimary = projection.years.any((y) => y.primaryAge != null);
    final hasSpouse = projection.years.any((y) => y.spouseAge != null);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.table_chart, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Yearly Breakdown ${useConstantDollars ? "(Constant \$)" : "(Current \$)"}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // DataTable2 with fixed height for scrolling
          SizedBox(
            height: 600,
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 24,
              minWidth: 1200,
              fixedLeftColumns: 1, // Year column stays fixed
              fixedTopRows: 1, // Header row stays fixed
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
                verticalInside: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
              headingRowHeight: 56,
              headingRowColor: WidgetStateProperty.all(
                theme.colorScheme.surfaceContainerHighest,
              ),
              dataRowHeight: 52,
              columns: [
                // Fixed Year column
                DataColumn2(
                  label: Text(
                    'Year',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.S,
                  fixedWidth: 80,
                ),
                // Age columns
                if (hasPrimary)
                  DataColumn2(
                    label: Text(
                      'Age 1',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    size: ColumnSize.S,
                    fixedWidth: 70,
                  ),
                if (hasSpouse)
                  DataColumn2(
                    label: Text(
                      'Age 2',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    size: ColumnSize.S,
                    fixedWidth: 70,
                  ),
                // Financial columns
                DataColumn2(
                  label: Text(
                    'Income',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.L,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Taxes',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.M,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'After-Tax Income',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.L,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Expenses',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.L,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Cash Flow',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.L,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Asset Returns',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.M,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Net Worth (Start)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.L,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Net Worth (End)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.L,
                  numeric: true,
                ),
                DataColumn2(
                  label: Text(
                    'Shortfall',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  size: ColumnSize.M,
                  numeric: true,
                ),
              ],
              rows: projection.years.map((year) {
                // Apply dollar mode conversion
                final totalIncome = _applyDollarMode(
                  year.totalIncome,
                  year.yearsFromStart,
                );
                final totalTax = _applyDollarMode(
                  year.totalTax,
                  year.yearsFromStart,
                );
                final afterTaxIncome = _applyDollarMode(
                  year.afterTaxIncome,
                  year.yearsFromStart,
                );
                final totalExpenses = _applyDollarMode(
                  year.totalExpenses,
                  year.yearsFromStart,
                );
                final netCashFlow = _applyDollarMode(
                  year.netCashFlow,
                  year.yearsFromStart,
                );
                final assetReturns = _applyDollarMode(
                  year.assetReturns.values.fold(0.0, (sum, val) => sum + val),
                  year.yearsFromStart,
                );
                final netWorthStart = _applyDollarMode(
                  year.netWorthStartOfYear,
                  year.yearsFromStart,
                );
                final netWorthEnd = _applyDollarMode(
                  year.netWorthEndOfYear,
                  year.yearsFromStart,
                );
                final shortfall = _applyDollarMode(
                  year.shortfallAmount,
                  year.yearsFromStart,
                );

                // Row color for shortfalls
                final rowColor = year.hasShortfall
                    ? theme.colorScheme.errorContainer.withOpacity(0.3)
                    : null;

                return DataRow2(
                  color: rowColor != null
                      ? WidgetStateProperty.all(rowColor)
                      : null,
                  onTap: onYearTap != null ? () => onYearTap!(year.year) : null,
                  cells: [
                    // Year (fixed column)
                    DataCell(
                      Text(
                        year.year.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Ages
                    if (hasPrimary)
                      DataCell(
                        Text(
                          year.primaryAge?.toString() ?? '-',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration:
                                _isPrimaryDeceased(projection.years, year)
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    if (hasSpouse)
                      DataCell(
                        Text(
                          year.spouseAge?.toString() ?? '-',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration:
                                _isSpouseDeceased(projection.years, year)
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                    // Income (with survivor benefits icon)
                    DataCell(
                      year.incomeByIndividual.values.any(
                            (income) => income.other > 0,
                          )
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  size: 14,
                                  color: theme.colorScheme.tertiary,
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    currencyFormat.format(totalIncome),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              currencyFormat.format(totalIncome),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: totalIncome > 0
                                    ? theme.colorScheme.tertiary
                                    : null,
                              ),
                            ),
                    ),
                    // Taxes
                    DataCell(
                      Text(
                        currencyFormat.format(totalTax),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: totalTax > 0 ? theme.colorScheme.error : null,
                        ),
                      ),
                    ),
                    // After-Tax Income
                    DataCell(
                      Text(
                        currencyFormat.format(afterTaxIncome),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: afterTaxIncome > 0
                              ? theme.colorScheme.tertiary
                              : null,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // Expenses
                    DataCell(
                      Text(
                        currencyFormat.format(totalExpenses),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: totalExpenses > 0
                              ? theme.colorScheme.error
                              : null,
                        ),
                      ),
                    ),
                    // Cash Flow
                    DataCell(
                      Text(
                        currencyFormat.format(netCashFlow),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: netCashFlow > 0
                              ? theme.colorScheme.tertiary
                              : netCashFlow < 0
                              ? theme.colorScheme.error
                              : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Asset Returns
                    DataCell(
                      Text(
                        currencyFormat.format(assetReturns),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: assetReturns > 0
                              ? theme.colorScheme.tertiary
                              : null,
                        ),
                      ),
                    ),
                    // Net Worth Start
                    DataCell(
                      Text(
                        currencyFormat.format(netWorthStart),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    // Net Worth End
                    DataCell(
                      Text(
                        currencyFormat.format(netWorthEnd),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Shortfall
                    DataCell(
                      year.hasShortfall
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 16,
                                  color: theme.colorScheme.error,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  currencyFormat.format(shortfall),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Text('-', style: theme.textTheme.bodyMedium),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if primary individual is deceased
  bool _isPrimaryDeceased(
    List<YearlyProjection> years,
    YearlyProjection currentYear,
  ) {
    if (individuals.isEmpty) return false;

    final primaryIndividual = individuals.first;
    final currentIndex = years.indexOf(currentYear);

    for (int i = 0; i <= currentIndex; i++) {
      final year = years[i];
      final hasDeath = year.eventsOccurred.any((eventId) {
        final event = events
            .where(
              (e) => e.map(
                retirement: (e) => e.id == eventId,
                death: (e) => e.id == eventId,
                realEstateTransaction: (e) => e.id == eventId,
              ),
            )
            .firstOrNull;

        if (event == null) return false;

        return event.map(
          retirement: (_) => false,
          death: (e) => e.individualId == primaryIndividual.id,
          realEstateTransaction: (_) => false,
        );
      });

      if (hasDeath) return true;
    }

    return false;
  }

  /// Check if spouse is deceased
  bool _isSpouseDeceased(
    List<YearlyProjection> years,
    YearlyProjection currentYear,
  ) {
    if (individuals.length < 2) return false;

    final spouseIndividual = individuals[1];
    final currentIndex = years.indexOf(currentYear);

    for (int i = 0; i <= currentIndex; i++) {
      final year = years[i];
      final hasDeath = year.eventsOccurred.any((eventId) {
        final event = events
            .where(
              (e) => e.map(
                retirement: (e) => e.id == eventId,
                death: (e) => e.id == eventId,
                realEstateTransaction: (e) => e.id == eventId,
              ),
            )
            .firstOrNull;

        if (event == null) return false;

        return event.map(
          retirement: (_) => false,
          death: (e) => e.individualId == spouseIndividual.id,
          realEstateTransaction: (_) => false,
        );
      });

      if (hasDeath) return true;
    }

    return false;
  }
}
