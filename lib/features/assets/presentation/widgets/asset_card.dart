import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/assets/domain/asset.dart';

/// Asset card widget that displays asset information based on type
class AssetCard extends StatelessWidget {
  final Asset asset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssetCard({
    super.key,
    required this.asset,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon based on asset type
            _buildIcon(theme),
            const SizedBox(width: 16),
            // Asset details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(theme),
                  const SizedBox(height: 4),
                  _buildSubtitle(theme, currencyFormat),
                ],
              ),
            ),
            // Action buttons
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
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    return asset.map(
      realEstate: (a) => CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          Icons.home,
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      rrsp: (a) => CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.account_balance,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      celi: (a) => CircleAvatar(
        backgroundColor: theme.colorScheme.tertiaryContainer,
        child: Icon(
          Icons.savings,
          color: theme.colorScheme.onTertiaryContainer,
        ),
      ),
      cri: (a) => CircleAvatar(
        backgroundColor: theme.colorScheme.errorContainer,
        child: Icon(
          Icons.lock,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      cash: (a) => CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.account_balance_wallet,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return asset.map(
      realEstate: (a) => Text(
        _getRealEstateTypeName(a.type),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      rrsp: (a) => Text(
        'RRSP Account',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      celi: (a) => Text(
        'CELI Account',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      cri: (a) => Text(
        'CRI/FRV Account',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      cash: (a) => Text(
        'Cash Account',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSubtitle(ThemeData theme, NumberFormat currencyFormat) {
    return asset.map(
      realEstate: (a) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Value: ${currencyFormat.format(a.value)}',
            style: theme.textTheme.bodyMedium,
          ),
          if (a.setAtStart)
            Text(
              'Set at start of planning',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
      rrsp: (a) => _buildAccountSubtitle(theme, currencyFormat, a.value, a.customReturnRate, a.annualContribution),
      celi: (a) => _buildAccountSubtitle(theme, currencyFormat, a.value, a.customReturnRate, a.annualContribution),
      cri: (a) => _buildCRISubtitle(theme, currencyFormat, a.value, a.customReturnRate, a.annualContribution, a.contributionRoom),
      cash: (a) => _buildAccountSubtitle(theme, currencyFormat, a.value, a.customReturnRate, a.annualContribution),
    );
  }

  Widget _buildAccountSubtitle(ThemeData theme, NumberFormat currencyFormat, double value, double? customReturnRate, double? annualContribution) {
    final hasOptionalFields = customReturnRate != null || annualContribution != null;

    if (!hasOptionalFields) {
      return Text(
        'Balance: ${currencyFormat.format(value)}',
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance: ${currencyFormat.format(value)}',
          style: theme.textTheme.bodyMedium,
        ),
        if (customReturnRate != null)
          Text(
            'Custom return: ${customReturnRate.toStringAsFixed(2)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        if (annualContribution != null)
          Text(
            'Annual contribution: ${currencyFormat.format(annualContribution)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
      ],
    );
  }

  Widget _buildCRISubtitle(ThemeData theme, NumberFormat currencyFormat, double value, double? customReturnRate, double? annualContribution, double? contributionRoom) {
    final hasOptionalFields = customReturnRate != null || annualContribution != null || contributionRoom != null;

    if (!hasOptionalFields) {
      return Text(
        'Balance: ${currencyFormat.format(value)}',
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Balance: ${currencyFormat.format(value)}',
          style: theme.textTheme.bodyMedium,
        ),
        if (contributionRoom != null)
          Text(
            'Contribution room: ${currencyFormat.format(contributionRoom)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        if (customReturnRate != null)
          Text(
            'Custom return: ${customReturnRate.toStringAsFixed(2)}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
        if (annualContribution != null)
          Text(
            'Annual contribution: ${currencyFormat.format(annualContribution)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
      ],
    );
  }

  String _getRealEstateTypeName(RealEstateType type) {
    switch (type) {
      case RealEstateType.house:
        return 'House';
      case RealEstateType.condo:
        return 'Condo';
      case RealEstateType.cottage:
        return 'Cottage';
      case RealEstateType.land:
        return 'Land';
      case RealEstateType.commercial:
        return 'Commercial Property';
      case RealEstateType.other:
        return 'Other Property';
    }
  }
}
