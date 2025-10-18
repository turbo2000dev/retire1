import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_state.dart';

/// Step 5: Select scenario variations to create
class WizardScenariosStep extends ConsumerStatefulWidget {
  const WizardScenariosStep({super.key});

  @override
  ConsumerState<WizardScenariosStep> createState() =>
      _WizardScenariosStepState();
}

class _WizardScenariosStepState extends ConsumerState<WizardScenariosStep> {
  // Base scenario is always created (required)
  bool _createBase = true; // Always true, disabled checkbox
  bool _createOptimistic = false;
  bool _createPessimistic = false;
  bool _createEarlyRetirement = false;
  bool _createLateRetirement = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final wizardState = ref.read(wizardProvider);
    if (wizardState == null) return;

    final scenariosData = wizardState.scenarios;

    _createBase = scenariosData.createBase; // Always true
    _createOptimistic = scenariosData.createOptimistic;
    _createPessimistic = scenariosData.createPessimistic;
    _createEarlyRetirement = scenariosData.createEarlyRetirement;
    _createLateRetirement = scenariosData.createLateRetirement;
  }

  void _saveData() {
    final data = WizardScenariosData(
      createBase: true, // Always true
      createOptimistic: _createOptimistic,
      createPessimistic: _createPessimistic,
      createEarlyRetirement: _createEarlyRetirement,
      createLateRetirement: _createLateRetirement,
    );

    ref.read(wizardProvider.notifier).updateScenarios(data);
  }

  int get _selectedCount {
    int count = 1; // Base is always selected
    if (_createOptimistic) count++;
    if (_createPessimistic) count++;
    if (_createEarlyRetirement) count++;
    if (_createLateRetirement) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = ref.watch(wizardProvider);

    if (wizardState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.isPhone ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brief step description
              Text(
                'Choose which scenario variations to create',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can customize or create additional scenarios later',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Base scenario (required, always checked, disabled)
              _buildScenarioCard(
                theme: theme,
                title: 'Base Scenario',
                badge: 'REQUIRED',
                badgeColor: theme.colorScheme.primary,
                description:
                    'Your main retirement plan using all the information you\'ve entered. This scenario is always created and serves as the foundation for comparison.',
                icon: Icons.account_balance_outlined,
                iconColor: theme.colorScheme.primary,
                value: _createBase,
                enabled: false, // Disabled - always checked
                onChanged: null,
                details: [
                  'Uses all entered data without modifications',
                  'Serves as baseline for comparison',
                  'Cannot be deleted',
                ],
              ),
              const SizedBox(height: 16),

              // Optimistic scenario
              _buildScenarioCard(
                theme: theme,
                title: 'Optimistic Scenario',
                description:
                    'A best-case scenario with higher investment returns and longer life expectancy. Useful for planning stretch goals and understanding upside potential.',
                icon: Icons.trending_up,
                iconColor: Colors.green,
                value: _createOptimistic,
                enabled: true,
                onChanged: (value) {
                  setState(() => _createOptimistic = value ?? false);
                  _saveData();
                },
                details: [
                  '+1% on all investment returns',
                  '+3 years to life expectancy',
                  'Shows potential upside',
                ],
              ),
              const SizedBox(height: 16),

              // Pessimistic scenario
              _buildScenarioCard(
                theme: theme,
                title: 'Pessimistic Scenario',
                description:
                    'A worst-case scenario with lower investment returns and higher expenses. Helps stress-test your plan and identify potential shortfalls.',
                icon: Icons.trending_down,
                iconColor: Colors.red,
                value: _createPessimistic,
                enabled: true,
                onChanged: (value) {
                  setState(() => _createPessimistic = value ?? false);
                  _saveData();
                },
                details: [
                  '-1% on all investment returns',
                  '+10% on all expenses',
                  'Stress-tests your plan',
                ],
              ),
              const SizedBox(height: 16),

              // Early retirement scenario
              _buildScenarioCard(
                theme: theme,
                title: 'Early Retirement',
                description:
                    'Explore retiring 5 years earlier than planned. This scenario shows if early retirement is financially feasible with your current savings.',
                icon: Icons.beach_access,
                iconColor: Colors.orange,
                value: _createEarlyRetirement,
                enabled: true,
                onChanged: (value) {
                  setState(() => _createEarlyRetirement = value ?? false);
                  _saveData();
                },
                details: [
                  '-5 years to retirement age (both individuals)',
                  'Earlier start to pension withdrawals',
                  'Tests feasibility of early retirement',
                ],
              ),
              const SizedBox(height: 16),

              // Late retirement scenario
              _buildScenarioCard(
                theme: theme,
                title: 'Late Retirement',
                description:
                    'Explore working 5 years longer than planned. This scenario shows the financial benefits of extended employment and delayed pension start.',
                icon: Icons.work_outline,
                iconColor: Colors.blue,
                value: _createLateRetirement,
                enabled: true,
                onChanged: (value) {
                  setState(() => _createLateRetirement = value ?? false);
                  _saveData();
                },
                details: [
                  '+5 years to retirement age (both individuals)',
                  'Later start to pension withdrawals',
                  'Shows benefits of working longer',
                ],
              ),
              const SizedBox(height: 24),

              // Summary card
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.summarize, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedCount == 1
                              ? '1 scenario will be created (Base only)'
                              : '$_selectedCount scenarios will be created',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScenarioCard({
    required ThemeData theme,
    required String title,
    String? badge,
    Color? badgeColor,
    required String description,
    required IconData icon,
    required Color iconColor,
    required bool value,
    required bool enabled,
    required ValueChanged<bool?>? onChanged,
    required List<String> details,
  }) {
    return Card(
      elevation: value ? 3 : 1,
      color: value && enabled
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: InkWell(
        onTap: enabled
            ? () {
                if (onChanged != null) {
                  onChanged(!value);
                }
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  Checkbox(value: value, onChanged: enabled ? onChanged : null),
                  const SizedBox(width: 12),

                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: iconColor, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // Title and badge
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (badge != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      badgeColor ?? theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  badge,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Padding(
                padding: const EdgeInsets.only(left: 64),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Details bullets
                    ...details.map(
                      (detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                detail,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
