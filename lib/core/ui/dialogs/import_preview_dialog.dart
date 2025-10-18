import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/core/services/project_import_service.dart';

/// Dialog showing preview of project data before import
class ImportPreviewDialog extends StatelessWidget {
  final ImportPreview preview;

  const ImportPreviewDialog({super.key, required this.preview});

  /// Show the import preview dialog
  static Future<bool?> show(BuildContext context, ImportPreview preview) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ImportPreviewDialog(preview: preview),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat.decimalPercentPattern(decimalDigits: 2);

    return AlertDialog(
      title: const Text('Import Project'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Project name
              Text(
                'Project Name',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                preview.projectName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Individuals
              _buildSection(
                theme,
                'Individuals',
                preview.individualCount.toString(),
                Icons.people_outline,
              ),
              const SizedBox(height: 16),

              // Assets
              _buildSection(
                theme,
                'Assets',
                _getTotalAssetCount().toString(),
                Icons.account_balance_wallet_outlined,
              ),
              if (_getTotalAssetCount() > 0) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: preview.assetCountsByType.entries
                        .where((e) => e.value > 0)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${e.key}: ${e.value}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Events
              _buildSection(
                theme,
                'Events',
                _getTotalEventCount().toString(),
                Icons.event_outlined,
              ),
              if (_getTotalEventCount() > 0) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: preview.eventCountsByType.entries
                        .where((e) => e.value > 0)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${e.key}: ${e.value}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Expenses
              _buildSection(
                theme,
                'Expenses',
                _getTotalExpenseCount().toString(),
                Icons.payments_outlined,
              ),
              if (_getTotalExpenseCount() > 0) ...[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: preview.expenseCountsByCategory.entries
                        .where((e) => e.value > 0)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${e.key}: ${e.value}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // Scenarios
              _buildSection(
                theme,
                'Scenarios',
                preview.scenarioCount.toString(),
                Icons.compare_arrows_outlined,
              ),
              const SizedBox(height: 16),

              // Economic assumptions
              Text(
                'Economic Assumptions',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRateRow(
                      theme,
                      'Inflation',
                      preview.economicAssumptions['inflationRate'] as double,
                      numberFormat,
                    ),
                    _buildRateRow(
                      theme,
                      'REER Return',
                      preview.economicAssumptions['reerReturnRate'] as double,
                      numberFormat,
                    ),
                    _buildRateRow(
                      theme,
                      'CELI Return',
                      preview.economicAssumptions['celiReturnRate'] as double,
                      numberFormat,
                    ),
                    _buildRateRow(
                      theme,
                      'CRI Return',
                      preview.economicAssumptions['criReturnRate'] as double,
                      numberFormat,
                    ),
                    _buildRateRow(
                      theme,
                      'Cash Return',
                      preview.economicAssumptions['cashReturnRate'] as double,
                      numberFormat,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Warning message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'A new project will be created with this data. All IDs will be regenerated.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.file_upload_outlined),
          label: const Text('Import'),
        ),
      ],
    );
  }

  Widget _buildSection(
    ThemeData theme,
    String title,
    String count,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 24, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Text(title, style: theme.textTheme.titleSmall),
        const Spacer(),
        Text(
          count,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildRateRow(
    ThemeData theme,
    String label,
    double rate,
    NumberFormat formatter, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            formatter.format(rate),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalAssetCount() {
    return preview.assetCountsByType.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }

  int _getTotalEventCount() {
    return preview.eventCountsByType.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }

  int _getTotalExpenseCount() {
    return preview.expenseCountsByCategory.values.fold(
      0,
      (sum, count) => sum + count,
    );
  }
}
