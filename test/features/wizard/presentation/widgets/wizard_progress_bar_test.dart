import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_progress_bar.dart';

void main() {
  group('WizardProgressBar', () {
    late WizardProgress testProgress;
    late List<WizardSection> requiredSections;

    setUp(() {
      testProgress = WizardProgress.create(
        projectId: 'test-project',
        userId: 'test-user',
      );

      requiredSections = WizardSectionsConfig.getRequiredSections();
    });

    Widget buildProgressBar({
      WizardProgress? progressData,
      List<WizardSection>? sectionsOverride,
    }) {
      return ProviderScope(
        overrides: [
          if (progressData != null)
            wizardProgressProvider.overrideWith((ref) {
              return AsyncValue.data(progressData);
            }),
          if (sectionsOverride != null)
            requiredSectionsProvider.overrideWithValue(sectionsOverride),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: WizardProgressBar(),
          ),
        ),
      );
    }

    group('Progress Display', () {
      testWidgets('shows 0% when no sections complete', (tester) async {
        await tester.pumpWidget(buildProgressBar(
          progressData: testProgress,
        ));
        await tester.pump();

        expect(find.text('0%'), findsOneWidget);
      });

      testWidgets('shows correct percentage with partial completion', (tester) async {
        // Complete 3 out of 6 required sections = 50%
        final progressWithCompletion = testProgress.copyWith(
          sectionStatuses: {
            requiredSections[0].id: WizardSectionStatus.complete(),
            requiredSections[1].id: WizardSectionStatus.complete(),
            requiredSections[2].id: WizardSectionStatus.complete(),
          },
        );

        await tester.pumpWidget(buildProgressBar(
          progressData: progressWithCompletion,
        ));
        await tester.pump();

        expect(find.text('50%'), findsOneWidget);
      });

      testWidgets('shows 100% when all required sections complete', (tester) async {
        final completedStatuses = {
          for (var section in requiredSections)
            section.id: WizardSectionStatus.complete(),
        };

        final progressComplete = testProgress.copyWith(
          sectionStatuses: completedStatuses,
        );

        await tester.pumpWidget(buildProgressBar(
          progressData: progressComplete,
        ));
        await tester.pump();

        expect(find.text('100%'), findsOneWidget);
      });

      testWidgets('does not count skipped sections in progress', (tester) async {
        // 1 complete, 1 skipped out of 6 = 17% (only complete counts)
        final progressMixed = testProgress.copyWith(
          sectionStatuses: {
            requiredSections[0].id: WizardSectionStatus.complete(),
            requiredSections[1].id: WizardSectionStatus.skipped(),
          },
        );

        await tester.pumpWidget(buildProgressBar(
          progressData: progressMixed,
        ));
        await tester.pump();

        // 1/6 = 16.67%, should round to 17%
        expect(find.text('17%'), findsOneWidget);
      });
    });

    group('Progress Bar Indicator', () {
      testWidgets('shows linear progress indicator', (tester) async {
        await tester.pumpWidget(buildProgressBar(
          progressData: testProgress,
        ));
        await tester.pump();

        expect(find.byType(LinearProgressIndicator), findsOneWidget);
      });

      testWidgets('progress bar value matches percentage', (tester) async {
        // 3 out of 6 = 50%
        final progressWithCompletion = testProgress.copyWith(
          sectionStatuses: {
            requiredSections[0].id: WizardSectionStatus.complete(),
            requiredSections[1].id: WizardSectionStatus.complete(),
            requiredSections[2].id: WizardSectionStatus.complete(),
          },
        );

        await tester.pumpWidget(buildProgressBar(
          progressData: progressWithCompletion,
        ));
        await tester.pump();

        final progressIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator),
        );

        expect(progressIndicator.value, closeTo(0.5, 0.01));
      });
    });
  });
}
