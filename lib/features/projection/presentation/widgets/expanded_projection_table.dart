import 'package:flutter/material.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/yearly_projection.dart';
import 'package:intl/intl.dart';

/// Widget for displaying detailed projection data with 40+ columns
class ExpandedProjectionTable extends StatelessWidget {
  final Projection projection;
  final List<Event> events;
  final List<Individual> individuals;
  final Set<String> visibleColumnGroups;
  final bool useConstantDollars;

  const ExpandedProjectionTable({
    super.key,
    required this.projection,
    required this.events,
    required this.individuals,
    required this.useConstantDollars,
    this.visibleColumnGroups = const {
      'basic',
      'income',
      'expenses',
      'taxes',
      'cashFlow',
      'withdrawals',
      'contributions',
      'assets',
      'netWorth',
      'warnings',
    },
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
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Check if we have couples (two individuals)
    final hasCouples = projection.years.any((y) => y.spouseAge != null);

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
                  'Detailed Yearly Breakdown ${useConstantDollars ? "(Constant \$)" : "(Current \$)"}',
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
                    columnSpacing: 24,
                columns: [
                  // === BASIC GROUP ===
                  if (visibleColumnGroups.contains('basic')) ...[
                    DataColumn(
                      label: Text(
                        'Year',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Age 1',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (hasCouples)
                      DataColumn(
                        label: Text(
                          'Age 2',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],

                  // === INCOME GROUP ===
                  if (visibleColumnGroups.contains('income')) ...[
                    DataColumn(
                      label: Text(
                        'Employment',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'RRQ',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'PSV',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'RRPE',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Other',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Total Income',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],

                  // === EXPENSES GROUP ===
                  if (visibleColumnGroups.contains('expenses')) ...[
                    DataColumn(
                      label: Text(
                        'Housing',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Transport',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Daily Living',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Recreation',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Health',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Family',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Total Expenses',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],

                  // === TAXES GROUP ===
                  if (visibleColumnGroups.contains('taxes')) ...[
                    DataColumn(
                      label: Text(
                        'Federal Tax',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Quebec Tax',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Total Tax',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],

                  // === CASH FLOW GROUP ===
                  if (visibleColumnGroups.contains('cashFlow')) ...[
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
                        'Net Cash Flow',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],

                  // === WITHDRAWALS GROUP ===
                  if (visibleColumnGroups.contains('withdrawals')) ...[
                    DataColumn(
                      label: Text(
                        'CELI Withdrawals',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Cash Withdrawals',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'CRI Withdrawals',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'REER Withdrawals',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Total Withdrawals',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],

                  // === CONTRIBUTIONS GROUP ===
                  if (visibleColumnGroups.contains('contributions')) ...[
                    DataColumn(
                      label: Text(
                        'CELI Contributions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Cash Contributions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Total Contributions',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                  ],

                  // === ASSETS GROUP ===
                  if (visibleColumnGroups.contains('assets')) ...[
                    DataColumn(
                      label: Text(
                        'Real Estate',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'REER Balance',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'CELI Balance',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'CRI Balance',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text(
                        'Cash Balance',
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
                  ],

                  // === NET WORTH GROUP ===
                  if (visibleColumnGroups.contains('netWorth')) ...[
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

                  // === WARNINGS GROUP ===
                  if (visibleColumnGroups.contains('warnings')) ...[
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
                ],
                rows: projection.years.map((year) {
                  // Add warning color for years with shortfalls
                  final rowColor = year.hasShortfall
                      ? theme.colorScheme.errorContainer.withOpacity(0.3)
                      : null;

                  // Calculate totals for income breakdown (then apply conversion)
                  final totalEmployment = _applyDollarMode(
                    year.incomeByIndividual.values.fold(0.0, (sum, income) => sum + income.employment),
                    year.yearsFromStart,
                  );
                  final totalRRQ = _applyDollarMode(
                    year.incomeByIndividual.values.fold(0.0, (sum, income) => sum + income.rrq),
                    year.yearsFromStart,
                  );
                  final totalPSV = _applyDollarMode(
                    year.incomeByIndividual.values.fold(0.0, (sum, income) => sum + income.psv),
                    year.yearsFromStart,
                  );
                  final totalRRPE = _applyDollarMode(
                    year.incomeByIndividual.values.fold(0.0, (sum, income) => sum + income.rrpe),
                    year.yearsFromStart,
                  );
                  final totalOther = _applyDollarMode(
                    year.incomeByIndividual.values.fold(0.0, (sum, income) => sum + income.other),
                    year.yearsFromStart,
                  );
                  final totalIncome = _applyDollarMode(year.totalIncome, year.yearsFromStart);

                  // Calculate expense categories (apply conversion)
                  final housingExpense = _applyDollarMode(year.expensesByCategory['housing'] ?? 0.0, year.yearsFromStart);
                  final transportExpense = _applyDollarMode(year.expensesByCategory['transport'] ?? 0.0, year.yearsFromStart);
                  final dailyLivingExpense = _applyDollarMode(year.expensesByCategory['dailyLiving'] ?? 0.0, year.yearsFromStart);
                  final recreationExpense = _applyDollarMode(year.expensesByCategory['recreation'] ?? 0.0, year.yearsFromStart);
                  final healthExpense = _applyDollarMode(year.expensesByCategory['health'] ?? 0.0, year.yearsFromStart);
                  final familyExpense = _applyDollarMode(year.expensesByCategory['family'] ?? 0.0, year.yearsFromStart);
                  final totalExpenses = _applyDollarMode(year.totalExpenses, year.yearsFromStart);

                  // Tax values (apply conversion)
                  final federalTax = _applyDollarMode(year.federalTax, year.yearsFromStart);
                  final quebecTax = _applyDollarMode(year.quebecTax, year.yearsFromStart);
                  final totalTax = _applyDollarMode(year.totalTax, year.yearsFromStart);

                  // Cash flow values (apply conversion)
                  final afterTaxIncome = _applyDollarMode(year.afterTaxIncome, year.yearsFromStart);
                  final netCashFlow = _applyDollarMode(year.netCashFlow, year.yearsFromStart);

                  // Calculate totals for withdrawals by account type (apply conversion)
                  final celiWithdrawals = _applyDollarMode(
                    year.withdrawalsByAccount.entries.where((e) => e.key.contains('celi')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final cashWithdrawals = _applyDollarMode(
                    year.withdrawalsByAccount.entries.where((e) => e.key.contains('cash')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final criWithdrawals = _applyDollarMode(
                    year.withdrawalsByAccount.entries.where((e) => e.key.contains('cri')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final reerWithdrawals = _applyDollarMode(
                    year.withdrawalsByAccount.entries.where((e) => e.key.contains('rrsp') || e.key.contains('reer')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final totalWithdrawals = _applyDollarMode(year.totalWithdrawals, year.yearsFromStart);

                  // Calculate totals for contributions by account type (apply conversion)
                  final celiContributions = _applyDollarMode(
                    year.contributionsByAccount.entries.where((e) => e.key.contains('celi')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final cashContributions = _applyDollarMode(
                    year.contributionsByAccount.entries.where((e) => e.key.contains('cash')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final totalContributions = _applyDollarMode(year.totalContributions, year.yearsFromStart);

                  // Calculate asset balances by type (apply conversion)
                  final realEstateBalance = _applyDollarMode(
                    year.assetsEndOfYear.entries.where((e) => e.key.contains('realEstate')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final reerBalance = _applyDollarMode(
                    year.assetsEndOfYear.entries.where((e) => e.key.contains('rrsp') || e.key.contains('reer')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final celiBalance = _applyDollarMode(
                    year.assetsEndOfYear.entries.where((e) => e.key.contains('celi')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final criBalance = _applyDollarMode(
                    year.assetsEndOfYear.entries.where((e) => e.key.contains('cri')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final cashBalance = _applyDollarMode(
                    year.assetsEndOfYear.entries.where((e) => e.key.contains('cash')).fold(0.0, (sum, e) => sum + e.value),
                    year.yearsFromStart,
                  );
                  final assetReturns = _applyDollarMode(
                    year.assetReturns.values.fold(0.0, (sum, val) => sum + val),
                    year.yearsFromStart,
                  );

                  // Net worth values (apply conversion)
                  final netWorthStart = _applyDollarMode(year.netWorthStartOfYear, year.yearsFromStart);
                  final netWorthEnd = _applyDollarMode(year.netWorthEndOfYear, year.yearsFromStart);

                  // Shortfall (apply conversion)
                  final shortfall = _applyDollarMode(year.shortfallAmount, year.yearsFromStart);

                  return DataRow(
                    color: rowColor != null
                        ? WidgetStateProperty.all(rowColor)
                        : null,
                    cells: [
                      // === BASIC GROUP ===
                      if (visibleColumnGroups.contains('basic')) ...[
                        DataCell(
                          Text(
                            year.year.toString(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                        if (hasCouples)
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
                      ],

                      // === INCOME GROUP ===
                      if (visibleColumnGroups.contains('income')) ...[
                        _buildNumericCell(theme, currencyFormat, totalEmployment,
                            positive: theme.colorScheme.tertiary),
                        _buildNumericCell(theme, currencyFormat, totalRRQ,
                            positive: theme.colorScheme.tertiary),
                        _buildNumericCell(theme, currencyFormat, totalPSV,
                            positive: theme.colorScheme.tertiary),
                        _buildNumericCell(theme, currencyFormat, totalRRPE,
                            positive: theme.colorScheme.tertiary),
                        _buildNumericCell(theme, currencyFormat, totalOther,
                            positive: theme.colorScheme.tertiary,
                            showHeartIcon: totalOther > 0),
                        _buildNumericCell(theme, currencyFormat, totalIncome,
                            positive: theme.colorScheme.tertiary, bold: true),
                      ],

                      // === EXPENSES GROUP ===
                      if (visibleColumnGroups.contains('expenses')) ...[
                        _buildNumericCell(theme, currencyFormat, housingExpense,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, transportExpense,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, dailyLivingExpense,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, recreationExpense,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, healthExpense,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, familyExpense,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, totalExpenses,
                            negative: theme.colorScheme.error, bold: true),
                      ],

                      // === TAXES GROUP ===
                      if (visibleColumnGroups.contains('taxes')) ...[
                        _buildNumericCell(theme, currencyFormat, federalTax,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, quebecTax,
                            negative: theme.colorScheme.error),
                        _buildNumericCell(theme, currencyFormat, totalTax,
                            negative: theme.colorScheme.error, bold: true),
                      ],

                      // === CASH FLOW GROUP ===
                      if (visibleColumnGroups.contains('cashFlow')) ...[
                        _buildNumericCell(theme, currencyFormat, afterTaxIncome,
                            positive: theme.colorScheme.tertiary, bold: true),
                        _buildNumericCell(theme, currencyFormat, netCashFlow,
                            positive: theme.colorScheme.tertiary,
                            negative: theme.colorScheme.error,
                            bold: true),
                      ],

                      // === WITHDRAWALS GROUP ===
                      if (visibleColumnGroups.contains('withdrawals')) ...[
                        _buildNumericCell(theme, currencyFormat, celiWithdrawals),
                        _buildNumericCell(theme, currencyFormat, cashWithdrawals),
                        _buildNumericCell(theme, currencyFormat, criWithdrawals),
                        _buildNumericCell(theme, currencyFormat, reerWithdrawals),
                        _buildNumericCell(theme, currencyFormat, totalWithdrawals,
                            bold: true),
                      ],

                      // === CONTRIBUTIONS GROUP ===
                      if (visibleColumnGroups.contains('contributions')) ...[
                        _buildNumericCell(theme, currencyFormat, celiContributions,
                            positive: theme.colorScheme.tertiary),
                        _buildNumericCell(theme, currencyFormat, cashContributions,
                            positive: theme.colorScheme.tertiary),
                        _buildNumericCell(theme, currencyFormat, totalContributions,
                            positive: theme.colorScheme.tertiary, bold: true),
                      ],

                      // === ASSETS GROUP ===
                      if (visibleColumnGroups.contains('assets')) ...[
                        _buildNumericCell(theme, currencyFormat, realEstateBalance),
                        _buildNumericCell(theme, currencyFormat, reerBalance),
                        _buildNumericCell(theme, currencyFormat, celiBalance),
                        _buildNumericCell(theme, currencyFormat, criBalance),
                        _buildNumericCell(theme, currencyFormat, cashBalance),
                        _buildNumericCell(theme, currencyFormat, assetReturns,
                            positive: theme.colorScheme.tertiary),
                      ],

                      // === NET WORTH GROUP ===
                      if (visibleColumnGroups.contains('netWorth')) ...[
                        _buildNumericCell(theme, currencyFormat, netWorthStart),
                        _buildNumericCell(theme, currencyFormat, netWorthEnd,
                            bold: true),
                      ],

                      // === WARNINGS GROUP ===
                      if (visibleColumnGroups.contains('warnings')) ...[
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
                                      currencyFormat.format(shortfall),
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

  /// Helper to build numeric data cells with optional color coding
  DataCell _buildNumericCell(
    ThemeData theme,
    NumberFormat format,
    double value, {
    Color? positive,
    Color? negative,
    bool bold = false,
    bool showHeartIcon = false,
  }) {
    Color? textColor;
    if (value > 0 && positive != null) {
      textColor = positive;
    } else if (value < 0 && negative != null) {
      textColor = negative;
    }

    final textWidget = Text(
      format.format(value),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );

    if (showHeartIcon) {
      return DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite,
              size: 14,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 4),
            textWidget,
          ],
        ),
      );
    }

    return DataCell(textWidget);
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
