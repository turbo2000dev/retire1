import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';
import 'package:retire1/features/scenarios/presentation/widgets/asset_override_section.dart';
import 'package:retire1/features/scenarios/presentation/widgets/event_override_section.dart';
import 'package:retire1/features/scenarios/presentation/widgets/expense_amount_override_section.dart';
import 'package:retire1/features/scenarios/presentation/widgets/expense_timing_override_section.dart';

/// Screen for editing a scenario and its parameter overrides
class ScenarioEditorScreen extends ConsumerStatefulWidget {
  final String scenarioId;

  const ScenarioEditorScreen({super.key, required this.scenarioId});

  @override
  ConsumerState<ScenarioEditorScreen> createState() =>
      _ScenarioEditorScreenState();
}

class _ScenarioEditorScreenState extends ConsumerState<ScenarioEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scenariosAsync = ref.watch(scenariosProvider);

    return scenariosAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/scenarios'),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/scenarios'),
          ),
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
                'Error loading scenarios',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/scenarios'),
                child: const Text('Back to Scenarios'),
              ),
            ],
          ),
        ),
      ),
      data: (scenarios) {
        final scenario = scenarios
            .where((s) => s.id == widget.scenarioId)
            .firstOrNull;

        if (scenario == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/scenarios'),
              ),
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
                  Text('Scenario not found', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/scenarios'),
                    child: const Text('Back to Scenarios'),
                  ),
                ],
              ),
            ),
          );
        }

        if (_nameController.text.isEmpty && !_isEditing) {
          _nameController.text = scenario.name;
        }

        return _buildEditor(context, theme, scenario);
      },
    );
  }

  Widget _buildEditor(
    BuildContext context,
    ThemeData theme,
    Scenario scenario,
  ) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scenarios'),
        ),
        title: Text(scenario.isBase ? 'Base Scenario' : 'Edit Scenario'),
        actions: [
          if (_isEditing) ...[
            TextButton(onPressed: _cancelEdit, child: const Text('Cancel')),
            const SizedBox(width: 8),
            FilledButton(onPressed: _saveScenario, child: const Text('Save')),
            const SizedBox(width: 16),
          ],
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Scenario Details Section
          SliverToBoxAdapter(
            child: ResponsiveContainer(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: scenario.isBase
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            scenario.isBase ? Icons.star : Icons.auto_awesome,
                            color: scenario.isBase
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSecondaryContainer,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (scenario.isBase)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'BASE SCENARIO',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              else
                                Text(
                                  'VARIATION SCENARIO',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.secondary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Text(
                                scenario.isBase
                                    ? 'Uses actual project values as the foundation'
                                    : 'Overrides specific parameters to explore alternatives',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Name Editor
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SCENARIO NAME',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (_isEditing)
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter scenario name',
                                border: OutlineInputBorder(),
                              ),
                              enabled: !scenario
                                  .isBase, // Can't edit base scenario name
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a scenario name';
                                }
                                if (value.trim().length < 3) {
                                  return 'Name must be at least 3 characters';
                                }
                                return null;
                              },
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    scenario.name,
                                    style: theme.textTheme.headlineMedium,
                                  ),
                                ),
                                if (!scenario.isBase)
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                                    icon: const Icon(Icons.edit),
                                    tooltip: 'Edit name',
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Parameter Overrides Section
          if (!scenario.isBase) ...[
            // Asset Overrides
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ASSET OVERRIDES',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AssetOverrideSection(scenario: scenario),
                ),
              ),
            ),
            // Event Overrides
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EVENT OVERRIDES',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: EventOverrideSection(scenario: scenario),
                ),
              ),
            ),
            // Expense Amount Overrides
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXPENSE AMOUNT OVERRIDES',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ExpenseAmountOverrideSection(scenario: scenario),
                ),
              ),
            ),
            // Expense Timing Overrides
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'EXPENSE TIMING OVERRIDES',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ExpenseTimingOverrideSection(scenario: scenario),
                ),
              ),
            ),
          ] else ...[
            // For base scenario, show info that it uses actual values
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                                'Base Scenario Values',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'The base scenario uses the actual values from your project parameters, assets, and events without any modifications. '
                            'Create variation scenarios to explore different assumptions and "what-if" situations.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      // Reset name to original
      final scenariosAsync = ref.read(scenariosProvider);
      scenariosAsync.whenData((scenarios) {
        final scenario = scenarios
            .where((s) => s.id == widget.scenarioId)
            .firstOrNull;
        if (scenario != null) {
          _nameController.text = scenario.name;
        }
      });
    });
  }

  Future<void> _saveScenario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final scenariosAsync = ref.read(scenariosProvider);
    final scenario = scenariosAsync.value
        ?.where((s) => s.id == widget.scenarioId)
        .firstOrNull;
    if (scenario == null) return;

    try {
      final updatedScenario = scenario.copyWith(
        name: _nameController.text.trim(),
      );

      await ref
          .read(scenariosProvider.notifier)
          .updateScenario(updatedScenario);

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scenario updated'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating scenario: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
