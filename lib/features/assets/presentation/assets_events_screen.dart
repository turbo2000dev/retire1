import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/assets/presentation/widgets/add_asset_dialog.dart';
import 'package:retire1/features/assets/presentation/widgets/asset_card.dart';

/// Assets & Events screen - manages assets and life events
/// Phase 13: Assets UI only (events will be added in Phase 15)
class AssetsEventsScreen extends ConsumerWidget {
  const AssetsEventsScreen({super.key});

  Future<void> _addAsset(BuildContext context, WidgetRef ref) async {
    final result = await AddAssetDialog.show(context);
    if (result != null && context.mounted) {
      try {
        await ref.read(assetsProvider.notifier).addAsset(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asset added successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add asset: $e')),
          );
        }
      }
    }
  }

  Future<void> _editAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    final result = await AddAssetDialog.show(context, asset: asset);
    if (result != null && context.mounted) {
      try {
        await ref.read(assetsProvider.notifier).updateAsset(result);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asset updated successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update asset: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteAsset(BuildContext context, WidgetRef ref, Asset asset) async {
    final assetId = asset.map(
      realEstate: (a) => a.id,
      rrsp: (a) => a.id,
      celi: (a) => a.id,
      cash: (a) => a.id,
    );

    final assetName = asset.map(
      realEstate: (a) => 'this property',
      rrsp: (a) => 'this RRSP account',
      celi: (a) => 'this CELI account',
      cash: (a) => 'this cash account',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete $assetName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(assetsProvider.notifier).deleteAsset(assetId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Asset deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete asset: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final assetsAsync = ref.watch(assetsProvider);
    final assetsByType = ref.watch(assetsByTypeProvider);

    return Scaffold(
      body: assetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: ResponsiveContainer(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load assets',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => ref.invalidate(assetsProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
        data: (assets) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assets',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Manage your financial assets',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Assets grouped by type
            ...assetsByType.entries.map((entry) {
            final typeName = entry.key;
            final assets = entry.value;

            return SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section header
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            Text(
                              typeName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${assets.length}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Asset cards
                      if (assets.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(
                              child: Text(
                                'No ${typeName.toLowerCase()} assets yet',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        ...assets.map((asset) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AssetCard(
                              asset: asset,
                              onEdit: () => _editAsset(context, ref, asset),
                              onDelete: () => _deleteAsset(context, ref, asset),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            );
          }),
            // Bottom padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAsset(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Asset'),
      ),
    );
  }
}
