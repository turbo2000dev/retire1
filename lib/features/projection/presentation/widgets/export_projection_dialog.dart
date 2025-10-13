import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';

enum ExportFormat { json, csv }

/// Dialog for selecting projection export format
class ExportProjectionDialog extends StatefulWidget {
  const ExportProjectionDialog({super.key});

  /// Show the export dialog and return the selected format
  static Future<ExportFormat?> show(BuildContext context) {
    return showDialog<ExportFormat>(
      context: context,
      builder: (context) => const ExportProjectionDialog(),
    );
  }

  @override
  State<ExportProjectionDialog> createState() => _ExportProjectionDialogState();
}

class _ExportProjectionDialogState extends State<ExportProjectionDialog> {
  ExportFormat _selectedFormat = ExportFormat.json;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveDialog(
      child: ResponsiveDialogContent(
        title: 'Export Projection',
        content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select export format:',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          // Format selector using SegmentedButton
          Center(
            child: SegmentedButton<ExportFormat>(
              segments: const [
                ButtonSegment<ExportFormat>(
                  value: ExportFormat.json,
                  label: Text('JSON'),
                  icon: Icon(Icons.data_object),
                ),
                ButtonSegment<ExportFormat>(
                  value: ExportFormat.csv,
                  label: Text('CSV'),
                  icon: Icon(Icons.table_chart),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (Set<ExportFormat> selection) {
                setState(() {
                  _selectedFormat = selection.first;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          // Format descriptions
          _buildFormatDescription(),
        ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(_selectedFormat),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatDescription() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String title;
    String description;
    IconData icon;

    switch (_selectedFormat) {
      case ExportFormat.json:
        title = 'JSON Format';
        description = 'Complete projection data with all fields. '
            'Ideal for debugging and technical analysis.';
        icon = Icons.data_object;
        break;
      case ExportFormat.csv:
        title = 'CSV Format';
        description = 'Spreadsheet-friendly format with yearly data. '
            'Opens in Excel, Google Sheets, etc.';
        icon = Icons.table_chart;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
