import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';

/// Result from wizard launch dialog
enum WizardLaunchChoice {
  startWizard,
  skipWizard,
}

/// Dialog shown after creating a new project, offering to use the setup wizard
class WizardLaunchDialog extends StatelessWidget {
  const WizardLaunchDialog({super.key});

  /// Show the wizard launch dialog
  static Future<WizardLaunchChoice?> show(BuildContext context) {
    return showDialog<WizardLaunchChoice>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (context) => const WizardLaunchDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveDialog(
      child: ResponsiveDialogContent(
        title: 'Setup Your Project',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and intro text
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Your project has been created!',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Option description
            Text(
              'How would you like to continue?',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Option 1: Setup Wizard
            _OptionCard(
              icon: Icons.assistant,
              iconColor: theme.colorScheme.primary,
              title: 'Use Setup Wizard',
              subtitle:
                  'Quick guided setup with smart defaults. Perfect for getting started fast.',
              highlights: [
                'Step-by-step guidance',
                'Smart defaults based on Quebec norms',
                'Takes about 5 minutes',
              ],
            ),
            const SizedBox(height: 16),

            // Option 2: Manual Setup
            _OptionCard(
              icon: Icons.edit_note,
              iconColor: theme.colorScheme.secondary,
              title: 'Manual Setup',
              subtitle:
                  'Configure everything yourself using the detailed screens.',
              highlights: [
                'Full control over all parameters',
                'Use when you have all details ready',
                'Can always run wizard later',
              ],
            ),
            const SizedBox(height: 16),

            // Helper text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You can refine all details later using the regular screens.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Manual setup button
          OutlinedButton.icon(
            onPressed: () =>
                Navigator.of(context).pop(WizardLaunchChoice.skipWizard),
            icon: const Icon(Icons.edit_note),
            label: const Text('Manual Setup'),
          ),

          const SizedBox(width: 8),

          // Wizard button (primary)
          FilledButton.icon(
            onPressed: () =>
                Navigator.of(context).pop(WizardLaunchChoice.startWizard),
            icon: const Icon(Icons.assistant),
            label: const Text('Use Wizard'),
          ),
        ],
      ),
    );
  }
}

/// Card showing an option with highlights
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<String> highlights;

  const _OptionCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.highlights,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Highlights
          ...highlights.map((highlight) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        highlight,
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
