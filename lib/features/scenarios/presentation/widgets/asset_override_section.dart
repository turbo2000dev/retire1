import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Section for managing asset value overrides in a scenario
class AssetOverrideSection extends ConsumerWidget {
  final Scenario scenario;

  const AssetOverrideSection({super.key, required this.scenario});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assetsAsync = ref.watch(assetsProvider);

    return assetsAsync.when(
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
                'Failed to load assets',
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
      data: (assets) {
        if (assets.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No assets available',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add assets in the Assets & Events screen to override their values here',
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
              'Override asset values to explore different scenarios. '
              'Only modified values will be used in projections for this scenario.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...assets.map((asset) {
              final assetId = asset.when(
                realEstate: (id, type, value, setAtStart, customReturnRate) =>
                    id,
                rrsp:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => id,
                celi:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => id,
                cri:
                    (
                      id,
                      individualId,
                      value,
                      contributionRoom,
                      customReturnRate,
                      annualContribution,
                    ) => id,
                cash:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => id,
              );

              final baseValue = asset.when(
                realEstate: (id, type, value, setAtStart, customReturnRate) =>
                    value,
                rrsp:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => value,
                celi:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => value,
                cri:
                    (
                      id,
                      individualId,
                      value,
                      contributionRoom,
                      customReturnRate,
                      annualContribution,
                    ) => value,
                cash:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => value,
              );

              final assetTypeName = asset.when(
                realEstate: (id, type, value, setAtStart, customReturnRate) =>
                    'Real Estate (${type.name})',
                rrsp:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => 'RRSP Account',
                celi:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => 'CELI Account',
                cri:
                    (
                      id,
                      individualId,
                      value,
                      contributionRoom,
                      customReturnRate,
                      annualContribution,
                    ) => 'CRI/FRV Account',
                cash:
                    (
                      id,
                      individualId,
                      value,
                      customReturnRate,
                      annualContribution,
                    ) => 'Cash Account',
              );

              // Check if there's an override for this asset
              final override = scenario.overrides
                  .where(
                    (o) => o.maybeWhen(
                      assetValue: (id, value) => id == assetId,
                      orElse: () => false,
                    ),
                  )
                  .firstOrNull;

              final overrideValue = override?.maybeWhen(
                assetValue: (id, value) => value,
                orElse: () => null,
              );

              return _AssetOverrideCard(
                assetId: assetId,
                assetTypeName: assetTypeName,
                baseValue: baseValue,
                overrideValue: overrideValue,
                scenario: scenario,
              );
            }),
          ],
        );
      },
    );
  }
}

/// Card for a single asset override
class _AssetOverrideCard extends ConsumerStatefulWidget {
  final String assetId;
  final String assetTypeName;
  final double baseValue;
  final double? overrideValue;
  final Scenario scenario;

  const _AssetOverrideCard({
    required this.assetId,
    required this.assetTypeName,
    required this.baseValue,
    required this.overrideValue,
    required this.scenario,
  });

  @override
  ConsumerState<_AssetOverrideCard> createState() => _AssetOverrideCardState();
}

class _AssetOverrideCardState extends ConsumerState<_AssetOverrideCard> {
  final _controller = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );
    final isOverridden = widget.overrideValue != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isOverridden
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.assetTypeName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Base: ${currencyFormat.format(widget.baseValue)}',
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
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'OVERRIDDEN',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
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
                  labelText: 'Override Value',
                  hintText: 'Enter new value',
                  prefixText: '\$ ',
                  border: const OutlineInputBorder(),
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                        'Override: ${currencyFormat.format(widget.overrideValue!)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _controller.text = widget.overrideValue!
                            .toInt()
                            .toString();
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
                        _controller.text = widget.baseValue.toInt().toString();
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
    final value = double.tryParse(_controller.text);
    if (value == null || value < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid value'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      final override = ParameterOverride.assetValue(
        assetId: widget.assetId,
        value: value,
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
        content: const Text('Remove this override and use the base value?'),
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
      final override = ParameterOverride.assetValue(
        assetId: widget.assetId,
        value: widget.overrideValue!,
      );

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
