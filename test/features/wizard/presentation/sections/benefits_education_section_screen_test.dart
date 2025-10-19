import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/sections/benefits_education_section_screen.dart';

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
  group('BenefitsEducationSectionScreen', () {
    late WizardProgress testProgress;
    late MockWizardProgressNotifier mockNotifier;

    setUp(() {
      testProgress = WizardProgress.create(
        projectId: 'test-project',
        userId: 'test-user',
      );
      mockNotifier = MockWizardProgressNotifier(testProgress);
    });

    Widget buildBenefitsEducationScreen({
      void Function(Future<bool> Function()?)? onRegisterCallback,
    }) {
      return ProviderScope(
        overrides: [wizardProgressProvider.overrideWith(() => mockNotifier)],
        child: MaterialApp(
          home: Scaffold(
            body: BenefitsEducationSectionScreen(
              onRegisterCallback: onRegisterCallback,
            ),
          ),
        ),
      );
    }

    group('Initialization', () {
      testWidgets('displays educational content', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pump();

        expect(
          find.text('Quebec Retirement Benefits Overview'),
          findsOneWidget,
        );
        expect(find.text('Quebec Pension Plan (QPP / RRQ)'), findsOneWidget);
        expect(find.text('Old Age Security (OAS)'), findsOneWidget);
        expect(find.text('Guaranteed Income Supplement (GIS)'), findsOneWidget);
      });

      testWidgets('registers validation callback', (tester) async {
        Future<bool> Function()? registeredCallback;

        await tester.pumpWidget(
          buildBenefitsEducationScreen(
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
          buildBenefitsEducationScreen(
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
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pump(); // Initial build
        await tester.pump(); // PostFrameCallback

        expect(mockNotifier.statusUpdates.length, 1);
        expect(mockNotifier.statusUpdates.first.key, 'benefits-education');
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
          buildBenefitsEducationScreen(
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
        expect(mockNotifier.statusUpdates.first.key, 'benefits-education');
        expect(
          mockNotifier.statusUpdates.first.value.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Content Display', () {
      testWidgets('displays QPP information', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        expect(find.text('Quebec Pension Plan (QPP / RRQ)'), findsOneWidget);
        expect(
          find.textContaining('Quebec Pension Plan (Régime de rentes'),
          findsOneWidget,
        );
        expect(find.textContaining('age 60'), findsAtLeastNWidgets(1));
      });

      testWidgets('displays OAS information', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        expect(find.text('Old Age Security (OAS)'), findsOneWidget);
        expect(find.textContaining('federal monthly payment'), findsOneWidget);
        expect(find.textContaining('age 65'), findsAtLeastNWidgets(1));
      });

      testWidgets('displays GIS information', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        expect(find.text('Guaranteed Income Supplement (GIS)'), findsOneWidget);
        expect(find.textContaining('low-income'), findsAtLeastNWidgets(1));
      });

      testWidgets('displays important notes section', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        expect(find.text('Important Notes'), findsOneWidget);
        expect(find.textContaining('indexed annually'), findsOneWidget);
        expect(find.textContaining('must apply'), findsOneWidget);
      });

      testWidgets('displays next steps message', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        expect(find.textContaining('In the next section'), findsOneWidget);
      });
    });

    group('Widget Structure', () {
      testWidgets('is a StatefulWidget', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());

        final widget = tester.widget<BenefitsEducationSectionScreen>(
          find.byType(BenefitsEducationSectionScreen),
        );

        expect(widget, isA<StatefulWidget>());
      });

      testWidgets('contains scrollable content', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pump();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('contains benefit cards', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        // Should have cards for QPP, OAS, GIS, and Important Notes
        expect(find.byType(Card), findsAtLeastNWidgets(4));
      });

      testWidgets('displays benefit icons', (tester) async {
        await tester.pumpWidget(buildBenefitsEducationScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.account_balance), findsOneWidget);
        expect(find.byIcon(Icons.elderly), findsOneWidget);
        expect(find.byIcon(Icons.volunteer_activism), findsOneWidget);
      });
    });

    group('Callback Registration', () {
      testWidgets('does not crash when callback is null', (tester) async {
        await tester.pumpWidget(
          buildBenefitsEducationScreen(onRegisterCallback: null),
        );
        await tester.pump();

        expect(find.byType(BenefitsEducationSectionScreen), findsOneWidget);
      });

      testWidgets('calls callback during initialization', (tester) async {
        bool callbackCalled = false;

        await tester.pumpWidget(
          buildBenefitsEducationScreen(
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
