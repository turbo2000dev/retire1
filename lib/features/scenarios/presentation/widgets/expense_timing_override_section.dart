import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/events/presentation/widgets/timing_selector.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Section for managing expense timing overrides in a scenario
class ExpenseTimingOverrideSection extends ConsumerWidget {
  final Scenario scenario;

  const ExpenseTimingOverrideSection({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expensesAsync = ref.watch(expensesProvider);
    final eventsAsync = ref.watch(eventsProvider);
    final projectState = ref.watch(currentProjectProvider);

    return expensesAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Card(
        color: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load expenses',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (expenses) {
        if (expenses.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 48,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No expenses available',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add expenses in the Assets & Events screen to override their timing here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Get project individuals for the timing selector
        final individuals = projectState is ProjectSelected
            ? projectState.project.individuals
            : <Individual>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Override expense timing (start and/or end dates) to explore different scenarios.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...expenses.map((expense) {
              return eventsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (events) => _ExpenseTimingOverrideCard(
                  expense: expense,
                  scenario: scenario,
                  individuals: individuals,
                  events: events,
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

/// Card for a single expense timing override
class _ExpenseTimingOverrideCard extends ConsumerStatefulWidget {
  final Expense expense;
  final Scenario scenario;
  final List<Individual> individuals;
  final List<Event> events;

  const _ExpenseTimingOverrideCard({
    required this.expense,
    required this.scenario,
    required this.individuals,
    required this.events,
  });

  @override
  ConsumerState<_ExpenseTimingOverrideCard> createState() =>
      _ExpenseTimingOverrideCardState();
}

class _ExpenseTimingOverrideCardState
    extends ConsumerState<_ExpenseTimingOverrideCard> {
  bool _isEditingStart = false;
  bool _isEditingEnd = false;
  EventTiming? _newStartTiming;
  EventTiming? _newEndTiming;

  IconData _getExpenseIcon() {
    return widget.expense.when(
      housing: (_, __, ___, ____) => Icons.home,
      transport: (_, __, ___, ____) => Icons.directions_car,
      dailyLiving: (_, __, ___, ____) => Icons.shopping_cart,
      recreation: (_, __, ___, ____) => Icons.theater_comedy,
      health: (_, __, ___, ____) => Icons.medical_services,
      family: (_, __, ___, ____) => Icons.family_restroom,
    );
  }

  Color _getExpenseColor(BuildContext context) {
    final theme = Theme.of(context);
    return widget.expense.when(
      housing: (_, __, ___, ____) => theme.colorScheme.primary,
      transport: (_, __, ___, ____) => theme.colorScheme.secondary,
      dailyLiving: (_, __, ___, ____) => theme.colorScheme.tertiary,
      recreation: (_, __, ___, ____) => Colors.purple,
      health: (_, __, ___, ____) => Colors.red,
      family: (_, __, ___, ____) => Colors.orange,
    );
  }

  EventTiming _getBaseStartTiming() {
    return widget.expense.when(
      housing: (id, startTiming, endTiming, annualAmount) => startTiming,
      transport: (id, startTiming, endTiming, annualAmount) => startTiming,
      dailyLiving: (id, startTiming, endTiming, annualAmount) => startTiming,
      recreation: (id, startTiming, endTiming, annualAmount) => startTiming,
      health: (id, startTiming, endTiming, annualAmount) => startTiming,
      family: (id, startTiming, endTiming, annualAmount) => startTiming,
    );
  }

  EventTiming _getBaseEndTiming() {
    return widget.expense.when(
      housing: (id, startTiming, endTiming, annualAmount) => endTiming,
      transport: (id, startTiming, endTiming, annualAmount) => endTiming,
      dailyLiving: (id, startTiming, endTiming, annualAmount) => endTiming,
      recreation: (id, startTiming, endTiming, annualAmount) => endTiming,
      health: (id, startTiming, endTiming, annualAmount) => endTiming,
      family: (id, startTiming, endTiming, annualAmount) => endTiming,
    );
  }

  String _formatTiming(EventTiming timing) {
    return timing.when(
      relative: (yearsFromStart) => '$yearsFromStart years from start',
      absolute: (calendarYear) => 'Year $calendarYear',
      age: (individualId, age) {
        final individual = widget.individuals
            .where((i) => i.id == individualId)
            .firstOrNull;
        final name = individual?.name ?? 'Unknown';
        return 'When $name reaches age $age';
      },
      eventRelative: (eventId, boundary) {
        final boundaryText = boundary == EventBoundary.start ? 'start' : 'end';
        return 'At $boundaryText of event';
      },
      projectionEnd: () => 'End of projection',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expenseId = widget.expense.when(
      housing: (id, startTiming, endTiming, annualAmount) => id,
      transport: (id, startTiming, endTiming, annualAmount) => id,
      dailyLiving: (id, startTiming, endTiming, annualAmount) => id,
      recreation: (id, startTiming, endTiming, annualAmount) => id,
      health: (id, startTiming, endTiming, annualAmount) => id,
      family: (id, startTiming, endTiming, annualAmount) => id,
    );

    // Check if there's an override for this expense
    final override = widget.scenario.overrides
        .where((o) => o.maybeWhen(
              expenseTiming: (id, overrideStart, overrideEnd) =>
                  id == expenseId,
              orElse: () => false,
            ))
        .firstOrNull;

    final overrideStartTiming = override?.maybeWhen(
      expenseTiming: (id, overrideStart, overrideEnd) => overrideStart,
      orElse: () => null,
    );

    final overrideEndTiming = override?.maybeWhen(
      expenseTiming: (id, overrideStart, overrideEnd) => overrideEnd,
      orElse: () => null,
    );

    final isOverridden = overrideStartTiming != null || overrideEndTiming != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverridden
          ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getExpenseColor(context).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getExpenseIcon(),
                    color: _getExpenseColor(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expense.categoryName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Base Start: ${_formatTiming(_getBaseStartTiming())}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        'Base End: ${_formatTiming(_getBaseEndTiming())}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOverridden)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OVERRIDDEN',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isEditingStart || _isEditingEnd) ...[
              if (_isEditingStart) ...[
                Text(
                  'Override Start Timing',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                TimingSelector(
                  initialTiming: overrideStartTiming ?? _getBaseStartTiming(),
                  individuals: widget.individuals,
                  events: widget.events,
                  onChanged: (timing) {
                    _newStartTiming = timing;
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (_isEditingEnd) ...[
                Text(
                  'Override End Timing',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                TimingSelector(
                  initialTiming: overrideEndTiming ?? _getBaseEndTiming(),
                  individuals: widget.individuals,
                  events: widget.events,
                  onChanged: (timing) {
                    _newEndTiming = timing;
                  },
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditingStart = false;
                        _isEditingEnd = false;
                        _newStartTiming = null;
                        _newEndTiming = null;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saveOverride,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ] else ...[
              if (isOverridden) ...[
                if (overrideStartTiming != null) ...[
                  Text(
                    'Override Start: ${_formatTiming(overrideStartTiming)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (overrideEndTiming != null) ...[
                  Text(
                    'Override End: ${_formatTiming(overrideEndTiming)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditingStart = true;
                          _isEditingEnd = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _removeOverride,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Remove'),
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {
                        setState(() {
                          _isEditingStart = true;
                        });
                      },
                      icon: const Icon(Icons.schedule),
                      label: const Text('Override Start'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        setState(() {
                          _isEditingEnd = true;
                        });
                      },
                      icon: const Icon(Icons.event_busy),
                      label: const Text('Override End'),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveOverride() async {
    try {
      final expenseId = widget.expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => id,
        transport: (id, startTiming, endTiming, annualAmount) => id,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => id,
        recreation: (id, startTiming, endTiming, annualAmount) => id,
        health: (id, startTiming, endTiming, annualAmount) => id,
        family: (id, startTiming, endTiming, annualAmount) => id,
      );

      // Remove existing timing override if present
      final existingOverride = widget.scenario.overrides
          .where((o) => o.maybeWhen(
                expenseTiming: (id, overrideStart, overrideEnd) =>
                    id == expenseId,
                orElse: () => false,
              ))
          .firstOrNull;

      if (existingOverride != null) {
        await ref
            .read(scenariosProvider.notifier)
            .removeOverride(widget.scenario.id, existingOverride);
      }

      // Determine which timings to use
      final existingStartOverride = existingOverride?.maybeWhen(
        expenseTiming: (id, overrideStart, overrideEnd) => overrideStart,
        orElse: () => null,
      );

      final existingEndOverride = existingOverride?.maybeWhen(
        expenseTiming: (id, overrideStart, overrideEnd) => overrideEnd,
        orElse: () => null,
      );

      final finalStartTiming =
          _isEditingStart ? _newStartTiming : existingStartOverride;
      final finalEndTiming =
          _isEditingEnd ? _newEndTiming : existingEndOverride;

      // Only create override if at least one timing is specified
      if (finalStartTiming != null || finalEndTiming != null) {
        final override = ParameterOverride.expenseTiming(
          expenseId: expenseId,
          overrideStartTiming: finalStartTiming,
          overrideEndTiming: finalEndTiming,
        );

        await ref
            .read(scenariosProvider.notifier)
            .addOverride(widget.scenario.id, override);
      }

      setState(() {
        _isEditingStart = false;
        _isEditingEnd = false;
        _newStartTiming = null;
        _newEndTiming = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Override saved'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving override: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeOverride() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Override'),
        content: const Text('Remove this timing override and use the base timing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final expenseId = widget.expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => id,
        transport: (id, startTiming, endTiming, annualAmount) => id,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => id,
        recreation: (id, startTiming, endTiming, annualAmount) => id,
        health: (id, startTiming, endTiming, annualAmount) => id,
        family: (id, startTiming, endTiming, annualAmount) => id,
      );

      final override = widget.scenario.overrides
          .where((o) => o.maybeWhen(
                expenseTiming: (id, overrideStart, overrideEnd) =>
                    id == expenseId,
                orElse: () => false,
              ))
          .firstOrNull;

      if (override != null) {
        await ref
            .read(scenariosProvider.notifier)
            .removeOverride(widget.scenario.id, override);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Override removed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing override: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
