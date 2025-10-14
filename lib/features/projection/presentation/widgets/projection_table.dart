import 'package:flutter/material.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:intl/intl.dart';

/// Widget for displaying projection data as a table
class ProjectionTable extends StatelessWidget {
  final Projection projection;

  const ProjectionTable({
    super.key,
    required this.projection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            const SizedBox(height: 24),
            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
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
                        'Age',
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
                ],
                rows: projection.years.map((year) {
                  return DataRow(
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
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      DataCell(
                        Text(
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
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
