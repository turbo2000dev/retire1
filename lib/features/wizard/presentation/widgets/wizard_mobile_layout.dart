import 'package:flutter/material.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';

/// Mobile layout - displays section content
/// Section navigation is handled via menu button in AppBar
class WizardMobileLayout extends StatelessWidget {
  final String currentSectionId;
  final List<WizardSection> sections;
  final Function(String) onSectionSelected;
  final Widget sectionContent;

  const WizardMobileLayout({
    super.key,
    required this.currentSectionId,
    required this.sections,
    required this.onSectionSelected,
    required this.sectionContent,
  });

  @override
  Widget build(BuildContext context) {
    // Simply return the section content
    // Navigation is now handled through the menu button in AppBar
    return sectionContent;
  }
}
