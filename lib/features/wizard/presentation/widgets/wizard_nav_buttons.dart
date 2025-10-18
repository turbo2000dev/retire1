import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';

/// Navigation buttons for wizard (Previous, Skip, Next)
class WizardNavButtons extends ConsumerWidget {
  final String currentSectionId;
  final Function(String) onNavigate;
  final VoidCallback? onSkip;

  const WizardNavButtons({
    super.key,
    required this.currentSectionId,
    required this.onNavigate,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentSection = WizardSectionsConfig.getSectionById(currentSectionId);
    final previousSection = WizardSectionsConfig.getPreviousSection(currentSectionId);
    final nextSection = WizardSectionsConfig.getNextSection(currentSectionId);

    if (currentSection == null) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        if (previousSection != null)
          TextButton.icon(
            onPressed: () => onNavigate(previousSection.id),
            icon: const Icon(Icons.chevron_left),
            label: Text(l10n.previous),
          ),

        const SizedBox(width: 8),

        // Skip button (only for optional sections)
        if (!currentSection.isRequired && onSkip != null)
          OutlinedButton(
            onPressed: () {
              onSkip!();
              if (nextSection != null) {
                onNavigate(nextSection.id);
              }
            },
            child: Text(l10n.skip),
          ),

        const SizedBox(width: 8),

        // Next button
        if (nextSection != null)
          FilledButton.icon(
            onPressed: () => onNavigate(nextSection.id),
            label: Text(l10n.next),
            icon: const Icon(Icons.chevron_right),
          )
        else
          // Finish button on last section
          FilledButton.icon(
            onPressed: () => _handleFinish(context, ref),
            label: Text(l10n.finish),
            icon: const Icon(Icons.check),
          ),
      ],
    );
  }

  Future<void> _handleFinish(BuildContext context, WidgetRef ref) async {
    // Mark wizard as complete
    await ref.read(wizardProgressProvider.notifier).completeWizard();

    // Navigate back or show completion message
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
