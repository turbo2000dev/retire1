import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/widgets/expense_form.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// Result from expense dialog including expense and whether to create another
class ExpenseDialogResult {
  final Expense expense;
  final bool createAnother;

  const ExpenseDialogResult({
    required this.expense,
    required this.createAnother,
  });
}

/// Dialog for adding/editing an expense with category selection
class AddExpenseDialog extends ConsumerStatefulWidget {
  final Expense? expense; // For editing existing expense
  final List<Individual> individuals;
  final List<Event>? events; // Optional list of events for event-relative timing

  const AddExpenseDialog({
    super.key,
    this.expense,
    required this.individuals,
    this.events,
  });

  static Future<ExpenseDialogResult?> show(
    BuildContext context, {
    Expense? expense,
    required List<Individual> individuals,
    List<Event>? events,
  }) {
    return showDialog<ExpenseDialogResult>(
      context: context,
      builder: (context) => AddExpenseDialog(
        expense: expense,
        individuals: individuals,
        events: events,
      ),
    );
  }

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  ExpenseType? _selectedType;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    // If editing, auto-select type and show form
    if (widget.expense != null) {
      _selectedType = widget.expense!.when(
        housing: (_, __, ___, ____) => ExpenseType.housing,
        transport: (_, __, ___, ____) => ExpenseType.transport,
        dailyLiving: (_, __, ___, ____) => ExpenseType.dailyLiving,
        recreation: (_, __, ___, ____) => ExpenseType.recreation,
        health: (_, __, ___, ____) => ExpenseType.health,
        family: (_, __, ___, ____) => ExpenseType.family,
      );
      _showForm = true;
    }
  }

  void _selectType(ExpenseType type) {
    setState(() {
      _selectedType = type;
      _showForm = true;
    });
  }

  void _handleSave(Expense expense, {bool createAnother = false}) {
    Navigator.of(context).pop(
      ExpenseDialogResult(
        expense: expense,
        createAnother: createAnother,
      ),
    );
  }

  void _handleCancel() {
    if (_showForm && widget.expense == null) {
      // Go back to type selection
      setState(() {
        _showForm = false;
        _selectedType = null;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.expense == null
        ? (_showForm ? 'Add ${_getTypeName(_selectedType!)}' : 'Add Expense')
        : 'Edit ${_getTypeName(_selectedType!)}';

    return ResponsiveDialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Flexible(
              child: _showForm ? _buildForm() : _buildTypeSelector(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Select expense category',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _buildTypeCard(
            theme: theme,
            icon: Icons.home,
            title: 'Housing',
            subtitle: 'Mortgage, rent, utilities, maintenance',
            type: ExpenseType.housing,
          ),
          const SizedBox(height: 8),
          _buildTypeCard(
            theme: theme,
            icon: Icons.directions_car,
            title: 'Transport',
            subtitle: 'Car, gas, insurance, public transit',
            type: ExpenseType.transport,
          ),
          const SizedBox(height: 8),
          _buildTypeCard(
            theme: theme,
            icon: Icons.shopping_cart,
            title: 'Daily Living',
            subtitle: 'Groceries, clothing, personal care',
            type: ExpenseType.dailyLiving,
          ),
          const SizedBox(height: 8),
          _buildTypeCard(
            theme: theme,
            icon: Icons.theater_comedy,
            title: 'Recreation',
            subtitle: 'Entertainment, hobbies, travel',
            type: ExpenseType.recreation,
          ),
          const SizedBox(height: 8),
          _buildTypeCard(
            theme: theme,
            icon: Icons.medical_services,
            title: 'Health',
            subtitle: 'Insurance, medical costs, prescriptions',
            type: ExpenseType.health,
          ),
          const SizedBox(height: 8),
          _buildTypeCard(
            theme: theme,
            icon: Icons.family_restroom,
            title: 'Family',
            subtitle: 'Childcare, education, family support',
            type: ExpenseType.family,
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required ExpenseType type,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _selectType(type),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return ExpenseForm(
      expenseType: widget.expense == null ? _selectedType : null,
      expense: widget.expense,
      individuals: widget.individuals,
      events: widget.events,
      onSave: _handleSave,
      onCancel: _handleCancel,
    );
  }

  String _getTypeName(ExpenseType type) {
    switch (type) {
      case ExpenseType.housing:
        return 'Housing';
      case ExpenseType.transport:
        return 'Transport';
      case ExpenseType.dailyLiving:
        return 'Daily Living';
      case ExpenseType.recreation:
        return 'Recreation';
      case ExpenseType.health:
        return 'Health';
      case ExpenseType.family:
        return 'Family';
    }
  }
}
