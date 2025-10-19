import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_desktop_layout.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_mobile_layout.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_progress_bar.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_nav_buttons.dart';
import 'package:retire1/features/wizard/presentation/sections/welcome_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/project_basics_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/primary_individual_section_screen.dart';

/// Main wizard screen that adapts to different screen sizes
class WizardScreen extends ConsumerStatefulWidget {
  const WizardScreen({super.key});

  @override
  ConsumerState<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends ConsumerState<WizardScreen> {
  String? _currentSectionId;
  bool _isLoading = true;
  String? _error;

  // Callback for current section to validate and save before navigation
  Future<bool> Function()? _onBeforeNavigate;

  @override
  void initState() {
    super.initState();
    _initializeWizard();
  }

  /// Register a callback that will be called before navigation
  void _registerNavigationCallback(Future<bool> Function()? callback) {
    setState(() {
      _onBeforeNavigate = callback;
    });
  }

  Future<void> _initializeWizard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final progress = await ref.read(wizardProgressProvider.notifier).getOrCreateProgress();
      if (mounted) {
        setState(() {
          _currentSectionId = progress.currentSectionId;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToSection(String sectionId) async {
    // Don't navigate if already on this section
    if (_currentSectionId == sectionId) {
      return;
    }

    // Call section's validation/save callback before navigating
    if (_onBeforeNavigate != null) {
      final canNavigate = await _onBeforeNavigate!();
      if (!canNavigate) {
        return; // Stay on current section if validation fails
      }
    }

    setState(() {
      _currentSectionId = sectionId;
      _onBeforeNavigate = null; // Clear callback for new section
    });
  }

  void _handleSkip() {
    if (_currentSectionId == null) return;

    // Mark current section as skipped
    ref.read(wizardProgressProvider.notifier).updateSectionStatus(
          _currentSectionId!,
          WizardSectionStatus.skipped(),
        );
  }

  Widget _buildSectionContent() {
    // Route to appropriate section based on current section ID
    return switch (_currentSectionId) {
      'welcome' => WelcomeSectionScreen(
          onRegisterCallback: _registerNavigationCallback,
        ),
      'project-basics' => ProjectBasicsSectionScreen(
          onRegisterCallback: _registerNavigationCallback,
        ),
      'primary-individual' => PrimaryIndividualSectionScreen(
          onRegisterCallback: _registerNavigationCallback,
        ),
      _ => Center(
          child: Text('Section $_currentSectionId - Coming Soon'),
        ),
    };
  }

  String _getSectionTitle(AppLocalizations l10n, String? titleKey) {
    if (titleKey == null) return l10n.wizard;

    return switch (titleKey) {
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
      _ => titleKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    // Loading state
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.loadingWizard),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Error state
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.wizard),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.failedToLoadWizard,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _initializeWizard,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    // Main wizard UI
    final sections = ref.watch(wizardSectionsProvider);
    final currentSection = WizardSectionsConfig.getSectionById(_currentSectionId!);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getSectionTitle(l10n, currentSection?.titleKey)),
            const SizedBox(height: 4),
            const WizardProgressBar(),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: WizardNavButtons(
              currentSectionId: _currentSectionId!,
              onNavigate: _navigateToSection,
              onSkip: _handleSkip,
            ),
          ),
        ],
      ),
      body: ResponsiveBuilder(
        builder: (context, screenSize) {
          if (screenSize.isPhone) {
            return WizardMobileLayout(
              currentSectionId: _currentSectionId!,
              sections: sections,
              onSectionSelected: _navigateToSection,
              sectionContent: _buildSectionContent(),
            );
          } else {
            return WizardDesktopLayout(
              currentSectionId: _currentSectionId!,
              sections: sections,
              onSectionSelected: _navigateToSection,
              sectionContent: _buildSectionContent(),
            );
          }
        },
      ),
    );
  }
}

