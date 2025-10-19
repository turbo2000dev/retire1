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
import 'package:retire1/features/wizard/presentation/sections/employment_section_screen.dart';

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
  group('EmploymentSectionScreen', () {
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
            employmentIncome: 0,
          ),
          Individual(
            id: 'individual-2',
            name: 'Jane Doe',
            birthdate: DateTime(1982, 8, 20),
            employmentIncome: 0,
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

    Widget buildEmploymentScreen({
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: EmploymentSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('loads with income fields for each individual', (
        tester,
      ) async {
        await tester.pumpWidget(buildEmploymentScreen());
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Jane Doe'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
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
        await tester.pumpWidget(buildEmploymentScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'employment');
        expect(
          mockNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });
    });

    group('Optional Section Behavior', () {
      testWidgets('allows skipping when no income entered', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        final result = await validationCallback!();
        await tester.pumpAndSettle();

        expect(result, isTrue); // Should allow navigation
        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'employment');
        expect(
          mockNotifier.statusUpdates.last.value.state,
          WizardSectionState.skipped,
        );
      });

      testWidgets('validates and saves when income entered', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter income for first individual
        final incomeField = find.byType(TextFormField).first;
        await tester.enterText(incomeField, '80000');
        await tester.pumpAndSettle();

        // Clear previous status updates
        mockNotifier.statusUpdates.clear();

        final result = await validationCallback!();
        await tester.pumpAndSettle();

        expect(result, isTrue);
        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.last.key, 'employment');
        expect(
          mockNotifier.statusUpdates.last.value.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Form Validation', () {
      testWidgets('accepts valid income', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter valid income
        final incomeField = find.byType(TextFormField).first;
        await tester.enterText(incomeField, '75000');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });

      testWidgets('only allows digits in income field', (tester) async {
        await tester.pumpWidget(buildEmploymentScreen());
        await tester.pumpAndSettle();

        // Try to enter non-digit characters
        final incomeField = find.byType(TextFormField).first;
        await tester.enterText(incomeField, 'abc-500');
        await tester.pumpAndSettle();

        // Should filter out non-digits, leaving empty field
        final textField = tester.widget<TextFormField>(incomeField);
        // Input formatter filters out non-digits, so text will be '500'
        expect(textField.controller?.text, '500');
      });

      testWidgets('accepts realistic income values', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter realistic income values
        final incomeFields = find.byType(TextFormField);
        await tester.enterText(incomeFields.at(0), '100000');
        await tester.enterText(incomeFields.at(1), '85000');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });
    });

    group('Data Persistence', () {
      testWidgets('saves employment income for individuals', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter income for both individuals
        final incomeFields = find.byType(TextFormField);
        await tester.enterText(incomeFields.at(0), '80000');
        await tester.enterText(incomeFields.at(1), '65000');
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        expect(
          fakeRepository.lastUpdatedProject!.individuals[0].employmentIncome,
          80000,
        );
        expect(
          fakeRepository.lastUpdatedProject!.individuals[1].employmentIncome,
          65000,
        );
      });

      testWidgets('handles partial income entry', (tester) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter income for only first individual
        final incomeField = find.byType(TextFormField).first;
        await tester.enterText(incomeField, '75000');
        await tester.pumpAndSettle();

        await validationCallback!();
        await tester.pumpAndSettle();

        expect(fakeRepository.lastUpdatedProject, isNotNull);
        expect(
          fakeRepository.lastUpdatedProject!.individuals[0].employmentIncome,
          75000,
        );
        expect(
          fakeRepository.lastUpdatedProject!.individuals[1].employmentIncome,
          0,
        );
      });
    });

    group('Widget Structure', () {
      testWidgets('contains form widget', (tester) async {
        await tester.pumpWidget(buildEmploymentScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('displays income fields for all individuals', (tester) async {
        await tester.pumpWidget(buildEmploymentScreen());
        await tester.pumpAndSettle();

        // Should have one field per individual
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.byType(Card), findsNWidgets(2));
      });

      testWidgets('shows help text', (tester) async {
        await tester.pumpWidget(buildEmploymentScreen());
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Click "Next" to continue, or "Skip" to skip employment income',
          ),
          findsOneWidget,
        );
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(
          buildEmploymentScreen(onRegisterCallback: null),
        );
        await tester.pumpAndSettle();

        expect(find.byType(EmploymentSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              callbackCalled = true;
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(callbackCalled, isTrue);
      });
    });

    group('Validation Callback', () {
      testWidgets('validation callback returns true for valid input', (
        tester,
      ) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Enter valid income
        final incomeField = find.byType(TextFormField).first;
        await tester.enterText(incomeField, '70000');
        await tester.pumpAndSettle();

        final result = await validationCallback!();
        expect(result, isTrue);
      });

      testWidgets('validation callback returns true for empty (skip)', (
        tester,
      ) async {
        Future<bool> Function()? validationCallback;

        await tester.pumpWidget(
          buildEmploymentScreen(
            onRegisterCallback: (callback) {
              validationCallback = callback;
            },
          ),
        );
        await tester.pumpAndSettle();

        // Don't enter any income - should allow skip
        final result = await validationCallback!();
        expect(result, isTrue);
      });
    });
  });
}
