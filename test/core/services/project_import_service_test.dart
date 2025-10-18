import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/core/services/project_export_service.dart';
import 'package:retire1/core/services/project_import_service.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

void main() {
  group('ProjectImportService', () {
    late ProjectImportService importService;
    late ProjectExportService exportService;

    setUp(() {
      importService = ProjectImportService();
      exportService = ProjectExportService();
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

    group('validateAndPreview', () {
      test('should validate and preview minimal project', () {
        final project = createTestProject();
        final json = exportService.exportProject(project);

        final preview = importService.validateAndPreview(json);

        expect(preview.projectName, 'Test Project');
        expect(preview.individualCount, 1);
        expect(preview.scenarioCount, 0); // No scenarios in export
        expect(preview.economicAssumptions['inflationRate'], 0.02);
        expect(preview.economicAssumptions['reerReturnRate'], 0.05);
      });

      test('should count assets by type', () {
        final project = createTestProject();
        final assets = [
          Asset.rrsp(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.rrsp(
            id: 'asset-2',
            individualId: 'ind-1',
            value: 50000,
            customReturnRate: null,
            annualContribution: null,
          ),
          Asset.celi(
            id: 'asset-3',
            individualId: 'ind-1',
            value: 40000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ];
        final json = exportService.exportProject(project, assets: assets);

        final preview = importService.validateAndPreview(json);

        expect(preview.assetCountsByType['RRSP'], 2);
        expect(preview.assetCountsByType['CELI'], 1);
        expect(preview.assetCountsByType['CRI'], 0);
        expect(preview.assetCountsByType['Cash'], 0);
        expect(preview.assetCountsByType['Real Estate'], 0);
      });

      test('should count events by type', () {
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
        ];
        final json = exportService.exportProject(project, events: events);

        final preview = importService.validateAndPreview(json);

        expect(preview.eventCountsByType['Retirement'], 1);
        expect(preview.eventCountsByType['Death'], 1);
        expect(preview.eventCountsByType['Real Estate Transaction'], 0);
      });

      test('should count expenses by category', () {
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
        ];
        final json = exportService.exportProject(project, expenses: expenses);

        final preview = importService.validateAndPreview(json);

        expect(preview.expenseCountsByCategory['Housing'], 1);
        expect(preview.expenseCountsByCategory['Transport'], 1);
        expect(preview.expenseCountsByCategory['Daily Living'], 0);
      });

      test('should count scenarios', () {
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
            overrides: [],
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];
        final json = exportService.exportProject(project, scenarios: scenarios);

        final preview = importService.validateAndPreview(json);

        expect(preview.scenarioCount, 2);
      });

      test('should throw on invalid JSON', () {
        expect(
          () => importService.validateAndPreview('not valid json'),
          throwsException,
        );
      });

      test('should throw on missing project field', () {
        final json = '{"exportVersion": "1.2"}';

        expect(() => importService.validateAndPreview(json), throwsException);
      });

      test('should throw on empty project name', () {
        final project = Project(
          id: 'project-1',
          name: '   ',
          ownerId: 'user-1',
          description: null,
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [],
        );
        final json = exportService.exportProject(project);

        expect(() => importService.validateAndPreview(json), throwsException);
      });
    });

    group('importProject', () {
      test('should import minimal project', () {
        final project = createTestProject();
        final json = exportService.exportProject(project);

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.project.name, 'Test Project');
        expect(importedData.project.ownerId, 'new-user-id'); // Changed
        expect(importedData.project.description, 'A test retirement project');
        expect(importedData.project.individuals.length, 1);
      });

      test('should generate new project ID', () {
        final project = createTestProject();
        final json = exportService.exportProject(project);

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.project.id, isNot('project-1')); // Changed
      });

      test('should remap individual IDs', () {
        final project = createTestProject();
        final json = exportService.exportProject(project);

        final importedData = importService.importProject(json, 'new-user-id');

        final individual = importedData.project.individuals.first;
        expect(individual.id, isNot('ind-1')); // Changed
        expect(individual.name, 'John Doe'); // Preserved
      });

      test('should import and remap assets', () {
        final project = createTestProject();
        final assets = [
          Asset.rrsp(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: null,
            annualContribution: 5000,
          ),
        ];
        final json = exportService.exportProject(project, assets: assets);

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.assets.length, 1);

        final asset = importedData.assets.first;
        asset.when(
          rrsp:
              (id, individualId, value, customReturnRate, annualContribution) {
                expect(id, isNot('asset-1')); // Changed
                expect(individualId, isNot('ind-1')); // Changed
                expect(value, 100000); // Preserved
                expect(annualContribution, 5000); // Preserved
              },
          celi: (_, __, ___, ____, _____) => fail('Wrong asset type'),
          cri: (_, __, ___, ____, _____, ______) => fail('Wrong asset type'),
          cash: (_, __, ___, ____, _____) => fail('Wrong asset type'),
          realEstate: (_, __, ___, ____, _____) => fail('Wrong asset type'),
        );
      });

      test('should import and remap events', () {
        final project = createTestProject();
        final events = [
          Event.retirement(
            id: 'event-1',
            individualId: 'ind-1',
            timing: const EventTiming.relative(yearsFromStart: 5),
          ),
        ];
        final json = exportService.exportProject(project, events: events);

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.events.length, 1);

        final event = importedData.events.first;
        event.when(
          retirement: (id, individualId, timing) {
            expect(id, isNot('event-1')); // Changed
            expect(individualId, isNot('ind-1')); // Changed

            timing.when(
              relative: (yearsFromStart) {
                expect(yearsFromStart, 5); // Preserved
              },
              absolute: (_) => fail('Wrong timing type'),
              age: (_, __) => fail('Wrong timing type'),
              eventRelative: (_, __) => fail('Wrong timing type'),
              projectionEnd: () => fail('Wrong timing type'),
            );
          },
          death: (_, __, ___) => fail('Wrong event type'),
          realEstateTransaction: (_, __, ___, ____, _____, ______) =>
              fail('Wrong event type'),
        );
      });

      test('should remap asset references in events', () {
        final project = createTestProject();
        final assets = [
          Asset.realEstate(
            id: 'asset-property',
            type: RealEstateType.house,
            value: 500000,
            setAtStart: true,
            customReturnRate: null,
          ),
          Asset.cash(
            id: 'asset-cash',
            individualId: 'ind-1',
            value: 10000,
            customReturnRate: null,
            annualContribution: null,
          ),
        ];
        final events = [
          Event.realEstateTransaction(
            id: 'event-1',
            timing: const EventTiming.relative(yearsFromStart: 5),
            assetSoldId: 'asset-property',
            assetPurchasedId: null,
            withdrawAccountId: 'asset-cash',
            depositAccountId: 'asset-cash',
          ),
        ];
        final json = exportService.exportProject(
          project,
          assets: assets,
          events: events,
        );

        final importedData = importService.importProject(json, 'new-user-id');

        // Extract old and new asset IDs
        final oldPropertyId = 'asset-property';
        final oldCashId = 'asset-cash';
        final newPropertyId = importedData.assets
            .firstWhere(
              (a) => a.maybeWhen(
                realEstate: (_, __, ___, ____, _____) => true,
                orElse: () => false,
              ),
            )
            .when(
              realEstate: (id, type, value, setAtStart, customReturnRate) => id,
              rrsp:
                  (
                    id,
                    individualId,
                    value,
                    customReturnRate,
                    annualContribution,
                  ) => '',
              celi:
                  (
                    id,
                    individualId,
                    value,
                    customReturnRate,
                    annualContribution,
                  ) => '',
              cri:
                  (
                    id,
                    individualId,
                    value,
                    contributionRoom,
                    customReturnRate,
                    annualContribution,
                  ) => '',
              cash:
                  (
                    id,
                    individualId,
                    value,
                    customReturnRate,
                    annualContribution,
                  ) => '',
            );
        final newCashId = importedData.assets
            .firstWhere(
              (a) => a.maybeWhen(
                cash: (_, __, ___, ____, _____) => true,
                orElse: () => false,
              ),
            )
            .when(
              realEstate: (id, type, value, setAtStart, customReturnRate) => '',
              rrsp:
                  (
                    id,
                    individualId,
                    value,
                    customReturnRate,
                    annualContribution,
                  ) => '',
              celi:
                  (
                    id,
                    individualId,
                    value,
                    customReturnRate,
                    annualContribution,
                  ) => '',
              cri:
                  (
                    id,
                    individualId,
                    value,
                    contributionRoom,
                    customReturnRate,
                    annualContribution,
                  ) => '',
              cash:
                  (
                    id,
                    individualId,
                    value,
                    customReturnRate,
                    annualContribution,
                  ) => id,
            );

        final event = importedData.events.first;
        event.when(
          realEstateTransaction:
              (
                id,
                timing,
                assetSoldId,
                assetPurchasedId,
                withdrawAccountId,
                depositAccountId,
              ) {
                expect(assetSoldId, newPropertyId); // Remapped
                expect(assetSoldId, isNot(oldPropertyId));
                expect(withdrawAccountId, newCashId); // Remapped
                expect(withdrawAccountId, isNot(oldCashId));
                expect(depositAccountId, newCashId); // Remapped
              },
          retirement: (_, __, ___) => fail('Wrong event type'),
          death: (_, __, ___) => fail('Wrong event type'),
        );
      });

      test('should import expenses with remapped timing references', () {
        final project = createTestProject();
        final expenses = [
          Expense.housing(
            id: 'expense-1',
            startTiming: const EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.age(individualId: 'ind-1', age: 75),
            annualAmount: 30000,
          ),
        ];
        final json = exportService.exportProject(project, expenses: expenses);

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.expenses.length, 1);

        final expense = importedData.expenses.first;
        expense.when(
          housing: (id, startTiming, endTiming, annualAmount) {
            expect(id, isNot('expense-1')); // Changed
            expect(annualAmount, 30000); // Preserved

            // End timing should have remapped individual ID
            endTiming.when(
              age: (individualId, age) {
                expect(individualId, isNot('ind-1')); // Changed
                expect(age, 75); // Preserved
              },
              relative: (_) => fail('Wrong timing type'),
              absolute: (_) => fail('Wrong timing type'),
              eventRelative: (_, __) => fail('Wrong timing type'),
              projectionEnd: () => fail('Wrong timing type'),
            );
          },
          transport: (_, __, ___, ____) => fail('Wrong expense type'),
          dailyLiving: (_, __, ___, ____) => fail('Wrong expense type'),
          recreation: (_, __, ___, ____) => fail('Wrong expense type'),
          health: (_, __, ___, ____) => fail('Wrong expense type'),
          family: (_, __, ___, ____) => fail('Wrong expense type'),
        );
      });

      test('should import scenarios with remapped overrides', () {
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
        final events = [
          Event.retirement(
            id: 'event-1',
            individualId: 'ind-1',
            timing: const EventTiming.relative(yearsFromStart: 5),
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
            ],
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];
        final json = exportService.exportProject(
          project,
          assets: assets,
          events: events,
          scenarios: scenarios,
        );

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.scenarios.length, 2);

        final variation = importedData.scenarios[1];
        expect(variation.name, 'Variation 1');
        expect(variation.overrides.length, 2);

        // Asset override should have remapped asset ID
        final assetOverride = variation.overrides[0];
        assetOverride.when(
          assetValue: (assetId, value) {
            expect(assetId, isNot('asset-1')); // Changed
            expect(value, 150000); // Preserved
          },
          eventTiming: (_, __) => fail('Wrong override type'),
          expenseAmount: (_, __, ___) => fail('Wrong override type'),
          expenseTiming: (_, __, ___) => fail('Wrong override type'),
        );

        // Event override should have remapped event ID
        final eventOverride = variation.overrides[1];
        eventOverride.when(
          eventTiming: (eventId, yearsFromStart) {
            expect(eventId, isNot('event-1')); // Changed
            expect(yearsFromStart, 3); // Preserved
          },
          assetValue: (_, __) => fail('Wrong override type'),
          expenseAmount: (_, __, ___) => fail('Wrong override type'),
          expenseTiming: (_, __, ___) => fail('Wrong override type'),
        );
      });

      test('should create base scenario if missing', () {
        final project = createTestProject();
        final scenarios = [
          Scenario(
            id: 'scenario-1',
            name: 'Variation 1',
            isBase: false,
            overrides: [],
            createdAt: DateTime(2024, 1, 1),
            updatedAt: DateTime(2024, 1, 1),
          ),
        ];
        final json = exportService.exportProject(project, scenarios: scenarios);

        final importedData = importService.importProject(json, 'new-user-id');

        // Should have 2 scenarios: auto-created base + imported variation
        expect(importedData.scenarios.length, 2);

        final baseScenario = importedData.scenarios.firstWhere(
          (s) => s.isBase == true,
        );
        expect(baseScenario.name, 'Base Scenario');
        expect(baseScenario.overrides, isEmpty);
      });

      test('should preserve economic assumptions', () {
        final project = createTestProject();
        final json = exportService.exportProject(project);

        final importedData = importService.importProject(json, 'new-user-id');

        expect(importedData.project.inflationRate, 0.02);
        expect(importedData.project.reerReturnRate, 0.05);
        expect(importedData.project.celiReturnRate, 0.05);
        expect(importedData.project.criReturnRate, 0.05);
        expect(importedData.project.cashReturnRate, 0.015);
      });

      test('should throw on invalid JSON', () {
        expect(
          () => importService.importProject('not valid json', 'user-1'),
          throwsException,
        );
      });

      test('should throw on unknown asset reference', () {
        // Manually craft JSON with invalid asset reference
        final json = '''{
          "exportVersion": "1.2",
          "project": {
            "id": "p1",
            "name": "Test",
            "ownerId": "u1",
            "createdAt": "2024-01-01T00:00:00.000",
            "updatedAt": "2024-01-01T00:00:00.000",
            "individuals": [{
              "id": "ind1",
              "name": "John",
              "birthdate": "1965-01-01T00:00:00.000",
              "employmentIncome": 80000,
              "retirementAge": 65,
              "rrqStartAge": 65,
              "psvStartAge": 65,
              "initialCeliRoom": 95000
            }]
          },
          "assets": [],
          "events": [{
            "runtimeType": "realEstateTransaction",
            "id": "e1",
            "timing": {"runtimeType": "relative", "yearsFromStart": 5},
            "assetSoldId": "unknown-asset",
            "assetPurchasedId": null,
            "withdrawAccountId": "unknown-account",
            "depositAccountId": "unknown-account"
          }]
        }''';

        expect(
          () => importService.importProject(json, 'user-1'),
          throwsException,
        );
      });

      test('should throw on unknown individual reference', () {
        // Manually craft JSON with invalid individual reference
        final json = '''{
          "exportVersion": "1.2",
          "project": {
            "id": "p1",
            "name": "Test",
            "ownerId": "u1",
            "createdAt": "2024-01-01T00:00:00.000",
            "updatedAt": "2024-01-01T00:00:00.000",
            "individuals": []
          },
          "assets": [{
            "runtimeType": "rrsp",
            "id": "a1",
            "individualId": "unknown-individual",
            "value": 100000,
            "customReturnRate": null,
            "annualContribution": null
          }]
        }''';

        expect(
          () => importService.importProject(json, 'user-1'),
          throwsException,
        );
      });
    });

    group('Round-trip Import/Export', () {
      test('should preserve all data through export and import', () {
        final project = createTestProject();
        final assets = [
          Asset.rrsp(
            id: 'asset-1',
            individualId: 'ind-1',
            value: 100000,
            customReturnRate: 0.06,
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

        final json = exportService.exportProject(
          project,
          assets: assets,
          events: events,
          expenses: expenses,
          scenarios: scenarios,
        );

        final importedData = importService.importProject(json, 'new-user-id');

        // Verify project
        expect(importedData.project.name, project.name);
        expect(importedData.project.description, project.description);
        expect(
          importedData.project.individuals.length,
          project.individuals.length,
        );

        // Verify assets
        expect(importedData.assets.length, assets.length);

        // Verify events
        expect(importedData.events.length, events.length);

        // Verify expenses
        expect(importedData.expenses.length, expenses.length);

        // Verify scenarios
        expect(importedData.scenarios.length, scenarios.length);
      });

      test('should maintain data integrity for complex project', () {
        final project = Project(
          id: 'project-1',
          name: 'Complex Project',
          ownerId: 'user-1',
          description: 'A complex test project',
          createdAt: DateTime(2024, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
          individuals: [
            Individual(
              id: 'ind-1',
              name: 'John',
              birthdate: DateTime(1965, 1, 1),
              employmentIncome: 80000,

              rrqStartAge: 65,
              psvStartAge: 65,
              initialCeliRoom: 95000,
            ),
            Individual(
              id: 'ind-2',
              name: 'Jane',
              birthdate: DateTime(1967, 1, 1),
              employmentIncome: 70000,

              rrqStartAge: 65,
              psvStartAge: 65,
              initialCeliRoom: 88000,
            ),
          ],
          inflationRate: 0.025,
          reerReturnRate: 0.055,
          celiReturnRate: 0.06,
          criReturnRate: 0.05,
          cashReturnRate: 0.02,
        );

        final json = exportService.exportProject(project);
        final importedData = importService.importProject(json, 'new-user-id');

        // Verify all individuals preserved
        expect(importedData.project.individuals.length, 2);
        expect(importedData.project.individuals[0].name, 'John');
        expect(importedData.project.individuals[1].name, 'Jane');

        // Verify custom rates preserved
        expect(importedData.project.inflationRate, 0.025);
        expect(importedData.project.reerReturnRate, 0.055);
        expect(importedData.project.celiReturnRate, 0.06);
      });
    });
  });
}
