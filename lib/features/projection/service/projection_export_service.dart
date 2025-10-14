import 'dart:convert';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/projection/domain/projection.dart';

/// Service for exporting projection data to various formats
class ProjectionExportService {
  /// Export projection to formatted JSON string
  ///
  /// Includes complete projection data:
  /// - Scenario metadata (ID, project ID)
  /// - Settings (start/end year, inflation rate, dollar type)
  /// - Yearly breakdown with all metrics
  /// - Asset values at start and end of each year
  /// - Events that occurred in each year
  ///
  /// The exported JSON can be used for:
  /// - Manual validation of calculations
  /// - Debugging projection logic
  /// - Sharing results for analysis
  String exportToJson(Projection projection, String scenarioName) {
    // Create export structure with metadata
    final exportData = {
      'scenario': scenarioName,
      'projectId': projection.projectId,
      'scenarioId': projection.scenarioId,
      'startYear': projection.startYear,
      'endYear': projection.endYear,
      'inflationRate': projection.inflationRate,
      'useConstantDollars': projection.useConstantDollars,
      'calculatedAt': projection.calculatedAt.toIso8601String(),
      'years': projection.years.map((y) => y.toJson()).toList(),
    };

    // Convert to pretty-printed JSON
    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(exportData);
  }

  /// Export projection to CSV format
  ///
  /// Format: Comma-separated values with headers
  /// Columns:
  /// - Year, YearsFromStart
  /// - PrimaryAge, SpouseAge (if individuals exist)
  /// - Income, Expenses, CashFlow
  /// - NetWorthStart, NetWorthEnd
  /// - Asset totals by type (RealEstate, RRSP, CELI, CRI, Cash)
  ///
  /// Opens easily in Excel, Google Sheets, or any spreadsheet software
  String exportToCsv(Projection projection, List<Asset> assets) {
    final buffer = StringBuffer();

    // Build asset type map (asset ID -> type name)
    final assetTypeMap = _buildAssetTypeMap(assets);

    // Determine if we have individuals (for age columns)
    final hasAges = projection.years.isNotEmpty &&
        (projection.years.first.primaryAge != null ||
            projection.years.first.spouseAge != null);

    // Build header row
    final headers = <String>[
      'Year',
      'YearsFromStart',
      if (hasAges) 'PrimaryAge',
      if (hasAges) 'SpouseAge',
      'Income',
      'Expenses',
      'CashFlow',
      'NetWorthStart',
      'NetWorthEnd',
      'RealEstateTotal',
      'RRSPTotal',
      'CELITotal',
      'CRITotal',
      'CashTotal',
    ];
    buffer.writeln(headers.join(','));

    // Write data rows
    for (final year in projection.years) {
      // Calculate asset totals by type
      final assetTotals = _calculateAssetTotalsByType(year.assetsEndOfYear, assetTypeMap);

      final row = <String>[
        year.year.toString(),
        year.yearsFromStart.toString(),
        if (hasAges) (year.primaryAge?.toString() ?? ''),
        if (hasAges) (year.spouseAge?.toString() ?? ''),
        _formatCurrency(year.totalIncome),
        _formatCurrency(year.totalExpenses),
        _formatCurrency(year.netCashFlow),
        _formatCurrency(year.netWorthStartOfYear),
        _formatCurrency(year.netWorthEndOfYear),
        _formatCurrency(assetTotals['realEstate'] ?? 0),
        _formatCurrency(assetTotals['rrsp'] ?? 0),
        _formatCurrency(assetTotals['celi'] ?? 0),
        _formatCurrency(assetTotals['cri'] ?? 0),
        _formatCurrency(assetTotals['cash'] ?? 0),
      ];
      buffer.writeln(row.join(','));
    }

    return buffer.toString();
  }

  /// Generate filename for exported projection
  ///
  /// Format: projection_[scenario-name]_[date].[ext]
  /// Example: projection_base-scenario_2025-10-13.json
  String generateFilename(String scenarioName, String extension) {
    final sanitizedName = scenarioName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    final dateStr = DateTime.now().toIso8601String().split('T')[0];
    return 'projection_${sanitizedName}_$dateStr.$extension';
  }

  /// Build a map of asset ID to asset type name
  ///
  /// This allows us to categorize asset values by type in the CSV export
  Map<String, String> _buildAssetTypeMap(List<Asset> assets) {
    final map = <String, String>{};

    for (final asset in assets) {
      asset.when(
        realEstate: (id, type, value, setAtStart, customReturnRate) {
          map[id] = 'realEstate';
        },
        rrsp: (id, individualId, value, customReturnRate, annualContribution) {
          map[id] = 'rrsp';
        },
        celi: (id, individualId, value, customReturnRate, annualContribution) {
          map[id] = 'celi';
        },
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) {
          map[id] = 'cri';
        },
        cash: (id, individualId, value, customReturnRate, annualContribution) {
          map[id] = 'cash';
        },
      );
    }

    return map;
  }

  /// Calculate asset totals by type from asset map
  ///
  /// Uses the asset type map to categorize assets correctly
  /// Returns map with keys: realEstate, rrsp, celi, cri, cash
  Map<String, double> _calculateAssetTotalsByType(
    Map<String, double> assetValues,
    Map<String, String> assetTypeMap,
  ) {
    final totals = <String, double>{
      'realEstate': 0,
      'rrsp': 0,
      'celi': 0,
      'cri': 0,
      'cash': 0,
    };

    for (final entry in assetValues.entries) {
      final assetId = entry.key;
      final value = entry.value;
      final type = assetTypeMap[assetId];

      if (type != null && totals.containsKey(type)) {
        totals[type] = totals[type]! + value;
      }
    }

    return totals;
  }

  /// Format currency value for CSV (no commas or symbols to avoid parsing issues)
  String _formatCurrency(double value) {
    return value.toStringAsFixed(2);
  }
}
