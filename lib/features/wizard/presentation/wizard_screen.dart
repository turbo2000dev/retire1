import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_desktop_layout.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_mobile_layout.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_progress_bar.dart';
import 'package:retire1/features/wizard/presentation/widgets/wizard_nav_buttons.dart';
import 'package:retire1/features/wizard/presentation/sections/welcome_section_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeWizard();
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

  void _navigateToSection(String sectionId) {
    setState(() {
      _currentSectionId = sectionId;
    });

    // Update progress in background
    ref.read(wizardProgressProvider.notifier).navigateToSection(sectionId);
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
    // For now, just show welcome section
    // Later phases will add all 12 sections
    return const WelcomeSectionScreen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Loading state
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Wizard...'),
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
          title: const Text('Error'),
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
                'Failed to load wizard',
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
                label: const Text('Retry'),
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
            Text(currentSection?.titleKey ?? 'Wizard'),
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

