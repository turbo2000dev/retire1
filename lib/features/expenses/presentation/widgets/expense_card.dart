import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// Expense card widget that displays expense information
class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final List<Individual> individuals;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.individuals,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon based on expense category
            _buildIcon(theme),
            const SizedBox(width: 16),
            // Expense details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category name
                  Text(
                    expense.categoryName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Amount
                  expense.when(
                    housing: (_, __, ___, annualAmount) =>
                        _buildAmount(theme, currencyFormat, annualAmount),
                    transport: (_, __, ___, annualAmount) =>
                        _buildAmount(theme, currencyFormat, annualAmount),
                    dailyLiving: (_, __, ___, annualAmount) =>
                        _buildAmount(theme, currencyFormat, annualAmount),
                    recreation: (_, __, ___, annualAmount) =>
                        _buildAmount(theme, currencyFormat, annualAmount),
                    health: (_, __, ___, annualAmount) =>
                        _buildAmount(theme, currencyFormat, annualAmount),
                    family: (_, __, ___, annualAmount) =>
                        _buildAmount(theme, currencyFormat, annualAmount),
                  ),
                  const SizedBox(height: 8),
                  // Timing
                  expense.when(
                    housing: (_, startTiming, endTiming, __) =>
                        _buildTiming(theme, startTiming, endTiming),
                    transport: (_, startTiming, endTiming, __) =>
                        _buildTiming(theme, startTiming, endTiming),
                    dailyLiving: (_, startTiming, endTiming, __) =>
                        _buildTiming(theme, startTiming, endTiming),
                    recreation: (_, startTiming, endTiming, __) =>
                        _buildTiming(theme, startTiming, endTiming),
                    health: (_, startTiming, endTiming, __) =>
                        _buildTiming(theme, startTiming, endTiming),
                    family: (_, startTiming, endTiming, __) =>
                        _buildTiming(theme, startTiming, endTiming),
                  ),
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
    return expense.when(
      housing: (_, __, ___, ____) => CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(Icons.home, color: theme.colorScheme.onPrimaryContainer),
      ),
      transport: (_, __, ___, ____) => CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.directions_car,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      dailyLiving: (_, __, ___, ____) => CircleAvatar(
        backgroundColor: theme.colorScheme.tertiaryContainer,
        child: Icon(
          Icons.shopping_cart,
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
      recreation: (_, __, ___, ____) => CircleAvatar(
        backgroundColor: Colors.purple.shade100,
        child: Icon(Icons.theater_comedy, color: Colors.purple.shade900),
      ),
      health: (_, __, ___, ____) => CircleAvatar(
        backgroundColor: Colors.red.shade100,
        child: Icon(Icons.medical_services, color: Colors.red.shade900),
      ),
      family: (_, __, ___, ____) => CircleAvatar(
        backgroundColor: Colors.orange.shade100,
        child: Icon(Icons.family_restroom, color: Colors.orange.shade900),
      ),
    );
  }

  Widget _buildAmount(
    ThemeData theme,
    NumberFormat currencyFormat,
    double annualAmount,
  ) {
    return Row(
      children: [
        Icon(Icons.attach_money, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          '${currencyFormat.format(annualAmount)} per year',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTiming(
    ThemeData theme,
    EventTiming startTiming,
    EventTiming? endTiming,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.play_arrow,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Start: ${_formatTiming(startTiming)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        if (endTiming != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.stop,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'End: ${_formatTiming(endTiming)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.all_inclusive,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                'Continues indefinitely',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatTiming(EventTiming timing) {
    return timing.map(
      relative: (t) => 'Year ${t.yearsFromStart}',
      absolute: (t) => 'Year ${t.calendarYear}',
      age: (t) {
        final individual = _getIndividual(t.individualId);
        return '${individual?.name ?? 'Individual'} at ${t.age}';
      },
      eventRelative: (t) {
        // TODO: Format event name properly when events are available
        final boundaryText = t.boundary == EventBoundary.start
            ? 'start'
            : 'end';
        return 'At $boundaryText of event';
      },
      projectionEnd: (t) => 'Until end',
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
