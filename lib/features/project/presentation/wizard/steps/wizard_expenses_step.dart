import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_state.dart';

/// Step 4: Configure annual expenses with smart defaults
class WizardExpensesStep extends ConsumerStatefulWidget {
  const WizardExpensesStep({super.key});

  @override
  ConsumerState<WizardExpensesStep> createState() => _WizardExpensesStepState();
}

class _WizardExpensesStepState extends ConsumerState<WizardExpensesStep> {
  // Expense category controllers
  final _housingController = TextEditingController();
  final _transportController = TextEditingController();
  final _dailyLivingController = TextEditingController();
  final _recreationController = TextEditingController();
  final _healthController = TextEditingController();
  final _familyController = TextEditingController();

  // Timing selection
  ExpenseStartTiming _startTiming = ExpenseStartTiming.now;
  final _customYearController = TextEditingController();

  bool _defaultsCalculated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingDataOrCalculateDefaults();
    });
  }

  @override
  void dispose() {
    _housingController.dispose();
    _transportController.dispose();
    _dailyLivingController.dispose();
    _recreationController.dispose();
    _healthController.dispose();
    _familyController.dispose();
    _customYearController.dispose();
    super.dispose();
  }

  void _loadExistingDataOrCalculateDefaults() {
    final wizardState = ref.read(wizardProvider);
    if (wizardState == null) return;

    final expensesData = wizardState.expenses;

    // Check if user has already entered data
    final hasExistingData =
        expensesData.housingAmount > 0 ||
        expensesData.transportAmount > 0 ||
        expensesData.dailyLivingAmount > 0 ||
        expensesData.recreationAmount > 0 ||
        expensesData.healthAmount > 0 ||
        expensesData.familyAmount > 0;

    if (hasExistingData) {
      // Load existing data
      _housingController.text = expensesData.housingAmount.toStringAsFixed(0);
      _transportController.text = expensesData.transportAmount.toStringAsFixed(
        0,
      );
      _dailyLivingController.text = expensesData.dailyLivingAmount
          .toStringAsFixed(0);
      _recreationController.text = expensesData.recreationAmount
          .toStringAsFixed(0);
      _healthController.text = expensesData.healthAmount.toStringAsFixed(0);
      _familyController.text = expensesData.familyAmount.toStringAsFixed(0);

      _startTiming = expensesData.startTiming;
      if (expensesData.customStartYear != null) {
        _customYearController.text = expensesData.customStartYear.toString();
      }
    } else {
      // Calculate defaults based on income
      _calculateDefaults();
    }

    _defaultsCalculated = true;
  }

  void _calculateDefaults() {
    final wizardState = ref.read(wizardProvider);
    if (wizardState == null) return;

    // Get combined income from individuals
    final income1 = wizardState.individual1?.employmentIncome ?? 0.0;
    final income2 = wizardState.individual2?.employmentIncome ?? 0.0;
    final totalIncome = income1 + income2;

    if (totalIncome > 0) {
      // Calculate defaults based on typical Quebec household spending patterns
      _housingController.text = (totalIncome * 0.30).toStringAsFixed(0);
      _transportController.text = (totalIncome * 0.15).toStringAsFixed(0);
      _dailyLivingController.text = (totalIncome * 0.20).toStringAsFixed(0);
      _recreationController.text = (totalIncome * 0.10).toStringAsFixed(0);
      _healthController.text = (totalIncome * 0.10).toStringAsFixed(0);
      _familyController.text = (totalIncome * 0.15).toStringAsFixed(0);
    }
  }

  void _saveData() {
    if (!_defaultsCalculated) return;

    final data = WizardExpensesData(
      housingAmount: double.tryParse(_housingController.text) ?? 0.0,
      transportAmount: double.tryParse(_transportController.text) ?? 0.0,
      dailyLivingAmount: double.tryParse(_dailyLivingController.text) ?? 0.0,
      recreationAmount: double.tryParse(_recreationController.text) ?? 0.0,
      healthAmount: double.tryParse(_healthController.text) ?? 0.0,
      familyAmount: double.tryParse(_familyController.text) ?? 0.0,
      startTiming: _startTiming,
      customStartYear: _startTiming == ExpenseStartTiming.custom
          ? int.tryParse(_customYearController.text)
          : null,
    );

    ref.read(wizardProvider.notifier).updateExpenses(data);
  }

  double get _totalExpenses {
    return (double.tryParse(_housingController.text) ?? 0.0) +
        (double.tryParse(_transportController.text) ?? 0.0) +
        (double.tryParse(_dailyLivingController.text) ?? 0.0) +
        (double.tryParse(_recreationController.text) ?? 0.0) +
        (double.tryParse(_healthController.text) ?? 0.0) +
        (double.tryParse(_familyController.text) ?? 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = ref.watch(wizardProvider);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

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
                'Estimate your annual expenses',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on your income from Step 1 - you can adjust any amount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Expense categories
              _buildExpenseCategory(
                theme: theme,
                title: 'Housing',
                description: 'Mortgage, rent, property taxes, utilities',
                icon: Icons.home_outlined,
                controller: _housingController,
                percentage: 30,
              ),
              const SizedBox(height: 16),

              _buildExpenseCategory(
                theme: theme,
                title: 'Transport',
                description: 'Car payments, insurance, gas, public transit',
                icon: Icons.directions_car_outlined,
                controller: _transportController,
                percentage: 15,
              ),
              const SizedBox(height: 16),

              _buildExpenseCategory(
                theme: theme,
                title: 'Daily Living',
                description: 'Groceries, clothing, personal care',
                icon: Icons.shopping_cart_outlined,
                controller: _dailyLivingController,
                percentage: 20,
              ),
              const SizedBox(height: 16),

              _buildExpenseCategory(
                theme: theme,
                title: 'Recreation',
                description: 'Entertainment, dining out, hobbies, travel',
                icon: Icons.celebration_outlined,
                controller: _recreationController,
                percentage: 10,
              ),
              const SizedBox(height: 16),

              _buildExpenseCategory(
                theme: theme,
                title: 'Health',
                description: 'Medical expenses, prescriptions, insurance',
                icon: Icons.local_hospital_outlined,
                controller: _healthController,
                percentage: 10,
              ),
              const SizedBox(height: 16),

              _buildExpenseCategory(
                theme: theme,
                title: 'Family',
                description: 'Childcare, education, support',
                icon: Icons.family_restroom_outlined,
                controller: _familyController,
                percentage: 15,
              ),
              const SizedBox(height: 24),

              // Total expenses card
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Annual Expenses',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currencyFormat.format(_totalExpenses),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Expense timing section
              Text(
                'When do these expenses start?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can set different timing per category later',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),

              // Timing options
              _buildTimingOption(
                theme: theme,
                title: 'Now (projection start)',
                value: ExpenseStartTiming.now,
                description: 'Expenses start immediately',
              ),
              const SizedBox(height: 8),

              _buildTimingOption(
                theme: theme,
                title: 'At retirement',
                value: ExpenseStartTiming.atRetirement,
                description: 'Expenses start when first person retires',
              ),
              const SizedBox(height: 8),

              _buildTimingOption(
                theme: theme,
                title: 'Custom year',
                value: ExpenseStartTiming.custom,
                description: 'Specify a custom start year',
              ),

              // Custom year field (conditional)
              if (_startTiming == ExpenseStartTiming.custom) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _customYearController,
                      decoration: const InputDecoration(
                        labelText: 'Start Year',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => _saveData(),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildExpenseCategory({
    required ThemeData theme,
    required String title,
    required String description,
    required IconData icon,
    required TextEditingController controller,
    required int percentage,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),

        // Title, description, and input
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '$percentage%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (_) {
                  setState(() {}); // Update total
                  _saveData();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimingOption({
    required ThemeData theme,
    required String title,
    required ExpenseStartTiming value,
    required String description,
  }) {
    final isSelected = _startTiming == value;

    return InkWell(
      onTap: () {
        setState(() => _startTiming = value);
        _saveData();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
              : null,
        ),
        child: Row(
          children: [
            Radio<ExpenseStartTiming>(
              value: value,
              groupValue: _startTiming,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() => _startTiming = newValue);
                  _saveData();
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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
