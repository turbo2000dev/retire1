import 'dart:convert';
import 'package:retire1/features/project/domain/project.dart';

/// Service for exporting project data to JSON format
class ProjectExportService {
  /// Export project data to formatted JSON string
  ///
  /// Includes:
  /// - Project metadata (id, name, description, dates)
  /// - Individuals (name, birthdate, pension parameters)
  /// - Economic assumptions (inflation and return rates)
  ///
  /// The exported JSON can be used for:
  /// - Sharing test cases
  /// - Debugging projection calculations
  /// - Backup and restore
  String exportProject(Project project) {
    // Create export structure with metadata
    final exportData = {
      'exportVersion': '1.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'project': project.toJson(),
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
