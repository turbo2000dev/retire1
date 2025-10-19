import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/assets/presentation/widgets/add_asset_dialog.dart';
import 'package:retire1/features/assets/presentation/widgets/asset_card.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Assets section - Manage retirement assets (optional)
class AssetsSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const AssetsSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<AssetsSectionScreen> createState() =>
      _AssetsSectionScreenState();
}

class _AssetsSectionScreenState extends ConsumerState<AssetsSectionScreen> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception(AppLocalizations.of(context).noProjectSelected);
      }

      // Register validation callback for Next button
      widget.onRegisterCallback?.call(_validateAndContinue);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Mark section as in progress after first frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus('assets', WizardSectionStatus.inProgress());
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _validateAndContinue() async {
    // Assets section is optional - always allow to continue
    // If no assets, mark as skipped; if has assets, mark as complete
    final assetsState = ref.read(assetsProvider);

    await assetsState.when(
      data: (assets) async {
        if (assets.isEmpty) {
          // No assets - mark as skipped
          await ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus('assets', WizardSectionStatus.skipped());
        } else {
          // Has assets - mark as complete
          await ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus('assets', WizardSectionStatus.complete());
        }
      },
      loading: () async {
        // Loading - mark as skipped for now
        await ref
            .read(wizardProgressProvider.notifier)
            .updateSectionStatus('assets', WizardSectionStatus.skipped());
      },
      error: (_, __) async {
        // Error - mark as skipped
        await ref
            .read(wizardProgressProvider.notifier)
            .updateSectionStatus('assets', WizardSectionStatus.skipped());
      },
    );

    return true; // Always allow to continue (optional section)
  }

  Future<void> _addAsset(BuildContext context) async {
    bool createAnother = true;

    while (createAnother) {
      if (!context.mounted) break;

      final result = await AddAssetDialog.show(context);

      if (result == null) {
        // User cancelled
        break;
      }

      if (!context.mounted) break;

      try {
        await ref.read(assetsProvider.notifier).addAsset(result.asset);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).assetCreated)),
          );
        }

        // Check if user wants to create another
        createAnother = result.createAnother;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToCreateAsset}: $e',
              ),
            ),
          );
        }
        // Break on error
        break;
      }
    }
  }

  Future<void> _editAsset(BuildContext context, Asset asset) async {
    final result = await AddAssetDialog.show(context, asset: asset);

    if (result == null) return;

    if (!context.mounted) return;

    try {
      await ref.read(assetsProvider.notifier).updateAsset(result.asset);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).assetUpdated)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).failedToUpdateAsset}: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteAsset(BuildContext context, Asset asset) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAssetTitle),
        content: Text(l10n.deleteAssetConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      await ref.read(assetsProvider.notifier).deleteAsset(asset.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).assetDeleted)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).failedToDeleteAsset}: $e',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${l10n.error}: $_errorMessage',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    final assetsAsync = ref.watch(assetsProvider);

    return ResponsiveContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.yourAssets, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            l10n.assetsSectionDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),

          // Add Asset Button
          FilledButton.icon(
            onPressed: () => _addAsset(context),
            icon: const Icon(Icons.add),
            label: Text(l10n.addAsset),
          ),
          const SizedBox(height: 24),

          // Assets List
          Expanded(
            child: assetsAsync.when(
              data: (assets) {
                if (assets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noAssetsYet,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.addFirstAssetOrSkip,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AssetCard(
                        asset: asset,
                        onEdit: () => _editAsset(context, asset),
                        onDelete: () => _deleteAsset(context, asset),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  '${l10n.errorLoadingAssets}: $error',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info text
          Text(
            l10n.clickNextOrSkipAssets,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
