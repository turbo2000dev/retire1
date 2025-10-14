import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Section for managing expense amount overrides in a scenario
/// Supports both absolute amounts and multipliers
class ExpenseAmountOverrideSection extends ConsumerWidget {
  final Scenario scenario;

  const ExpenseAmountOverrideSection({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final expensesAsync = ref.watch(expensesProvider);

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
                    'Add expenses in the Assets & Events screen to override their amounts here',
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Override expense amounts to explore different scenarios. '
              'You can set absolute amounts or use multipliers.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            // Section 1: Absolute Amount Overrides
            Text(
              'Absolute Amount Overrides',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set specific dollar amounts for expenses',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...expenses.map((expense) {
              return _ExpenseAmountOverrideCard(
                expense: expense,
                scenario: scenario,
                isMultiplier: false,
              );
            }),
            const SizedBox(height: 32),
            // Section 2: Multiplier Overrides
            Text(
              'Multiplier Overrides',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scale expenses by percentage (e.g., 1.5 = 150%, 0.5 = 50%, 0.0 = eliminate)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...expenses.map((expense) {
              return _ExpenseAmountOverrideCard(
                expense: expense,
                scenario: scenario,
                isMultiplier: true,
              );
            }),
          ],
        );
      },
    );
  }
}

/// Card for a single expense amount override
class _ExpenseAmountOverrideCard extends ConsumerStatefulWidget {
  final Expense expense;
  final Scenario scenario;
  final bool isMultiplier; // true = multiplier mode, false = absolute amount mode

  const _ExpenseAmountOverrideCard({
    required this.expense,
    required this.scenario,
    required this.isMultiplier,
  });

  @override
  ConsumerState<_ExpenseAmountOverrideCard> createState() =>
      _ExpenseAmountOverrideCardState();
}

class _ExpenseAmountOverrideCardState
    extends ConsumerState<_ExpenseAmountOverrideCard> {
  final _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  double _getBaseAmount() {
    return widget.expense.when(
      housing: (id, startTiming, endTiming, annualAmount) => annualAmount,
      transport: (id, startTiming, endTiming, annualAmount) => annualAmount,
      dailyLiving: (id, startTiming, endTiming, annualAmount) => annualAmount,
      recreation: (id, startTiming, endTiming, annualAmount) => annualAmount,
      health: (id, startTiming, endTiming, annualAmount) => annualAmount,
      family: (id, startTiming, endTiming, annualAmount) => annualAmount,
    );
  }

  String _formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        )}';
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

    // Check if there's an override for this expense (matching the mode)
    final override = widget.scenario.overrides
        .where((o) => o.maybeWhen(
              expenseAmount: (id, overrideAmount, amountMultiplier) {
                if (id != expenseId) return false;
                // Match the mode: absolute has overrideAmount, multiplier has amountMultiplier
                if (widget.isMultiplier) {
                  return amountMultiplier != null;
                } else {
                  return overrideAmount != null;
                }
              },
              orElse: () => false,
            ))
        .firstOrNull;

    final overrideValue = override?.maybeWhen(
      expenseAmount: (id, overrideAmount, amountMultiplier) =>
          widget.isMultiplier ? amountMultiplier : overrideAmount,
      orElse: () => null,
    );

    final isOverridden = overrideValue != null;

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
                        'Base: ${_formatCurrency(_getBaseAmount())} / year',
                        style: theme.textTheme.bodyMedium?.copyWith(
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
            const SizedBox(height: 12),
            if (_isEditing) ...[
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: widget.isMultiplier
                      ? 'Override Multiplier'
                      : 'Override Amount (\$)',
                  hintText: widget.isMultiplier
                      ? 'e.g., 1.5 for 150%'
                      : 'Enter annual amount',
                  border: const OutlineInputBorder(),
                  helperText: widget.isMultiplier
                      ? 'Multiplier: 1.0 = same, 1.5 = 150%, 0.5 = 50%, 0.0 = eliminate'
                      : 'Absolute amount in dollars per year',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _controller.clear();
                      });
                    },
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                autofocus: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _controller.clear();
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
              Row(
                children: [
                  if (isOverridden) ...[
                    Expanded(
                      child: Text(
                        widget.isMultiplier
                            ? 'Override: ${overrideValue!.toStringAsFixed(2)}x (${(overrideValue * 100).toStringAsFixed(0)}%)'
                            : 'Override: ${_formatCurrency(overrideValue!)} / year',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller.text = overrideValue.toString();
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit override',
                    ),
                    IconButton(
                      onPressed: _removeOverride,
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Remove override',
                      color: theme.colorScheme.error,
                    ),
                  ] else ...[
                    const Spacer(),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        if (widget.isMultiplier) {
                          _controller.text = '1.0';
                        } else {
                          _controller.text = _getBaseAmount().toStringAsFixed(0);
                        }
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: Text(widget.isMultiplier
                          ? 'Add Multiplier'
                          : 'Add Override'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveOverride() async {
    final value = double.tryParse(_controller.text);
    if (value == null || value < 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid positive number'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // For multiplier mode, allow 0.0
    // For absolute mode, value >= 0 is already checked above

    try {
      final expenseId = widget.expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => id,
        transport: (id, startTiming, endTiming, annualAmount) => id,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => id,
        recreation: (id, startTiming, endTiming, annualAmount) => id,
        health: (id, startTiming, endTiming, annualAmount) => id,
        family: (id, startTiming, endTiming, annualAmount) => id,
      );

      // First, remove any existing override for this expense (both types)
      final existingOverrides = widget.scenario.overrides
          .where((o) => o.maybeWhen(
                expenseAmount: (id, overrideAmount, amountMultiplier) =>
                    id == expenseId,
                orElse: () => false,
              ))
          .toList();

      for (final existing in existingOverrides) {
        await ref
            .read(scenariosProvider.notifier)
            .removeOverride(widget.scenario.id, existing);
      }

      // Create the appropriate override
      final override = widget.isMultiplier
          ? ParameterOverride.expenseAmount(
              expenseId: expenseId,
              amountMultiplier: value,
            )
          : ParameterOverride.expenseAmount(
              expenseId: expenseId,
              overrideAmount: value,
            );

      await ref
          .read(scenariosProvider.notifier)
          .addOverride(widget.scenario.id, override);

      setState(() {
        _isEditing = false;
        _controller.clear();
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
        content: const Text('Remove this override and use the base amount?'),
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
                expenseAmount: (id, overrideAmount, amountMultiplier) {
                  if (id != expenseId) return false;
                  if (widget.isMultiplier) {
                    return amountMultiplier != null;
                  } else {
                    return overrideAmount != null;
                  }
                },
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
