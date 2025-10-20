import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_progress_bar.dart';

/// Mock notifier for testing
class MockWizardProgressNotifier extends WizardProgressNotifier {
  final WizardProgress? mockProgress;

  MockWizardProgressNotifier(this.mockProgress);

  @override
  Future<WizardProgress?> build() async {
    return mockProgress;
  }
}

void main() {
  group('WizardProgressBar', () {
    late WizardProgress testProgress;
    late List<WizardSection> allSections;

    setUp(() {
      testProgress = WizardProgress.create(
        projectId: 'test-project',
        userId: 'test-user',
      );

      allSections = WizardSectionsConfig.sections;
    });

    Widget buildProgressBar({
      WizardProgress? progressData,
      List<WizardSection>? sectionsOverride,
    }) {
      return ProviderScope(
        overrides: [
          if (progressData != null)
            wizardProgressProvider.overrideWith(
              () => MockWizardProgressNotifier(progressData),
            ),
          if (sectionsOverride != null)
            wizardSectionsProvider.overrideWithValue(sectionsOverride),
        ],
        child: const MaterialApp(home: Scaffold(body: WizardProgressBar())),
      );
    }

    group('Progress Display', () {
      testWidgets('shows 0% when no sections complete', (tester) async {
        await tester.pumpWidget(buildProgressBar(progressData: testProgress));
        await tester.pump();

        expect(find.text('0%'), findsOneWidget);
      });

      testWidgets('shows correct percentage with partial completion', (
        tester,
      ) async {
        // Complete 6 out of 12 sections = 50%
        final progressWithCompletion = testProgress.copyWith(
          sectionStatuses: {
            allSections[0].id: WizardSectionStatus.complete(),
            allSections[1].id: WizardSectionStatus.complete(),
            allSections[2].id: WizardSectionStatus.complete(),
            allSections[3].id: WizardSectionStatus.complete(),
            allSections[4].id: WizardSectionStatus.complete(),
            allSections[5].id: WizardSectionStatus.complete(),
          },
        );

        await tester.pumpWidget(
          buildProgressBar(progressData: progressWithCompletion),
        );
        await tester.pump();

        expect(find.text('50%'), findsOneWidget);
      });

      testWidgets('shows 100% when all sections complete', (tester) async {
        final completedStatuses = {
          for (var section in allSections)
            section.id: WizardSectionStatus.complete(),
        };

        final progressComplete = testProgress.copyWith(
          sectionStatuses: completedStatuses,
        );

        await tester.pumpWidget(
          buildProgressBar(progressData: progressComplete),
        );
        await tester.pump();

        expect(find.text('100%'), findsOneWidget);
      });

      testWidgets('does not count skipped sections in progress', (
        tester,
      ) async {
        // 2 complete, 1 skipped out of 12 = 17% (only complete counts)
        final progressMixed = testProgress.copyWith(
          sectionStatuses: {
            allSections[0].id: WizardSectionStatus.complete(),
            allSections[1].id: WizardSectionStatus.complete(),
            allSections[2].id: WizardSectionStatus.skipped(),
          },
        );

        await tester.pumpWidget(buildProgressBar(progressData: progressMixed));
        await tester.pump();

        // 2/12 = 16.67%, should round to 17%
        expect(find.text('17%'), findsOneWidget);
      });
    });

    group('Progress Bar Indicator', () {
      testWidgets('shows linear progress indicator', (tester) async {
        await tester.pumpWidget(buildProgressBar(progressData: testProgress));
        await tester.pump();

        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('progress bar value matches percentage', (tester) async {
        // 6 out of 12 = 50%
        final progressWithCompletion = testProgress.copyWith(
          sectionStatuses: {
            allSections[0].id: WizardSectionStatus.complete(),
            allSections[1].id: WizardSectionStatus.complete(),
            allSections[2].id: WizardSectionStatus.complete(),
            allSections[3].id: WizardSectionStatus.complete(),
            allSections[4].id: WizardSectionStatus.complete(),
            allSections[5].id: WizardSectionStatus.complete(),
          },
        );

        await tester.pumpWidget(
          buildProgressBar(progressData: progressWithCompletion),
        );
        await tester.pump();

        final progressIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );

        expect(progressIndicator.value, closeTo(0.5, 0.01));
      });
    });
  });
}
