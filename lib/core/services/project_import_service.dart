import 'dart:convert';
import 'dart:developer';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:uuid/uuid.dart';

/// Result of parsing an import file before creating the project
class ImportPreview {
  final String projectName;
  final int individualCount;
  final Map<String, int> assetCountsByType;
  final Map<String, int> eventCountsByType;
  final int scenarioCount;
  final Map<String, dynamic> economicAssumptions;

  ImportPreview({
    required this.projectName,
    required this.individualCount,
    required this.assetCountsByType,
    required this.eventCountsByType,
    required this.scenarioCount,
    required this.economicAssumptions,
  });
}

/// Data extracted from import file, ready to be saved
class ImportedProjectData {
  final Project project;
  final List<Asset> assets;
  final List<Event> events;
  final List<Scenario> scenarios;

  ImportedProjectData({
    required this.project,
    required this.assets,
    required this.events,
    required this.scenarios,
  });
}

/// Service for importing project data from JSON format
class ProjectImportService {
  final _uuid = const Uuid();

  /// Parse and validate JSON, return preview without creating entities
  ImportPreview validateAndPreview(String jsonContent) {
    try {
      final data = jsonDecode(jsonContent) as Map<String, dynamic>;

      // Validate export version
      if (!data.containsKey('exportVersion')) {
        throw Exception('Missing exportVersion field');
      }

      final version = data['exportVersion'] as String;
      if (version != '1.0' && version != '1.1') {
        throw Exception('Unsupported export version: $version');
      }

      // Validate required project field
      if (!data.containsKey('project')) {
        throw Exception('Missing project data');
      }

      final projectData = data['project'] as Map<String, dynamic>;

      // Validate required project fields
      if (!projectData.containsKey('name')) {
        throw Exception('Missing project name');
      }

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
            assetCountsByType['Real Estate'] = assetCountsByType['Real Estate']! + 1;
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
            eventCountsByType['Retirement'] = eventCountsByType['Retirement']! + 1;
            break;
          case 'death':
            eventCountsByType['Death'] = eventCountsByType['Death']! + 1;
            break;
          case 'realEstateTransaction':
            eventCountsByType['Real Estate Transaction'] = eventCountsByType['Real Estate Transaction']! + 1;
            break;
          default:
            throw Exception('Unknown event type: $runtimeType');
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
        final newId = DateTime.now().millisecondsSinceEpoch.toString() + individuals.indexOf(individualJson).toString();
        individualIdMap[oldId] = newId;
      }

      // Remap asset IDs
      final assets = (data['assets'] as List<dynamic>?) ?? [];
      for (final assetJson in assets) {
        final asset = assetJson as Map<String, dynamic>;
        final oldId = asset['id'] as String;
        final newId = DateTime.now().millisecondsSinceEpoch.toString() + assets.indexOf(assetJson).toString();
        assetIdMap[oldId] = newId;
      }

      // Create project with new ID and owner
      final remappedIndividuals = individuals.map((json) {
        final individualData = Map<String, dynamic>.from(json as Map<String, dynamic>);
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
        inflationRate: (projectData['inflationRate'] as num?)?.toDouble() ?? 0.02,
        reerReturnRate: (projectData['reerReturnRate'] as num?)?.toDouble() ?? 0.05,
        celiReturnRate: (projectData['celiReturnRate'] as num?)?.toDouble() ?? 0.05,
        criReturnRate: (projectData['criReturnRate'] as num?)?.toDouble() ?? 0.05,
        cashReturnRate: (projectData['cashReturnRate'] as num?)?.toDouble() ?? 0.015,
      );

      // Import assets with remapped IDs and individual references
      log('Importing ${assets.length} assets');
      final importedAssets = assets.map((json) {
        try {
          final assetData = Map<String, dynamic>.from(json as Map<String, dynamic>);
          final oldId = assetData['id'] as String;
          log('Processing asset: $oldId (type: ${assetData['runtimeType']})');
          assetData['id'] = assetIdMap[oldId]!;

          // Remap individual ID references for accounts
          if (assetData.containsKey('individualId') && assetData['individualId'] != null) {
            final oldIndividualId = assetData['individualId'] as String;
            if (individualIdMap.containsKey(oldIndividualId)) {
              assetData['individualId'] = individualIdMap[oldIndividualId]!;
            } else {
              throw Exception('Asset references unknown individual ID: $oldIndividualId');
            }
          }

          log('Creating Asset from JSON for: $oldId');
          return Asset.fromJson(assetData);
        } catch (e, stack) {
          log('Error importing asset: $e', error: e, stackTrace: stack);
          log('Asset JSON: $json');
          rethrow;
        }
      }).toList();
      log('Assets imported successfully');

      // Import events with remapped IDs and references
      final events = (data['events'] as List<dynamic>?) ?? [];
      log('Importing ${events.length} events');
      final importedEvents = events.map((json) {
        try {
          final eventData = Map<String, dynamic>.from(json as Map<String, dynamic>);
          final oldId = eventData['id'] as String;
          log('Processing event: $oldId (type: ${eventData['runtimeType']})');

          // Generate new event ID and track mapping
          final newId = _uuid.v4();
          eventIdMap[oldId] = newId;
          eventData['id'] = newId;

        // Remap individual ID references
        if (eventData.containsKey('individualId') && eventData['individualId'] != null) {
          final oldIndividualId = eventData['individualId'] as String;
          if (individualIdMap.containsKey(oldIndividualId)) {
            eventData['individualId'] = individualIdMap[oldIndividualId]!;
          } else {
            throw Exception('Event references unknown individual ID: $oldIndividualId');
          }
        }

        // Remap timing individual ID if age-based
        if (eventData.containsKey('timing')) {
          final timingData = eventData['timing'] as Map<String, dynamic>;
          if (timingData.containsKey('individualId') && timingData['individualId'] != null) {
            final oldIndividualId = timingData['individualId'] as String;
            if (individualIdMap.containsKey(oldIndividualId)) {
              timingData['individualId'] = individualIdMap[oldIndividualId]!;
            } else {
              throw Exception('Event timing references unknown individual ID: $oldIndividualId');
            }
          }
        }

        // Remap asset ID references for real estate transactions
        if (eventData.containsKey('assetSoldId') && eventData['assetSoldId'] != null) {
          final oldAssetId = eventData['assetSoldId'] as String;
          if (assetIdMap.containsKey(oldAssetId)) {
            eventData['assetSoldId'] = assetIdMap[oldAssetId]!;
          } else {
            throw Exception('Event references unknown asset ID: $oldAssetId');
          }
        }

        if (eventData.containsKey('assetPurchasedId') && eventData['assetPurchasedId'] != null) {
          final oldAssetId = eventData['assetPurchasedId'] as String;
          if (assetIdMap.containsKey(oldAssetId)) {
            eventData['assetPurchasedId'] = assetIdMap[oldAssetId]!;
          } else {
            throw Exception('Event references unknown asset ID: $oldAssetId');
          }
        }

        if (eventData.containsKey('withdrawAccountId') && eventData['withdrawAccountId'] != null) {
          final oldAssetId = eventData['withdrawAccountId'] as String;
          if (assetIdMap.containsKey(oldAssetId)) {
            eventData['withdrawAccountId'] = assetIdMap[oldAssetId]!;
          } else {
            throw Exception('Event references unknown account ID: $oldAssetId');
          }
        }

        if (eventData.containsKey('depositAccountId') && eventData['depositAccountId'] != null) {
          final oldAssetId = eventData['depositAccountId'] as String;
          if (assetIdMap.containsKey(oldAssetId)) {
            eventData['depositAccountId'] = assetIdMap[oldAssetId]!;
          } else {
            throw Exception('Event references unknown account ID: $oldAssetId');
          }
        }

          log('Creating Event from JSON for: $oldId');
          return Event.fromJson(eventData);
        } catch (e, stack) {
          log('Error importing event: $e', error: e, stackTrace: stack);
          log('Event JSON: $json');
          rethrow;
        }
      }).toList();
      log('Events imported successfully');

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

      for (final json in scenarios) {
        try {
          final scenarioData = Map<String, dynamic>.from(json as Map<String, dynamic>);

          // Generate new scenario ID
          final newScenarioId = _uuid.v4();
          final oldScenarioId = scenarioData['id'] as String;
          log('Processing scenario: $oldScenarioId');
          scenarioIdMap[oldScenarioId] = newScenarioId;
          scenarioData['id'] = newScenarioId;

        // Remap asset and event IDs in overrides
        if (scenarioData.containsKey('overrides')) {
          final overrides = scenarioData['overrides'] as List<dynamic>;
          final remappedOverrides = overrides.map((overrideJson) {
            final overrideData = Map<String, dynamic>.from(overrideJson as Map<String, dynamic>);

            // Remap asset ID for AssetValueOverride
            if (overrideData['runtimeType'] == 'assetValue' && overrideData.containsKey('assetId')) {
              final oldAssetId = overrideData['assetId'] as String;
              if (assetIdMap.containsKey(oldAssetId)) {
                overrideData['assetId'] = assetIdMap[oldAssetId]!;
              } else {
                throw Exception('Override references unknown asset ID: $oldAssetId');
              }
            }

            // Remap event ID for EventTimingOverride
            if (overrideData['runtimeType'] == 'eventTiming' && overrideData.containsKey('eventId')) {
              final oldEventId = overrideData['eventId'] as String;
              if (eventIdMap.containsKey(oldEventId)) {
                overrideData['eventId'] = eventIdMap[oldEventId]!;
              } else {
                throw Exception('Override references unknown event ID: $oldEventId');
              }
            }

            return overrideData;
          }).toList();

          scenarioData['overrides'] = remappedOverrides;
        }

          log('Creating Scenario from JSON for: $oldScenarioId');
          importedScenarios.add(Scenario.fromJson(scenarioData));
        } catch (e, stack) {
          log('Error importing scenario: $e', error: e, stackTrace: stack);
          log('Scenario JSON: $json');
          rethrow;
        }
      }
      log('Scenarios imported successfully');

      log('Creating ImportedProjectData');
      return ImportedProjectData(
        project: project,
        assets: importedAssets,
        events: importedEvents,
        scenarios: importedScenarios,
      );
    } on FormatException catch (e) {
      log('Format exception: ${e.message}', error: e);
      throw Exception('Invalid JSON format: ${e.message}');
    } catch (e, stack) {
      log('Import failed: $e', error: e, stackTrace: stack);
      if (e is Exception) rethrow;
      throw Exception('Failed to import project: $e');
    }
  }
}
