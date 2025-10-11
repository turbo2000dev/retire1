import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// Dialog for creating or editing an individual
class IndividualDialog extends StatefulWidget {
  final Individual? individual;

  const IndividualDialog({
    super.key,
    this.individual,
  });

  /// Show dialog to create a new individual
  static Future<Individual?> showCreate(BuildContext context) {
    return showDialog<Individual>(
      context: context,
      builder: (context) => const IndividualDialog(),
    );
  }

  /// Show dialog to edit an existing individual
  static Future<Individual?> showEdit(
    BuildContext context,
    Individual individual,
  ) {
    return showDialog<Individual>(
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
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.individual?.name ?? '');
    _selectedDate = widget.individual?.birthdate ?? DateTime(1970, 1, 1);
  }

  @override
  void dispose() {
    _nameController.dispose();
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

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final individual = Individual(
      id: widget.individual?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      birthdate: _selectedDate,
    );

    Navigator.of(context).pop(individual);
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}
