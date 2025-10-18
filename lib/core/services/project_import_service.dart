import 'dart:convert';
import 'dart:developer';
import 'package:retire1/core/error/import_exception.dart';
import 'package:retire1/core/services/import_schema_validator.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:uuid/uuid.dart';

/// Result of parsing an import file before creating the project
class ImportPreview {
  final String projectName;
  final int individualCount;
  final Map<String, int> assetCountsByType;
  final Map<String, int> eventCountsByType;
  final Map<String, int> expenseCountsByCategory;
  final int scenarioCount;
  final Map<String, dynamic> economicAssumptions;

  ImportPreview({
    required this.projectName,
    required this.individualCount,
    required this.assetCountsByType,
    required this.eventCountsByType,
    required this.expenseCountsByCategory,
    required this.scenarioCount,
    required this.economicAssumptions,
  });
}

/// Data extracted from import file, ready to be saved
class ImportedProjectData {
  final Project project;
  final List<Asset> assets;
  final List<Event> events;
  final List<Expense> expenses;
  final List<Scenario> scenarios;

  ImportedProjectData({
    required this.project,
    required this.assets,
    required this.events,
    required this.expenses,
    required this.scenarios,
  });
}

/// Service for importing project data from JSON format
class ProjectImportService {
  final _uuid = const Uuid();

  /// Parse and validate JSON, return preview without creating entities
  ImportPreview validateAndPreview(String jsonContent) {
    try {
      log('Starting import validation and preview');
      final data = jsonDecode(jsonContent) as Map<String, dynamic>;

      // Run schema validation first
      log('Running schema validation');
      final validator = ImportSchemaValidator();
      final errors = validator.validate(data, jsonContent);

      if (errors.isNotEmpty) {
        // Log all validation errors to console
        log(
          'Schema validation failed with ${errors.length} error(s):',
          level: 900,
        );
        for (final error in errors) {
          log(error.toString(), error: error, level: 900);
        }

        // Throw first error for user display
        throw Exception(errors.first.userMessage);
      }

      log('Schema validation passed');

      final projectData = data['project'] as Map<String, dynamic>;
      final projectName = projectData['name'] as String;

      if (projectName.trim().isEmpty) {
        throw Exception('Project name cannot be empty');
      }

      // Count individuals
      final individuals = (projectData['individuals'] as List<dynamic>?) ?? [];
      final individualCount = individuals.length;

      // Count assets by type
      final assets = (data['assets'] as List<dynamic>?) ?? [];
      final assetCountsByType = <String, int>{
        'Real Estate': 0,
        'RRSP': 0,
        'CELI': 0,
        'CRI': 0,
        'Cash': 0,
      };

      for (final assetJson in assets) {
        final asset = assetJson as Map<String, dynamic>;
        final runtimeType = asset['runtimeType'] as String?;

        switch (runtimeType) {
          case 'realEstate':
            assetCountsByType['Real Estate'] =
                assetCountsByType['Real Estate']! + 1;
            break;
          case 'rrsp':
            assetCountsByType['RRSP'] = assetCountsByType['RRSP']! + 1;
            break;
          case 'celi':
            assetCountsByType['CELI'] = assetCountsByType['CELI']! + 1;
            break;
          case 'cri':
            assetCountsByType['CRI'] = assetCountsByType['CRI']! + 1;
            break;
          case 'cash':
            assetCountsByType['Cash'] = assetCountsByType['Cash']! + 1;
            break;
          default:
            throw Exception('Unknown asset type: $runtimeType');
        }
      }

      // Count events by type
      final events = (data['events'] as List<dynamic>?) ?? [];
      final eventCountsByType = <String, int>{
        'Retirement': 0,
        'Death': 0,
        'Real Estate Transaction': 0,
      };

      for (final eventJson in events) {
        final event = eventJson as Map<String, dynamic>;
        final runtimeType = event['runtimeType'] as String?;

        switch (runtimeType) {
          case 'retirement':
            eventCountsByType['Retirement'] =
                eventCountsByType['Retirement']! + 1;
            break;
          case 'death':
            eventCountsByType['Death'] = eventCountsByType['Death']! + 1;
            break;
          case 'realEstateTransaction':
            eventCountsByType['Real Estate Transaction'] =
                eventCountsByType['Real Estate Transaction']! + 1;
            break;
          default:
            throw Exception('Unknown event type: $runtimeType');
        }
      }

      // Count expenses by category
      final expenses = (data['expenses'] as List<dynamic>?) ?? [];
      final expenseCountsByCategory = <String, int>{
        'Housing': 0,
        'Transport': 0,
        'Daily Living': 0,
        'Recreation': 0,
        'Health': 0,
        'Family': 0,
      };

      for (final expenseJson in expenses) {
        final expense = expenseJson as Map<String, dynamic>;
        final runtimeType = expense['runtimeType'] as String?;

        switch (runtimeType) {
          case 'housing':
            expenseCountsByCategory['Housing'] =
                expenseCountsByCategory['Housing']! + 1;
            break;
          case 'transport':
            expenseCountsByCategory['Transport'] =
                expenseCountsByCategory['Transport']! + 1;
            break;
          case 'dailyLiving':
            expenseCountsByCategory['Daily Living'] =
                expenseCountsByCategory['Daily Living']! + 1;
            break;
          case 'recreation':
            expenseCountsByCategory['Recreation'] =
                expenseCountsByCategory['Recreation']! + 1;
            break;
          case 'health':
            expenseCountsByCategory['Health'] =
                expenseCountsByCategory['Health']! + 1;
            break;
          case 'family':
            expenseCountsByCategory['Family'] =
                expenseCountsByCategory['Family']! + 1;
            break;
          default:
            throw Exception('Unknown expense category: $runtimeType');
        }
      }

      // Count scenarios
      final scenarios = (data['scenarios'] as List<dynamic>?) ?? [];
      final scenarioCount = scenarios.length;

      // Extract economic assumptions
      final economicAssumptions = {
        'inflationRate': projectData['inflationRate'] ?? 0.02,
        'reerReturnRate': projectData['reerReturnRate'] ?? 0.05,
        'celiReturnRate': projectData['celiReturnRate'] ?? 0.05,
        'criReturnRate': projectData['criReturnRate'] ?? 0.05,
        'cashReturnRate': projectData['cashReturnRate'] ?? 0.015,
      };

      return ImportPreview(
        projectName: projectName,
        individualCount: individualCount,
        assetCountsByType: assetCountsByType,
        eventCountsByType: eventCountsByType,
        expenseCountsByCategory: expenseCountsByCategory,
        scenarioCount: scenarioCount,
        economicAssumptions: economicAssumptions,
      );
    } on FormatException catch (e) {
      throw Exception('Invalid JSON format: ${e.message}');
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception('Failed to parse import data: $e');
    }
  }

  /// Import project data and generate new entities with remapped IDs
  ImportedProjectData importProject(String jsonContent, String currentUserId) {
    try {
      log('Starting import process');
      final data = jsonDecode(jsonContent) as Map<String, dynamic>;

      // Run schema validation first
      log('Running schema validation');
      final validator = ImportSchemaValidator();
      final errors = validator.validate(data, jsonContent);

      if (errors.isNotEmpty) {
        // Log all validation errors to console
        log(
          'Schema validation failed with ${errors.length} error(s):',
          level: 900,
        );
        for (final error in errors) {
          log(error.toString(), error: error, level: 900);
        }

        // Throw first error for user display
        throw ImportException.schemaViolation(
          errors.first.userMessage,
          fieldPath: errors.first.fieldPath,
          lineNumber: errors.first.lineNumber,
        );
      }

      log('Schema validation passed');

      final projectData = data['project'] as Map<String, dynamic>;
      log('Parsed JSON successfully');

      // Generate new IDs
      final newProjectId = _uuid.v4();
      final individualIdMap = <String, String>{};
      final assetIdMap = <String, String>{};
      final eventIdMap = <String, String>{};
      final scenarioIdMap = <String, String>{};

      // Remap individual IDs
      final individuals = (projectData['individuals'] as List<dynamic>?) ?? [];
      for (final individualJson in individuals) {
        final individual = individualJson as Map<String, dynamic>;
        final oldId = individual['id'] as String;
        final newId =
            DateTime.now().millisecondsSinceEpoch.toString() +
            individuals.indexOf(individualJson).toString();
        individualIdMap[oldId] = newId;
      }

      // Remap asset IDs
      final assets = (data['assets'] as List<dynamic>?) ?? [];
      for (final assetJson in assets) {
        final asset = assetJson as Map<String, dynamic>;
        final oldId = asset['id'] as String;
        final newId =
            DateTime.now().millisecondsSinceEpoch.toString() +
            assets.indexOf(assetJson).toString();
        assetIdMap[oldId] = newId;
      }

      // Create project with new ID and owner
      final remappedIndividuals = individuals.map((json) {
        final individualData = Map<String, dynamic>.from(
          json as Map<String, dynamic>,
        );
        final oldId = individualData['id'] as String;
        individualData['id'] = individualIdMap[oldId]!;
        return Individual.fromJson(individualData);
      }).toList();

      final now = DateTime.now();
      final project = Project(
        id: newProjectId,
        name: projectData['name'] as String,
        ownerId: currentUserId,
        description: projectData['description'] as String?,
        createdAt: now,
        updatedAt: now,
        individuals: remappedIndividuals,
        inflationRate:
            (projectData['inflationRate'] as num?)?.toDouble() ?? 0.02,
        reerReturnRate:
            (projectData['reerReturnRate'] as num?)?.toDouble() ?? 0.05,
        celiReturnRate:
            (projectData['celiReturnRate'] as num?)?.toDouble() ?? 0.05,
        criReturnRate:
            (projectData['criReturnRate'] as num?)?.toDouble() ?? 0.05,
        cashReturnRate:
            (projectData['cashReturnRate'] as num?)?.toDouble() ?? 0.015,
      );

      // Import assets with remapped IDs and individual references
      log('Importing ${assets.length} assets');
      final importedAssets = <Asset>[];
      for (var i = 0; i < assets.length; i++) {
        try {
          final json = assets[i];
          final assetData = Map<String, dynamic>.from(
            json as Map<String, dynamic>,
          );
          final oldId = assetData['id'] as String;
          log(
            'Processing asset [$i]: $oldId (type: ${assetData['runtimeType']})',
          );
          assetData['id'] = assetIdMap[oldId]!;

          // Remap individual ID references for accounts
          if (assetData.containsKey('individualId') &&
              assetData['individualId'] != null) {
            final oldIndividualId = assetData['individualId'] as String;
            if (individualIdMap.containsKey(oldIndividualId)) {
              assetData['individualId'] = individualIdMap[oldIndividualId]!;
            } else {
              final error =
                  'Asset references unknown individual ID: $oldIndividualId';
              log(error, level: 900);
              throw ImportException.schemaViolation(
                error,
                fieldPath: 'assets[$i].individualId',
              );
            }
          }

          log('Creating Asset from JSON for: $oldId');
          importedAssets.add(Asset.fromJson(assetData));
        } catch (e, stack) {
          if (e is ImportException) {
            log(
              'Import error for asset [$i]: $e',
              error: e,
              stackTrace: stack,
              level: 900,
            );
            rethrow;
          }
          log(
            'Error importing asset [$i]: $e',
            error: e,
            stackTrace: stack,
            level: 900,
          );
          log('Asset JSON: ${assets[i]}', level: 900);
          throw ImportException.parsingFailed(
            'assets[$i]',
            assets[i],
            e,
            stack,
          );
        }
      }
      log('Assets imported successfully');

      // Import events with remapped IDs and references
      final events = (data['events'] as List<dynamic>?) ?? [];
      log('Importing ${events.length} events');
      final importedEvents = <Event>[];
      for (var i = 0; i < events.length; i++) {
        try {
          final json = events[i];
          final eventData = Map<String, dynamic>.from(
            json as Map<String, dynamic>,
          );
          final oldId = eventData['id'] as String;
          log(
            'Processing event [$i]: $oldId (type: ${eventData['runtimeType']})',
          );

          // Generate new event ID and track mapping
          final newId = _uuid.v4();
          eventIdMap[oldId] = newId;
          eventData['id'] = newId;

          // Remap individual ID references
          if (eventData.containsKey('individualId') &&
              eventData['individualId'] != null) {
            final oldIndividualId = eventData['individualId'] as String;
            if (individualIdMap.containsKey(oldIndividualId)) {
              eventData['individualId'] = individualIdMap[oldIndividualId]!;
            } else {
              final error =
                  'Event references unknown individual ID: $oldIndividualId';
              log(error, level: 900);
              throw ImportException.schemaViolation(
                error,
                fieldPath: 'events[$i].individualId',
              );
            }
          }

          // Remap timing individual ID if age-based
          if (eventData.containsKey('timing')) {
            final timingData = eventData['timing'] as Map<String, dynamic>;
            if (timingData.containsKey('individualId') &&
                timingData['individualId'] != null) {
              final oldIndividualId = timingData['individualId'] as String;
              if (individualIdMap.containsKey(oldIndividualId)) {
                timingData['individualId'] = individualIdMap[oldIndividualId]!;
              } else {
                final error =
                    'Event timing references unknown individual ID: $oldIndividualId';
                log(error, level: 900);
                throw ImportException.schemaViolation(
                  error,
                  fieldPath: 'events[$i].timing.individualId',
                );
              }
            }
          }

          // Remap asset ID references for real estate transactions
          if (eventData.containsKey('assetSoldId') &&
              eventData['assetSoldId'] != null) {
            final oldAssetId = eventData['assetSoldId'] as String;
            if (assetIdMap.containsKey(oldAssetId)) {
              eventData['assetSoldId'] = assetIdMap[oldAssetId]!;
            } else {
              final error = 'Event references unknown asset ID: $oldAssetId';
              log(error, level: 900);
              throw ImportException.schemaViolation(
                error,
                fieldPath: 'events[$i].assetSoldId',
              );
            }
          }

          if (eventData.containsKey('assetPurchasedId') &&
              eventData['assetPurchasedId'] != null) {
            final oldAssetId = eventData['assetPurchasedId'] as String;
            if (assetIdMap.containsKey(oldAssetId)) {
              eventData['assetPurchasedId'] = assetIdMap[oldAssetId]!;
            } else {
              final error = 'Event references unknown asset ID: $oldAssetId';
              log(error, level: 900);
              throw ImportException.schemaViolation(
                error,
                fieldPath: 'events[$i].assetPurchasedId',
              );
            }
          }

          if (eventData.containsKey('withdrawAccountId') &&
              eventData['withdrawAccountId'] != null) {
            final oldAssetId = eventData['withdrawAccountId'] as String;
            if (assetIdMap.containsKey(oldAssetId)) {
              eventData['withdrawAccountId'] = assetIdMap[oldAssetId]!;
            } else {
              final error = 'Event references unknown account ID: $oldAssetId';
              log(error, level: 900);
              throw ImportException.schemaViolation(
                error,
                fieldPath: 'events[$i].withdrawAccountId',
              );
            }
          }

          if (eventData.containsKey('depositAccountId') &&
              eventData['depositAccountId'] != null) {
            final oldAssetId = eventData['depositAccountId'] as String;
            if (assetIdMap.containsKey(oldAssetId)) {
              eventData['depositAccountId'] = assetIdMap[oldAssetId]!;
            } else {
              final error = 'Event references unknown account ID: $oldAssetId';
              log(error, level: 900);
              throw ImportException.schemaViolation(
                error,
                fieldPath: 'events[$i].depositAccountId',
              );
            }
          }

          log('Creating Event from JSON for: $oldId');
          importedEvents.add(Event.fromJson(eventData));
        } catch (e, stack) {
          if (e is ImportException) {
            log(
              'Import error for event [$i]: $e',
              error: e,
              stackTrace: stack,
              level: 900,
            );
            rethrow;
          }
          log(
            'Error importing event [$i]: $e',
            error: e,
            stackTrace: stack,
            level: 900,
          );
          log('Event JSON: ${events[i]}', level: 900);
          throw ImportException.parsingFailed(
            'events[$i]',
            events[i],
            e,
            stack,
          );
        }
      }
      log('Events imported successfully');

      // Import expenses with remapped IDs and timing references
      final expenses = (data['expenses'] as List<dynamic>?) ?? [];
      log('Importing ${expenses.length} expenses');
      final importedExpenses = <Expense>[];
      for (var i = 0; i < expenses.length; i++) {
        try {
          final json = expenses[i];
          final expenseData = Map<String, dynamic>.from(
            json as Map<String, dynamic>,
          );
          final oldId = expenseData['id'] as String;
          log(
            'Processing expense [$i]: $oldId (type: ${expenseData['runtimeType']})',
          );

          // Generate new expense ID
          final newId = _uuid.v4();
          expenseData['id'] = newId;

          // Helper function to remap timing references
          void remapTiming(String timingKey) {
            if (expenseData.containsKey(timingKey)) {
              final timingData = expenseData[timingKey] as Map<String, dynamic>;

              // Remap individual ID for age-based timing
              if (timingData.containsKey('individualId') &&
                  timingData['individualId'] != null) {
                final oldIndividualId = timingData['individualId'] as String;
                if (individualIdMap.containsKey(oldIndividualId)) {
                  timingData['individualId'] =
                      individualIdMap[oldIndividualId]!;
                } else {
                  final error =
                      'Expense $timingKey references unknown individual ID: $oldIndividualId';
                  log(error, level: 900);
                  throw ImportException.schemaViolation(
                    error,
                    fieldPath: 'expenses[$i].$timingKey.individualId',
                  );
                }
              }

              // Remap event ID for event-relative timing
              if (timingData.containsKey('eventId') &&
                  timingData['eventId'] != null) {
                final oldEventId = timingData['eventId'] as String;
                if (eventIdMap.containsKey(oldEventId)) {
                  timingData['eventId'] = eventIdMap[oldEventId]!;
                } else {
                  final error =
                      'Expense $timingKey references unknown event ID: $oldEventId';
                  log(error, level: 900);
                  throw ImportException.schemaViolation(
                    error,
                    fieldPath: 'expenses[$i].$timingKey.eventId',
                  );
                }
              }
            }
          }

          // Remap both start and end timing references
          remapTiming('startTiming');
          remapTiming('endTiming');

          log('Creating Expense from JSON for: $oldId');
          importedExpenses.add(Expense.fromJson(expenseData));
        } catch (e, stack) {
          if (e is ImportException) {
            log(
              'Import error for expense [$i]: $e',
              error: e,
              stackTrace: stack,
              level: 900,
            );
            rethrow;
          }
          log(
            'Error importing expense [$i]: $e',
            error: e,
            stackTrace: stack,
            level: 900,
          );
          log('Expense JSON: ${expenses[i]}', level: 900);
          throw ImportException.parsingFailed(
            'expenses[$i]',
            expenses[i],
            e,
            stack,
          );
        }
      }
      log('Expenses imported successfully');

      // Import scenarios with remapped override references
      final scenarios = (data['scenarios'] as List<dynamic>?) ?? [];
      log('Importing ${scenarios.length} scenarios');

      // Ensure base scenario exists, or create one
      final hasBaseScenario = scenarios.any((s) {
        final scenarioData = s as Map<String, dynamic>;
        return scenarioData['isBase'] == true;
      });

      final importedScenarios = <Scenario>[];

      // If no base scenario in export, create one
      if (!hasBaseScenario) {
        final baseScenario = Scenario(
          id: _uuid.v4(),
          name: 'Base Scenario',
          isBase: true,
          overrides: [],
          createdAt: now,
          updatedAt: now,
        );
        importedScenarios.add(baseScenario);
        scenarioIdMap['base'] = baseScenario.id;
      }

      for (var i = 0; i < scenarios.length; i++) {
        try {
          final json = scenarios[i];
          final scenarioData = Map<String, dynamic>.from(
            json as Map<String, dynamic>,
          );

          // Generate new scenario ID
          final newScenarioId = _uuid.v4();
          final oldScenarioId = scenarioData['id'] as String;
          log('Processing scenario [$i]: $oldScenarioId');
          scenarioIdMap[oldScenarioId] = newScenarioId;
          scenarioData['id'] = newScenarioId;

          // Remap asset and event IDs in overrides
          if (scenarioData.containsKey('overrides')) {
            final overrides = scenarioData['overrides'] as List<dynamic>;
            final remappedOverrides = <Map<String, dynamic>>[];

            for (var j = 0; j < overrides.length; j++) {
              final overrideJson = overrides[j];
              final overrideData = Map<String, dynamic>.from(
                overrideJson as Map<String, dynamic>,
              );

              // Remap asset ID for AssetValueOverride
              if (overrideData['runtimeType'] == 'assetValue' &&
                  overrideData.containsKey('assetId')) {
                final oldAssetId = overrideData['assetId'] as String;
                if (assetIdMap.containsKey(oldAssetId)) {
                  overrideData['assetId'] = assetIdMap[oldAssetId]!;
                } else {
                  final error =
                      'Override references unknown asset ID: $oldAssetId';
                  log(error, level: 900);
                  throw ImportException.schemaViolation(
                    error,
                    fieldPath: 'scenarios[$i].overrides[$j].assetId',
                  );
                }
              }

              // Remap event ID for EventTimingOverride
              if (overrideData['runtimeType'] == 'eventTiming' &&
                  overrideData.containsKey('eventId')) {
                final oldEventId = overrideData['eventId'] as String;
                if (eventIdMap.containsKey(oldEventId)) {
                  overrideData['eventId'] = eventIdMap[oldEventId]!;
                } else {
                  final error =
                      'Override references unknown event ID: $oldEventId';
                  log(error, level: 900);
                  throw ImportException.schemaViolation(
                    error,
                    fieldPath: 'scenarios[$i].overrides[$j].eventId',
                  );
                }
              }

              remappedOverrides.add(overrideData);
            }

            scenarioData['overrides'] = remappedOverrides;
          }

          log('Creating Scenario from JSON for: $oldScenarioId');
          importedScenarios.add(Scenario.fromJson(scenarioData));
        } catch (e, stack) {
          if (e is ImportException) {
            log(
              'Import error for scenario [$i]: $e',
              error: e,
              stackTrace: stack,
              level: 900,
            );
            rethrow;
          }
          log(
            'Error importing scenario [$i]: $e',
            error: e,
            stackTrace: stack,
            level: 900,
          );
          log('Scenario JSON: ${scenarios[i]}', level: 900);
          throw ImportException.parsingFailed(
            'scenarios[$i]',
            scenarios[i],
            e,
            stack,
          );
        }
      }
      log('Scenarios imported successfully');

      log('Creating ImportedProjectData');
      return ImportedProjectData(
        project: project,
        assets: importedAssets,
        events: importedEvents,
        expenses: importedExpenses,
        scenarios: importedScenarios,
      );
    } on FormatException catch (e, stack) {
      log(
        'Format exception: ${e.message}',
        error: e,
        stackTrace: stack,
        level: 900,
      );
      throw ImportException(
        'Invalid JSON format: ${e.message}',
        originalException: e,
        stackTrace: stack,
      );
    } on ImportException {
      // Already logged and formatted, just rethrow
      rethrow;
    } catch (e, stack) {
      log('Import failed: $e', error: e, stackTrace: stack, level: 900);
      throw ImportException(
        'Failed to import project: $e',
        originalException: e,
        stackTrace: stack,
      );
    }
  }
}
