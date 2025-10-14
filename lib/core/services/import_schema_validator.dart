import 'package:retire1/core/error/import_exception.dart';

/// Validates import JSON structure before parsing
///
/// Checks for:
/// - Required top-level fields
/// - Correct field types
/// - Valid enum values
/// - Required nested fields
///
/// Returns detailed error messages with field paths and line numbers
class ImportSchemaValidator {
  static const Set<String> _supportedVersions = {'1.0', '1.1', '1.2'};
  static const Set<String> _validAssetTypes = {'realEstate', 'rrsp', 'celi', 'cri', 'cash'};
  static const Set<String> _validEventTypes = {'retirement', 'death', 'realEstateTransaction'};
  static const Set<String> _validExpenseTypes = {
    'housing',
    'transport',
    'dailyLiving',
    'recreation',
    'health',
    'family',
  };
  static const Set<String> _validTimingTypes = {'relative', 'absolute', 'age', 'eventRelative', 'projectionEnd'};

  /// Validate the entire import JSON structure
  ///
  /// Returns a list of validation errors. Empty list means valid.
  List<ImportException> validate(Map<String, dynamic> json, String? jsonString) {
    final errors = <ImportException>[];

    // Create line number map if we have the original JSON string
    final lineMap = jsonString != null ? _createLineMap(jsonString) : null;

    // Validate top-level structure
    errors.addAll(_validateTopLevel(json, lineMap));

    // Validate project
    if (json.containsKey('project')) {
      errors.addAll(_validateProject(json['project'], lineMap));
    }

    // Validate individuals
    if (json.containsKey('project') && json['project']['individuals'] != null) {
      errors.addAll(_validateIndividuals(json['project']['individuals'], lineMap));
    }

    // Validate assets
    if (json.containsKey('assets')) {
      errors.addAll(_validateAssets(json['assets'], lineMap));
    }

    // Validate events
    if (json.containsKey('events')) {
      errors.addAll(_validateEvents(json['events'], lineMap));
    }

    // Validate expenses
    if (json.containsKey('expenses')) {
      errors.addAll(_validateExpenses(json['expenses'], lineMap));
    }

    // Validate scenarios
    if (json.containsKey('scenarios')) {
      errors.addAll(_validateScenarios(json['scenarios'], lineMap));
    }

    return errors;
  }

  /// Validate top-level required fields
  List<ImportException> _validateTopLevel(Map<String, dynamic> json, Map<String, int>? lineMap) {
    final errors = <ImportException>[];

    // Check exportVersion
    if (!json.containsKey('exportVersion')) {
      errors.add(ImportException.missingField('exportVersion', lineNumber: lineMap?['exportVersion']));
    } else if (json['exportVersion'] is! String) {
      errors.add(
        ImportException.invalidType(
          'exportVersion',
          'String',
          json['exportVersion'],
          lineNumber: lineMap?['exportVersion'],
        ),
      );
    } else if (!_supportedVersions.contains(json['exportVersion'])) {
      errors.add(
        ImportException.schemaViolation(
          'Unsupported export version: ${json['exportVersion']}. '
          'Supported versions: ${_supportedVersions.join(', ')}',
          fieldPath: 'exportVersion',
          lineNumber: lineMap?['exportVersion'],
        ),
      );
    }

    // Check project
    if (!json.containsKey('project')) {
      errors.add(ImportException.missingField('project', lineNumber: lineMap?['project']));
    } else if (json['project'] is! Map) {
      errors.add(ImportException.invalidType('project', 'Map', json['project'], lineNumber: lineMap?['project']));
    }

    return errors;
  }

  /// Validate project fields
  List<ImportException> _validateProject(dynamic project, Map<String, int>? lineMap) {
    final errors = <ImportException>[];
    if (project is! Map<String, dynamic>) return errors;

    final requiredFields = ['id', 'name', 'individuals'];
    for (final field in requiredFields) {
      if (!project.containsKey(field)) {
        errors.add(ImportException.missingField('project.$field', lineNumber: lineMap?['project.$field']));
      }
    }

    // Validate individuals array
    if (project.containsKey('individuals') && project['individuals'] is! List) {
      errors.add(
        ImportException.invalidType(
          'project.individuals',
          'List',
          project['individuals'],
          lineNumber: lineMap?['project.individuals'],
        ),
      );
    }

    return errors;
  }

  /// Validate individuals array
  List<ImportException> _validateIndividuals(dynamic individuals, Map<String, int>? lineMap) {
    final errors = <ImportException>[];
    if (individuals is! List) return errors;

    for (var i = 0; i < individuals.length; i++) {
      final individual = individuals[i];
      if (individual is! Map<String, dynamic>) {
        errors.add(
          ImportException.invalidType(
            'project.individuals[$i]',
            'Map',
            individual,
            lineNumber: lineMap?['project.individuals[$i]'],
          ),
        );
        continue;
      }

      final requiredFields = ['id', 'name', 'birthdate'];
      for (final field in requiredFields) {
        if (!individual.containsKey(field)) {
          errors.add(
            ImportException.missingField(
              'project.individuals[$i].$field',
              lineNumber: lineMap?['project.individuals[$i].$field'],
            ),
          );
        }
      }
    }

    return errors;
  }

  /// Validate assets array
  List<ImportException> _validateAssets(dynamic assets, Map<String, int>? lineMap) {
    final errors = <ImportException>[];
    if (assets is! List) {
      errors.add(ImportException.invalidType('assets', 'List', assets, lineNumber: lineMap?['assets']));
      return errors;
    }

    for (var i = 0; i < assets.length; i++) {
      final asset = assets[i];
      if (asset is! Map<String, dynamic>) {
        errors.add(ImportException.invalidType('assets[$i]', 'Map', asset, lineNumber: lineMap?['assets[$i]']));
        continue;
      }

      // Check runtimeType field (Freezed union discriminator)
      if (!asset.containsKey('runtimeType')) {
        errors.add(
          ImportException.missingField('assets[$i].runtimeType', lineNumber: lineMap?['assets[$i].runtimeType']),
        );
      } else {
        final type = asset['runtimeType'];
        if (type is! String) {
          errors.add(
            ImportException.invalidType(
              'assets[$i].runtimeType',
              'String',
              type,
              lineNumber: lineMap?['assets[$i].runtimeType'],
            ),
          );
        } else if (!_isValidAssetType(type)) {
          errors.add(
            ImportException.schemaViolation(
              'Unknown asset type: $type. Valid types: ${_validAssetTypes.join(', ')}',
              fieldPath: 'assets[$i].runtimeType',
              lineNumber: lineMap?['assets[$i].runtimeType'],
            ),
          );
        }
      }

      // Check required id field
      if (!asset.containsKey('id')) {
        errors.add(ImportException.missingField('assets[$i].id', lineNumber: lineMap?['assets[$i].id']));
      }
    }

    return errors;
  }

  /// Validate events array
  List<ImportException> _validateEvents(dynamic events, Map<String, int>? lineMap) {
    final errors = <ImportException>[];
    if (events is! List) {
      errors.add(ImportException.invalidType('events', 'List', events, lineNumber: lineMap?['events']));
      return errors;
    }

    for (var i = 0; i < events.length; i++) {
      final event = events[i];
      if (event is! Map<String, dynamic>) {
        errors.add(ImportException.invalidType('events[$i]', 'Map', event, lineNumber: lineMap?['events[$i]']));
        continue;
      }

      // Check runtimeType
      if (!event.containsKey('runtimeType')) {
        errors.add(
          ImportException.missingField('events[$i].runtimeType', lineNumber: lineMap?['events[$i].runtimeType']),
        );
      }

      // Check timing
      if (!event.containsKey('timing')) {
        errors.add(ImportException.missingField('events[$i].timing', lineNumber: lineMap?['events[$i].timing']));
      } else if (event['timing'] is Map<String, dynamic>) {
        errors.addAll(_validateTiming(event['timing'], 'events[$i].timing', lineMap));
      }
    }

    return errors;
  }

  /// Validate expenses array
  List<ImportException> _validateExpenses(dynamic expenses, Map<String, int>? lineMap) {
    final errors = <ImportException>[];
    if (expenses is! List) {
      errors.add(ImportException.invalidType('expenses', 'List', expenses, lineNumber: lineMap?['expenses']));
      return errors;
    }

    for (var i = 0; i < expenses.length; i++) {
      final expense = expenses[i];
      if (expense is! Map<String, dynamic>) {
        errors.add(ImportException.invalidType('expenses[$i]', 'Map', expense, lineNumber: lineMap?['expenses[$i]']));
        continue;
      }

      // Check runtimeType
      if (!expense.containsKey('runtimeType')) {
        errors.add(
          ImportException.missingField('expenses[$i].runtimeType', lineNumber: lineMap?['expenses[$i].runtimeType']),
        );
      }

      // Check timing fields
      if (!expense.containsKey('startTiming')) {
        errors.add(
          ImportException.missingField('expenses[$i].startTiming', lineNumber: lineMap?['expenses[$i].startTiming']),
        );
      }

      if (!expense.containsKey('endTiming')) {
        errors.add(
          ImportException.missingField('expenses[$i].endTiming', lineNumber: lineMap?['expenses[$i].endTiming']),
        );
      }

      if (!expense.containsKey('annualAmount')) {
        errors.add(
          ImportException.missingField('expenses[$i].annualAmount', lineNumber: lineMap?['expenses[$i].annualAmount']),
        );
      }
    }

    return errors;
  }

  /// Validate scenarios array
  List<ImportException> _validateScenarios(dynamic scenarios, Map<String, int>? lineMap) {
    final errors = <ImportException>[];
    if (scenarios is! List) {
      errors.add(ImportException.invalidType('scenarios', 'List', scenarios, lineNumber: lineMap?['scenarios']));
      return errors;
    }

    for (var i = 0; i < scenarios.length; i++) {
      final scenario = scenarios[i];
      if (scenario is! Map<String, dynamic>) {
        errors.add(
          ImportException.invalidType('scenarios[$i]', 'Map', scenario, lineNumber: lineMap?['scenarios[$i]']),
        );
        continue;
      }

      final requiredFields = ['id', 'name', 'isBase'];
      for (final field in requiredFields) {
        if (!scenario.containsKey(field)) {
          errors.add(
            ImportException.missingField('scenarios[$i].$field', lineNumber: lineMap?['scenarios[$i].$field']),
          );
        }
      }
    }

    return errors;
  }

  /// Validate timing structure
  List<ImportException> _validateTiming(Map<String, dynamic> timing, String path, Map<String, int>? lineMap) {
    final errors = <ImportException>[];

    if (!timing.containsKey('runtimeType')) {
      errors.add(ImportException.missingField('$path.runtimeType', lineNumber: lineMap?['$path.runtimeType']));
    }

    return errors;
  }

  /// Check if asset type is valid (handles both Freezed class names and type field)
  bool _isValidAssetType(String type) {
    // Check for exact matches
    if (_validAssetTypes.contains(type)) return true;

    // Check for Freezed class names (e.g., "_$RRSPImpl")
    final lowerType = type.toLowerCase();
    return _validAssetTypes.any((validType) => lowerType.contains(validType));
  }

  /// Create a map of field paths to approximate line numbers
  ///
  /// This is a best-effort approach - JSON doesn't have inherent line numbers,
  /// but we can estimate based on string positions
  Map<String, int> _createLineMap(String jsonString) {
    final lineMap = <String, int>{};
    final lines = jsonString.split('\n');

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final lineNumber = i + 1;

      // Extract field name if this line contains one
      final match = RegExp(r'"(\w+)"\s*:').firstMatch(line);
      if (match != null) {
        final fieldName = match.group(1)!;
        lineMap[fieldName] = lineNumber;
      }
    }

    return lineMap;
  }
}
