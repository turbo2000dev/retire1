import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/project/domain/individual.dart';

enum TimingType { relative, absolute, age }

/// Widget for selecting event timing
class TimingSelector extends StatefulWidget {
  final EventTiming? initialTiming;
  final List<Individual> individuals;
  final ValueChanged<EventTiming?>? onChanged;
  final String? defaultIndividualId;

  const TimingSelector({
    super.key,
    this.initialTiming,
    required this.individuals,
    this.onChanged,
    this.defaultIndividualId,
  });

  @override
  State<TimingSelector> createState() => _TimingSelectorState();
}

class _TimingSelectorState extends State<TimingSelector> {
  late TimingType _selectedType;
  final _yearsController = TextEditingController();
  final _yearController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedIndividualId;

  @override
  void initState() {
    super.initState();
    _initializeFromTiming();
  }

  void _initializeFromTiming() {
    if (widget.initialTiming != null) {
      widget.initialTiming!.when(
        relative: (years) {
          _selectedType = TimingType.relative;
          _yearsController.text = years.toString();
        },
        absolute: (year) {
          _selectedType = TimingType.absolute;
          _yearController.text = year.toString();
        },
        age: (individualId, age) {
          _selectedType = TimingType.age;
          _selectedIndividualId = individualId;
          _ageController.text = age.toString();
        },
      );
    } else {
      _selectedType = TimingType.relative;
    }
  }

  @override
  void dispose() {
    _yearsController.dispose();
    _yearController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    EventTiming? timing;

    try {
      switch (_selectedType) {
        case TimingType.relative:
          final years = int.tryParse(_yearsController.text);
          if (years != null) {
            timing = EventTiming.relative(yearsFromStart: years);
          }
          break;
        case TimingType.absolute:
          final year = int.tryParse(_yearController.text);
          if (year != null) {
            timing = EventTiming.absolute(calendarYear: year);
          }
          break;
        case TimingType.age:
          final age = int.tryParse(_ageController.text);
          if (age != null && _selectedIndividualId != null) {
            timing = EventTiming.age(individualId: _selectedIndividualId!, age: age);
          }
          break;
      }
    } catch (e) {
      // Invalid input, timing will be null
    }

    widget.onChanged?.call(timing);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('When', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        // Timing type selector
        ...TimingType.values.map((type) {
          return RadioListTile<TimingType>(
            title: Text(_getTimingTypeLabel(type)),
            value: type,
            // ignore: deprecated_member_use
            groupValue: _selectedType,
            // ignore: deprecated_member_use
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                  // When switching to age timing, default to the provided individual if none is selected
                  if (value == TimingType.age && _selectedIndividualId == null && widget.defaultIndividualId != null) {
                    _selectedIndividualId = widget.defaultIndividualId;
                  }
                });
                _notifyChange();
              }
            },
            toggleable: false,
          );
        }),
        const SizedBox(height: 8),
        // Conditional fields based on selected type
        if (_selectedType == TimingType.relative) ...[
          ResponsiveTextField(
            controller: _yearsController,
            label: 'Years from start',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _notifyChange(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter years from start';
              }
              final years = int.tryParse(value);
              if (years == null || years < 0) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
        ] else if (_selectedType == TimingType.absolute) ...[
          ResponsiveTextField(
            controller: _yearController,
            label: 'Calendar year',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _notifyChange(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a calendar year';
              }
              final year = int.tryParse(value);
              if (year == null || year < 2000 || year > 2100) {
                return 'Please enter a valid year (2000-2100)';
              }
              return null;
            },
          ),
        ] else if (_selectedType == TimingType.age) ...[
          if (widget.individuals.isEmpty)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'No individuals found. Please add individuals in Base Parameters first.',
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            DropdownButtonFormField<String>(
              initialValue: _selectedIndividualId,
              decoration: const InputDecoration(labelText: 'Individual', border: OutlineInputBorder()),
              items: widget.individuals.map((individual) {
                return DropdownMenuItem(value: individual.id, child: Text(individual.name));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedIndividualId = value;
                });
                _notifyChange();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an individual';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ResponsiveTextField(
              controller: _ageController,
              label: 'Age',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => _notifyChange(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an age';
                }
                final age = int.tryParse(value);
                if (age == null || age < 0 || age > 120) {
                  return 'Please enter a valid age (0-120)';
                }
                return null;
              },
            ),
          ],
        ],
      ],
    );
  }

  String _getTimingTypeLabel(TimingType type) {
    switch (type) {
      case TimingType.relative:
        return 'Years from start of projection';
      case TimingType.absolute:
        return 'Specific calendar year';
      case TimingType.age:
        return 'When individual reaches age';
    }
  }
}
