import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/widgets/account_form.dart';
import 'package:retire1/features/assets/presentation/widgets/real_estate_form.dart';

/// Result from asset dialog including asset and whether to create another
class AssetDialogResult {
  final Asset asset;
  final bool createAnother;

  const AssetDialogResult({
    required this.asset,
    required this.createAnother,
  });
}

/// Asset type selection for the dialog
enum AssetTypeSelection {
  realEstate,
  rrsp,
  celi,
  cash,
}

/// Dialog for adding a new asset with type selection
class AddAssetDialog extends StatefulWidget {
  final Asset? asset; // For editing existing asset

  const AddAssetDialog({
    super.key,
    this.asset,
  });

  static Future<AssetDialogResult?> show(BuildContext context, {Asset? asset}) {
    return showDialog<AssetDialogResult>(
      context: context,
      builder: (context) => AddAssetDialog(asset: asset),
    );
  }

  @override
  State<AddAssetDialog> createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  AssetTypeSelection? _selectedType;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    // If editing, auto-select type and show form
    if (widget.asset != null) {
      _selectedType = widget.asset!.map(
        realEstate: (_) => AssetTypeSelection.realEstate,
        rrsp: (_) => AssetTypeSelection.rrsp,
        celi: (_) => AssetTypeSelection.celi,
        cash: (_) => AssetTypeSelection.cash,
      );
      _showForm = true;
    }
  }

  void _selectType(AssetTypeSelection type) {
    setState(() {
      _selectedType = type;
      _showForm = true;
    });
  }

  void _handleSave(Asset asset, {bool createAnother = false}) {
    Navigator.of(context).pop(
      AssetDialogResult(
        asset: asset,
        createAnother: createAnother,
      ),
    );
  }

  void _handleCancel() {
    if (_showForm && widget.asset == null) {
      // Go back to type selection
      setState(() {
        _showForm = false;
        _selectedType = null;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = widget.asset == null
        ? (_showForm ? 'Add ${_getTypeName(_selectedType!)}' : 'Add Asset')
        : 'Edit ${_getTypeName(_selectedType!)}';

    return ResponsiveDialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _showForm
                ? _buildForm()
                : _buildTypeSelector(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Select asset type',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        _buildTypeCard(
          theme: theme,
          icon: Icons.home,
          title: 'Real Estate',
          subtitle: 'House, condo, cottage, land, etc.',
          type: AssetTypeSelection.realEstate,
        ),
        const SizedBox(height: 8),
        _buildTypeCard(
          theme: theme,
          icon: Icons.account_balance,
          title: 'RRSP Account',
          subtitle: 'Registered Retirement Savings Plan',
          type: AssetTypeSelection.rrsp,
        ),
        const SizedBox(height: 8),
        _buildTypeCard(
          theme: theme,
          icon: Icons.savings,
          title: 'CELI Account',
          subtitle: 'Tax-Free Savings Account',
          type: AssetTypeSelection.celi,
        ),
        const SizedBox(height: 8),
        _buildTypeCard(
          theme: theme,
          icon: Icons.account_balance_wallet,
          title: 'Cash Account',
          subtitle: 'Savings or checking account',
          type: AssetTypeSelection.cash,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildTypeCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required AssetTypeSelection type,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _selectType(type),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    switch (_selectedType!) {
      case AssetTypeSelection.realEstate:
        return RealEstateForm(
          asset: widget.asset as RealEstateAsset?,
          onSave: _handleSave,
          onCancel: _handleCancel,
        );
      case AssetTypeSelection.rrsp:
        return AccountForm(
          accountType: AccountType.rrsp,
          asset: widget.asset,
          onSave: _handleSave,
          onCancel: _handleCancel,
        );
      case AssetTypeSelection.celi:
        return AccountForm(
          accountType: AccountType.celi,
          asset: widget.asset,
          onSave: _handleSave,
          onCancel: _handleCancel,
        );
      case AssetTypeSelection.cash:
        return AccountForm(
          accountType: AccountType.cash,
          asset: widget.asset,
          onSave: _handleSave,
          onCancel: _handleCancel,
        );
    }
  }

  String _getTypeName(AssetTypeSelection type) {
    switch (type) {
      case AssetTypeSelection.realEstate:
        return 'Real Estate';
      case AssetTypeSelection.rrsp:
        return 'RRSP';
      case AssetTypeSelection.celi:
        return 'CELI';
      case AssetTypeSelection.cash:
        return 'Cash Account';
    }
  }
}
