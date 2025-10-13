import 'dart:convert';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

/// Service for exporting project data to JSON format
class ProjectExportService {
  /// Export project data to formatted JSON string
  ///
  /// Includes:
  /// - Project metadata (id, name, description, dates)
  /// - Individuals (name, birthdate, pension parameters)
  /// - Economic assumptions (inflation and return rates)
  /// - Assets (all 5 types with custom rates and contributions)
  /// - Events (all 3 types with timing information)
  /// - Expenses (all 6 categories with timing and amounts)
  /// - Scenarios (base and variations with overrides)
  ///
  /// The exported JSON can be used for:
  /// - Sharing test cases
  /// - Debugging projection calculations
  /// - Backup and restore
  ///
  /// [assets], [events], [expenses], and [scenarios] are optional to handle cases where they fail to load
  String exportProject(
    Project project, {
    List<Asset>? assets,
    List<Event>? events,
    List<Expense>? expenses,
    List<Scenario>? scenarios,
  }) {
    // Create export structure with metadata
    final exportData = {
      'exportVersion': '1.2', // Bumped version for expense support
      'exportedAt': DateTime.now().toIso8601String(),
      'project': project.toJson(),
      if (assets != null) 'assets': assets.map((a) => a.toJson()).toList(),
      if (events != null) 'events': events.map((e) => e.toJson()).toList(),
      if (expenses != null) 'expenses': expenses.map((e) => e.toJson()).toList(),
      if (scenarios != null) 'scenarios': scenarios.map((s) => s.toJson()).toList(),
    };

    // Convert to pretty-printed JSON
    final encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(exportData);
  }

  /// Generate a filename for the exported project
  ///
  /// Format: project_[sanitized-name]_[date].json
  /// Example: project_retirement-plan_2025-10-13.json
  String generateFilename(Project project) {
    final sanitizedName = project.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');

    final dateStr = DateTime.now().toIso8601String().split('T')[0];
    return 'project_${sanitizedName}_$dateStr.json';
  }
}
