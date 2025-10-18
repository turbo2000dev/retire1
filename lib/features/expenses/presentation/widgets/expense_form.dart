import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/widgets/timing_selector.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// Expense category type for form
enum ExpenseType { housing, transport, dailyLiving, recreation, health, family }

/// Reusable form for creating or editing expenses
class ExpenseForm extends ConsumerStatefulWidget {
  final ExpenseType? expenseType; // For creating new expenses
  final Expense? expense; // For editing existing expenses
  final List<Individual> individuals;
  final List<Event>?
  events; // Optional list of events for event-relative timing
  final void Function(Expense, {bool createAnother}) onSave;
  final VoidCallback? onCancel;

  const ExpenseForm({
    super.key,
    this.expenseType,
    this.expense,
    required this.individuals,
    this.events,
    required this.onSave,
    this.onCancel,
  }) : assert(
         expenseType != null || expense != null,
         'Either expenseType or expense must be provided',
       );

  @override
  ConsumerState<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _annualAmountController = TextEditingController();

  EventTiming? _startTiming;
  EventTiming? _endTiming;

  @override
  void initState() {
    super.initState();

    // Initialize from existing expense if editing
    if (widget.expense != null) {
      widget.expense!.when(
        housing: (_, startTiming, endTiming, annualAmount) =>
            _initializeFields(startTiming, endTiming, annualAmount),
        transport: (_, startTiming, endTiming, annualAmount) =>
            _initializeFields(startTiming, endTiming, annualAmount),
        dailyLiving: (_, startTiming, endTiming, annualAmount) =>
            _initializeFields(startTiming, endTiming, annualAmount),
        recreation: (_, startTiming, endTiming, annualAmount) =>
            _initializeFields(startTiming, endTiming, annualAmount),
        health: (_, startTiming, endTiming, annualAmount) =>
            _initializeFields(startTiming, endTiming, annualAmount),
        family: (_, startTiming, endTiming, annualAmount) =>
            _initializeFields(startTiming, endTiming, annualAmount),
      );
    } else {
      // Default timings for new expenses
      _startTiming = const EventTiming.relative(yearsFromStart: 0);
      _endTiming = const EventTiming.projectionEnd();
    }
  }

  void _initializeFields(
    EventTiming startTiming,
    EventTiming endTiming,
    double annualAmount,
  ) {
    _startTiming = startTiming;
    _endTiming = endTiming;
    _annualAmountController.text = annualAmount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _annualAmountController.dispose();
    super.dispose();
  }

  void _submit({bool createAnother = false}) {
    if (!_formKey.currentState!.validate()) return;

    if (_startTiming == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please configure start timing')),
      );
      return;
    }

    if (_endTiming == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please configure end timing')),
      );
      return;
    }

    final id =
        widget.expense?.when(
          housing: (id, _, __, ___) => id,
          transport: (id, _, __, ___) => id,
          dailyLiving: (id, _, __, ___) => id,
          recreation: (id, _, __, ___) => id,
          health: (id, _, __, ___) => id,
          family: (id, _, __, ___) => id,
        ) ??
        DateTime.now().millisecondsSinceEpoch.toString();

    final annualAmount = double.parse(
      _annualAmountController.text.replaceAll(',', ''),
    );

    // Create expense with same type as existing or from expenseType (for new)
    final Expense expense;
    if (widget.expense != null) {
      // Editing existing expense - preserve type
      expense = widget.expense!.when(
        housing: (_, __, ___, ____) => Expense.housing(
          id: id,
          startTiming: _startTiming!,
          endTiming: _endTiming!,
          annualAmount: annualAmount,
        ),
        transport: (_, __, ___, ____) => Expense.transport(
          id: id,
          startTiming: _startTiming!,
          endTiming: _endTiming!,
          annualAmount: annualAmount,
        ),
        dailyLiving: (_, __, ___, ____) => Expense.dailyLiving(
          id: id,
          startTiming: _startTiming!,
          endTiming: _endTiming!,
          annualAmount: annualAmount,
        ),
        recreation: (_, __, ___, ____) => Expense.recreation(
          id: id,
          startTiming: _startTiming!,
          endTiming: _endTiming!,
          annualAmount: annualAmount,
        ),
        health: (_, __, ___, ____) => Expense.health(
          id: id,
          startTiming: _startTiming!,
          endTiming: _endTiming!,
          annualAmount: annualAmount,
        ),
        family: (_, __, ___, ____) => Expense.family(
          id: id,
          startTiming: _startTiming!,
          endTiming: _endTiming!,
          annualAmount: annualAmount,
        ),
      );
    } else {
      // Creating new expense - use expenseType
      switch (widget.expenseType!) {
        case ExpenseType.housing:
          expense = Expense.housing(
            id: id,
            startTiming: _startTiming!,
            endTiming: _endTiming!,
            annualAmount: annualAmount,
          );
          break;
        case ExpenseType.transport:
          expense = Expense.transport(
            id: id,
            startTiming: _startTiming!,
            endTiming: _endTiming!,
            annualAmount: annualAmount,
          );
          break;
        case ExpenseType.dailyLiving:
          expense = Expense.dailyLiving(
            id: id,
            startTiming: _startTiming!,
            endTiming: _endTiming!,
            annualAmount: annualAmount,
          );
          break;
        case ExpenseType.recreation:
          expense = Expense.recreation(
            id: id,
            startTiming: _startTiming!,
            endTiming: _endTiming!,
            annualAmount: annualAmount,
          );
          break;
        case ExpenseType.health:
          expense = Expense.health(
            id: id,
            startTiming: _startTiming!,
            endTiming: _endTiming!,
            annualAmount: annualAmount,
          );
          break;
        case ExpenseType.family:
          expense = Expense.family(
            id: id,
            startTiming: _startTiming!,
            endTiming: _endTiming!,
            annualAmount: annualAmount,
          );
          break;
      }
    }

    widget.onSave(expense, createAnother: createAnother);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Annual amount field
            TextFormField(
              controller: _annualAmountController,
              decoration: const InputDecoration(
                labelText: 'Annual Amount',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
                helperText: 'Total amount per year in current dollars',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an annual amount';
                }
                final numValue = double.tryParse(value.replaceAll(',', ''));
                if (numValue == null || numValue < 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Start timing
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TimingSelector(
                      initialTiming: _startTiming,
                      individuals: widget.individuals,
                      events: widget.events,
                      onChanged: (timing) {
                        setState(() {
                          _startTiming = timing;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // End timing (required, defaults to projection end)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'End',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TimingSelector(
                      initialTiming: _endTiming,
                      individuals: widget.individuals,
                      events: widget.events,
                      onChanged: (timing) {
                        setState(() {
                          _endTiming = timing;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                if (widget.onCancel != null) const SizedBox(width: 8),
                // Show "Save and create another" only when creating new expense
                if (widget.expense == null) ...[
                  FilledButton.tonal(
                    onPressed: widget.individuals.isEmpty
                        ? null
                        : () => _submit(createAnother: true),
                    child: const Text('Save and create another'),
                  ),
                  const SizedBox(width: 8),
                ],
                FilledButton(
                  onPressed: widget.individuals.isEmpty ? null : _submit,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
