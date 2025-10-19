import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_section_card.dart';

/// List of wizard sections grouped by category
class WizardSectionList extends ConsumerStatefulWidget {
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
  ConsumerState<WizardSectionList> createState() => _WizardSectionListState();
}

class _WizardSectionListState extends ConsumerState<WizardSectionList> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    // Create keys for each section
    for (final section in widget.sections) {
      _sectionKeys[section.id] = GlobalKey();
    }
    // Scroll to current section after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentSection();
    });
  }

  @override
  void didUpdateWidget(WizardSectionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Scroll when current section changes
    if (oldWidget.currentSectionId != widget.currentSectionId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToCurrentSection();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentSection() {
    final key = _sectionKeys[widget.currentSectionId];
    if (key?.currentContext != null && _scrollController.hasClients) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3, // Position section at 30% from top (not centered)
      );
    }
  }

  String _getCategoryTitle(AppLocalizations l10n, String? titleKey) {
    if (titleKey == null) return '';

    return switch (titleKey) {
      'categoryGettingStarted' => l10n.categoryGettingStarted,
      'categoryIndividuals' => l10n.categoryIndividuals,
      'categoryFinancialSituation' => l10n.categoryFinancialSituation,
      'categoryRetirementIncome' => l10n.categoryRetirementIncome,
      'categoryKeyEvents' => l10n.categoryKeyEvents,
      'categoryScenariosReview' => l10n.categoryScenariosReview,
      _ => titleKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(wizardProgressProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return progressAsync.when(
      data: (progress) {
        // Group sections by category
        final Map<WizardSectionCategory, List<WizardSection>> groupedSections =
            {};
        for (final section in widget.sections) {
          groupedSections.putIfAbsent(section.category, () => []).add(section);
        }

        // Determine suggested next section
        String? suggestedNextId;
        if (progress != null) {
          // Find first incomplete required section
          for (final section in widget.sections) {
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
          controller: _scrollController,
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
                          _getCategoryTitle(
                            l10n,
                            WizardSectionsConfig.categoryTitleKeys[category],
                          ),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
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
                    key: _sectionKeys[section.id],
                    section: section,
                    isCurrentSection: section.id == widget.currentSectionId,
                    isSuggestedNext: section.id == suggestedNextId,
                    status: progress?.getStatus(section.id),
                    onTap: () => widget.onSectionSelected(section.id),
                  ),
                ),
              ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('${l10n.errorLoadingSections}: $error')),
    );
  }
}
