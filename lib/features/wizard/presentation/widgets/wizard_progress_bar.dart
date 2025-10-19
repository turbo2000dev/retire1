import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';

/// Progress bar showing wizard completion percentage
class WizardProgressBar extends ConsumerWidget {
  const WizardProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(wizardProgressProvider);
    final allSections = ref.watch(wizardSectionsProvider);
    final allSectionIds = allSections.map((s) => s.id).toList();

    return progressAsync.when(
      data: (progress) {
        final percentage = progress?.calculateProgress(allSectionIds) ?? 0.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 6,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(minHeight: 6),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
