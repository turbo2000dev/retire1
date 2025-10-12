import 'package:flutter/material.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/widgets/timing_selector.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:uuid/uuid.dart';

/// Form for creating/editing a death event
class DeathEventForm extends StatefulWidget {
  final DeathEvent? initialEvent;
  final List<Individual> individuals;
  final ValueChanged<Event?> onChanged;

  const DeathEventForm({
    super.key,
    this.initialEvent,
    required this.individuals,
    required this.onChanged,
  });

  @override
  State<DeathEventForm> createState() => _DeathEventFormState();
}

class _DeathEventFormState extends State<DeathEventForm> {
  String? _selectedIndividualId;
  EventTiming? _timing;

  @override
  void initState() {
    super.initState();
    if (widget.initialEvent != null) {
      _selectedIndividualId = widget.initialEvent!.individualId;
      _timing = widget.initialEvent!.timing;
    } else if (widget.individuals.isNotEmpty) {
      // Auto-select first individual when creating new event
      _selectedIndividualId = widget.individuals.first.id;
    }
  }

  void _notifyChange() {
    if (_selectedIndividualId != null && _timing != null) {
      final event = Event.death(
        id: widget.initialEvent?.id ?? const Uuid().v4(),
        individualId: _selectedIndividualId!,
        timing: _timing!,
      );
      widget.onChanged(event);
    } else {
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Individual selector
        Text(
          'Who',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (widget.individuals.isEmpty)
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No individuals found. Please add individuals in Base Parameters first.',
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          DropdownButtonFormField<String>(
            initialValue: _selectedIndividualId,
            decoration: const InputDecoration(
              labelText: 'Individual',
              border: OutlineInputBorder(),
            ),
            items: widget.individuals.map((individual) {
              return DropdownMenuItem(
                value: individual.id,
                child: Text(individual.name),
              );
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
        const SizedBox(height: 24),
        // Timing selector
        TimingSelector(
          initialTiming: _timing,
          individuals: widget.individuals,
          defaultIndividualId: _selectedIndividualId,
          onChanged: (timing) {
            setState(() {
              _timing = timing;
            });
            _notifyChange();
          },
        ),
      ],
    );
  }
}
