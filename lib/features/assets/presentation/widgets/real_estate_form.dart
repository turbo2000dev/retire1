import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retire1/features/assets/domain/asset.dart';

/// Form for creating or editing a real estate asset
class RealEstateForm extends StatefulWidget {
  final RealEstateAsset? asset;
  final void Function(RealEstateAsset, {bool createAnother}) onSave;
  final VoidCallback? onCancel;

  const RealEstateForm({
    super.key,
    this.asset,
    required this.onSave,
    this.onCancel,
  });

  @override
  State<RealEstateForm> createState() => _RealEstateFormState();
}

class _RealEstateFormState extends State<RealEstateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _valueController;
  late RealEstateType _selectedType;
  late bool _setAtStart;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.asset?.type ?? RealEstateType.house;
    _valueController = TextEditingController(
      text: widget.asset?.value.toStringAsFixed(0) ?? '',
    );
    _setAtStart = widget.asset?.setAtStart ?? false;
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _submit({bool createAnother = false}) {
    if (!_formKey.currentState!.validate()) return;

    final asset = Asset.realEstate(
      id: widget.asset?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      value: double.parse(_valueController.text.replaceAll(',', '')),
      setAtStart: _setAtStart,
    ) as RealEstateAsset;

    widget.onSave(asset, createAnother: createAnother);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Type dropdown
          DropdownButtonFormField<RealEstateType>(
            initialValue: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Property Type',
              border: OutlineInputBorder(),
            ),
            items: RealEstateType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(_getRealEstateTypeName(type)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          // Value field
          TextFormField(
            controller: _valueController,
            decoration: const InputDecoration(
              labelText: 'Value',
              border: OutlineInputBorder(),
              prefixText: '\$ ',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              final numValue = double.tryParse(value.replaceAll(',', ''));
              if (numValue == null || numValue <= 0) {
                return 'Please enter a valid positive value';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Set at start checkbox
          CheckboxListTile(
            title: const Text('Set at start of planning period'),
            subtitle: const Text(
              'Will be sold/acquired at the beginning of the projection',
            ),
            value: _setAtStart,
            onChanged: (value) {
              setState(() {
                _setAtStart = value ?? false;
              });
            },
            contentPadding: EdgeInsets.zero,
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
          ),
        ],
      ),
    );
  }

  String _getRealEstateTypeName(RealEstateType type) {
    switch (type) {
      case RealEstateType.house:
        return 'House';
      case RealEstateType.condo:
        return 'Condo';
      case RealEstateType.cottage:
        return 'Cottage';
      case RealEstateType.land:
        return 'Land';
      case RealEstateType.commercial:
        return 'Commercial Property';
      case RealEstateType.other:
        return 'Other';
    }
  }
}
