import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_nav_buttons.dart';

void main() {
  group('WizardNavButtons', () {
    Widget buildNavButtons({
      required String currentSectionId,
      Function(String)? onNavigate,
      VoidCallback? onSkip,
    }) {
      return ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: WizardNavButtons(
              currentSectionId: currentSectionId,
              onNavigate: onNavigate ?? (_) {},
              onSkip: onSkip,
            ),
          ),
        ),
      );
    }

    group('First Section (Welcome)', () {
      testWidgets('does not show Previous button on first section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'welcome',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Previous'), findsNothing);
      });

      testWidgets('shows Next button on first section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'welcome',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('shows Skip button for optional section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'welcome',
          onSkip: () {},
        ));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsOneWidget);
      });
    });

    group('Middle Section (Project Basics)', () {
      testWidgets('shows Previous button on middle section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'project-basics',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Previous'), findsOneWidget);
      });

      testWidgets('shows Next button on middle section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'project-basics',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Next'), findsOneWidget);
      });

      testWidgets('does not show Skip for required section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'project-basics',
          onSkip: () {},
        ));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsNothing);
      });
    });

    group('Last Section (Summary)', () {
      testWidgets('shows Previous button on last section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'summary',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Previous'), findsOneWidget);
      });

      testWidgets('shows Finish button instead of Next on last section', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'summary',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Next'), findsNothing);
        expect(find.text('Finish'), findsOneWidget);
      });

      testWidgets('Finish button has check icon', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'summary',
        ));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });
    });

    group('Optional Section (Partner)', () {
      testWidgets('shows Skip button for optional section when callback provided', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'partner',
          onSkip: () {},
        ));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsOneWidget);
      });

      testWidgets('does not show Skip button when callback not provided', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'partner',
        ));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsNothing);
      });
    });

    group('Navigation Callbacks', () {
      testWidgets('calls onNavigate with previous section ID', (tester) async {
        String? navigatedTo;
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'project-basics',
          onNavigate: (id) => navigatedTo = id,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Previous'));
        await tester.pump();

        expect(navigatedTo, 'welcome');
      });

      testWidgets('calls onNavigate with next section ID', (tester) async {
        String? navigatedTo;
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'welcome',
          onNavigate: (id) => navigatedTo = id,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Next'));
        await tester.pump();

        expect(navigatedTo, 'project-basics');
      });

      testWidgets('calls onSkip and navigates when Skip is tapped', (tester) async {
        bool skipped = false;
        String? navigatedTo;

        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'partner',
          onNavigate: (id) => navigatedTo = id,
          onSkip: () => skipped = true,
        ));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Skip'));
        await tester.pump();

        expect(skipped, isTrue);
        expect(navigatedTo, 'assets'); // Next section after partner
      });
    });

    group('Button Icons', () {
      testWidgets('Previous button has chevron_left icon', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'project-basics',
        ));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      });

      testWidgets('Next button has chevron_right icon', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'welcome',
        ));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.chevron_right), findsOneWidget);
      });
    });

    group('Invalid Section', () {
      testWidgets('shows nothing for invalid section ID', (tester) async {
        await tester.pumpWidget(buildNavButtons(
          currentSectionId: 'invalid-section',
        ));
        await tester.pumpAndSettle();

        expect(find.byType(WizardNavButtons), findsOneWidget);
        expect(find.text('Previous'), findsNothing);
        expect(find.text('Next'), findsNothing);
        expect(find.text('Skip'), findsNothing);
      });
    });
  });
}
