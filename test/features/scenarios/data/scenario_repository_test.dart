import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/scenarios/data/scenario_repository.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

void main() {
  group('ScenarioRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ScenarioRepository repository;
    const testProjectId = 'test-project-123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = ScenarioRepository(
        projectId: testProjectId,
        firestore: fakeFirestore,
      );
    });

    group('Create Scenario', () {
      test('should create base scenario', () async {
        final scenario = Scenario(
          id: 'base',
          name: 'Base Scenario',
          isBase: true,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);

        final retrieved = await repository.getScenario('base');
        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'base');
        expect(retrieved.name, 'Base Scenario');
        expect(retrieved.isBase, true);
        expect(retrieved.overrides, isEmpty);
      });

      test('should create scenario with asset value overrides', () async {
        final scenario = Scenario(
          id: 'scenario-1',
          name: 'Optimistic Scenario',
          isBase: false,
          overrides: [
            ParameterOverride.assetValue(
              assetId: 'asset-1',
              value: 200000,
            ),
            ParameterOverride.assetValue(
              assetId: 'asset-2',
              value: 150000,
            ),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);

        final retrieved = await repository.getScenario('scenario-1');
        expect(retrieved, isNotNull);
        expect(retrieved!.overrides.length, 2);

        retrieved.overrides[0].map(
          assetValue: (o) {
            expect(o.assetId, 'asset-1');
            expect(o.value, 200000);
          },
          eventTiming: (_) => fail('Expected assetValue'),
          expenseAmount: (_) => fail('Expected assetValue'),
          expenseTiming: (_) => fail('Expected assetValue'),
        );
      });

      test('should create scenario with event timing overrides', () async {
        final scenario = Scenario(
          id: 'scenario-2',
          name: 'Early Retirement',
          isBase: false,
          overrides: [
            ParameterOverride.eventTiming(
              eventId: 'event-retirement',
              yearsFromStart: 3,
            ),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);

        final retrieved = await repository.getScenario('scenario-2');
        expect(retrieved!.overrides.length, 1);

        retrieved.overrides[0].map(
          assetValue: (_) => fail('Expected eventTiming'),
          eventTiming: (o) {
            expect(o.eventId, 'event-retirement');
            expect(o.yearsFromStart, 3);
          },
          expenseAmount: (_) => fail('Expected eventTiming'),
          expenseTiming: (_) => fail('Expected eventTiming'),
        );
      });

      test('should create scenario with expense amount overrides', () async {
        final scenario = Scenario(
          id: 'scenario-3',
          name: 'Reduced Expenses',
          isBase: false,
          overrides: [
            ParameterOverride.expenseAmount(
              expenseId: 'expense-1',
              overrideAmount: 20000,
            ),
            ParameterOverride.expenseAmount(
              expenseId: 'expense-2',
              amountMultiplier: 0.8, // 80% of original
            ),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);

        final retrieved = await repository.getScenario('scenario-3');
        expect(retrieved!.overrides.length, 2);

        retrieved.overrides[0].map(
          assetValue: (_) => fail('Expected expenseAmount'),
          eventTiming: (_) => fail('Expected expenseAmount'),
          expenseAmount: (o) {
            expect(o.expenseId, 'expense-1');
            expect(o.overrideAmount, 20000);
            expect(o.amountMultiplier, isNull);
          },
          expenseTiming: (_) => fail('Expected expenseAmount'),
        );

        retrieved.overrides[1].map(
          assetValue: (_) => fail('Expected expenseAmount'),
          eventTiming: (_) => fail('Expected expenseAmount'),
          expenseAmount: (o) {
            expect(o.expenseId, 'expense-2');
            expect(o.overrideAmount, isNull);
            expect(o.amountMultiplier, 0.8);
          },
          expenseTiming: (_) => fail('Expected expenseAmount'),
        );
      });

      test('should create scenario with expense timing overrides', () async {
        final scenario = Scenario(
          id: 'scenario-4',
          name: 'Adjusted Timing',
          isBase: false,
          overrides: [
            ParameterOverride.expenseTiming(
              expenseId: 'expense-1',
              overrideStartTiming: EventTiming.relative(yearsFromStart: 2),
              overrideEndTiming: EventTiming.relative(yearsFromStart: 10),
            ),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);

        final retrieved = await repository.getScenario('scenario-4');
        expect(retrieved!.overrides.length, 1);

        retrieved.overrides[0].map(
          assetValue: (_) => fail('Expected expenseTiming'),
          eventTiming: (_) => fail('Expected expenseTiming'),
          expenseAmount: (_) => fail('Expected expenseTiming'),
          expenseTiming: (o) {
            expect(o.expenseId, 'expense-1');
            expect(o.overrideStartTiming, isNotNull);
            expect(o.overrideEndTiming, isNotNull);
          },
        );
      });

      test('should create scenario with mixed override types', () async {
        final scenario = Scenario(
          id: 'scenario-5',
          name: 'Complex Scenario',
          isBase: false,
          overrides: [
            ParameterOverride.assetValue(assetId: 'asset-1', value: 250000),
            ParameterOverride.eventTiming(eventId: 'event-1', yearsFromStart: 5),
            ParameterOverride.expenseAmount(
              expenseId: 'expense-1',
              amountMultiplier: 1.2,
            ),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);

        final retrieved = await repository.getScenario('scenario-5');
        expect(retrieved!.overrides.length, 3);
      });
    });

    group('Read Scenario', () {
      test('should get scenario by ID', () async {
        final scenario = Scenario(
          id: 'scenario-1',
          name: 'Test Scenario',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);
        final retrieved = await repository.getScenario('scenario-1');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'scenario-1');
        expect(retrieved.name, 'Test Scenario');
      });

      test('should return null for non-existent scenario', () async {
        final result = await repository.getScenario('non-existent-id');
        expect(result, isNull);
      });

      test('should get all scenarios for project', () async {
        await repository.createScenario(Scenario(
          id: 'base',
          name: 'Base',
          isBase: true,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ));
        await repository.createScenario(Scenario(
          id: 'scenario-1',
          name: 'Variation 1',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 2),
          updatedAt: DateTime(2025, 1, 2),
        ));
        await repository.createScenario(Scenario(
          id: 'scenario-2',
          name: 'Variation 2',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 3),
          updatedAt: DateTime(2025, 1, 3),
        ));

        final scenarios = await repository.getScenariosStream().first;

        expect(scenarios.length, 3);
        final ids = scenarios.map((s) => s.id).toList();
        expect(ids, containsAll(['base', 'scenario-1', 'scenario-2']));
      });

      test('should stream scenario updates', () async {
        final stream = repository.getScenariosStream();

        // Create initial scenario
        await repository.createScenario(Scenario(
          id: 'base',
          name: 'Base',
          isBase: true,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ));

        // Get first emission
        final firstEmission = await stream.first;
        expect(firstEmission.length, 1);
      });
    });

    group('Update Scenario', () {
      test('should update scenario name', () async {
        final original = Scenario(
          id: 'scenario-1',
          name: 'Original Name',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(original);

        final updated = original.copyWith(
          name: 'Updated Name',
          updatedAt: DateTime(2025, 1, 2),
        );

        await repository.updateScenario(updated);

        final retrieved = await repository.getScenario('scenario-1');
        expect(retrieved!.name, 'Updated Name');
        expect(retrieved.updatedAt, DateTime(2025, 1, 2));
      });

      test('should update scenario overrides', () async {
        final original = Scenario(
          id: 'scenario-1',
          name: 'Test',
          isBase: false,
          overrides: [
            ParameterOverride.assetValue(assetId: 'asset-1', value: 100000),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(original);

        final updated = original.copyWith(
          overrides: [
            ParameterOverride.assetValue(assetId: 'asset-1', value: 150000),
            ParameterOverride.assetValue(assetId: 'asset-2', value: 200000),
          ],
          updatedAt: DateTime(2025, 1, 2),
        );

        await repository.updateScenario(updated);

        final retrieved = await repository.getScenario('scenario-1');
        expect(retrieved!.overrides.length, 2);
      });

      test('should clear overrides when set to empty', () async {
        final original = Scenario(
          id: 'scenario-1',
          name: 'Test',
          isBase: false,
          overrides: [
            ParameterOverride.assetValue(assetId: 'asset-1', value: 100000),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(original);

        final updated = original.copyWith(
          overrides: [],
          updatedAt: DateTime(2025, 1, 2),
        );

        await repository.updateScenario(updated);

        final retrieved = await repository.getScenario('scenario-1');
        expect(retrieved!.overrides, isEmpty);
      });
    });

    group('Delete Scenario', () {
      test('should delete scenario from Firestore', () async {
        final scenario = Scenario(
          id: 'scenario-1',
          name: 'To Delete',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);
        await repository.deleteScenario('scenario-1');

        final retrieved = await repository.getScenario('scenario-1');
        expect(retrieved, isNull);
      });

      test('should remove scenario from stream', () async {
        await repository.createScenario(Scenario(
          id: 'scenario-1',
          name: 'Scenario 1',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ));
        await repository.createScenario(Scenario(
          id: 'scenario-2',
          name: 'Scenario 2',
          isBase: false,
          overrides: [],
          createdAt: DateTime(2025, 1, 2),
          updatedAt: DateTime(2025, 1, 2),
        ));

        await repository.deleteScenario('scenario-1');

        final scenarios = await repository.getScenariosStream().first;
        expect(scenarios.length, 1);
        expect(scenarios[0].id, 'scenario-2');
      });
    });

    group('Ensure Base Scenario', () {
      test('should create base scenario if none exists', () async {
        await repository.ensureBaseScenario();

        final scenarios = await repository.getScenariosStream().first;
        expect(scenarios.length, 1);
        expect(scenarios[0].id, 'base');
        expect(scenarios[0].name, 'Base Scenario');
        expect(scenarios[0].isBase, true);
        expect(scenarios[0].overrides, isEmpty);
      });

      test('should not create base scenario if one already exists', () async {
        // Create a custom base scenario
        await repository.createScenario(Scenario(
          id: 'custom-base',
          name: 'Custom Base',
          isBase: true,
          overrides: [],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        ));

        await repository.ensureBaseScenario();

        final scenarios = await repository.getScenariosStream().first;
        expect(scenarios.length, 1);
        expect(scenarios[0].id, 'custom-base');
        expect(scenarios[0].name, 'Custom Base');
      });
    });

    group('Override Serialization', () {
      test('should preserve all override types through serialization', () async {
        final scenario = Scenario(
          id: 'scenario-1',
          name: 'All Override Types',
          isBase: false,
          overrides: [
            ParameterOverride.assetValue(assetId: 'asset-1', value: 100000),
            ParameterOverride.eventTiming(eventId: 'event-1', yearsFromStart: 5),
            ParameterOverride.expenseAmount(
              expenseId: 'expense-1',
              overrideAmount: 25000,
            ),
            ParameterOverride.expenseTiming(
              expenseId: 'expense-2',
              overrideStartTiming: EventTiming.relative(yearsFromStart: 0),
              overrideEndTiming: EventTiming.projectionEnd(),
            ),
          ],
          createdAt: DateTime(2025, 1, 1),
          updatedAt: DateTime(2025, 1, 1),
        );

        await repository.createScenario(scenario);
        final retrieved = await repository.getScenario('scenario-1');

        expect(retrieved, isNotNull);
        expect(retrieved!.overrides.length, 4);
        expect(retrieved.toJson(), equals(scenario.toJson()));
      });
    });

    group('Data Integrity', () {
      test('should maintain all fields through round-trip', () async {
        final original = Scenario(
          id: 'scenario-test',
          name: 'Complete Scenario',
          isBase: false,
          overrides: [
            ParameterOverride.assetValue(assetId: 'asset-1', value: 200000),
            ParameterOverride.eventTiming(eventId: 'event-1', yearsFromStart: 3),
          ],
          createdAt: DateTime(2025, 1, 1, 10, 30),
          updatedAt: DateTime(2025, 1, 2, 15, 45),
        );

        await repository.createScenario(original);
        final retrieved = await repository.getScenario('scenario-test');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, original.id);
        expect(retrieved.name, original.name);
        expect(retrieved.isBase, original.isBase);
        expect(retrieved.overrides.length, original.overrides.length);
        expect(retrieved.createdAt.year, original.createdAt.year);
        expect(retrieved.updatedAt.year, original.updatedAt.year);
      });
    });

    group('Error Handling', () {
      test('should handle empty project collection', () async {
        final scenarios = await repository.getScenariosStream().first;
        expect(scenarios, isEmpty);
      });
    });
  });
}
