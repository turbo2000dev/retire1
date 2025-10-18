import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/projection/presentation/providers/column_visibility_provider.dart';

/// Dialog for toggling column group visibility in the expanded table
class ColumnVisibilityDialog extends ConsumerWidget {
  const ColumnVisibilityDialog({super.key});

  static const Map<String, String> _columnGroupLabels = {
    'basic': 'Basic (Year, Ages)',
    'income': 'Income Sources',
    'expenses': 'Expenses by Category',
    'taxes': 'Taxes',
    'cashFlow': 'Cash Flow',
    'withdrawals': 'Withdrawals by Account',
    'contributions': 'Contributions by Account',
    'assets': 'Asset Balances',
    'netWorth': 'Net Worth',
    'warnings': 'Warnings',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final columnVisibility = ref.watch(columnVisibilityProvider);
    final columnVisibilityNotifier = ref.read(
      columnVisibilityProvider.notifier,
    );

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.visibility, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          const Text('Column Visibility'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select which column groups to show in the detailed table:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            // Column group checkboxes
            ..._columnGroupLabels.entries.map((entry) {
              final groupKey = entry.key;
              final groupLabel = entry.value;
              final isVisible = columnVisibility.visibleColumnGroups.contains(
                groupKey,
              );

              return CheckboxListTile(
                title: Text(groupLabel),
                value: isVisible,
                onChanged: (value) {
                  columnVisibilityNotifier.toggleColumnGroup(groupKey);
                },
                dense: true,
                contentPadding: EdgeInsets.zero,
              );
            }),
            const SizedBox(height: 16),
            // Quick action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    columnVisibilityNotifier.showAll();
                  },
                  icon: const Icon(Icons.check_box),
                  label: const Text('Show All'),
                ),
                TextButton.icon(
                  onPressed: () {
                    columnVisibilityNotifier.hideAll();
                  },
                  icon: const Icon(Icons.check_box_outline_blank),
                  label: const Text('Hide All'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            columnVisibilityNotifier.reset();
          },
          child: const Text('Reset to Default'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
