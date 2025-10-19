import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/government_benefits_section_screen.dart';

/// Fake Firestore for testing
class FakeFirestore extends Fake implements FirebaseFirestore {}

/// Fake project repository for testing
class FakeProjectRepository extends ProjectRepository {
  Project? _lastUpdatedProject;

  FakeProjectRepository()
    : super(userId: 'test-user', firestore: FakeFirestore());

  @override
  Future<void> updateProjectData(Project project) async {
    _lastUpdatedProject = project;
  }

  Project? get lastUpdatedProject => _lastUpdatedProject;
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

void main() {
  group('GovernmentBenefitsSectionScreen', () {
    late Project testProject;
    late WizardProgress testProgress;
    late FakeProjectRepository fakeRepository;
    late MockWizardProgressNotifier mockNotifier;

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

      fakeRepository = FakeProjectRepository();
      mockNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildGovernmentBenefitsScreen({
      Project? projectOverride,
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      final project = projectOverride ?? testProject;
      return ProviderScope(
        overrides: [
          currentProjectProvider.overrideWith(
            (ref) => MockCurrentProjectNotifier(
              ProjectSelected(project),
              ref,
              fakeRepository,
            ),
          ),
          projectRepositoryProvider.overrideWithValue(fakeRepository),
          wizardProgressProvider.overrideWith(() => mockNotifier),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: GovernmentBenefitsSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with benefit fields for individuals', (tester) async {
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        // First individual should be visible
        expect(find.text('John Doe'), findsOneWidget);
        // Each individual has 4 fields: RRQ age, PSV age, RRQ at 60, RRQ at 65
        // At least the first individual's fields should be visible
        expect(find.byType(TextFormField), findsAtLeastNWidgets(4));
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(
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
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'government-benefits');
        expect(
          mockNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });

      testWidgets('initializes with default values', (tester) async {
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pumpAndSettle();

        // Check that default values are displayed (at least for first individual)
        expect(
          find.text('65'),
          findsAtLeastNWidgets(2),
        ); // Ages visible on screen
        expect(find.text('12000'), findsAtLeastNWidgets(1)); // RRQ at 60
        expect(find.text('16000'), findsAtLeastNWidgets(1)); // RRQ at 65
      });
    });

    group('Form Validation', () {
      testWidgets('accepts default values', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Default values should be valid
        final result = await validationCallback!();
        expect(result, isTrue);
      });

      testWidgets('accepts valid ages within range', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter valid ages
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), '67'); // RRQ age (60-70)
        await tester.enterText(fields.at(1), '67'); // PSV age (65-70)
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });
    });

    group('Data Persistence', () {
      testWidgets('saves benefit settings for individuals', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Change values for first individual
        final fields = find.byType(TextFormField);
        await tester.enterText(fields.at(0), '62'); // RRQ age
        await tester.enterText(fields.at(1), '67'); // PSV age
        await tester.enterText(fields.at(2), '11000'); // RRQ at 60
        await tester.enterText(fields.at(3), '15000'); // RRQ at 65
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        final updatedIndividual =
            fakeRepository.lastUpdatedProject!.individuals[0];
        expect(updatedIndividual.rrqStartAge, 62);
        expect(updatedIndividual.psvStartAge, 67);
        expect(updatedIndividual.projectedRrqAt60, 11000);
        expect(updatedIndividual.projectedRrqAt65, 15000);
      });

      testWidgets('marks section as complete after saving', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'government-benefits');
        expect(
          mockNotifier.statusUpdates.last.value.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('displays benefit fields for all individuals', (
        tester,
      ) async {
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pumpAndSettle();

        // Should have at least one card visible
        expect(find.byType(Card), findsAtLeastNWidgets(1));
        // Each has 4 fields, but they may not all be visible
        expect(find.byType(TextFormField), findsAtLeastNWidgets(4));
      });

      testWidgets('shows help text', (tester) async {
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pumpAndSettle();

        expect(find.textContaining('Starting QPP earlier'), findsOneWidget);
      });

      testWidgets('displays individual ages', (tester) async {
        await tester.pumpWidget(buildGovernmentBenefitsScreen());
        await tester.pumpAndSettle();

        // Should show current age for at least one individual visible on screen
        expect(find.textContaining('Age:'), findsAtLeastNWidgets(1));
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(onRegisterCallback: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(GovernmentBenefitsSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildGovernmentBenefitsScreen(
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
