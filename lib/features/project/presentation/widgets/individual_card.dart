import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/project/domain/individual.dart';

/// A card that displays information about an individual
class IndividualCard extends StatelessWidget {
  final Individual individual;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const IndividualCard({
    super.key,
    required this.individual,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                individual.name.isNotEmpty
                    ? individual.name[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Individual info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    individual.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Born ${dateFormat.format(individual.birthdate)} • Age ${individual.age}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      _buildInfoChip(
                        context,
                        Icons.attach_money,
                        'Income: ${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(individual.employmentIncome)}',
                      ),
                      _buildInfoChip(
                        context,
                        Icons.calendar_today,
                        'RRQ: ${individual.rrqStartAge}',
                      ),
                      _buildInfoChip(
                        context,
                        Icons.calendar_today,
                        'PSV: ${individual.psvStartAge}',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            if (onEdit != null || onDelete != null) ...[
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
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
                      tooltip: 'Delete',
                      color: theme.colorScheme.error,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
