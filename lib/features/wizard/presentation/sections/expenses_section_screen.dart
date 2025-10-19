import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:uuid/uuid.dart';

/// Expenses section - Set up initial annual expense estimates
class ExpensesSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const ExpensesSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<ExpensesSectionScreen> createState() =>
      _ExpensesSectionScreenState();
}

class _ExpensesSectionScreenState extends ConsumerState<ExpensesSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;
  bool _isSaving = false;
  List<Expense> _existingExpenses = [];

  // Expense categories with default values
  final Map<String, Map<String, dynamic>> _expenseCategories = {
    'housing': {
      'name': 'Housing',
      'icon': Icons.home,
      'color': Colors.blue,
      'default': 24000,
      'hint': 'Mortgage, rent, property tax, utilities',
    },
    'transport': {
      'name': 'Transport',
      'icon': Icons.directions_car,
      'color': Colors.green,
      'default': 8000,
      'hint': 'Car payments, gas, insurance, transit',
    },
    'dailyLiving': {
      'name': 'Daily Living',
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
      'default': 12000,
      'hint': 'Groceries, clothing, personal care',
    },
    'recreation': {
      'name': 'Recreation',
      'icon': Icons.theater_comedy,
      'color': Colors.purple,
      'default': 6000,
      'hint': 'Entertainment, hobbies, dining, travel',
    },
    'health': {
      'name': 'Health',
      'icon': Icons.health_and_safety,
      'color': Colors.red,
      'default': 4000,
      'hint': 'Insurance, medical, prescriptions',
    },
    'family': {
      'name': 'Family',
      'icon': Icons.family_restroom,
      'color': Colors.pink,
      'default': 3000,
      'hint': 'Childcare, education, family support',
    },
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      // Load existing expenses
      final expensesAsync = ref.read(expensesProvider);
      await expensesAsync.when(
        data: (expenses) async {
          _existingExpenses = expenses;
        },
        loading: () async {
          // Initialize with empty list if still loading
          _existingExpenses = [];
        },
        error: (e, s) => throw e,
      );

      // Initialize controllers with existing values or defaults
      for (var category in _expenseCategories.keys) {
        final existingExpense = _getExpenseForCategory(category);
        final defaultAmount = _expenseCategories[category]!['default'];
        _controllers[category] = TextEditingController(
          text: existingExpense != null
              ? existingExpense.annualAmount.toStringAsFixed(0)
              : defaultAmount.toString(),
        );
      }

      // Register validation callback
      widget.onRegisterCallback?.call(_validateAndContinue);

      if (mounted) {
        setState(() => _isLoading = false);

        // Mark section as in progress
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus(
                'expenses',
                WizardSectionStatus.inProgress(),
              );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading expenses: $e')));
      }
    }
  }

  Expense? _getExpenseForCategory(String category) {
    try {
      return _existingExpenses.firstWhere(
        (expense) => expense.when(
          housing: (_, __, ___, ____) => category == 'housing',
          transport: (_, __, ___, ____) => category == 'transport',
          dailyLiving: (_, __, ___, ____) => category == 'dailyLiving',
          recreation: (_, __, ___, ____) => category == 'recreation',
          health: (_, __, ___, ____) => category == 'health',
          family: (_, __, ___, ____) => category == 'family',
        ),
      );
    } catch (e) {
      return null; // No matching expense found
    }
  }

  Future<bool> _validateAndContinue() async {
    if (_isSaving) return false;

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    setState(() => _isSaving = true);

    try {
      final uuid = const Uuid();
      final notifier = ref.read(expensesProvider.notifier);

      // Create or update expenses for each category
      for (var category in _expenseCategories.keys) {
        final controller = _controllers[category]!;
        final amountText = controller.text.trim();

        if (amountText.isEmpty) continue; // Skip empty categories

        final amount = double.parse(amountText);
        if (amount == 0) continue; // Skip zero amounts

        final existingExpense = _getExpenseForCategory(category);

        // Default timing: from projection start to projection end
        final startTiming = EventTiming.relative(yearsFromStart: 0);
        final endTiming = EventTiming.projectionEnd();

        final Expense expense;
        if (existingExpense != null) {
          // Update existing expense
          expense = _updateExpenseAmount(existingExpense, amount);
          await notifier.updateExpense(expense);
        } else {
          // Create new expense
          expense = _createExpense(
            category,
            uuid.v4(),
            amount,
            startTiming,
            endTiming,
          );
          await notifier.addExpense(expense);
        }
      }

      // Mark section as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('expenses', WizardSectionStatus.complete());

      if (mounted) {
        setState(() => _isSaving = false);
      }

      return true;
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
      return false;
    }
  }

  Expense _createExpense(
    String category,
    String id,
    double amount,
    EventTiming startTiming,
    EventTiming endTiming,
  ) {
    return switch (category) {
      'housing' => Expense.housing(
        id: id,
        startTiming: startTiming,
        endTiming: endTiming,
        annualAmount: amount,
      ),
      'transport' => Expense.transport(
        id: id,
        startTiming: startTiming,
        endTiming: endTiming,
        annualAmount: amount,
      ),
      'dailyLiving' => Expense.dailyLiving(
        id: id,
        startTiming: startTiming,
        endTiming: endTiming,
        annualAmount: amount,
      ),
      'recreation' => Expense.recreation(
        id: id,
        startTiming: startTiming,
        endTiming: endTiming,
        annualAmount: amount,
      ),
      'health' => Expense.health(
        id: id,
        startTiming: startTiming,
        endTiming: endTiming,
        annualAmount: amount,
      ),
      'family' => Expense.family(
        id: id,
        startTiming: startTiming,
        endTiming: endTiming,
        annualAmount: amount,
      ),
      _ => throw Exception('Unknown expense category: $category'),
    };
  }

  Expense _updateExpenseAmount(Expense expense, double newAmount) {
    return expense.when(
      housing: (id, start, end, _) => Expense.housing(
        id: id,
        startTiming: start,
        endTiming: end,
        annualAmount: newAmount,
      ),
      transport: (id, start, end, _) => Expense.transport(
        id: id,
        startTiming: start,
        endTiming: end,
        annualAmount: newAmount,
      ),
      dailyLiving: (id, start, end, _) => Expense.dailyLiving(
        id: id,
        startTiming: start,
        endTiming: end,
        annualAmount: newAmount,
      ),
      recreation: (id, start, end, _) => Expense.recreation(
        id: id,
        startTiming: start,
        endTiming: end,
        annualAmount: newAmount,
      ),
      health: (id, start, end, _) => Expense.health(
        id: id,
        startTiming: start,
        endTiming: end,
        annualAmount: newAmount,
      ),
      family: (id, start, end, _) => Expense.family(
        id: id,
        startTiming: start,
        endTiming: end,
        annualAmount: newAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ResponsiveContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Annual Expenses', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Estimate your annual expenses in each category. You can refine these later.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 2
                      : 1,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _expenseCategories.length,
                itemBuilder: (context, index) {
                  final category = _expenseCategories.keys.elementAt(index);
                  final config = _expenseCategories[category]!;
                  final controller = _controllers[category]!;

                  return Card(
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
                                  color: (config['color'] as Color).withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  config['icon'] as IconData,
                                  color: config['color'] as Color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                config['name'] as String,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              enabled: !_isSaving,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Annual Amount',
                                prefixText: '\$ ',
                                hintText: config['hint'] as String,
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null; // Optional
                                }
                                final amount = double.tryParse(value);
                                if (amount == null || amount < 0) {
                                  return 'Invalid amount';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Leave categories at zero or empty if not applicable. You can adjust timing and amounts later in the Expenses screen.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_isSaving) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
