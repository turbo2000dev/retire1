import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_desktop_layout.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_mobile_layout.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_progress_bar.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_nav_buttons.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_section_list.dart';
import 'package:retire1/features/wizard/presentation/sections/welcome_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/project_basics_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/primary_individual_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/partner_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/assets_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/employment_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/benefits_education_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/government_benefits_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/expenses_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/retirement_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/life_events_section_screen.dart';
import 'package:retire1/features/wizard/presentation/sections/summary_section_screen.dart';

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
    _onBeforeNavigate = callback;
  }

  Future<void> _initializeWizard() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final progress = await ref
          .read(wizardProgressProvider.notifier)
          .getOrCreateProgress();
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

    // Update local state immediately for responsive UI
    setState(() {
      _currentSectionId = sectionId;
      _onBeforeNavigate = null; // Clear callback for new section
    });

    // Persist the navigation to Firestore so we can resume later
    try {
      await ref
          .read(wizardProgressProvider.notifier)
          .navigateToSection(sectionId);
    } catch (e) {
      // Log error but don't block navigation (local state already updated)
      // The stream will sync the state if needed
    }
  }

  void _handleSkip() {
    if (_currentSectionId == null) return;

    // Mark current section as skipped
    ref
        .read(wizardProgressProvider.notifier)
        .updateSectionStatus(_currentSectionId!, WizardSectionStatus.skipped());
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
      'partner' => PartnerSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'assets' => AssetsSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'employment' => EmploymentSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'benefits-education' => BenefitsEducationSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'government-benefits' => GovernmentBenefitsSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'expenses' => ExpensesSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'retirement-timing' => RetirementSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'life-events' => LifeEventsSectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      'summary' => SummarySectionScreen(
        onRegisterCallback: _registerNavigationCallback,
      ),
      _ => Center(child: Text('Section $_currentSectionId - Coming Soon')),
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
        appBar: AppBar(title: Text(l10n.loadingWizard)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Error state
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.wizard)),
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
    final currentSection = WizardSectionsConfig.getSectionById(
      _currentSectionId!,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wizard),
        actions: [
          // Show section list button on mobile
          ResponsiveBuilder(
            builder: (context, screenSize) {
              if (screenSize.isPhone) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Show section list in bottom sheet
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
                                  margin: const EdgeInsets.only(
                                    top: 12,
                                    bottom: 8,
                                  ),
                                  width: 40,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.outline
                                        .withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),

                                // Title
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    l10n.sections,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),

                                const Divider(height: 1),

                                // Section list
                                Expanded(
                                  child: WizardSectionList(
                                    currentSectionId: _currentSectionId!,
                                    sections: sections,
                                    onSectionSelected: (sectionId) {
                                      Navigator.of(context).pop();
                                      _navigateToSection(sectionId);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  tooltip: l10n.sections,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Section content takes most of the space
          Expanded(
            child: ResponsiveBuilder(
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
          ),

          // Bottom section with title, progress bar, and navigation buttons
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ResponsiveContainer(
                  child: ResponsiveBuilder(
                    builder: (context, screenSize) {
                      final isPhone = screenSize.isPhone;

                      if (isPhone) {
                        // Mobile layout: Title on top
                        // Then progress bar and buttons below
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Section title
                            Text(
                              _getSectionTitle(l10n, currentSection?.titleKey),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Progress bar
                            const WizardProgressBar(),
                            const SizedBox(height: 16),

                            // Buttons row: Leave on left, nav buttons on right
                            Row(
                              children: [
                                // Leave Wizard button
                                TextButton.icon(
                                  onPressed: () {
                                    // TODO: Show confirmation dialog then navigate away
                                    context.go('/');
                                  },
                                  icon: const Icon(Icons.exit_to_app, size: 18),
                                  label: Text(l10n.leaveWizard),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    minimumSize: const Size(0, 32),
                                  ),
                                ),

                                const Spacer(),

                                // Navigation buttons (Previous, Skip, Next/Finish)
                                WizardNavButtons(
                                  currentSectionId: _currentSectionId!,
                                  onNavigate: _navigateToSection,
                                  onSkip: _handleSkip,
                                ),
                              ],
                            ),
                          ],
                        );
                      } else {
                        // Desktop/Tablet layout: Title on left, progress + buttons on right
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Left side: Section title (280px to match sidebar width)
                            SizedBox(
                              width: 280,
                              child: Text(
                                _getSectionTitle(
                                  l10n,
                                  currentSection?.titleKey,
                                ),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Right side: Progress bar and buttons
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Progress bar
                                  const WizardProgressBar(),
                                  const SizedBox(height: 16),

                                  // Buttons row: Leave on left, nav buttons on right
                                  Row(
                                    children: [
                                      // Leave Wizard button
                                      TextButton.icon(
                                        onPressed: () {
                                          // TODO: Show confirmation dialog then navigate away
                                          context.go('/');
                                        },
                                        icon: const Icon(Icons.exit_to_app),
                                        label: Text(l10n.leaveWizard),
                                      ),

                                      const Spacer(),

                                      // Navigation buttons (Previous, Skip, Next/Finish)
                                      WizardNavButtons(
                                        currentSectionId: _currentSectionId!,
                                        onNavigate: _navigateToSection,
                                        onSkip: _handleSkip,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
