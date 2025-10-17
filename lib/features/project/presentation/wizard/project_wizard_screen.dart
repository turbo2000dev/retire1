import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';
import 'package:retire1/features/project/presentation/wizard/steps/wizard_individuals_step.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';

/// Main wizard screen with stepper navigation
class ProjectWizardScreen extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectWizardScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<ProjectWizardScreen> createState() => _ProjectWizardScreenState();
}

class _ProjectWizardScreenState extends ConsumerState<ProjectWizardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize wizard state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(wizardProvider.notifier).initialize(widget.projectId);
    });
  }

  Future<bool> _onWillPop() async {
    final wizardState = ref.read(wizardProvider);

    // If no data entered, just pop
    if (wizardState == null || !ref.read(wizardProvider.notifier).hasAnyData()) {
      return true;
    }

    // Show confirmation dialog
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Setup?'),
        content: const Text(
          'You\'ll lose your progress if you cancel now. Are you sure you want to exit the wizard?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Continue Setup'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit Wizard'),
          ),
        ],
      ),
    );

    if (shouldPop == true) {
      ref.read(wizardProvider.notifier).clear();
    }

    return shouldPop ?? false;
  }

  void _handleCancel() async {
    final shouldExit = await _onWillPop();
    if (shouldExit && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _handleNext() {
    final notifier = ref.read(wizardProvider.notifier);

    // Check if current step is valid
    if (!notifier.canProceedFromCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete required fields before proceeding'),
        ),
      );
      return;
    }

    notifier.nextStep();
  }

  void _handlePrevious() {
    ref.read(wizardProvider.notifier).previousStep();
  }

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardProvider);

    // Show loading if wizard not initialized
    if (wizardState == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Project Setup Wizard'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleCancel,
            tooltip: 'Cancel',
          ),
        ),
        body: ResponsiveBuilder(
          builder: (context, screenSize) {
            return Column(
              children: [
                // Progress indicator
                _buildProgressIndicator(wizardState.currentStep, screenSize),

                // Step content
                Expanded(
                  child: ResponsiveContainer(
                    child: _buildStepContent(wizardState.currentStep),
                  ),
                ),

                // Navigation buttons
                _buildNavigationButtons(wizardState.currentStep, screenSize),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep, ScreenSize screenSize) {
    final theme = Theme.of(context);
    final steps = [
      'Individuals',
      'Income Sources',
      'Assets',
      'Expenses',
      'Scenarios',
      'Summary',
    ];

    if (screenSize.isPhone) {
      // Compact progress for phone
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Project Setup',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Step ${currentStep + 1}/${steps.length}: ${steps[currentStep]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: (currentStep + 1) / steps.length,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: 6),
            Text(
              'You can refine all details later',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    } else {
      // Full stepper for tablet/desktop
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Project Setup Wizard',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'You can refine all details later',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(steps.length, (index) {
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _StepIndicator(
                          stepNumber: index + 1,
                          label: steps[index],
                          isActive: isActive,
                          isCompleted: isCompleted,
                        ),
                      ),
                      if (index < steps.length - 1)
                        Container(
                          height: 2,
                          width: 20,
                          color: isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildStepContent(int currentStep) {
    switch (currentStep) {
      case 0:
        // Step 1: Individuals (Phase 2 - Implemented)
        return const WizardIndividualsStep();

      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
        // Placeholder content for remaining steps
        final stepTitles = [
          'Step 1: Individuals',
          'Step 2: Income Sources',
          'Step 3: Assets',
          'Step 4: Expenses',
          'Step 5: Scenarios',
          'Step 6: Summary',
        ];

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.construction,
                  size: 64,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  stepTitles[currentStep],
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'This step will be implemented in Phase ${currentStep + 2}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(int currentStep, ScreenSize screenSize) {
    final theme = Theme.of(context);
    final isFirstStep = currentStep == 0;
    final isLastStep = currentStep == 5; // 6 steps (0-5)

    return Container(
      padding: EdgeInsets.all(screenSize.isPhone ? 16 : 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous/Cancel button
          if (isFirstStep)
            OutlinedButton.icon(
              onPressed: _handleCancel,
              icon: const Icon(Icons.close),
              label: const Text('Cancel'),
            )
          else
            OutlinedButton.icon(
              onPressed: _handlePrevious,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            ),

          // Next/Complete button
          FilledButton.icon(
            onPressed: isLastStep ? _handleComplete : _handleNext,
            icon: Icon(isLastStep ? Icons.check : Icons.arrow_forward),
            label: Text(isLastStep ? 'Complete Setup' : 'Next'),
            iconAlignment: IconAlignment.end,
          ),
        ],
      ),
    );
  }

  void _handleComplete() {
    // TODO: Implement data commitment in Phase 7
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Complete functionality will be implemented in Phase 7'),
      ),
    );
  }
}

/// Step indicator widget for desktop stepper
class _StepIndicator extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.stepNumber,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color circleColor;
    Color textColor;
    IconData? icon;

    if (isCompleted) {
      circleColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
      icon = Icons.check;
    } else if (isActive) {
      circleColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
    } else {
      circleColor = theme.colorScheme.surfaceContainerHigh;
      textColor = theme.colorScheme.onSurfaceVariant;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: isActive && !isCompleted
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, color: textColor, size: 16)
                : Text(
                    stepNumber.toString(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
