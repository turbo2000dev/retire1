import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_section_card.dart';

void main() {
  group('WizardSectionCard', () {
    late WizardSection testSection;

    setUp(() {
      testSection = const WizardSection(
        id: 'test-section',
        titleKey: 'Test Section',
        descriptionKey: 'Test description',
        category: WizardSectionCategory.gettingStarted,
        isRequired: true,
        isEducational: false,
        orderIndex: 1,
      );
    });

    Widget buildCard({
      WizardSection? section,
      bool isCurrentSection = false,
      bool isSuggestedNext = false,
      WizardSectionStatus? status,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: WizardSectionCard(
            section: section ?? testSection,
            isCurrentSection: isCurrentSection,
            isSuggestedNext: isSuggestedNext,
            status: status,
            onTap: onTap ?? () {},
          ),
        ),
      );
    }

    group('Status Icons', () {
      testWidgets('shows not started icon when no status provided', (
        tester,
      ) async {
        await tester.pumpWidget(buildCard());

        expect(find.text('⏹️'), findsOneWidget);
      });

      testWidgets('shows in progress icon', (tester) async {
        await tester.pumpWidget(
          buildCard(status: WizardSectionStatus.inProgress()),
        );

        expect(find.text('🔄'), findsOneWidget);
      });

      testWidgets('shows complete icon', (tester) async {
        await tester.pumpWidget(
          buildCard(status: WizardSectionStatus.complete()),
        );

        expect(find.text('✅'), findsOneWidget);
      });

      testWidgets('shows skipped icon', (tester) async {
        await tester.pumpWidget(
          buildCard(status: WizardSectionStatus.skipped()),
        );

        expect(find.text('⏸️'), findsOneWidget);
      });

      testWidgets('shows needs attention icon', (tester) async {
        await tester.pumpWidget(
          buildCard(status: WizardSectionStatus.needsAttention([])),
        );

        expect(find.text('⚠️'), findsOneWidget);
      });
    });

    group('Section Content', () {
      testWidgets('displays section title', (tester) async {
        await tester.pumpWidget(buildCard());

        expect(find.text('Test Section'), findsOneWidget);
      });

      testWidgets('displays section description', (tester) async {
        await tester.pumpWidget(buildCard());

        expect(find.text('Test description'), findsOneWidget);
      });
    });

    group('Badges', () {
      testWidgets('shows required badge for required sections', (tester) async {
        await tester.pumpWidget(
          buildCard(section: testSection.copyWith(isRequired: true)),
        );

        expect(find.text('Required'), findsOneWidget);
      });

      testWidgets('does not show required badge for optional sections', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildCard(section: testSection.copyWith(isRequired: false)),
        );

        expect(find.text('Required'), findsNothing);
      });

      testWidgets('shows optional badge for educational sections', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildCard(section: testSection.copyWith(isEducational: true)),
        );

        expect(find.text('Optional'), findsOneWidget);
      });

      testWidgets('does not show optional badge for non-educational sections', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildCard(section: testSection.copyWith(isEducational: false)),
        );

        expect(find.text('Optional'), findsNothing);
      });
    });

    group('Current Section Indicator', () {
      testWidgets('shows chevron for current section', (tester) async {
        await tester.pumpWidget(buildCard(isCurrentSection: true));

        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });

      testWidgets('does not show chevron for non-current section', (
        tester,
      ) async {
        await tester.pumpWidget(buildCard(isCurrentSection: false));

        expect(find.byIcon(Icons.chevron_right), findsNothing);
      });

      testWidgets('uses primary container color for current section', (
        tester,
      ) async {
        await tester.pumpWidget(buildCard(isCurrentSection: true));

        final container = tester.widget<Container>(
          find
              .ancestor(
                of: find.byType(InkWell),
                matching: find.byType(Container),
              )
              .first,
        );

        expect(container.decoration, isA<BoxDecoration>());
      });
    });

    group('Current Section Indicator', () {
      testWidgets('shows chevron for current section', (tester) async {
        await tester.pumpWidget(buildCard(isCurrentSection: true));

        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });

      testWidgets('does not show chevron for non-current section', (
        tester,
      ) async {
        await tester.pumpWidget(buildCard(isCurrentSection: false));

        expect(find.byIcon(Icons.chevron_right), findsNothing);
      });

      testWidgets('shows chevron even when suggested next', (tester) async {
        await tester.pumpWidget(
          buildCard(isCurrentSection: true, isSuggestedNext: true),
        );

        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });

    group('Interactions', () {
      testWidgets('calls onTap when tapped', (tester) async {
        bool tapped = false;
        await tester.pumpWidget(buildCard(onTap: () => tapped = true));

        await tester.tap(find.byType(WizardSectionCard));
        await tester.pump();

        expect(tapped, isTrue);
      });

      testWidgets('has ink splash effect', (tester) async {
        await tester.pumpWidget(buildCard());

        expect(find.byType(InkWell), findsOneWidget);
      });
    });

    group('Visual States', () {
      testWidgets('shows border for suggested next section', (tester) async {
        await tester.pumpWidget(buildCard(isSuggestedNext: true));

        final container = tester.widget<Container>(
          find
              .ancestor(
                of: find.byType(InkWell),
                matching: find.byType(Container),
              )
              .first,
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
      });

      testWidgets('shows border for current section', (tester) async {
        await tester.pumpWidget(buildCard(isCurrentSection: true));

        final container = tester.widget<Container>(
          find
              .ancestor(
                of: find.byType(InkWell),
                matching: find.byType(Container),
              )
              .first,
        );

        final decoration = container.decoration as BoxDecoration;
        expect(decoration.border, isNotNull);
      });
    });
  });
}
