import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Section for managing event timing overrides in a scenario
class EventOverrideSection extends ConsumerWidget {
  final Scenario scenario;

  const EventOverrideSection({
    super.key,
    required this.scenario,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Card(
        color: theme.colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load events',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (events) {
        if (events.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: 48,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No events available',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add events in the Assets & Events screen to override their timing here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Override event timing to explore different scenarios. '
              'Timing is specified as years from the start of projection.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...events.map((event) {
              return _EventOverrideCard(
                event: event,
                scenario: scenario,
              );
            }),
          ],
        );
      },
    );
  }
}

/// Card for a single event timing override
class _EventOverrideCard extends ConsumerStatefulWidget {
  final Event event;
  final Scenario scenario;

  const _EventOverrideCard({
    required this.event,
    required this.scenario,
  });

  @override
  ConsumerState<_EventOverrideCard> createState() => _EventOverrideCardState();
}

class _EventOverrideCardState extends ConsumerState<_EventOverrideCard> {
  final _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getEventTypeName() {
    return widget.event.when(
      retirement: (id, individualId, timing) => 'Retirement',
      death: (id, individualId, timing) => 'Death',
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          'Real Estate Transaction',
    );
  }

  IconData _getEventIcon() {
    return widget.event.when(
      retirement: (id, individualId, timing) => Icons.beach_access,
      death: (id, individualId, timing) => Icons.favorite_border,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          Icons.home,
    );
  }

  String _getIndividualName(String individualId) {
    final projectState = ref.watch(currentProjectProvider);
    if (projectState is ProjectSelected) {
      final individual = projectState.project.individuals
          .where((i) => i.id == individualId)
          .firstOrNull;
      return individual?.name ?? 'Unknown';
    }
    return 'Unknown';
  }

  String _getEventDescription() {
    return widget.event.when(
      retirement: (id, individualId, timing) =>
          '${_getIndividualName(individualId)} retires',
      death: (id, individualId, timing) =>
          '${_getIndividualName(individualId)} passes away',
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
          withdrawAccountId, depositAccountId) {
        if (assetSoldId != null && assetPurchasedId != null) {
          return 'Sell and buy property';
        } else if (assetSoldId != null) {
          return 'Sell property';
        } else {
          return 'Buy property';
        }
      },
    );
  }

  String _getBaseTimingDescription() {
    final timing = widget.event.when(
      retirement: (id, individualId, timing) => timing,
      death: (id, individualId, timing) => timing,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          timing,
    );

    return timing.when(
      relative: (yearsFromStart) => '$yearsFromStart years from start',
      absolute: (calendarYear) => 'Year $calendarYear',
      age: (individualId, age) =>
          'When ${_getIndividualName(individualId)} reaches age $age',
      eventRelative: (eventId, boundary) {
        final boundaryText = boundary == EventBoundary.start ? 'start' : 'end';
        return 'At $boundaryText of event';
      },
      projectionEnd: () => 'End of projection',
    );
  }

  int? _getBaseTimingYears() {
    final timing = widget.event.when(
      retirement: (id, individualId, timing) => timing,
      death: (id, individualId, timing) => timing,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          timing,
    );

    return timing.maybeWhen(
      relative: (yearsFromStart) => yearsFromStart,
      orElse: () => null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final eventId = widget.event.when(
      retirement: (id, individualId, timing) => id,
      death: (id, individualId, timing) => id,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          id,
    );

    // Check if there's an override for this event
    final override = widget.scenario.overrides
        .where((o) => o.maybeWhen(
              eventTiming: (id, years) => id == eventId,
              orElse: () => false,
            ))
        .firstOrNull;

    final overrideYears = override?.maybeWhen(
      eventTiming: (id, years) => years,
      orElse: () => null,
    );

    final isOverridden = overrideYears != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverridden
          ? theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getEventIcon(),
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getEventTypeName(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getEventDescription(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Base: ${_getBaseTimingDescription()}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isOverridden)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OVERRIDDEN',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_isEditing) ...[
              TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Override Timing (Years from Start)',
                  hintText: 'Enter years from start',
                  border: const OutlineInputBorder(),
                  helperText: 'Specify timing relative to projection start',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _controller.clear();
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autofocus: true,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                        _controller.clear();
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _saveOverride,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ] else ...[
              Row(
                children: [
                  if (isOverridden) ...[
                    Expanded(
                      child: Text(
                        'Override: $overrideYears years from start',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller.text = overrideYears.toString();
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                      tooltip: 'Edit override',
                    ),
                    IconButton(
                      onPressed: _removeOverride,
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Remove override',
                      color: theme.colorScheme.error,
                    ),
                  ] else ...[
                    const Spacer(),
                    FilledButton.tonalIcon(
                      onPressed: () {
                        final baseYears = _getBaseTimingYears();
                        if (baseYears != null) {
                          _controller.text = baseYears.toString();
                        }
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Override'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _saveOverride() async {
    final value = int.tryParse(_controller.text);
    if (value == null || value < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number of years'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final eventId = widget.event.when(
        retirement: (id, individualId, timing) => id,
        death: (id, individualId, timing) => id,
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            id,
      );

      final override = ParameterOverride.eventTiming(
        eventId: eventId,
        yearsFromStart: value,
      );

      await ref
          .read(scenariosProvider.notifier)
          .addOverride(widget.scenario.id, override);

      setState(() {
        _isEditing = false;
        _controller.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Override saved'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving override: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _removeOverride() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Override'),
        content: const Text('Remove this override and use the base timing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final eventId = widget.event.when(
        retirement: (id, individualId, timing) => id,
        death: (id, individualId, timing) => id,
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            id,
      );

      final override = widget.scenario.overrides
          .where((o) => o.maybeWhen(
                eventTiming: (id, years) => id == eventId,
                orElse: () => false,
              ))
          .firstOrNull;

      if (override != null) {
        await ref
            .read(scenariosProvider.notifier)
            .removeOverride(widget.scenario.id, override);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Override removed'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing override: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
