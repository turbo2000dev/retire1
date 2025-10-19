import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Benefits Education section - Educational overview of Quebec retirement benefits
class BenefitsEducationSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const BenefitsEducationSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<BenefitsEducationSectionScreen> createState() =>
      _BenefitsEducationSectionScreenState();
}

class _BenefitsEducationSectionScreenState
    extends ConsumerState<BenefitsEducationSectionScreen> {
  @override
  void initState() {
    super.initState();

    // Register a callback that marks section complete when user clicks Next
    widget.onRegisterCallback?.call(() async {
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus(
            'benefits-education',
            WizardSectionStatus.complete(),
          );
      return true;
    });

    // Mark as in progress after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus(
            'benefits-education',
            WizardSectionStatus.inProgress(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveContainer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Quebec Retirement Benefits Overview',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Understanding the government benefits available to you in Quebec',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // QPP Section
            _buildBenefitCard(
              theme: theme,
              title: 'Quebec Pension Plan (QPP / RRQ)',
              icon: Icons.account_balance,
              color: Colors.blue,
              description:
                  'The Quebec Pension Plan (Régime de rentes du Québec) is a mandatory public insurance plan that provides basic financial protection to workers and their families.',
              keyPoints: [
                'Replaces 25% to 33% of average employment income',
                'Can start as early as age 60 (reduced) or as late as age 70 (increased)',
                'Standard retirement age is 65',
                'Amount based on your contributions during your working years',
                'Maximum monthly amount in 2024: ~\$1,364.60 at age 65',
              ],
            ),

            const SizedBox(height: 24),

            // OAS Section
            _buildBenefitCard(
              theme: theme,
              title: 'Old Age Security (OAS)',
              icon: Icons.elderly,
              color: Colors.green,
              description:
                  'Old Age Security is a federal monthly payment available to most Canadians aged 65 and older, regardless of employment history.',
              keyPoints: [
                'Available starting at age 65',
                'Based on years of residence in Canada after age 18',
                'Full pension requires 40 years of Canadian residence',
                'Maximum monthly amount in 2024: ~\$713.34',
                'Subject to income clawback for high earners',
              ],
            ),

            const SizedBox(height: 24),

            // GIS Section
            _buildBenefitCard(
              theme: theme,
              title: 'Guaranteed Income Supplement (GIS)',
              icon: Icons.volunteer_activism,
              color: Colors.orange,
              description:
                  'The Guaranteed Income Supplement is a monthly payment for low-income Old Age Security recipients living in Canada.',
              keyPoints: [
                'Available to OAS recipients with low income',
                'Income-tested based on previous year\'s income',
                'Maximum monthly amount varies based on marital status',
                'Automatically reviewed annually',
                'Not taxable income',
              ],
            ),

            const SizedBox(height: 32),

            // Important Notes
            Card(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Important Notes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildBullet(
                      theme,
                      'Amounts are indexed annually to inflation',
                    ),
                    _buildBullet(
                      theme,
                      'You must apply for these benefits - they are not automatic',
                    ),
                    _buildBullet(
                      theme,
                      'QPP and OAS amounts shown are maximums - your actual amount may vary',
                    ),
                    _buildBullet(
                      theme,
                      'Consider applying for QPP between ages 60-70 based on your situation',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Next Steps
            Text(
              'In the next section, you\'ll enter your expected retirement age and we\'ll help estimate your government benefits.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required List<String> keyPoints,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(
              'Key Points:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...keyPoints.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _buildBullet(theme, point),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBullet(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(
            Icons.check_circle,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
