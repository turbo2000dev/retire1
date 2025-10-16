import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:intl/intl.dart';

/// Service for exporting projection data to CSV
class ProjectionCsvExport {
  /// Export projection to CSV and trigger download
  static void exportToCSV(Projection projection, String scenarioName, List<Asset> assets) {
    final csv = _generateCSV(projection, assets);
    final fileName =
        'projection_${scenarioName.replaceAll(' ', '-')}_${DateFormat('yyyy-MM-dd').format(DateTime.now())}.csv';

    _downloadFile(csv, fileName);
  }

  /// Generate CSV content from projection data
  static String _generateCSV(Projection projection, List<Asset> assets) {
    // Create asset type map for quick lookup
    final assetTypeMap = <String, String>{};
    for (final asset in assets) {
      final id = asset.when(
        realEstate: (id, type, value, setAtStart, customReturnRate) => id,
        rrsp: (id, individualId, value, customReturnRate, annualContribution) => id,
        celi: (id, individualId, value, customReturnRate, annualContribution) => id,
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) => id,
        cash: (id, individualId, value, customReturnRate, annualContribution) => id,
      );
      final type = asset.when(
        realEstate: (id, type, value, setAtStart, customReturnRate) => 'realEstate',
        rrsp: (id, individualId, value, customReturnRate, annualContribution) => 'rrsp',
        celi: (id, individualId, value, customReturnRate, annualContribution) => 'celi',
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) => 'cri',
        cash: (id, individualId, value, customReturnRate, annualContribution) => 'cash',
      );
      assetTypeMap[id] = type;
    }
    final buffer = StringBuffer();
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    // Check if we have couples
    final hasCouples = projection.years.any((y) => y.spouseAge != null);

    // Header row
    final headers = <String>[
      'Year',
      'Age 1',
      if (hasCouples) 'Age 2',
      // Income sources
      'Employment Income',
      'RRQ Income',
      'PSV Income',
      'RRPE Income',
      'Other Income',
      'Total Income',
      // Expenses by category
      'Housing Expenses',
      'Transport Expenses',
      'Daily Living Expenses',
      'Recreation Expenses',
      'Health Expenses',
      'Family Expenses',
      'Total Expenses',
      // Taxes
      'Federal Tax',
      'Quebec Tax',
      'Total Tax',
      // Cash flow
      'After-Tax Income',
      'Net Cash Flow',
      // Withdrawals
      'CELI Withdrawals',
      'Cash Withdrawals',
      'CRI Withdrawals',
      'REER Withdrawals',
      'Total Withdrawals',
      // Contributions
      'CELI Contributions',
      'Cash Contributions',
      'Total Contributions',
      // Asset balances (end of year)
      'Real Estate Balance',
      'REER Balance',
      'CELI Balance',
      'CRI Balance',
      'Cash Balance',
      'Total Asset Returns',
      // Net worth
      'Net Worth (Start)',
      'Net Worth (End)',
      // Warnings
      'Shortfall Amount',
    ];

    buffer.writeln(headers.map(_escapeCsvValue).join(','));

    // Data rows
    for (final year in projection.years) {
      // Calculate totals for income breakdown
      final totalEmployment = year.incomeByIndividual.values
          .fold(0.0, (sum, income) => sum + income.employment);
      final totalRRQ = year.incomeByIndividual.values
          .fold(0.0, (sum, income) => sum + income.rrq);
      final totalPSV = year.incomeByIndividual.values
          .fold(0.0, (sum, income) => sum + income.psv);
      final totalRRPE = year.incomeByIndividual.values
          .fold(0.0, (sum, income) => sum + income.rrpe);
      final totalOther = year.incomeByIndividual.values
          .fold(0.0, (sum, income) => sum + income.other);

      // Calculate totals for withdrawals by account type using asset type map
      final celiWithdrawals = year.withdrawalsByAccount.entries
          .where((e) => assetTypeMap[e.key] == 'celi')
          .fold(0.0, (sum, e) => sum + e.value);
      final cashWithdrawals = year.withdrawalsByAccount.entries
          .where((e) => assetTypeMap[e.key] == 'cash')
          .fold(0.0, (sum, e) => sum + e.value);
      final criWithdrawals = year.withdrawalsByAccount.entries
          .where((e) => assetTypeMap[e.key] == 'cri')
          .fold(0.0, (sum, e) => sum + e.value);
      final reerWithdrawals = year.withdrawalsByAccount.entries
          .where((e) => assetTypeMap[e.key] == 'rrsp')
          .fold(0.0, (sum, e) => sum + e.value);

      // Calculate totals for contributions by account type using asset type map
      final celiContributions = year.contributionsByAccount.entries
          .where((e) => assetTypeMap[e.key] == 'celi')
          .fold(0.0, (sum, e) => sum + e.value);
      final cashContributions = year.contributionsByAccount.entries
          .where((e) => assetTypeMap[e.key] == 'cash')
          .fold(0.0, (sum, e) => sum + e.value);

      // Calculate asset balances by type using asset type map
      final realEstateBalance = year.assetsEndOfYear.entries
          .where((e) => assetTypeMap[e.key] == 'realEstate')
          .fold(0.0, (sum, e) => sum + e.value);
      final reerBalance = year.assetsEndOfYear.entries
          .where((e) => assetTypeMap[e.key] == 'rrsp')
          .fold(0.0, (sum, e) => sum + e.value);
      final celiBalance = year.assetsEndOfYear.entries
          .where((e) => assetTypeMap[e.key] == 'celi')
          .fold(0.0, (sum, e) => sum + e.value);
      final criBalance = year.assetsEndOfYear.entries
          .where((e) => assetTypeMap[e.key] == 'cri')
          .fold(0.0, (sum, e) => sum + e.value);
      final cashBalance = year.assetsEndOfYear.entries
          .where((e) => assetTypeMap[e.key] == 'cash')
          .fold(0.0, (sum, e) => sum + e.value);
      final totalReturns =
          year.assetReturns.values.fold(0.0, (sum, val) => sum + val);

      final row = <String>[
        year.year.toString(),
        year.primaryAge?.toString() ?? '',
        if (hasCouples) year.spouseAge?.toString() ?? '',
        // Income sources
        _formatCurrency(currencyFormat, totalEmployment),
        _formatCurrency(currencyFormat, totalRRQ),
        _formatCurrency(currencyFormat, totalPSV),
        _formatCurrency(currencyFormat, totalRRPE),
        _formatCurrency(currencyFormat, totalOther),
        _formatCurrency(currencyFormat, year.totalIncome),
        // Expenses by category
        _formatCurrency(
            currencyFormat, year.expensesByCategory['housing'] ?? 0.0),
        _formatCurrency(
            currencyFormat, year.expensesByCategory['transport'] ?? 0.0),
        _formatCurrency(
            currencyFormat, year.expensesByCategory['dailyLiving'] ?? 0.0),
        _formatCurrency(
            currencyFormat, year.expensesByCategory['recreation'] ?? 0.0),
        _formatCurrency(
            currencyFormat, year.expensesByCategory['health'] ?? 0.0),
        _formatCurrency(
            currencyFormat, year.expensesByCategory['family'] ?? 0.0),
        _formatCurrency(currencyFormat, year.totalExpenses),
        // Taxes
        _formatCurrency(currencyFormat, year.federalTax),
        _formatCurrency(currencyFormat, year.quebecTax),
        _formatCurrency(currencyFormat, year.totalTax),
        // Cash flow
        _formatCurrency(currencyFormat, year.afterTaxIncome),
        _formatCurrency(currencyFormat, year.netCashFlow),
        // Withdrawals
        _formatCurrency(currencyFormat, celiWithdrawals),
        _formatCurrency(currencyFormat, cashWithdrawals),
        _formatCurrency(currencyFormat, criWithdrawals),
        _formatCurrency(currencyFormat, reerWithdrawals),
        _formatCurrency(currencyFormat, year.totalWithdrawals),
        // Contributions
        _formatCurrency(currencyFormat, celiContributions),
        _formatCurrency(currencyFormat, cashContributions),
        _formatCurrency(currencyFormat, year.totalContributions),
        // Asset balances
        _formatCurrency(currencyFormat, realEstateBalance),
        _formatCurrency(currencyFormat, reerBalance),
        _formatCurrency(currencyFormat, celiBalance),
        _formatCurrency(currencyFormat, criBalance),
        _formatCurrency(currencyFormat, cashBalance),
        _formatCurrency(currencyFormat, totalReturns),
        // Net worth
        _formatCurrency(currencyFormat, year.netWorthStartOfYear),
        _formatCurrency(currencyFormat, year.netWorthEndOfYear),
        // Warnings
        year.hasShortfall
            ? _formatCurrency(currencyFormat, year.shortfallAmount)
            : '',
      ];

      buffer.writeln(row.map(_escapeCsvValue).join(','));
    }

    return buffer.toString();
  }

  /// Format currency value for CSV (remove $ symbol for Excel compatibility)
  static String _formatCurrency(NumberFormat format, double value) {
    return format.format(value).replaceAll('\$', '').trim();
  }

  /// Escape CSV values (handle commas, quotes, newlines)
  static String _escapeCsvValue(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  /// Trigger file download in the browser
  static void _downloadFile(String content, String filename) {
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], 'text/csv');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
