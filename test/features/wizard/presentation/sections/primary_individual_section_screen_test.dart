import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/primary_individual_section_screen.dart';

/// Fake Firestore for testing
class FakeFirestore extends Fake implements FirebaseFirestore {}

/// Fake repository for testing
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

  MockCurrentProjectNotifier(this.mockState, Ref ref, FakeProjectRepository repo)
      : super(ref, null, repo) {
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
  group('PrimaryIndividualSectionScreen', () {
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
        individuals: [],
      );

      testProgress = WizardProgress.create(
        projectId: testProject.id,
        userId: 'test-user',
      );

      fakeRepository = FakeProjectRepository();
      mockNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildPrimaryIndividualScreen({
      Project? projectOverride,
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      final project = projectOverride ?? testProject;
      return ProviderScope(
        overrides: [
          currentProjectProvider.overrideWith((ref) =>
              MockCurrentProjectNotifier(ProjectSelected(project), ref, fakeRepository)),
          projectRepositoryProvider.overrideWithValue(fakeRepository),
          wizardProgressProvider.overrideWith(() => mockNotifier),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PrimaryIndividualSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with empty form when no individuals exist', (tester) async {
        await tester.pumpWidget(buildPrimaryIndividualScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        // Name field should be empty
        final textFields = find.byType(TextField);
        expect(textFields, findsAtLeastNWidgets(1));
      });

      testWidgets('loads existing primary individual data', (tester) async {
        final projectWithIndividual = testProject.copyWith(
          individuals: [
            Individual(
              id: 'individual-1',
              name: 'John Doe',
              birthdate: DateTime(1980, 5, 15),
            ),
          ],
        );

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          projectOverride: projectWithIndividual,
        ));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          onRegisterCallback: (callback) {
            registeredCallback = callback;
          },
        ));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(registeredCallback, isNotNull);
      });

      testWidgets('marks section as in progress after loading', (tester) async {
        await tester.pumpWidget(buildPrimaryIndividualScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'primary-individual');
        expect(mockNotifier.statusUpdates.first.value.state, WizardSectionState.inProgress);
      });
    });

    group('Form Validation', () {
      testWidgets('validation fails with empty name', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });

      testWidgets('validation fails without birthdate', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Enter name only
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Jane Doe');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });

      testWidgets('validation succeeds with valid inputs', (tester) async {
        Future<bool> Function()? validationCallback;

        final projectWithIndividual = testProject.copyWith(
          individuals: [
            Individual(
              id: 'individual-1',
              name: 'John Doe',
              birthdate: DateTime(1980, 5, 15),
            ),
          ],
        );

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          projectOverride: projectWithIndividual,
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });
    });

    group('Data Persistence', () {
      testWidgets('creates new individual when none exists', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Enter name
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Jane Smith');
        await tester.pumpAndSettle();

        // Select birthdate
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        expect(fakeRepository.lastUpdatedProject!.individuals.length, 1);
        expect(fakeRepository.lastUpdatedProject!.individuals.first.name, 'Jane Smith');
      });

      testWidgets('updates existing individual', (tester) async {
        Future<bool> Function()? validationCallback;

        final projectWithIndividual = testProject.copyWith(
          individuals: [
            Individual(
              id: 'individual-1',
              name: 'John Doe',
              birthdate: DateTime(1980, 5, 15),
            ),
          ],
        );

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          projectOverride: projectWithIndividual,
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Update name
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'John Smith');
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        expect(fakeRepository.lastUpdatedProject!.individuals.first.name, 'John Smith');
        expect(fakeRepository.lastUpdatedProject!.individuals.first.id, 'individual-1');
      });

      testWidgets('marks section as complete after save', (tester) async {
        Future<bool> Function()? validationCallback;

        final projectWithIndividual = testProject.copyWith(
          individuals: [
            Individual(
              id: 'individual-1',
              name: 'John Doe',
              birthdate: DateTime(1980, 5, 15),
            ),
          ],
        );

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          projectOverride: projectWithIndividual,
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'primary-individual');
        expect(mockNotifier.statusUpdates.last.value.state, WizardSectionState.complete);
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildPrimaryIndividualScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('contains text field for name', (tester) async {
        await tester.pumpWidget(buildPrimaryIndividualScreen());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsAtLeastNWidgets(1));
      });

      testWidgets('contains date picker button', (tester) async {
        await tester.pumpWidget(buildPrimaryIndividualScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildPrimaryIndividualScreen(
          onRegisterCallback: null,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(PrimaryIndividualSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(buildPrimaryIndividualScreen(
          onRegisterCallback: (callback) {
            callbackCalled = true;
          },
        ));
        await tester.pumpAndSettle();

        expect(callbackCalled, isTrue);
      });
    });
  });
}
