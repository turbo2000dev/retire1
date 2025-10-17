import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';
import 'package:uuid/uuid.dart';

/// Step 1: Collect information about 1-2 individuals
class WizardIndividualsStep extends ConsumerStatefulWidget {
  const WizardIndividualsStep({super.key});

  @override
  ConsumerState<WizardIndividualsStep> createState() =>
      _WizardIndividualsStepState();
}

class _WizardIndividualsStepState extends ConsumerState<WizardIndividualsStep> {
  // Individual 1 (required)
  final _name1Controller = TextEditingController();
  final _income1Controller = TextEditingController();
  final _retirementAge1Controller = TextEditingController(text: '65');
  final _lifeExpectancy1Controller = TextEditingController(text: '85');
  DateTime _birthdate1 = DateTime(1970, 1, 1);

  // Individual 2 (optional)
  bool _hasIndividual2 = false;
  final _name2Controller = TextEditingController();
  final _income2Controller = TextEditingController();
  final _retirementAge2Controller = TextEditingController(text: '65');
  final _lifeExpectancy2Controller = TextEditingController(text: '85');
  DateTime _birthdate2 = DateTime(1970, 1, 1);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final wizardState = ref.read(wizardProvider);
    if (wizardState == null) return;

    // Load Individual 1 if exists
    if (wizardState.individual1 != null) {
      final ind1 = wizardState.individual1!;
      _name1Controller.text = ind1.name;
      _income1Controller.text = ind1.employmentIncome.toStringAsFixed(0);
      _birthdate1 = ind1.birthdate;
      // Calculate retirement age and life expectancy from Individual data
      // For now, use defaults as these are simplified in wizard
      _retirementAge1Controller.text = '65';
      _lifeExpectancy1Controller.text = '85';
    }

    // Load Individual 2 if exists
    if (wizardState.individual2 != null) {
      _hasIndividual2 = true;
      final ind2 = wizardState.individual2!;
      _name2Controller.text = ind2.name;
      _income2Controller.text = ind2.employmentIncome.toStringAsFixed(0);
      _birthdate2 = ind2.birthdate;
      _retirementAge2Controller.text = '65';
      _lifeExpectancy2Controller.text = '85';
    }
  }

  @override
  void dispose() {
    _name1Controller.dispose();
    _income1Controller.dispose();
    _retirementAge1Controller.dispose();
    _lifeExpectancy1Controller.dispose();
    _name2Controller.dispose();
    _income2Controller.dispose();
    _retirementAge2Controller.dispose();
    _lifeExpectancy2Controller.dispose();
    super.dispose();
  }

  void _saveData() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create Individual 1
    final individual1 = Individual(
      id: ref.read(wizardProvider)?.individual1?.id ?? const Uuid().v4(),
      name: _name1Controller.text.trim(),
      birthdate: _birthdate1,
      employmentIncome: double.tryParse(_income1Controller.text) ?? 0.0,
    );

    ref.read(wizardProvider.notifier).updateIndividual1(individual1);

    // Create Individual 2 if applicable
    if (_hasIndividual2 && _name2Controller.text.trim().isNotEmpty) {
      final individual2 = Individual(
        id: ref.read(wizardProvider)?.individual2?.id ?? const Uuid().v4(),
        name: _name2Controller.text.trim(),
        birthdate: _birthdate2,
        employmentIncome: double.tryParse(_income2Controller.text) ?? 0.0,
      );
      ref.read(wizardProvider.notifier).updateIndividual2(individual2);
    } else {
      // Remove Individual 2 if unchecked or empty
      ref.read(wizardProvider.notifier).removeIndividual2();
    }
  }

  Future<void> _selectDate1() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthdate1,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select birthdate',
    );
    if (picked != null) {
      setState(() => _birthdate1 = picked);
    }
  }

  Future<void> _selectDate2() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthdate2,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select birthdate',
    );
    if (picked != null) {
      setState(() => _birthdate2 = picked);
    }
  }

  void _toggleIndividual2() {
    setState(() {
      _hasIndividual2 = !_hasIndividual2;
      if (!_hasIndividual2) {
        // Clear Individual 2 data
        _name2Controller.clear();
        _income2Controller.clear();
        _retirementAge2Controller.text = '65';
        _lifeExpectancy2Controller.text = '85';
        _birthdate2 = DateTime(1970, 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.isPhone ? 16 : 24),
          child: Form(
            key: _formKey,
            onChanged: _saveData,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Tell us about the people in this retirement plan',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'You can refine these details later in Base Parameters',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // Layout: stacked on phone, side-by-side on tablet/desktop
                if (screenSize.isPhone)
                  ..._buildStackedLayout(theme)
                else
                  _buildSideBySideLayout(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildStackedLayout(ThemeData theme) {
    return [
      _buildIndividual1Card(theme),
      const SizedBox(height: 24),
      if (_hasIndividual2)
        _buildIndividual2Card(theme)
      else
        _buildAddIndividual2Button(theme),
    ];
  }

  Widget _buildSideBySideLayout(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildIndividual1Card(theme)),
        const SizedBox(width: 24),
        Expanded(
          child: _hasIndividual2
              ? _buildIndividual2Card(theme)
              : _buildAddIndividual2Button(theme),
        ),
      ],
    );
  }

  Widget _buildIndividual1Card(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Individual 1',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._buildIndividualFields(
              nameController: _name1Controller,
              incomeController: _income1Controller,
              retirementAgeController: _retirementAge1Controller,
              lifeExpectancyController: _lifeExpectancy1Controller,
              birthdate: _birthdate1,
              onDateTap: _selectDate1,
              required: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividual2Card(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.people_outline,
                        color: theme.colorScheme.secondary),
                    const SizedBox(width: 12),
                    Text(
                      'Partner/Spouse',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _toggleIndividual2,
                  tooltip: 'Remove',
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._buildIndividualFields(
              nameController: _name2Controller,
              incomeController: _income2Controller,
              retirementAgeController: _retirementAge2Controller,
              lifeExpectancyController: _lifeExpectancy2Controller,
              birthdate: _birthdate2,
              onDateTap: _selectDate2,
              required: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddIndividual2Button(ThemeData theme) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: _toggleIndividual2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_outlined,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Add Partner/Spouse',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Optional',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIndividualFields({
    required TextEditingController nameController,
    required TextEditingController incomeController,
    required TextEditingController retirementAgeController,
    required TextEditingController lifeExpectancyController,
    required DateTime birthdate,
    required VoidCallback onDateTap,
    required bool required,
  }) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return [
      // Name
      TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.person),
        ),
        textCapitalization: TextCapitalization.words,
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              }
            : null,
      ),
      const SizedBox(height: 16),

      // Birthdate
      InkWell(
        onTap: onDateTap,
        borderRadius: BorderRadius.circular(4),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Birthdate',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.cake),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateFormat.format(birthdate),
                style: theme.textTheme.bodyLarge,
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Current Annual Income
      TextFormField(
        controller: incomeController,
        decoration: const InputDecoration(
          labelText: 'Current Annual Income',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.attach_money),
          prefixText: '\$ ',
          helperText: 'Gross annual employment income',
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        ],
      ),
      const SizedBox(height: 16),

      // Expected Retirement Age
      TextFormField(
        controller: retirementAgeController,
        decoration: InputDecoration(
          labelText: 'Expected Retirement Age',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.event),
          suffixIcon: Tooltip(
            message:
                'The age at which this person plans to retire from employment',
            child: Icon(Icons.info_outline,
                color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          final age = int.tryParse(value);
          if (age == null || age < 50 || age > 75) {
            return 'Age should be between 50 and 75';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      // Life Expectancy
      TextFormField(
        controller: lifeExpectancyController,
        decoration: InputDecoration(
          labelText: 'Life Expectancy',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.favorite_border),
          suffixIcon: Tooltip(
            message:
                'The projection will run until this age. You can adjust this later.',
            child: Icon(Icons.info_outline,
                color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          final age = int.tryParse(value);
          if (age == null || age < 70 || age > 110) {
            return 'Age should be between 70 and 110';
          }
          return null;
        },
      ),
    ];
  }
}
