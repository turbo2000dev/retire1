import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/core/services/project_export_service.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

void main() {
  group('ProjectExportService', () {
    late ProjectExportService service;

    setUp(() {
      service = ProjectExportService();
    });

    /// Helper to create a test project
    Project createTestProject() {
      return Project(
        id: 'project-1',
        name: 'Test Project',
        ownerId: 'user-1',
        description: 'A test retirement project',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
        individuals: [
          Individual(
            id: 'ind-1',
            name: 'John Doe',
            birthdate: DateTime(1965, 1, 1),
            employmentIncome: 80000,

            rrqStartAge: 65,
            psvStartAge: 65,
            initialCeliRoom: 95000,
          ),
        ],
        inflationRate: 0.02,
        reerReturnRate: 0.05,
        celiReturnRate: 0.05,
        criReturnRate: 0.05,
        cashReturnRate: 0.015,
      );
    }

    group('exportProject', () {
      test('should export project with minimal data', () {
        final project = createTestProject();

        final json = service.exportProject(project);

        expect(json, isNotEmpty);

        final data = jsonDecode(json) as Map<String, dynamic>;
        expect(data['exportVersion'], '1.2');
        expect(data['exportedAt'], isNotNull);
        expect(data['project'], isNotNull);

        final projectData = data['project'] as Map<String, dynamic>;
        expect(projectData['id'], 'project-1');
        expect(projectData['name'], 'Test Project');
        expect(projectData['ownerId'], 'user-1');
        expect(projectData['description'], 'A test retirement project');
      });

      test('should export project with all data', () {
        final project = createTestProject();
        final assets = [
          Asset.rrsp(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: 5000,
          ),
          Asset.celi(
            id: 'asset-2',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: 7000,
          ),
        ];
        final events = [
          Event.retirement(
            id: 'event-1',
            individualId: 'ind-1',
            timing: const EventTiming.relative(yearsFromStart: 5),
          ),
        ];
        final expenses = [
          Expense.housing(
            id: 'expense-1',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 30000,
          ),
        ];
        final scenarios = [
          Scenario(
            id: 'scenario-1',
            name: 'Base Scenario',
            isBase: true,
            overrides: [],
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        final json = service.exportProject(
          project,
          assets: assets,
          events: events,
          expenses: expenses,
          scenarios: scenarios,
        );

        final data = jsonDecode(json) as Map<String, dynamic>;
        expect(data['assets'], isNotNull);
        expect(data['events'], isNotNull);
        expect(data['expenses'], isNotNull);
        expect(data['scenarios'], isNotNull);

        final assetsList = data['assets'] as List;
        expect(assetsList.length, 2);

        final eventsList = data['events'] as List;
        expect(eventsList.length, 1);

        final expensesList = data['expenses'] as List;
        expect(expensesList.length, 1);

        final scenariosList = data['scenarios'] as List;
        expect(scenariosList.length, 1);
      });

      test('should export valid JSON format', () {
        final project = createTestProject();

        final json = service.exportProject(project);

        // Should be parseable
        expect(() => jsonDecode(json), returnsNormally);
      });

      test('should include individuals in project data', () {
        final project = createTestProject();

        final json = service.exportProject(project);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final projectData = data['project'] as Map<String, dynamic>;
        final individuals = projectData['individuals'] as List;

        expect(individuals.length, 1);

        final individual = individuals[0] as Map<String, dynamic>;
        expect(individual['id'], 'ind-1');
        expect(individual['name'], 'John Doe');
        expect(individual['employmentIncome'], 80000);
      });

      test('should include economic assumptions', () {
        final project = createTestProject();

        final json = service.exportProject(project);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final projectData = data['project'] as Map<String, dynamic>;

        expect(projectData['inflationRate'], 0.02);
        expect(projectData['reerReturnRate'], 0.05);
        expect(projectData['celiReturnRate'], 0.05);
        expect(projectData['criReturnRate'], 0.05);
        expect(projectData['cashReturnRate'], 0.015);
      });

      test('should export all asset types correctly', () {
        final project = createTestProject();
        final assets = [
          Asset.realEstate(
            id: 'asset-1',
            type: RealEstateType.house,
            value: 500000,
            setAtStart: true,
            customReturnRate: null,
          ),
          Asset.rrsp(
            id: 'asset-2',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: 0.06,
            annualContribution: 5000,
          ),
          Asset.celi(
            id: 'asset-3',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: 7000,
          ),
          Asset.cri(
            id: 'asset-4',
            individualId: 'ind-1',
            value: 200000,
            contributionRoom: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.cash(
            id: 'asset-5',
            individualId: 'ind-1',
            value: 30000,
            customReturnRate: null,
            annualContribution: 1000,
          ),
        ];

        final json = service.exportProject(project, assets: assets);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final assetsList = data['assets'] as List;

        expect(assetsList.length, 5);

        // Check each asset type is preserved
        final assetTypes = assetsList
            .map((a) => (a as Map<String, dynamic>)['runtimeType'])
            .toList();
        expect(assetTypes, contains('realEstate'));
        expect(assetTypes, contains('rrsp'));
        expect(assetTypes, contains('celi'));
        expect(assetTypes, contains('cri'));
        expect(assetTypes, contains('cash'));
      });

      test('should export all event types correctly', () {
        final project = createTestProject();
        final events = [
          Event.retirement(
            id: 'event-1',
            individualId: 'ind-1',
            timing: const EventTiming.relative(yearsFromStart: 5),
          ),
          Event.death(
            id: 'event-2',
            individualId: 'ind-1',
            timing: const EventTiming.age(individualId: 'ind-1', age: 85),
          ),
          Event.realEstateTransaction(
            id: 'event-3',
            timing: const EventTiming.absolute(calendarYear: 2030),
            assetSoldId: 'asset-1',
            assetPurchasedId: null,
            withdrawAccountId: 'asset-2',
            depositAccountId: 'asset-3',
          ),
        ];

        final json = service.exportProject(project, events: events);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final eventsList = data['events'] as List;

        expect(eventsList.length, 3);

        final eventTypes = eventsList
            .map((e) => (e as Map<String, dynamic>)['runtimeType'])
            .toList();
        expect(eventTypes, contains('retirement'));
        expect(eventTypes, contains('death'));
        expect(eventTypes, contains('realEstateTransaction'));
      });

      test('should export all expense categories correctly', () {
        final project = createTestProject();
        final expenses = [
          Expense.housing(
            id: 'expense-1',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 30000,
          ),
          Expense.transport(
            id: 'expense-2',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 10000,
          ),
          Expense.dailyLiving(
            id: 'expense-3',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 20000,
          ),
          Expense.recreation(
            id: 'expense-4',
            startTiming: const EventTiming.relative(yearsFromStart: 5),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 5000,
          ),
          Expense.health(
            id: 'expense-5',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 8000,
          ),
          Expense.family(
            id: 'expense-6',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.relative(yearsFromStart: 10),
            annualAmount: 12000,
          ),
        ];

        final json = service.exportProject(project, expenses: expenses);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final expensesList = data['expenses'] as List;

        expect(expensesList.length, 6);

        final expenseCategories = expensesList
            .map((e) => (e as Map<String, dynamic>)['runtimeType'])
            .toList();
        expect(expenseCategories, contains('housing'));
        expect(expenseCategories, contains('transport'));
        expect(expenseCategories, contains('dailyLiving'));
        expect(expenseCategories, contains('recreation'));
        expect(expenseCategories, contains('health'));
        expect(expenseCategories, contains('family'));
      });

      test('should export scenario overrides correctly', () {
        final project = createTestProject();
        final scenarios = [
          Scenario(
            id: 'scenario-1',
            name: 'Base Scenario',
            isBase: true,
            overrides: [],
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
          Scenario(
            id: 'scenario-2',
            name: 'Variation 1',
            isBase: false,
            overrides: [
              const ParameterOverride.assetValue(
                assetId: 'asset-1',
                value: 150000,
              ),
              const ParameterOverride.eventTiming(
                eventId: 'event-1',
                yearsFromStart: 3,
              ),
              const ParameterOverride.expenseAmount(
                expenseId: 'expense-1',
                overrideAmount: 40000,
                amountMultiplier: null,
              ),
            ],
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];

        final json = service.exportProject(project, scenarios: scenarios);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final scenariosList = data['scenarios'] as List;

        expect(scenariosList.length, 2);

        final variation = scenariosList[1] as Map<String, dynamic>;
        final overrides = variation['overrides'] as List;

        expect(overrides.length, 3);
        expect(overrides[0]['runtimeType'], 'assetValue');
        expect(overrides[1]['runtimeType'], 'eventTiming');
        expect(overrides[2]['runtimeType'], 'expenseAmount');
      });

      test('should handle null optional fields gracefully', () {
        final project = createTestProject();

        final json = service.exportProject(
          project,
          assets: null,
          events: null,
          expenses: null,
          scenarios: null,
        );

        final data = jsonDecode(json) as Map<String, dynamic>;

        expect(data['assets'], isNull);
        expect(data['events'], isNull);
        expect(data['expenses'], isNull);
        expect(data['scenarios'], isNull);
      });

      test('should produce pretty-printed JSON', () {
        final project = createTestProject();

        final json = service.exportProject(project);

        // Should contain newlines and indentation
        expect(json, contains('\n'));
        expect(json, contains('  ')); // Indentation
      });
    });

    group('generateFilename', () {
      test('should generate valid filename with sanitized name', () {
        final project = createTestProject();

        final filename = service.generateFilename(project);

        expect(filename, startsWith('project_'));
        expect(filename, endsWith('.json'));
        expect(filename, contains('test-project'));
      });

      test('should sanitize special characters', () {
        final project = Project(
          id: 'project-1',
          name: 'My Retirement Plan!!! @2024',
          ownerId: 'user-1',
          description: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [],
        );

        final filename = service.generateFilename(project);

        // Should only contain alphanumeric and hyphens
        expect(
          filename,
          matches(RegExp(r'^project_[a-z0-9-]+_\d{4}-\d{2}-\d{2}\.json$')),
        );
        expect(filename, isNot(contains('!')));
        expect(filename, isNot(contains('@')));
      });

      test('should handle multiple spaces', () {
        final project = Project(
          id: 'project-1',
          name: 'My   Retirement    Plan',
          ownerId: 'user-1',
          description: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [],
        );

        final filename = service.generateFilename(project);

        // Multiple spaces should become single hyphen
        expect(filename, contains('my-retirement-plan'));
        expect(filename, isNot(contains('--')));
      });

      test('should include current date', () {
        final project = createTestProject();

        final filename = service.generateFilename(project);

        // Should contain date in YYYY-MM-DD format
        expect(filename, matches(RegExp(r'\d{4}-\d{2}-\d{2}\.json$')));
      });

      test('should handle empty project name', () {
        final project = Project(
          id: 'project-1',
          name: '',
          ownerId: 'user-1',
          description: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [],
        );

        final filename = service.generateFilename(project);

        // Should still generate valid filename
        expect(filename, startsWith('project_'));
        expect(filename, endsWith('.json'));
      });

      test('should handle non-ASCII characters', () {
        final project = Project(
          id: 'project-1',
          name: 'Plan de Retraite \u00E9t\u00E9',
          ownerId: 'user-1',
          description: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [],
        );

        final filename = service.generateFilename(project);

        // Should only contain ASCII alphanumeric and hyphens
        expect(
          filename,
          matches(RegExp(r'^project_[a-z0-9-]+_\d{4}-\d{2}-\d{2}\.json$')),
        );
      });

      test('should strip leading and trailing hyphens', () {
        final project = Project(
          id: 'project-1',
          name: '---Test Project---',
          ownerId: 'user-1',
          description: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [],
        );

        final filename = service.generateFilename(project);

        // Should not have leading/trailing hyphens after "project_"
        expect(filename, contains('test-project'));
        expect(filename, isNot(matches(RegExp(r'project_-'))));
        expect(filename, isNot(matches(RegExp(r'-_\d{4}'))));
      });
    });

    group('Round-trip Compatibility', () {
      test('should produce JSON that can be parsed back', () {
        final project = createTestProject();
        final assets = [
          Asset.rrsp(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ];

        final json = service.exportProject(project, assets: assets);

        // Parse back
        final data = jsonDecode(json) as Map<String, dynamic>;
        final projectData = data['project'] as Map<String, dynamic>;

        // Should be able to recreate project
        final recreatedProject = Project.fromJson(projectData);
        expect(recreatedProject.id, project.id);
        expect(recreatedProject.name, project.name);
        expect(recreatedProject.ownerId, project.ownerId);
        expect(recreatedProject.individuals.length, project.individuals.length);
      });

      test('should preserve all data types correctly', () {
        final project = createTestProject();

        final json = service.exportProject(project);

        final data = jsonDecode(json) as Map<String, dynamic>;
        final projectData = data['project'] as Map<String, dynamic>;

        // Verify types
        expect(projectData['inflationRate'], isA<double>());
        expect(projectData['reerReturnRate'], isA<double>());
        expect(projectData['individuals'], isA<List>());
      });
    });
  });
}
