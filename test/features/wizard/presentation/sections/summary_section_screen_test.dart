import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/assets/data/asset_repository.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/events/data/event_repository.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/expenses/data/expense_repository.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/summary_section_screen.dart';

/// Fake Firestore for testing
class FakeFirestore extends Fake implements FirebaseFirestore {}

/// Fake project repository for testing
class FakeProjectRepository extends ProjectRepository {
  FakeProjectRepository()
    : super(userId: 'test-user', firestore: FakeFirestore());
}

/// Fake asset repository for testing
class FakeAssetRepository extends AssetRepository {
  FakeAssetRepository()
    : super(projectId: 'test-project', firestore: FakeFirestore());
}

/// Fake event repository for testing
class FakeEventRepository extends EventRepository {
  FakeEventRepository()
    : super(projectId: 'test-project', firestore: FakeFirestore());
}

/// Fake expense repository for testing
class FakeExpenseRepository extends ExpenseRepository {
  FakeExpenseRepository()
    : super(projectId: 'test-project', firestore: FakeFirestore());
}

/// Mock notifier for CurrentProjectProvider
class MockCurrentProjectNotifier extends CurrentProjectNotifier {
  final CurrentProjectState mockState;

  MockCurrentProjectNotifier(
    this.mockState,
    Ref ref,
    FakeProjectRepository repo,
  ) : super(ref, null, repo) {
    state = mockState;
  }
}

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

/// Mock notifier for AssetsProvider
class MockAssetsNotifier extends AssetsNotifier {
  final List<Asset> mockAssets;

  MockAssetsNotifier(this.mockAssets);

  @override
  Future<List<Asset>> build() async {
    return mockAssets;
  }
}

/// Mock notifier for EventsProvider
class MockEventsNotifier extends EventsNotifier {
  final List<Event> mockEvents;

  MockEventsNotifier(this.mockEvents);

  @override
  Future<List<Event>> build() async {
    return mockEvents;
  }
}

/// Mock notifier for ExpensesProvider
class MockExpensesNotifier extends ExpensesNotifier {
  final List<Expense> mockExpenses;

  MockExpensesNotifier(this.mockExpenses);

  @override
  Future<List<Expense>> build() async {
    return mockExpenses;
  }
}

void main() {
  group('SummarySectionScreen', () {
    late Project testProject;
    late WizardProgress testProgress;
    late FakeProjectRepository fakeProjectRepository;
    late FakeAssetRepository fakeAssetRepository;
    late FakeEventRepository fakeEventRepository;
    late FakeExpenseRepository fakeExpenseRepository;
    late MockWizardProgressNotifier mockWizardNotifier;

    setUp(() {
      final now = DateTime.now();
      testProject = Project(
        id: 'test-project-id',
        name: 'Test Project',
        ownerId: 'test-user',
        createdAt: now,
        updatedAt: now,
        individuals: [
          Individual(
            id: 'individual-1',
            name: 'John Doe',
            birthdate: DateTime(1980, 5, 15),
            rrqStartAge: 65,
            psvStartAge: 65,
            projectedRrqAt60: 12000,
            projectedRrqAt65: 16000,
          ),
          Individual(
            id: 'individual-2',
            name: 'Jane Doe',
            birthdate: DateTime(1982, 8, 20),
            rrqStartAge: 65,
            psvStartAge: 65,
            projectedRrqAt60: 12000,
            projectedRrqAt65: 16000,
          ),
        ],
      );

      testProgress = WizardProgress.create(
        projectId: testProject.id,
        userId: 'test-user',
      );

      fakeProjectRepository = FakeProjectRepository();
      fakeAssetRepository = FakeAssetRepository();
      fakeEventRepository = FakeEventRepository();
      fakeExpenseRepository = FakeExpenseRepository();
      mockWizardNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildSummaryScreen({
      Project? projectOverride,
      List<Asset>? assetsOverride,
      List<Event>? eventsOverride,
      List<Expense>? expensesOverride,
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      final project = projectOverride ?? testProject;
      final assets = assetsOverride ?? [];
      final events = eventsOverride ?? [];
      final expenses = expensesOverride ?? [];

      final assetsNotifier = MockAssetsNotifier(assets);
      final eventsNotifier = MockEventsNotifier(events);
      final expensesNotifier = MockExpensesNotifier(expenses);

      return ProviderScope(
        overrides: [
          currentProjectProvider.overrideWith(
            (ref) => MockCurrentProjectNotifier(
              ProjectSelected(project),
              ref,
              fakeProjectRepository,
            ),
          ),
          projectRepositoryProvider.overrideWithValue(fakeProjectRepository),
          assetRepositoryProvider.overrideWithValue(fakeAssetRepository),
          eventRepositoryProvider.overrideWithValue(fakeEventRepository),
          expenseRepositoryProvider.overrideWithValue(fakeExpenseRepository),
          assetsProvider.overrideWith(() => assetsNotifier),
          eventsProvider.overrideWith(() => eventsNotifier),
          expensesProvider.overrideWith(() => expensesNotifier),
          wizardProgressProvider.overrideWith(() => mockWizardNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SummarySectionScreen(onRegisterCallback: onRegisterCallback),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with project summary', (tester) async {
        await tester.pumpWidget(buildSummaryScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('Summary & Review'), findsOneWidget);
        expect(find.text('Test Project'), findsOneWidget);
        expect(find.text('John Doe, Jane Doe'), findsOneWidget);
      });

      testWidgets('registers completion callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildSummaryScreen(
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
        await tester.pumpWidget(buildSummaryScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockWizardNotifier.statusUpdates.length, 1);
        expect(mockWizardNotifier.statusUpdates.first.key, 'summary');
        expect(
          mockWizardNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });
    });

    group('Asset Summary', () {
      testWidgets('displays total asset count and value', (tester) async {
        final assets = [
          const Asset.rrsp(
            id: 'rrsp-1',
            individualId: 'individual-1',
            value: 100000,
          ),
          const Asset.celi(
            id: 'celi-1',
            individualId: 'individual-2',
            value: 50000,
          ),
        ];

        await tester.pumpWidget(buildSummaryScreen(assetsOverride: assets));
        await tester.pumpAndSettle();

        expect(find.text('2 accounts'), findsOneWidget);
        expect(find.text('\$150,000'), findsOneWidget);
      });

      testWidgets('handles empty asset list', (tester) async {
        await tester.pumpWidget(buildSummaryScreen(assetsOverride: []));
        await tester.pumpAndSettle();

        expect(find.text('0 accounts'), findsOneWidget);
        // Note: $0 appears in both assets and expenses, so we find at least one
        expect(find.text('\$0'), findsAtLeastNWidgets(1));
      });
    });

    group('Expense Summary', () {
      testWidgets('displays expense count and total', (tester) async {
        final expenses = [
          Expense.housing(
            id: 'expense-1',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 24000,
          ),
          Expense.transport(
            id: 'expense-2',
            startTiming: EventTiming.relative(yearsFromStart: 0),
            endTiming: const EventTiming.projectionEnd(),
            annualAmount: 12000,
          ),
        ];

        await tester.pumpWidget(buildSummaryScreen(expensesOverride: expenses));
        await tester.pumpAndSettle();

        // Scroll down to see expenses section
        await tester.drag(find.byType(ListView), const Offset(0, -200));
        await tester.pumpAndSettle();

        expect(find.text('2 configured'), findsOneWidget);
        expect(find.text('\$36,000'), findsOneWidget);
      });

      testWidgets('handles empty expense list', (tester) async {
        await tester.pumpWidget(buildSummaryScreen(expensesOverride: []));
        await tester.pumpAndSettle();

        // Scroll down to see expenses section
        await tester.drag(find.byType(ListView), const Offset(0, -200));
        await tester.pumpAndSettle();

        expect(find.text('0 configured'), findsAtLeastNWidgets(1));
        // Note: $0 appears in both assets and expenses, so we find at least one
        expect(find.text('\$0'), findsAtLeastNWidgets(1));
      });
    });

    group('Event Summary', () {
      testWidgets('displays retirement and death event counts', (tester) async {
        final events = [
          Event.retirement(
            id: 'retirement-1',
            individualId: 'individual-1',
            timing: EventTiming.age(individualId: 'individual-1', age: 65),
          ),
          Event.retirement(
            id: 'retirement-2',
            individualId: 'individual-2',
            timing: EventTiming.age(individualId: 'individual-2', age: 65),
          ),
          Event.death(
            id: 'death-1',
            individualId: 'individual-1',
            timing: EventTiming.age(individualId: 'individual-1', age: 85),
          ),
        ];

        await tester.pumpWidget(buildSummaryScreen(eventsOverride: events));
        await tester.pumpAndSettle();

        // Scroll down to see the events section
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        expect(find.text('2 configured'), findsAtLeastNWidgets(1));
        expect(find.text('1 configured'), findsAtLeastNWidgets(1));
      });

      testWidgets('handles empty event list', (tester) async {
        await tester.pumpWidget(buildSummaryScreen(eventsOverride: []));
        await tester.pumpAndSettle();

        // Scroll down to see the events section
        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        expect(find.text('0 configured'), findsAtLeastNWidgets(2));
      });
    });

    group('Wizard Completion', () {
      testWidgets('completes wizard when callback invoked', (tester) async {
        Future<bool> Function()? completionCallback;

        await tester.pumpWidget(
          buildSummaryScreen(
            onRegisterCallback: (callback) {
              completionCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear status updates from initialization
        mockWizardNotifier.statusUpdates.clear();

        final result = await completionCallback!();
        await tester.pumpAndSettle();

        expect(result, isTrue);
        expect(mockWizardNotifier.statusUpdates.length, 1);
        expect(mockWizardNotifier.statusUpdates.last.key, 'summary');
        expect(
          mockWizardNotifier.statusUpdates.last.value.state,
          WizardSectionState.complete,
        );
      });

      testWidgets('shows completion message at top', (tester) async {
        await tester.pumpWidget(buildSummaryScreen());
        await tester.pumpAndSettle();

        // Completion message should be visible at the top without scrolling
        expect(find.text('Ready to Complete'), findsOneWidget);
        expect(
          find.textContaining('configured the essential elements'),
          findsOneWidget,
        );
      });
    });

    group('Widget Structure', () {
      testWidgets('displays all summary cards', (tester) async {
        await tester.pumpWidget(buildSummaryScreen());
        await tester.pumpAndSettle();

        // Should have cards for: Project, Assets visible at top
        // (Expenses and Events may need scrolling)
        expect(find.byType(Card), findsAtLeastNWidgets(2));
      });

      testWidgets('shows section title and description', (tester) async {
        await tester.pumpWidget(buildSummaryScreen());
        await tester.pumpAndSettle();

        expect(find.text('Summary & Review'), findsOneWidget);
        expect(
          find.textContaining('Review your retirement planning'),
          findsOneWidget,
        );
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildSummaryScreen(onRegisterCallback: null));
        await tester.pumpAndSettle();

        expect(find.byType(SummarySectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildSummaryScreen(
            onRegisterCallback: (callback) {
              callbackCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(callbackCalled, isTrue);
      });
    });

    group('Error Handling', () {
      testWidgets('handles no project selected', (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentProjectProvider.overrideWith(
                (ref) => MockCurrentProjectNotifier(
                  NoProjectSelected(),
                  ref,
                  fakeProjectRepository,
                ),
              ),
              projectRepositoryProvider.overrideWithValue(
                fakeProjectRepository,
              ),
              assetRepositoryProvider.overrideWithValue(fakeAssetRepository),
              eventRepositoryProvider.overrideWithValue(fakeEventRepository),
              expenseRepositoryProvider.overrideWithValue(
                fakeExpenseRepository,
              ),
              assetsProvider.overrideWith(() => MockAssetsNotifier([])),
              eventsProvider.overrideWith(() => MockEventsNotifier([])),
              expensesProvider.overrideWith(() => MockExpensesNotifier([])),
              wizardProgressProvider.overrideWith(() => mockWizardNotifier),
            ],
            child: MaterialApp(home: Scaffold(body: SummarySectionScreen())),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No project selected'), findsOneWidget);
      });
    });
  });
}
