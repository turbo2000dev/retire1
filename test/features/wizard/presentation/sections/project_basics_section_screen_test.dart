import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/project_basics_section_screen.dart';

/// Fake Firestore for testing
class FakeFirestore extends Fake implements FirebaseFirestore {}

/// Fake repository for testing
class FakeProjectRepository extends ProjectRepository {
  Project? _projectToUpdate;
  String? _lastUpdatedProjectId;
  String? _lastUpdatedName;
  String? _lastUpdatedDescription;

  FakeProjectRepository()
      : super(userId: 'test-user', firestore: FakeFirestore());

  @override
  Future<void> updateProject({
    required String projectId,
    required String name,
    String? description,
  }) async {
    _lastUpdatedProjectId = projectId;
    _lastUpdatedName = name;
    _lastUpdatedDescription = description;
  }

  @override
  Future<void> updateProjectData(Project project) async {
    _projectToUpdate = project;
  }

  Project? get lastUpdatedProject => _projectToUpdate;
  String? get lastUpdatedName => _lastUpdatedName;
  String? get lastUpdatedDescription => _lastUpdatedDescription;
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
  group('ProjectBasicsSectionScreen', () {
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
        inflationRate: 0.02,
      );

      testProgress = WizardProgress.create(
        projectId: testProject.id,
        userId: 'test-user',
      );

      fakeRepository = FakeProjectRepository();
      mockNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildProjectBasicsScreen({
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      return ProviderScope(
        overrides: [
          currentProjectProvider.overrideWith((ref) =>
              MockCurrentProjectNotifier(ProjectSelected(testProject), ref, fakeRepository)),
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
            body: ProjectBasicsSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads and displays existing project data', (tester) async {
        await tester.pumpWidget(buildProjectBasicsScreen());
        await tester.pump(); // Initial build
        await tester.pumpAndSettle(); // Wait for loading

        expect(find.text('Test Project'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(buildProjectBasicsScreen(
          onRegisterCallback: (callback) {
            registeredCallback = callback;
          },
        ));
        await tester.pump();
        await tester.pumpAndSettle();

        expect(registeredCallback, isNotNull);
      });

      testWidgets('marks section as in progress after loading', (tester) async {
        await tester.pumpWidget(buildProjectBasicsScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'project-basics');
        expect(mockNotifier.statusUpdates.first.value.state, WizardSectionState.inProgress);
      });
    });

    group('Form Validation', () {
      testWidgets('validation fails with empty project name', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildProjectBasicsScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Clear the project name field
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, '');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });

      testWidgets('validation fails with short project name', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildProjectBasicsScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Enter short name
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'A');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isFalse);
      });

      testWidgets('validation succeeds with valid inputs', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildProjectBasicsScreen(
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
      testWidgets('saves updated project name', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildProjectBasicsScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Update project name
        final nameField = find.byType(TextField).first;
        await tester.enterText(nameField, 'Updated Project Name');
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedName, 'Updated Project Name');
      });

      testWidgets('marks section as complete after successful save', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(buildProjectBasicsScreen(
          onRegisterCallback: (callback) {
            validationCallback = callback;
          },
        ));
        await tester.pumpAndSettle();

        // Clear previous status updates from initialization
        mockNotifier.statusUpdates.clear();

        await validationCallback!();
        await tester.pumpAndSettle();

        // Should have one update marking as complete
        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'project-basics');
        expect(mockNotifier.statusUpdates.last.value.state, WizardSectionState.complete);
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildProjectBasicsScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('contains text fields for project info', (tester) async {
        await tester.pumpWidget(buildProjectBasicsScreen());
        await tester.pumpAndSettle();

        // Should have at least 2 TextFields (name and description)
        expect(find.byType(TextField), findsAtLeastNWidgets(2));
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildProjectBasicsScreen(
          onRegisterCallback: null,
        ));
        await tester.pumpAndSettle();

        expect(find.byType(ProjectBasicsSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(buildProjectBasicsScreen(
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
