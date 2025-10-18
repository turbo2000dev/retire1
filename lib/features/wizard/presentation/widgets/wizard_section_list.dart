import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_section_card.dart';

/// List of wizard sections grouped by category
class WizardSectionList extends ConsumerWidget {
  final String currentSectionId;
  final List<WizardSection> sections;
  final Function(String) onSectionSelected;

  const WizardSectionList({
    super.key,
    required this.currentSectionId,
    required this.sections,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(wizardProgressProvider);
    final theme = Theme.of(context);

    return progressAsync.when(
      data: (progress) {
        // Group sections by category
        final Map<WizardSectionCategory, List<WizardSection>> groupedSections = {};
        for (final section in sections) {
          groupedSections.putIfAbsent(section.category, () => []).add(section);
        }

        // Determine suggested next section
        String? suggestedNextId;
        if (progress != null) {
          // Find first incomplete required section
          for (final section in sections) {
            if (section.isRequired) {
              final status = progress.getStatus(section.id);
              if (!status.isDone) {
                suggestedNextId = section.id;
                break;
              }
            }
          }
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            // Render each category
            for (final category in WizardSectionCategory.values)
              if (groupedSections.containsKey(category)) ...[
                // Category header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Text(
                        WizardSectionsConfig.categoryIcons[category] ?? '',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          WizardSectionsConfig.categoryTitleKeys[category] ?? '',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sections in this category
                ...groupedSections[category]!.map(
                  (section) => WizardSectionCard(
                    section: section,
                    isCurrentSection: section.id == currentSectionId,
                    isSuggestedNext: section.id == suggestedNextId,
                    status: progress?.getStatus(section.id),
                    onTap: () => onSectionSelected(section.id),
                  ),
                ),
              ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading sections: $error'),
      ),
    );
  }
}
