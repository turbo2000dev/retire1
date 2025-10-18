import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/expenses/data/expense_repository.dart';
import 'package:retire1/features/expenses/domain/expense.dart';

void main() {
  group('ExpenseRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ExpenseRepository repository;
    const testProjectId = 'test-project-123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = ExpenseRepository(
        projectId: testProjectId,
        firestore: fakeFirestore,
      );
    });

    group('Create Expense', () {
      test('should create housing expense', () async {
        final expense = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        );

        await repository.createExpense(expense);

        final retrieved = await repository.getExpense('expense-1');
        expect(retrieved, isNotNull);
        retrieved!.when(
          housing: (id, startTiming, endTiming, annualAmount) {
            expect(id, 'expense-1');
            expect(annualAmount, 24000);
            startTiming.map(
              relative: (t) => expect(t.yearsFromStart, 0),
              absolute: (_) => fail('Expected relative timing'),
              age: (_) => fail('Expected relative timing'),
              eventRelative: (_) => fail('Expected relative timing'),
              projectionEnd: (_) => fail('Expected relative timing'),
            );
            endTiming.map(
              relative: (_) => fail('Expected projection end timing'),
              absolute: (_) => fail('Expected projection end timing'),
              age: (_) => fail('Expected projection end timing'),
              eventRelative: (_) => fail('Expected projection end timing'),
              projectionEnd: (_) => expect(true, true),
            );
          },
          transport: (_, __, ___, ____) => fail('Expected housing'),
          dailyLiving: (_, __, ___, ____) => fail('Expected housing'),
          recreation: (_, __, ___, ____) => fail('Expected housing'),
          health: (_, __, ___, ____) => fail('Expected housing'),
          family: (_, __, ___, ____) => fail('Expected housing'),
        );
      });

      test('should create transport expense', () async {
        final expense = Expense.transport(
          id: 'expense-2',
          startTiming: EventTiming.absolute(calendarYear: 2025),
          endTiming: EventTiming.absolute(calendarYear: 2040),
          annualAmount: 12000,
        );

        await repository.createExpense(expense);

        final retrieved = await repository.getExpense('expense-2');
        expect(retrieved, isNotNull);
        retrieved!.when(
          housing: (_, __, ___, ____) => fail('Expected transport'),
          transport: (id, startTiming, endTiming, annualAmount) {
            expect(id, 'expense-2');
            expect(annualAmount, 12000);
            startTiming.map(
              relative: (_) => fail('Expected absolute timing'),
              absolute: (t) => expect(t.calendarYear, 2025),
              age: (_) => fail('Expected absolute timing'),
              eventRelative: (_) => fail('Expected absolute timing'),
              projectionEnd: (_) => fail('Expected absolute timing'),
            );
            endTiming.map(
              relative: (_) => fail('Expected absolute timing'),
              absolute: (t) => expect(t.calendarYear, 2040),
              age: (_) => fail('Expected absolute timing'),
              eventRelative: (_) => fail('Expected absolute timing'),
              projectionEnd: (_) => fail('Expected absolute timing'),
            );
          },
          dailyLiving: (_, __, ___, ____) => fail('Expected transport'),
          recreation: (_, __, ___, ____) => fail('Expected transport'),
          health: (_, __, ___, ____) => fail('Expected transport'),
          family: (_, __, ___, ____) => fail('Expected transport'),
        );
      });

      test('should create daily living expense', () async {
        final expense = Expense.dailyLiving(
          id: 'expense-3',
          startTiming: EventTiming.age(individualId: 'ind-1', age: 25),
          endTiming: EventTiming.age(individualId: 'ind-1', age: 65),
          annualAmount: 30000,
        );

        await repository.createExpense(expense);

        final retrieved = await repository.getExpense('expense-3');
        expect(retrieved, isNotNull);
        expect(retrieved!.categoryName, 'Daily Living');
      });

      test('should create recreation expense', () async {
        final expense = Expense.recreation(
          id: 'expense-4',
          startTiming: EventTiming.eventRelative(
            eventId: 'event-retirement',
            boundary: EventBoundary.start,
          ),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 15000,
        );

        await repository.createExpense(expense);

        final retrieved = await repository.getExpense('expense-4');
        expect(retrieved, isNotNull);
        expect(retrieved!.categoryName, 'Recreation');
      });

      test('should create health expense', () async {
        final expense = Expense.health(
          id: 'expense-5',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 8000,
        );

        await repository.createExpense(expense);

        final retrieved = await repository.getExpense('expense-5');
        expect(retrieved, isNotNull);
        expect(retrieved!.categoryName, 'Health');
      });

      test('should create family expense', () async {
        final expense = Expense.family(
          id: 'expense-6',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.relative(yearsFromStart: 18),
          annualAmount: 10000,
        );

        await repository.createExpense(expense);

        final retrieved = await repository.getExpense('expense-6');
        expect(retrieved, isNotNull);
        expect(retrieved!.categoryName, 'Family');
      });
    });

    group('Read Expense', () {
      test('should get expense by ID', () async {
        final expense = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        );

        await repository.createExpense(expense);
        final retrieved = await repository.getExpense('expense-1');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'expense-1');
      });

      test('should return null for non-existent expense', () async {
        final result = await repository.getExpense('non-existent-id');
        expect(result, isNull);
      });

      test('should get all expenses for project', () async {
        await repository.createExpense(Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        ));
        await repository.createExpense(Expense.transport(
          id: 'expense-2',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 12000,
        ));
        await repository.createExpense(Expense.health(
          id: 'expense-3',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 8000,
        ));

        final expenses = await repository.getExpensesStream().first;

        expect(expenses.length, 3);
        final ids = expenses.map((e) => e.id).toList();
        expect(ids, containsAll(['expense-1', 'expense-2', 'expense-3']));
      });

      test('should stream expense updates', () async {
        final stream = repository.getExpensesStream();

        // Create initial expense
        await repository.createExpense(Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        ));

        // Get first emission
        final firstEmission = await stream.first;
        expect(firstEmission.length, 1);
      });
    });

    group('Update Expense', () {
      test('should update expense amount', () async {
        final original = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        );

        await repository.createExpense(original);

        final updated = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 30000,
        );

        await repository.updateExpense(updated);

        final retrieved = await repository.getExpense('expense-1');
        retrieved!.when(
          housing: (id, startTiming, endTiming, annualAmount) {
            expect(annualAmount, 30000);
          },
          transport: (_, __, ___, ____) => fail('Expected housing'),
          dailyLiving: (_, __, ___, ____) => fail('Expected housing'),
          recreation: (_, __, ___, ____) => fail('Expected housing'),
          health: (_, __, ___, ____) => fail('Expected housing'),
          family: (_, __, ___, ____) => fail('Expected housing'),
        );
      });

      test('should update expense timing', () async {
        final original = Expense.transport(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.relative(yearsFromStart: 20),
          annualAmount: 12000,
        );

        await repository.createExpense(original);

        final updated = Expense.transport(
          id: 'expense-1',
          startTiming: EventTiming.absolute(calendarYear: 2025),
          endTiming: EventTiming.absolute(calendarYear: 2040),
          annualAmount: 12000,
        );

        await repository.updateExpense(updated);

        final retrieved = await repository.getExpense('expense-1');
        retrieved!.when(
          housing: (_, __, ___, ____) => fail('Expected transport'),
          transport: (id, startTiming, endTiming, annualAmount) {
            startTiming.map(
              relative: (_) => fail('Expected absolute timing'),
              absolute: (t) => expect(t.calendarYear, 2025),
              age: (_) => fail('Expected absolute timing'),
              eventRelative: (_) => fail('Expected absolute timing'),
              projectionEnd: (_) => fail('Expected absolute timing'),
            );
            endTiming.map(
              relative: (_) => fail('Expected absolute timing'),
              absolute: (t) => expect(t.calendarYear, 2040),
              age: (_) => fail('Expected absolute timing'),
              eventRelative: (_) => fail('Expected absolute timing'),
              projectionEnd: (_) => fail('Expected absolute timing'),
            );
          },
          dailyLiving: (_, __, ___, ____) => fail('Expected transport'),
          recreation: (_, __, ___, ____) => fail('Expected transport'),
          health: (_, __, ___, ____) => fail('Expected transport'),
          family: (_, __, ___, ____) => fail('Expected transport'),
        );
      });

      test('should update expense category', () async {
        final original = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        );

        await repository.createExpense(original);

        final updated = Expense.transport(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 12000,
        );

        await repository.updateExpense(updated);

        final retrieved = await repository.getExpense('expense-1');
        expect(retrieved!.categoryName, 'Transport');
      });
    });

    group('Delete Expense', () {
      test('should delete expense from Firestore', () async {
        final expense = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        );

        await repository.createExpense(expense);
        await repository.deleteExpense('expense-1');

        final retrieved = await repository.getExpense('expense-1');
        expect(retrieved, isNull);
      });

      test('should remove expense from stream', () async {
        await repository.createExpense(Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 24000,
        ));
        await repository.createExpense(Expense.transport(
          id: 'expense-2',
          startTiming: EventTiming.relative(yearsFromStart: 0),
          endTiming: EventTiming.projectionEnd(),
          annualAmount: 12000,
        ));

        await repository.deleteExpense('expense-1');

        final expenses = await repository.getExpensesStream().first;
        expect(expenses.length, 1);
        expect(expenses[0].id, 'expense-2');
      });
    });

    group('Nested Union Serialization', () {
      test('should preserve both startTiming and endTiming through serialization', () async {
        final expense = Expense.housing(
          id: 'expense-1',
          startTiming: EventTiming.age(individualId: 'ind-1', age: 25),
          endTiming: EventTiming.age(individualId: 'ind-1', age: 65),
          annualAmount: 24000,
        );

        await repository.createExpense(expense);
        final retrieved = await repository.getExpense('expense-1');

        expect(retrieved, isNotNull);
        retrieved!.when(
          housing: (id, startTiming, endTiming, annualAmount) {
            startTiming.map(
              relative: (_) => fail('Expected age timing'),
              absolute: (_) => fail('Expected age timing'),
              age: (t) {
                expect(t.individualId, 'ind-1');
                expect(t.age, 25);
              },
              eventRelative: (_) => fail('Expected age timing'),
              projectionEnd: (_) => fail('Expected age timing'),
            );
            endTiming.map(
              relative: (_) => fail('Expected age timing'),
              absolute: (_) => fail('Expected age timing'),
              age: (t) {
                expect(t.individualId, 'ind-1');
                expect(t.age, 65);
              },
              eventRelative: (_) => fail('Expected age timing'),
              projectionEnd: (_) => fail('Expected age timing'),
            );
          },
          transport: (_, __, ___, ____) => fail('Expected housing'),
          dailyLiving: (_, __, ___, ____) => fail('Expected housing'),
          recreation: (_, __, ___, ____) => fail('Expected housing'),
          health: (_, __, ___, ____) => fail('Expected housing'),
          family: (_, __, ___, ____) => fail('Expected housing'),
        );
      });

      test('should handle all 5 timing types for start and end', () async {
        final timingTypes = [
          EventTiming.relative(yearsFromStart: 0),
          EventTiming.absolute(calendarYear: 2025),
          EventTiming.age(individualId: 'ind-1', age: 65),
          EventTiming.eventRelative(
            eventId: 'event-retirement',
            boundary: EventBoundary.start,
          ),
          EventTiming.projectionEnd(),
        ];

        for (int i = 0; i < timingTypes.length; i++) {
          final expense = Expense.housing(
            id: 'expense-start-$i',
            startTiming: timingTypes[i],
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 24000,
          );

          await repository.createExpense(expense);
          final retrieved = await repository.getExpense('expense-start-$i');

          expect(retrieved, isNotNull);
          expect(
            retrieved!.when(
              housing: (_, startTiming, __, ___) => startTiming.toJson(),
              transport: (_, startTiming, __, ___) => startTiming.toJson(),
              dailyLiving: (_, startTiming, __, ___) => startTiming.toJson(),
              recreation: (_, startTiming, __, ___) => startTiming.toJson(),
              health: (_, startTiming, __, ___) => startTiming.toJson(),
              family: (_, startTiming, __, ___) => startTiming.toJson(),
            ),
            equals(timingTypes[i].toJson()),
          );
        }

        for (int i = 0; i < timingTypes.length; i++) {
          final expense = Expense.transport(
            id: 'expense-end-$i',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: timingTypes[i],
            annualAmount: 12000,
          );

          await repository.createExpense(expense);
          final retrieved = await repository.getExpense('expense-end-$i');

          expect(retrieved, isNotNull);
          expect(
            retrieved!.when(
              housing: (_, __, endTiming, ___) => endTiming.toJson(),
              transport: (_, __, endTiming, ___) => endTiming.toJson(),
              dailyLiving: (_, __, endTiming, ___) => endTiming.toJson(),
              recreation: (_, __, endTiming, ___) => endTiming.toJson(),
              health: (_, __, endTiming, ___) => endTiming.toJson(),
              family: (_, __, endTiming, ___) => endTiming.toJson(),
            ),
            equals(timingTypes[i].toJson()),
          );
        }
      });
    });

    group('Data Integrity', () {
      test('should maintain all fields through round-trip for each category', () async {
        final expenses = [
          Expense.housing(
            id: 'expense-housing',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 24000,
          ),
          Expense.transport(
            id: 'expense-transport',
            startTiming: EventTiming.absolute(calendarYear: 2025),
            endTiming: EventTiming.absolute(calendarYear: 2040),
            annualAmount: 12000,
          ),
          Expense.dailyLiving(
            id: 'expense-daily',
            startTiming: EventTiming.age(individualId: 'ind-1', age: 25),
            endTiming: EventTiming.age(individualId: 'ind-1', age: 65),
            annualAmount: 30000,
          ),
          Expense.recreation(
            id: 'expense-recreation',
            startTiming: EventTiming.eventRelative(
              eventId: 'event-retirement',
              boundary: EventBoundary.start,
            ),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 15000,
          ),
          Expense.health(
            id: 'expense-health',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 8000,
          ),
          Expense.family(
            id: 'expense-family',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.relative(yearsFromStart: 18),
            annualAmount: 10000,
          ),
        ];

        for (final expense in expenses) {
          await repository.createExpense(expense);
          final retrieved = await repository.getExpense(expense.id);

          expect(retrieved, isNotNull);
          expect(retrieved!.toJson(), equals(expense.toJson()));
        }
      });
    });

    group('Category Name Extension', () {
      test('should return correct category names', () async {
        final expenses = [
          Expense.housing(
            id: 'expense-1',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 24000,
          ),
          Expense.transport(
            id: 'expense-2',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 12000,
          ),
          Expense.dailyLiving(
            id: 'expense-3',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 30000,
          ),
          Expense.recreation(
            id: 'expense-4',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 15000,
          ),
          Expense.health(
            id: 'expense-5',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 8000,
          ),
          Expense.family(
            id: 'expense-6',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: EventTiming.projectionEnd(),
            annualAmount: 10000,
          ),
        ];

        final expectedNames = [
          'Housing',
          'Transport',
          'Daily Living',
          'Recreation',
          'Health',
          'Family',
        ];

        for (int i = 0; i < expenses.length; i++) {
          await repository.createExpense(expenses[i]);
          final retrieved = await repository.getExpense(expenses[i].id);
          expect(retrieved!.categoryName, expectedNames[i]);
        }
      });
    });

    group('Error Handling', () {
      test('should handle empty project collection', () async {
        final expenses = await repository.getExpensesStream().first;
        expect(expenses, isEmpty);
      });
    });
  });
}
