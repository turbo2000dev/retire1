import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/events/data/event_repository.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/retirement_section_screen.dart';

/// Fake Firestore for testing
class FakeFirestore extends Fake implements FirebaseFirestore {}

/// Fake project repository for testing
class FakeProjectRepository extends ProjectRepository {
  FakeProjectRepository()
    : super(userId: 'test-user', firestore: FakeFirestore());
}

/// Fake event repository for testing
class FakeEventRepository extends EventRepository {
  FakeEventRepository()
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

/// Mock notifier for EventsProvider
class MockEventsNotifier extends EventsNotifier {
  final List<Event> mockEvents;
  final List<Event> addedEvents = [];
  final List<Event> updatedEvents = [];

  MockEventsNotifier(this.mockEvents);

  @override
  Future<List<Event>> build() async {
    return mockEvents;
  }

  @override
  Future<void> addEvent(Event event) async {
    addedEvents.add(event);
  }

  @override
  Future<void> updateEvent(Event event) async {
    updatedEvents.add(event);
  }
}

void main() {
  group('RetirementSectionScreen', () {
    late Project testProject;
    late WizardProgress testProgress;
    late FakeProjectRepository fakeProjectRepository;
    late FakeEventRepository fakeEventRepository;
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
      fakeEventRepository = FakeEventRepository();
      mockWizardNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildRetirementScreen({
      Project? projectOverride,
      List<Event>? eventsOverride,
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      final project = projectOverride ?? testProject;
      final events = eventsOverride ?? [];
      final eventsNotifier = MockEventsNotifier(events);

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
          eventRepositoryProvider.overrideWithValue(fakeEventRepository),
          eventsProvider.overrideWith(() => eventsNotifier),
          wizardProgressProvider.overrideWith(() => mockWizardNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: RetirementSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with retirement age fields for individuals', (
        tester,
      ) async {
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        // First individual should be visible
        expect(find.text('John Doe'), findsOneWidget);
        // Should have retirement age field
        expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildRetirementScreen(
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
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockWizardNotifier.statusUpdates.length, 1);
        expect(mockWizardNotifier.statusUpdates.first.key, 'retirement');
        expect(
          mockWizardNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });

      testWidgets('initializes with default retirement age', (tester) async {
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pumpAndSettle();

        // Default retirement age is 65
        expect(find.text('65'), findsAtLeastNWidgets(1));
      });

      testWidgets('loads existing retirement event ages', (tester) async {
        final existingEvents = [
          Event.retirement(
            id: 'retirement-1',
            individualId: 'individual-1',
            timing: EventTiming.age(individualId: 'individual-1', age: 62),
          ),
        ];

        await tester.pumpWidget(
          buildRetirementScreen(eventsOverride: existingEvents),
        );
        await tester.pumpAndSettle();

        // Should have loaded without errors
        expect(find.byType(RetirementSectionScreen), findsOneWidget);
        // Field should be populated (may not be visible due to scrolling)
        expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      });
    });

    group('Form Validation', () {
      testWidgets('accepts valid retirement ages', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildRetirementScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter valid retirement age
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.first, '67');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });

      testWidgets('rejects retirement age below current age', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildRetirementScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter retirement age below current age (John is 44, enter 40)
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.first, '40');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });

      testWidgets('requires retirement age', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildRetirementScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear the field
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.first, '');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });
    });

    group('Data Persistence', () {
      testWidgets('creates new retirement events', (tester) async {
        Future<bool> Function()? validationCallback;
        final eventsNotifier = MockEventsNotifier([]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentProjectProvider.overrideWith(
                (ref) => MockCurrentProjectNotifier(
                  ProjectSelected(testProject),
                  ref,
                  fakeProjectRepository,
                ),
              ),
              projectRepositoryProvider.overrideWithValue(
                fakeProjectRepository,
              ),
              eventRepositoryProvider.overrideWithValue(fakeEventRepository),
              eventsProvider.overrideWith(() => eventsNotifier),
              wizardProgressProvider.overrideWith(() => mockWizardNotifier),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RetirementSectionScreen(
                  onRegisterCallback: (callback) {
                    validationCallback = callback;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Enter retirement ages
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), '67');
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        // Should have created at least one retirement event
        expect(eventsNotifier.addedEvents.length, greaterThan(0));
        final addedEvent = eventsNotifier.addedEvents.first;
        addedEvent.map(
          retirement: (e) {
            expect(e.individualId, 'individual-1');
            e.timing.map(
              relative: (_) => fail('Should be age timing'),
              absolute: (_) => fail('Should be age timing'),
              age: (t) {
                expect(t.age, 67);
                expect(t.individualId, 'individual-1');
              },
              eventRelative: (_) => fail('Should be age timing'),
              projectionEnd: (_) => fail('Should be age timing'),
            );
          },
          death: (_) => fail('Should be retirement event'),
          realEstateTransaction: (_) => fail('Should be retirement event'),
        );
      });

      testWidgets('updates existing retirement events', (tester) async {
        Future<bool> Function()? validationCallback;
        final existingEvents = [
          Event.retirement(
            id: 'retirement-1',
            individualId: 'individual-1',
            timing: EventTiming.age(individualId: 'individual-1', age: 65),
          ),
        ];
        final eventsNotifier = MockEventsNotifier(existingEvents);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              currentProjectProvider.overrideWith(
                (ref) => MockCurrentProjectNotifier(
                  ProjectSelected(testProject),
                  ref,
                  fakeProjectRepository,
                ),
              ),
              projectRepositoryProvider.overrideWithValue(
                fakeProjectRepository,
              ),
              eventRepositoryProvider.overrideWithValue(fakeEventRepository),
              eventsProvider.overrideWith(() => eventsNotifier),
              wizardProgressProvider.overrideWith(() => mockWizardNotifier),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: RetirementSectionScreen(
                  onRegisterCallback: (callback) {
                    validationCallback = callback;
                  },
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Change retirement age
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.first, '62');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        await tester.pumpAndSettle();

        // Validation should succeed
        expect(result, isTrue);
        // Should have updated at least one event (may update multiple for all individuals)
        expect(
          eventsNotifier.updatedEvents.length +
              eventsNotifier.addedEvents.length,
          greaterThan(0),
        );
      });

      testWidgets('marks section as complete after saving', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildRetirementScreen(
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
        expect(mockWizardNotifier.statusUpdates.last.key, 'retirement');
        expect(
          mockWizardNotifier.statusUpdates.last.value.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('displays cards for individuals', (tester) async {
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pumpAndSettle();

        // Should have at least one card visible
        expect(find.byType(Card), findsAtLeastNWidgets(1));
      });

      testWidgets('shows individual names and current ages', (tester) async {
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.textContaining('Current age:'), findsAtLeastNWidgets(1));
      });

      testWidgets('shows help text', (tester) async {
        await tester.pumpWidget(buildRetirementScreen());
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Consider coordinating retirement ages'),
          findsOneWidget,
        );
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(
          buildRetirementScreen(onRegisterCallback: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RetirementSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildRetirementScreen(
            onRegisterCallback: (callback) {
              callbackCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(callbackCalled, isTrue);
      });
    });
  });
}
