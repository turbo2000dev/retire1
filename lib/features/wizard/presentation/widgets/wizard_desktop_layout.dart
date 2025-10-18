import 'package:flutter/material.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_section_list.dart';

/// Desktop layout with sidebar navigation (280px) and main content area
class WizardDesktopLayout extends StatelessWidget {
  final String currentSectionId;
  final List<WizardSection> sections;
  final Function(String) onSectionSelected;
  final Widget sectionContent;

  const WizardDesktopLayout({
    super.key,
    required this.currentSectionId,
    required this.sections,
    required this.onSectionSelected,
    required this.sectionContent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Left sidebar - Section list (280px fixed width)
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              right: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: WizardSectionList(
            currentSectionId: currentSectionId,
            sections: sections,
            onSectionSelected: onSectionSelected,
          ),
        ),

        // Right content area - Current section (flexible)
        Expanded(
          child: Container(
            color: theme.colorScheme.background,
            child: sectionContent,
          ),
        ),
      ],
    );
  }
}
