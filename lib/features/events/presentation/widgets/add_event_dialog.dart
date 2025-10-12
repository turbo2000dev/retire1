import 'package:flutter/material.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/presentation/widgets/death_event_form.dart';
import 'package:retire1/features/events/presentation/widgets/real_estate_transaction_form.dart';
import 'package:retire1/features/events/presentation/widgets/retirement_event_form.dart';
import 'package:retire1/features/project/domain/individual.dart';

enum EventType { retirement, death, realEstateTransaction }

/// Dialog for adding or editing an event
class AddEventDialog extends StatefulWidget {
  final Event? event;
  final List<Individual> individuals;
  final List<Asset> assets;

  const AddEventDialog({super.key, this.event, required this.individuals, required this.assets});

  /// Show the dialog and return the created/edited event
  static Future<Event?> show(
    BuildContext context, {
    Event? event,
    required List<Individual> individuals,
    required List<Asset> assets,
  }) {
    return showDialog<Event?>(
      context: context,
      builder: (context) => AddEventDialog(event: event, individuals: individuals, assets: assets),
    );
  }

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  late EventType? _selectedType;
  Event? _currentEvent;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _selectedType = widget.event!.map(
        retirement: (_) => EventType.retirement,
        death: (_) => EventType.death,
        realEstateTransaction: (_) => EventType.realEstateTransaction,
      );
      _currentEvent = widget.event;
    } else {
      _selectedType = null;
    }
  }

  void _submit() {
    if (_currentEvent == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all required fields')));
      return;
    }

    Navigator.of(context).pop(_currentEvent);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.event == null ? 'Add Event' : 'Edit Event',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Event type selector (only if creating new)
                      if (widget.event == null) ...[
                        Text('Event Type', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ...EventType.values.map((type) {
                          return RadioListTile<EventType>(
                            title: Text(_getEventTypeLabel(type)),
                            subtitle: Text(_getEventTypeDescription(type)),
                            value: type,
                            // ignore: deprecated_member_use
                            groupValue: _selectedType,
                            // ignore: deprecated_member_use
                            onChanged: (value) {
                              setState(() {
                                _selectedType = value;
                                _currentEvent = null;
                              });
                            },
                            toggleable: false,
                          );
                        }),
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                      ],
                      // Event-specific form
                      if (_selectedType != null) _buildEventForm(),
                    ],
                  ),
                ),
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _currentEvent != null ? _submit : null,
                    child: Text(widget.event == null ? 'Add' : 'Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventForm() {
    switch (_selectedType!) {
      case EventType.retirement:
        return RetirementEventForm(
          initialEvent: widget.event != null ? widget.event! as RetirementEvent : null,
          individuals: widget.individuals,
          onChanged: (event) {
            setState(() {
              _currentEvent = event;
            });
          },
        );
      case EventType.death:
        return DeathEventForm(
          initialEvent: widget.event != null ? widget.event! as DeathEvent : null,
          individuals: widget.individuals,
          onChanged: (event) {
            setState(() {
              _currentEvent = event;
            });
          },
        );
      case EventType.realEstateTransaction:
        return RealEstateTransactionForm(
          initialEvent: widget.event != null ? widget.event! as RealEstateTransactionEvent : null,
          individuals: widget.individuals,
          assets: widget.assets,
          onChanged: (event) {
            setState(() {
              _currentEvent = event;
            });
          },
        );
    }
  }

  String _getEventTypeLabel(EventType type) {
    switch (type) {
      case EventType.retirement:
        return 'Retirement';
      case EventType.death:
        return 'Death';
      case EventType.realEstateTransaction:
        return 'Real Estate Transaction';
    }
  }

  String _getEventTypeDescription(EventType type) {
    switch (type) {
      case EventType.retirement:
        return 'Individual retires from work';
      case EventType.death:
        return 'Individual passes away';
      case EventType.realEstateTransaction:
        return 'Buy or sell real estate property';
    }
  }
}
