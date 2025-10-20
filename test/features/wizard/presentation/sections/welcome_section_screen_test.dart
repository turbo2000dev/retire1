import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/welcome_section_screen.dart';

/// Mock notifier for testing
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
  group('WelcomeSectionScreen', () {
    late WizardProgress testProgress;
    late MockWizardProgressNotifier mockNotifier;

    setUp(() {
      testProgress = WizardProgress.create(
        projectId: 'test-project',
        userId: 'test-user',
      );
      mockNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildWelcomeScreen({
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      return ProviderScope(
        overrides: [wizardProgressProvider.overrideWith(() => mockNotifier)],
        child: MaterialApp(
          home: Scaffold(
            body: WelcomeSectionScreen(onRegisterCallback: onRegisterCallback),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('displays welcome text', (tester) async {
        await tester.pumpWidget(buildWelcomeScreen());
        await tester.pump();

        expect(find.text('Welcome - Coming Soon'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildWelcomeScreen(
            onRegisterCallback: (callback) {
              registeredCallback = callback;
            },
          ),
        );
        await tester.pump();

        expect(registeredCallback, isNotNull);
      });

      testWidgets('validation callback always returns true', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildWelcomeScreen(
            onRegisterCallback: (callback) {
              registeredCallback = callback;
            },
          ),
        );
        await tester.pump();

        final result = await registeredCallback!();
        expect(result, isTrue);
      });

      testWidgets('marks section as in progress after loading', (tester) async {
        await tester.pumpWidget(buildWelcomeScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'welcome');
        expect(
          mockNotifier.statusUpdates.first.value.state,
          WizardSectionState.inProgress,
        );
      });

      testWidgets('marks section as complete when callback is called', (
        tester,
      ) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildWelcomeScreen(
            onRegisterCallback: (callback) {
              registeredCallback = callback;
            },
          ),
        );
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        // Clear the in-progress status update
        mockNotifier.statusUpdates.clear();

        // Call the validation callback (simulates clicking Next)
        await registeredCallback!();
        await tester.pump();

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'welcome');
        expect(
          mockNotifier.statusUpdates.first.value.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Widget Structure', () {
      testWidgets('is a StatefulWidget', (tester) async {
        await tester.pumpWidget(buildWelcomeScreen());

        final widget = tester.widget<WelcomeSectionScreen>(
          find.byType(WelcomeSectionScreen),
        );

        expect(widget, isA<StatefulWidget>());
      });

      testWidgets('contains Center widget', (tester) async {
        await tester.pumpWidget(buildWelcomeScreen());
        await tester.pump();

        expect(find.byType(Center), findsOneWidget);
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(buildWelcomeScreen(onRegisterCallback: null));
        await tester.pump();

        expect(find.byType(WelcomeSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildWelcomeScreen(
            onRegisterCallback: (callback) {
              callbackCalled = true;
            },
          ),
        );
        await tester.pump();

        expect(callbackCalled, isTrue);
      });
    });
  });
}
