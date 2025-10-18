import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:retire1/features/auth/presentation/widgets/edit_display_name_dialog.dart';
import 'package:retire1/features/auth/presentation/widgets/profile_picture.dart';
import 'package:retire1/features/settings/domain/app_settings.dart';
import 'package:retire1/features/settings/presentation/providers/settings_provider.dart';

/// Settings screen - app settings and user preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showLogoutConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authNotifierProvider.notifier).logout();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  Future<void> _showEditDisplayNameDialog(
    BuildContext context,
    String currentName,
  ) async {
    await showDialog(
      context: context,
      builder: (context) =>
          EditDisplayNameDialog(currentDisplayName: currentName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);
    final currentLanguage = ref.watch(currentLanguageProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ResponsiveContainer(
            maxWidth: 600,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.settings,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Settings',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'App settings and preferences',
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // User profile section
                if (user != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Profile', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 24),
                          // Profile picture
                          Center(
                            child: ProfilePicture(
                              photoUrl: user.photoUrl,
                              displayName: user.displayName,
                              size: 120,
                              editable: true,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Display name
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(user.displayName ?? 'No name'),
                            subtitle: const Text('Display Name'),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _showEditDisplayNameDialog(
                                context,
                                user.displayName ?? '',
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          // Email
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: Text(user.email),
                            subtitle: const Text('Email'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Language settings
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Language', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 16),
                        SegmentedButton<AppLanguage>(
                          segments: const [
                            ButtonSegment<AppLanguage>(
                              value: AppLanguage.english,
                              label: Text('English'),
                              icon: Icon(Icons.language),
                            ),
                            ButtonSegment<AppLanguage>(
                              value: AppLanguage.french,
                              label: Text('Français'),
                              icon: Icon(Icons.language),
                            ),
                          ],
                          selected: {AppLanguage.fromCode(currentLanguage)},
                          onSelectionChanged: (Set<AppLanguage> selected) {
                            final language = selected.first;
                            ref
                                .read(settingsProvider.notifier)
                                .updateLanguage(language.code);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Excel export preferences
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Excel Export',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          title: const Text('Auto-open Excel files'),
                          subtitle: const Text(
                            'Automatically open Excel files after export',
                          ),
                          value:
                              ref
                                  .watch(settingsProvider)
                                  .value
                                  ?.autoOpenExcelFiles ??
                              true,
                          onChanged: (bool value) {
                            ref
                                .read(settingsProvider.notifier)
                                .updateAutoOpenExcelFiles(value);
                          },
                          secondary: const Icon(Icons.table_chart),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Logout button
                FilledButton.icon(
                  onPressed: () => _showLogoutConfirmation(context, ref),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
