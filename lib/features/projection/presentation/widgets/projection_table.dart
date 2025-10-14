import 'package:flutter/material.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/yearly_projection.dart';
import 'package:intl/intl.dart';

/// Widget for displaying projection data as a table
class ProjectionTable extends StatelessWidget {
  final Projection projection;
  final List<Event> events;
  final List<Individual> individuals;

  const ProjectionTable({
    super.key,
    required this.projection,
    required this.events,
    required this.individuals,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with padding
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              children: [
                Icon(
                  Icons.table_chart,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Yearly Breakdown',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Table with horizontal scrolling - no left/right padding
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 600, // Max height for vertical scrolling
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    horizontalMargin: 24,
                headingRowColor: WidgetStateProperty.resolveWith(
                  (states) => theme.colorScheme.surfaceContainerHighest,
                ),
                columns: [
                  DataColumn(
                    label: Text(
                      'Year',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (projection.years.any((y) => y.primaryAge != null))
                    DataColumn(
                      label: Text(
                        'Age 1',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (projection.years.any((y) => y.spouseAge != null))
                    DataColumn(
                      label: Text(
                        'Age 2',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  DataColumn(
                    label: Text(
                      'Income',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Taxes',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'After-Tax Income',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Expenses',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Cash Flow',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Asset Returns',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Net Worth (Start)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Net Worth (End)',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text(
                      'Shortfall',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    numeric: true,
                  ),
                ],
                rows: projection.years.map((year) {
                  // Add warning color for years with shortfalls
                  final rowColor = year.hasShortfall
                      ? theme.colorScheme.errorContainer.withOpacity(0.3)
                      : null;

                  return DataRow(
                    color: rowColor != null
                        ? WidgetStateProperty.all(rowColor)
                        : null,
                    cells: [
                      DataCell(
                        Text(
                          year.year.toString(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (projection.years.any((y) => y.primaryAge != null))
                        DataCell(
                          Text(
                            year.primaryAge?.toString() ?? '-',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: _isPrimaryDeceased(projection.years, year)
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      if (projection.years.any((y) => y.spouseAge != null))
                        DataCell(
                          Text(
                            year.spouseAge?.toString() ?? '-',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              decoration: _isSpouseDeceased(projection.years, year)
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      DataCell(
                        // Check if there are survivor benefits (other income > 0)
                        year.incomeByIndividual.values.any((income) => income.other > 0)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    size: 14,
                                    color: theme.colorScheme.tertiary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    currencyFormat.format(year.totalIncome),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                currencyFormat.format(year.totalIncome),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: year.totalIncome > 0
                                      ? theme.colorScheme.tertiary
                                      : null,
                                ),
                              ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(year.totalTax),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: year.totalTax > 0
                                ? theme.colorScheme.error
                                : null,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(year.afterTaxIncome),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: year.afterTaxIncome > 0
                                ? theme.colorScheme.tertiary
                                : null,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(year.totalExpenses),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: year.totalExpenses > 0
                                ? theme.colorScheme.error
                                : null,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(year.netCashFlow),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: year.netCashFlow > 0
                                ? theme.colorScheme.tertiary
                                : year.netCashFlow < 0
                                    ? theme.colorScheme.error
                                    : null,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(
                            year.assetReturns.values.fold(0.0, (sum, val) => sum + val),
                          ),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: year.assetReturns.values.fold(0.0, (sum, val) => sum + val) > 0
                                ? theme.colorScheme.tertiary
                                : null,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(year.netWorthStartOfYear),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      DataCell(
                        Text(
                          currencyFormat.format(year.netWorthEndOfYear),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataCell(
                        year.hasShortfall
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.warning,
                                    size: 16,
                                    color: theme.colorScheme.error,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    currencyFormat.format(year.shortfallAmount),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                '-',
                                style: theme.textTheme.bodyMedium,
                              ),
                      ),
                    ],
                  );
                }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if primary individual is deceased by checking if death event occurred in this year or any previous year
  bool _isPrimaryDeceased(List<YearlyProjection> years, YearlyProjection currentYear) {
    if (individuals.isEmpty) return false;

    final primaryIndividual = individuals.first;
    final currentIndex = years.indexOf(currentYear);

    // Check all years up to and including current year for death event
    for (int i = 0; i <= currentIndex; i++) {
      final year = years[i];
      final hasDeath = year.eventsOccurred.any((eventId) {
        final event = events.where((e) => e.map(
          retirement: (e) => e.id == eventId,
          death: (e) => e.id == eventId,
          realEstateTransaction: (e) => e.id == eventId,
        )).firstOrNull;

        if (event == null) return false;

        // Check if it's a death event for the primary individual
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

  /// Check if spouse is deceased by checking if death event occurred in this year or any previous year
  bool _isSpouseDeceased(List<YearlyProjection> years, YearlyProjection currentYear) {
    if (individuals.length < 2) return false;

    final spouseIndividual = individuals[1];
    final currentIndex = years.indexOf(currentYear);

    // Check all years up to and including current year for death event
    for (int i = 0; i <= currentIndex; i++) {
      final year = years[i];
      final hasDeath = year.eventsOccurred.any((eventId) {
        final event = events.where((e) => e.map(
          retirement: (e) => e.id == eventId,
          death: (e) => e.id == eventId,
          realEstateTransaction: (e) => e.id == eventId,
        )).firstOrNull;

        if (event == null) return false;

        // Check if it's a death event for the spouse
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
