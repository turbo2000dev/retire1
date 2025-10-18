import 'package:flutter/material.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// Event card widget that displays event information in a timeline
class EventCard extends StatelessWidget {
  final Event event;
  final List<Individual> individuals;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.individuals,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon based on event type
            _buildIcon(theme),
            const SizedBox(width: 16),
            // Event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(theme),
                  const SizedBox(height: 4),
                  _buildTiming(theme),
                  const SizedBox(height: 8),
                  _buildDetails(theme),
                ],
              ),
            ),
            // Action buttons
            Column(
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEdit,
                    tooltip: 'Edit',
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: onDelete,
                    color: theme.colorScheme.error,
                    tooltip: 'Delete',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return event.map(
      retirement: (_) => CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.beach_access,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      death: (_) => CircleAvatar(
        backgroundColor: theme.colorScheme.errorContainer,
        child: Icon(Icons.favorite, color: theme.colorScheme.onErrorContainer),
      ),
      realEstateTransaction: (_) => CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(Icons.home, color: theme.colorScheme.onSecondaryContainer),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return event.map(
      retirement: (e) {
        final individual = _getIndividual(e.individualId);
        return Text(
          'Retirement${individual != null ? ' - ${individual.name}' : ''}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
      },
      death: (e) {
        final individual = _getIndividual(e.individualId);
        return Text(
          'Death${individual != null ? ' - ${individual.name}' : ''}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        );
      },
      realEstateTransaction: (_) => Text(
        'Real Estate Transaction',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTiming(ThemeData theme) {
    final timingText = event.map(
      retirement: (e) => _formatTiming(e.timing),
      death: (e) => _formatTiming(e.timing),
      realEstateTransaction: (e) => _formatTiming(e.timing),
    );

    return Row(
      children: [
        Icon(
          Icons.schedule,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          timingText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(ThemeData theme) {
    return event.map(
      retirement: (_) => const SizedBox.shrink(),
      death: (_) => const SizedBox.shrink(),
      realEstateTransaction: (e) {
        final details = <String>[];

        if (e.assetSoldId != null) {
          details.add('Selling property');
        }
        if (e.assetPurchasedId != null) {
          details.add('Purchasing property');
        }

        return Text(
          details.join(' • '),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
    );
  }

  String _formatTiming(EventTiming timing) {
    return timing.map(
      relative: (t) => 'Year ${t.yearsFromStart} of projection',
      absolute: (t) => 'Calendar year ${t.calendarYear}',
      age: (t) {
        final individual = _getIndividual(t.individualId);
        return 'When ${individual?.name ?? 'individual'} turns ${t.age}';
      },
      eventRelative: (t) {
        final boundaryText = t.boundary == EventBoundary.start
            ? 'start'
            : 'end';
        return 'At $boundaryText of event';
      },
      projectionEnd: (t) => 'End of projection',
    );
  }

  Individual? _getIndividual(String id) {
    try {
      return individuals.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }
}
