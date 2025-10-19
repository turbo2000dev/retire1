import 'package:flutter/material.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_section_list.dart';

/// Mobile layout with bottom sheet navigation
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

  void _showSectionList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).sections,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                const Divider(height: 1),

                // Section list
                Expanded(
                  child: WizardSectionList(
                    currentSectionId: currentSectionId,
                    sections: sections,
                    onSectionSelected: (sectionId) {
                      Navigator.of(context).pop();
                      onSectionSelected(sectionId);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        sectionContent,

        // Floating action button to show section list
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: () => _showSectionList(context),
            child: const Icon(Icons.list),
          ),
        ),
      ],
    );
  }
}
