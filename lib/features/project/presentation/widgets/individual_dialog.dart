import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// Result from individual dialog including individual and whether to create another
class IndividualDialogResult {
  final Individual individual;
  final bool createAnother;

  const IndividualDialogResult({
    required this.individual,
    required this.createAnother,
  });
}

/// Dialog for creating or editing an individual
class IndividualDialog extends StatefulWidget {
  final Individual? individual;

  const IndividualDialog({
    super.key,
    this.individual,
  });

  /// Show dialog to create a new individual
  static Future<IndividualDialogResult?> showCreate(BuildContext context) {
    return showDialog<IndividualDialogResult>(
      context: context,
      builder: (context) => const IndividualDialog(),
    );
  }

  /// Show dialog to edit an existing individual
  static Future<IndividualDialogResult?> showEdit(
    BuildContext context,
    Individual individual,
  ) {
    return showDialog<IndividualDialogResult>(
      context: context,
      builder: (context) => IndividualDialog(individual: individual),
    );
  }

  @override
  State<IndividualDialog> createState() => _IndividualDialogState();
}

class _IndividualDialogState extends State<IndividualDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _employmentIncomeController;
  late final TextEditingController _rrqStartAgeController;
  late final TextEditingController _psvStartAgeController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.individual?.name ?? '');
    _employmentIncomeController = TextEditingController(
      text: widget.individual?.employmentIncome.toStringAsFixed(0) ?? '0',
    );
    _rrqStartAgeController = TextEditingController(
      text: widget.individual?.rrqStartAge.toString() ?? '65',
    );
    _psvStartAgeController = TextEditingController(
      text: widget.individual?.psvStartAge.toString() ?? '65',
    );
    _selectedDate = widget.individual?.birthdate ?? DateTime(1970, 1, 1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _employmentIncomeController.dispose();
    _rrqStartAgeController.dispose();
    _psvStartAgeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select birthdate',
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submit({bool createAnother = false}) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final employmentIncome = double.tryParse(_employmentIncomeController.text) ?? 0.0;
    final rrqStartAge = int.tryParse(_rrqStartAgeController.text) ?? 65;
    final psvStartAge = int.tryParse(_psvStartAgeController.text) ?? 65;

    final individual = Individual(
      id: widget.individual?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      birthdate: _selectedDate,
      employmentIncome: employmentIncome,
      rrqStartAge: rrqStartAge,
      psvStartAge: psvStartAge,
    );

    Navigator.of(context).pop(
      IndividualDialogResult(
        individual: individual,
        createAnother: createAnother,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();
    final isEditing = widget.individual != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Individual' : 'Add Individual'),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
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
                        dateFormat.format(_selectedDate),
                        style: theme.textTheme.bodyLarge,
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pension Parameters',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employmentIncomeController,
                decoration: const InputDecoration(
                  labelText: 'Annual Employment Income',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: '\$ ',
                  helperText: 'Current annual salary or employment income',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount < 0) {
                    return 'Must be a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _rrqStartAgeController,
                decoration: const InputDecoration(
                  labelText: 'RRQ Start Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                  helperText: 'Age to start receiving Quebec Pension Plan (60-70)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 60 || age > 70) {
                    return 'Must be between 60 and 70';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _psvStartAgeController,
                decoration: const InputDecoration(
                  labelText: 'PSV Start Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                  helperText: 'Age to start receiving Old Age Security (60-70)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 60 || age > 70) {
                    return 'Must be between 60 and 70';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Show "Save and create another" only when creating new individual
        if (!isEditing) ...[
          FilledButton.tonal(
            onPressed: () => _submit(createAnother: true),
            child: const Text('Save and create another'),
          ),
          const SizedBox(width: 8),
        ],
        FilledButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
