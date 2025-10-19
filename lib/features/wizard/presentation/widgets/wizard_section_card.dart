import 'package:flutter/material.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

/// Card representing a single wizard section in the list
class WizardSectionCard extends StatelessWidget {
  final WizardSection section;
  final bool isCurrentSection;
  final bool isSuggestedNext;
  final WizardSectionStatus? status;
  final VoidCallback onTap;

  const WizardSectionCard({
    super.key,
    required this.section,
    required this.isCurrentSection,
    required this.isSuggestedNext,
    required this.status,
    required this.onTap,
  });

  String _getLocalizedTitle(AppLocalizations l10n) {
    return switch (section.titleKey) {
      'section1Title' => l10n.section1Title,
      'section2Title' => l10n.section2Title,
      'section3Title' => l10n.section3Title,
      'section4Title' => l10n.section4Title,
      'section5Title' => l10n.section5Title,
      'section6Title' => l10n.section6Title,
      'section7Title' => l10n.section7Title,
      'section8Title' => l10n.section8Title,
      'section9Title' => l10n.section9Title,
      'section10Title' => l10n.section10Title,
      'section11Title' => l10n.section11Title,
      'section12Title' => l10n.section12Title,
      _ => section.titleKey,
    };
  }

  String _getLocalizedDescription(AppLocalizations l10n) {
    return switch (section.descriptionKey) {
      'section1Description' => l10n.section1Description,
      'section2Description' => l10n.section2Description,
      'section3Description' => l10n.section3Description,
      'section4Description' => l10n.section4Description,
      'section5Description' => l10n.section5Description,
      'section6Description' => l10n.section6Description,
      'section7Description' => l10n.section7Description,
      'section8Description' => l10n.section8Description,
      'section9Description' => l10n.section9Description,
      'section10Description' => l10n.section10Description,
      'section11Description' => l10n.section11Description,
      'section12Description' => l10n.section12Description,
      _ => section.descriptionKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final effectiveStatus = status ?? WizardSectionStatus.notStarted();

    // Determine card styling based on state
    Color? backgroundColor;
    Color? borderColor;

    if (isCurrentSection) {
      backgroundColor = theme.colorScheme.primaryContainer;
      borderColor = theme.colorScheme.primary;
    } else if (isSuggestedNext) {
      borderColor = theme.colorScheme.secondary;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: borderColor != null
            ? Border.all(color: borderColor, width: 2)
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Status icon
                Text(
                  effectiveStatus.icon,
                  style: const TextStyle(fontSize: 20),
                ),

                const SizedBox(width: 12),

                // Section title and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getLocalizedTitle(l10n),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: isCurrentSection
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),

                          // Required badge
                          if (section.isRequired)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.required,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.error,
                                  fontSize: 10,
                                ),
                              ),
                            ),

                          // Educational badge
                          if (section.isEducational)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                l10n.optional,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.tertiary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Description
                      Text(
                        _getLocalizedDescription(l10n),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Current section indicator
                if (isCurrentSection) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: theme.colorScheme.primary),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
