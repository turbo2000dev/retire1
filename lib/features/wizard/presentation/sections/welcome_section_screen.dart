import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Welcome section - Educational introduction to the wizard
class WelcomeSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const WelcomeSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<WelcomeSectionScreen> createState() =>
      _WelcomeSectionScreenState();
}

class _WelcomeSectionScreenState extends ConsumerState<WelcomeSectionScreen> {
  @override
  void initState() {
    super.initState();

    // Register a callback that marks section complete when user clicks Next
    widget.onRegisterCallback?.call(() async {
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('welcome', WizardSectionStatus.complete());
      return true;
    });

    // Mark as in progress after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('welcome', WizardSectionStatus.inProgress());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Define reassuring color palette (blue and green tones)
    final primaryColor = const Color(0xFF4A90A4); // Calming blue
    final secondaryColor = const Color(0xFF7CB342); // Mild green
    final accentColor = const Color(0xFF81C784); // Light green

    return ResponsiveContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),

            // Title
            Text(
              l10n.welcomeWizardTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Image placeholder
            Container(
              height: screenSize.width > 600 ? 300 : 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.2),
                    accentColor.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.beach_access,
                      size: 80,
                      color: primaryColor.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Image placeholder\nRecommended: 1200x800px',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Intro text
            Text(
              l10n.welcomeWizardIntro,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // 5 steps
            _buildStepCard(
              context,
              1,
              Icons.person_outline,
              l10n.welcomeWizardStep1Title,
              l10n.welcomeWizardStep1Description,
              primaryColor,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              context,
              2,
              Icons.attach_money,
              l10n.welcomeWizardStep2Title,
              l10n.welcomeWizardStep2Description,
              secondaryColor,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              context,
              3,
              Icons.savings_outlined,
              l10n.welcomeWizardStep3Title,
              l10n.welcomeWizardStep3Description,
              accentColor,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              context,
              4,
              Icons.star_outline,
              l10n.welcomeWizardStep4Title,
              l10n.welcomeWizardStep4Description,
              primaryColor,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              context,
              5,
              Icons.assignment_outlined,
              l10n.welcomeWizardStep5Title,
              l10n.welcomeWizardStep5Description,
              secondaryColor,
            ),

            const SizedBox(height: 32),

            // Time estimate and ready question
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.1),
                    accentColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: primaryColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.schedule, size: 40, color: primaryColor),
                  const SizedBox(height: 12),
                  Text(
                    l10n.welcomeWizardTimeEstimate,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.welcomeWizardReady,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    int stepNumber,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  stepNumber.toString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),

            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
