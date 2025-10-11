import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';

/// Settings screen - app settings and user preferences
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showLogoutConfirmation(BuildContext context, WidgetRef ref) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final user = authState is Authenticated ? authState.user : null;

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

                // User account section
                if (user != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(user.displayName ?? 'No name'),
                            subtitle: const Text('Display Name'),
                            contentPadding: EdgeInsets.zero,
                          ),
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
