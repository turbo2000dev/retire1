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
import 'package:retire1/features/wizard/presentation/sections/partner_section_screen.dart';

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
  group('PartnerSectionScreen', () {
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
          // Primary individual (index 0)
          Individual(
            id: 'primary-id',
            name: 'Primary User',
            birthdate: DateTime(1980, 1, 1),
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

    Widget buildPartnerScreen({
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
            body: PartnerSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with empty form when no partner exists', (tester) async {
        await tester.pumpWidget(buildPartnerScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        // Should have text fields
        expect(find.byType(TextField), findsAtLeastNWidgets(1));
      });

      testWidgets('loads existing partner data', (tester) async {
        final projectWithPartner = testProject.copyWith(
          individuals: [
            testProject.individuals.first, // Primary
            Individual(
              id: 'partner-id',
              name: 'Jane Doe',
              birthdate: DateTime(1985, 8, 20),
            ),
          ],
        );

        await tester.pumpWidget(buildPartnerScreen(
          projectOverride: projectWithPartner,
        ));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('Jane Doe'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(buildPartnerScreen(
          onRegisterCallback: (callback) {
            registeredCallback = callback;
          },
        ));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(registeredCallback, isNotNull);
      });

      testWidgets('marks section as in progress after loading', (tester) async {
        await tester.pumpWidget(buildPartnerScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'partner');
        expect(mockNotifier.statusUpdates.first.value.state, WizardSectionState.inProgress);
      });
    });

    group('Optional Section Behavior', () {
      testWidgets('allows skipping when no data entered', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildPartnerScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        final result = await validationCallback!();
        await tester.pumpAndSettle();

        expect(result, isTrue); // Should allow navigation
        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'partner');
        expect(mockNotifier.statusUpdates.last.value.state, WizardSectionState.skipped);
      });

      testWidgets('validation fails with name but no birthdate', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildPartnerScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Enter name only
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Partner Name');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });

      testWidgets('validation succeeds with complete data', (tester) async {
        Future<bool> Function()? validationCallback;

        final projectWithPartner = testProject.copyWith(
          individuals: [
            testProject.individuals.first,
            Individual(
              id: 'partner-id',
              name: 'Jane Doe',
              birthdate: DateTime(1985, 8, 20),
            ),
          ],
        );

        await tester.pumpWidget(buildPartnerScreen(
          projectOverride: projectWithPartner,
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
      testWidgets('adds new partner as second individual', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildPartnerScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Enter partner name
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'New Partner');
        await tester.pumpAndSettle();

        // Select birthdate
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        expect(fakeRepository.lastUpdatedProject!.individuals.length, 2);
        expect(fakeRepository.lastUpdatedProject!.individuals[1].name, 'New Partner');
      });

      testWidgets('updates existing partner', (tester) async {
        Future<bool> Function()? validationCallback;

        final projectWithPartner = testProject.copyWith(
          individuals: [
            testProject.individuals.first,
            Individual(
              id: 'partner-id',
              name: 'Jane Doe',
              birthdate: DateTime(1985, 8, 20),
            ),
          ],
        );

        await tester.pumpWidget(buildPartnerScreen(
          projectOverride: projectWithPartner,
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Update partner name
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Jane Smith');
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        expect(fakeRepository.lastUpdatedProject!.individuals[1].name, 'Jane Smith');
        expect(fakeRepository.lastUpdatedProject!.individuals[1].id, 'partner-id');
      });

      testWidgets('marks section as complete after save', (tester) async {
        Future<bool> Function()? validationCallback;

        final projectWithPartner = testProject.copyWith(
          individuals: [
            testProject.individuals.first,
            Individual(
              id: 'partner-id',
              name: 'Jane Doe',
              birthdate: DateTime(1985, 8, 20),
            ),
          ],
        );

        await tester.pumpWidget(buildPartnerScreen(
          projectOverride: projectWithPartner,
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
        expect(mockNotifier.statusUpdates.last.key, 'partner');
        expect(mockNotifier.statusUpdates.last.value.state, WizardSectionState.complete);
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildPartnerScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('contains text field for name', (tester) async {
        await tester.pumpWidget(buildPartnerScreen());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsAtLeastNWidgets(1));
      });

      testWidgets('contains date picker button', (tester) async {
        await tester.pumpWidget(buildPartnerScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.calendar_today), findsOneWidget);
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildPartnerScreen(
          onRegisterCallback: null,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(PartnerSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(buildPartnerScreen(
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
