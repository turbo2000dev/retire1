import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/expenses_section_screen.dart';

/// Mock notifier for WizardProgressProvider
class MockWizardProgressNotifier extends WizardProgressNotifier {
  final WizardProgress? mockProgress;
  final List<MapEntry<String, WizardSectionStatus>> statusUpdates = [];

  MockWizardProgressNotifier(this.mockProgress);

  @override
  Future<WizardProgress?> build() async {
    return mockProgress;
  }

  @override
  Future<void> updateSectionStatus(
    String sectionId,
    WizardSectionStatus status,
  ) async {
    statusUpdates.add(MapEntry(sectionId, status));
  }
}

/// Mock notifier for ExpensesProvider
class MockExpensesNotifier extends ExpensesNotifier {
  final List<Expense> mockExpenses;
  final List<Expense> addedExpenses = [];
  final List<Expense> updatedExpenses = [];

  MockExpensesNotifier(this.mockExpenses);

  @override
  Future<List<Expense>> build() async {
    return mockExpenses;
  }

  @override
  Future<void> addExpense(Expense expense) async {
    addedExpenses.add(expense);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    updatedExpenses.add(expense);
  }
}

void main() {
  group('ExpensesSectionScreen', () {
    late WizardProgress testProgress;
    late MockWizardProgressNotifier mockWizardNotifier;
    late MockExpensesNotifier mockExpensesNotifier;

    setUp(() {
      testProgress = WizardProgress.create(
        projectId: 'test-project',
        userId: 'test-user',
      );
      mockWizardNotifier = MockWizardProgressNotifier(testProgress);
      mockExpensesNotifier = MockExpensesNotifier([]);
    });

    Widget buildExpensesScreen({
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      return ProviderScope(
        overrides: [
          wizardProgressProvider.overrideWith(() => mockWizardNotifier),
          expensesProvider.overrideWith(() => mockExpensesNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ExpensesSectionScreen(onRegisterCallback: onRegisterCallback),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with expense category fields', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        // Should have 6 expense categories
        expect(find.text('Housing'), findsOneWidget);
        expect(find.text('Transport'), findsOneWidget);
        expect(find.text('Daily Living'), findsOneWidget);
        expect(find.text('Recreation'), findsOneWidget);
        expect(find.text('Health'), findsOneWidget);
        expect(find.text('Family'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildExpensesScreen(
            onRegisterCallback: (callback) {
              registeredCallback = callback;
            },
          ),
        );
        await tester.pump();
        await tester.pumpAndSettle();

        expect(registeredCallback, isNotNull);
      });

      testWidgets('marks section as in progress after loading', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockWizardNotifier.statusUpdates.length, 1);
        expect(mockWizardNotifier.statusUpdates.first.key, 'expenses');
        expect(
          mockWizardNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });

      testWidgets('initializes with default values', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pumpAndSettle();

        // Check that default values are displayed
        expect(find.text('24000'), findsOneWidget); // Housing
        expect(find.text('8000'), findsOneWidget); // Transport
        expect(find.text('12000'), findsOneWidget); // Daily Living
        expect(find.text('6000'), findsOneWidget); // Recreation
        expect(find.text('4000'), findsOneWidget); // Health
        expect(find.text('3000'), findsOneWidget); // Family
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('displays expense category cards', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pumpAndSettle();

        // Should have 6 cards (one per category)
        expect(find.byType(Card), findsNWidgets(6));
      });

      testWidgets('displays category icons', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.home), findsOneWidget);
        expect(find.byIcon(Icons.directions_car), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
        expect(find.byIcon(Icons.theater_comedy), findsOneWidget);
        expect(find.byIcon(Icons.health_and_safety), findsOneWidget);
        expect(find.byIcon(Icons.family_restroom), findsOneWidget);
      });

      testWidgets('shows info text', (tester) async {
        await tester.pumpWidget(buildExpensesScreen());
        await tester.pumpAndSettle();

        expect(find.textContaining('Leave categories at zero'), findsOneWidget);
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildExpensesScreen(onRegisterCallback: null));
        await tester.pumpAndSettle();

        expect(find.byType(ExpensesSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildExpensesScreen(
            onRegisterCallback: (callback) {
              callbackCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(callbackCalled, isTrue);
      });
    });

    group('Validation', () {
      testWidgets('validation callback returns true with default values', (
        tester,
      ) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildExpensesScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });

      testWidgets('marks section as complete after validation', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildExpensesScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockWizardNotifier.statusUpdates.clear();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(mockWizardNotifier.statusUpdates.length, 1);
        expect(mockWizardNotifier.statusUpdates.last.key, 'expenses');
        expect(
          mockWizardNotifier.statusUpdates.last.value.state,
          WizardSectionState.complete,
        );
      });
    });
  });
}
