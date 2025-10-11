import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'core/config/theme/app_theme.dart';
import 'core/config/i18n/app_localizations.dart';
import 'demo/responsive_demo_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

// Simple provider to manage locale state
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Retirement Planner',
      theme: AppTheme.darkTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ResponsiveDemoScreen(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome message
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'A retirement planning application for individuals based in Quebec.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),

            // Language switcher section
            Text(
              l10n.language,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),

            // Language toggle buttons
            SegmentedButton<String>(
              segments: [
                ButtonSegment<String>(
                  value: 'en',
                  label: Text(l10n.english),
                  icon: const Icon(Icons.language),
                ),
                ButtonSegment<String>(
                  value: 'fr',
                  label: Text(l10n.french),
                  icon: const Icon(Icons.language),
                ),
              ],
              selected: {locale.languageCode},
              onSelectionChanged: (Set<String> selected) {
                ref.read(localeProvider.notifier).state = Locale(selected.first);
              },
            ),
            const SizedBox(height: 48),

            // Test buttons to demonstrate theme
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(l10n.create),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text(l10n.edit),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(l10n.cancel),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Test card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dashboard,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.noProjects,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
