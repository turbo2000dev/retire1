import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';

/// Account type for account form
enum AccountType { rrsp, celi, cash }

/// Reusable form for creating or editing account assets (RRSP, CELI, Cash)
class AccountForm extends ConsumerStatefulWidget {
  final AccountType accountType;
  final Asset? asset;
  final void Function(Asset, {bool createAnother}) onSave;
  final VoidCallback? onCancel;

  const AccountForm({
    super.key,
    required this.accountType,
    this.asset,
    required this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<AccountForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueController;
  String? _selectedIndividualId;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
      text: widget.asset?.map(
        realEstate: (_) => '',
        rrsp: (a) => a.value.toStringAsFixed(0),
        celi: (a) => a.value.toStringAsFixed(0),
        cash: (a) => a.value.toStringAsFixed(0),
      ) ?? '',
    );
    _selectedIndividualId = widget.asset?.map(
      realEstate: (_) => null,
      rrsp: (a) => a.individualId,
      celi: (a) => a.individualId,
      cash: (a) => a.individualId,
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _submit({bool createAnother = false}) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedIndividualId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an individual')),
      );
      return;
    }

    final id = widget.asset?.map(
      realEstate: (a) => a.id,
      rrsp: (a) => a.id,
      celi: (a) => a.id,
      cash: (a) => a.id,
    ) ?? DateTime.now().millisecondsSinceEpoch.toString();

    final value = double.parse(_valueController.text.replaceAll(',', ''));

    final Asset asset;
    switch (widget.accountType) {
      case AccountType.rrsp:
        asset = Asset.rrsp(
          id: id,
          individualId: _selectedIndividualId!,
          value: value,
        );
        break;
      case AccountType.celi:
        asset = Asset.celi(
          id: id,
          individualId: _selectedIndividualId!,
          value: value,
        );
        break;
      case AccountType.cash:
        asset = Asset.cash(
          id: id,
          individualId: _selectedIndividualId!,
          value: value,
        );
        break;
    }

    widget.onSave(asset, createAnother: createAnother);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProjectState = ref.watch(currentProjectProvider);

    // Get individuals from current project
    final individuals = currentProjectState is ProjectSelected
        ? currentProjectState.project.individuals
        : <Individual>[];

    // Auto-select first individual if none selected and individuals available
    if (_selectedIndividualId == null && individuals.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _selectedIndividualId = individuals.first.id;
        });
      });
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Individual selector
          if (individuals.isEmpty)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No individuals found. Please add individuals in Base Parameters first.',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            )
          else
            DropdownButtonFormField<String>(
              initialValue: _selectedIndividualId,
              decoration: const InputDecoration(
                labelText: 'Owner',
                border: OutlineInputBorder(),
              ),
              items: individuals.map((individual) {
                return DropdownMenuItem(
                  value: individual.id,
                  child: Text(individual.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIndividualId = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an owner';
                }
                return null;
              },
            ),
          const SizedBox(height: 16),
          // Value field
          TextFormField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Balance',
              border: OutlineInputBorder(),
              prefixText: '\$ ',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a balance';
              }
              final numValue = double.tryParse(value.replaceAll(',', ''));
              if (numValue == null || numValue < 0) {
                return 'Please enter a valid balance';
              }
              return null;
            },
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
              // Show "Save and create another" only when creating new asset
              if (widget.asset == null) ...[
                FilledButton.tonal(
                  onPressed: individuals.isEmpty ? null : () => _submit(createAnother: true),
                  child: const Text('Save and create another'),
                ),
                const SizedBox(width: 8),
              ],
              FilledButton(
                onPressed: individuals.isEmpty ? null : _submit,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
