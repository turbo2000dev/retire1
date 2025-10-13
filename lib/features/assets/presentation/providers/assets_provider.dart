import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/assets/data/asset_repository.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';

/// Repository provider for assets - depends on current project
final assetRepositoryProvider = Provider<AssetRepository?>((ref) {
  final currentProjectState = ref.watch(currentProjectProvider);

  if (currentProjectState is ProjectSelected) {
    return AssetRepository(projectId: currentProjectState.project.id);
  }

  return null;
});

/// Assets notifier - manages assets from Firestore
class AssetsNotifier extends AsyncNotifier<List<Asset>> {
  StreamSubscription<List<Asset>>? _subscription;

  @override
  Future<List<Asset>> build() async {
    ref.onDispose(() {
      _subscription?.cancel();
    });

    final repository = ref.watch(assetRepositoryProvider);

    if (repository == null) {
      return [];
    }

    // Subscribe to Firestore stream
    _subscription = repository.getAssetsStream().listen(
      (assets) {
        state = AsyncValue.data(assets);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );

    // Return initial empty state while waiting for first snapshot
    return [];
  }

  /// Add a new asset
  Future<void> addAsset(Asset asset) async {
    final repository = ref.read(assetRepositoryProvider);
    if (repository == null) {
      throw Exception('No project selected');
    }

    try {
      await repository.createAsset(asset);
      log('Asset added successfully');
    } catch (e, stack) {
      log('Failed to add asset', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Update an existing asset
  Future<void> updateAsset(Asset asset) async {
    final repository = ref.read(assetRepositoryProvider);
    if (repository == null) {
      throw Exception('No project selected');
    }

    try {
      await repository.updateAsset(asset);
      log('Asset updated successfully');
    } catch (e, stack) {
      log('Failed to update asset', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Delete an asset
  Future<void> deleteAsset(String assetId) async {
    final repository = ref.read(assetRepositoryProvider);
    if (repository == null) {
      throw Exception('No project selected');
    }

    try {
      await repository.deleteAsset(assetId);
      log('Asset deleted successfully');
    } catch (e, stack) {
      log('Failed to delete asset', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

/// Provider for assets
final assetsProvider = AsyncNotifierProvider<AssetsNotifier, List<Asset>>(() {
  return AssetsNotifier();
});

/// Provider for assets grouped by type
final assetsByTypeProvider = Provider<Map<String, List<Asset>>>((ref) {
  final assetsAsync = ref.watch(assetsProvider);

  return assetsAsync.maybeWhen(
    data: (assets) {
      final Map<String, List<Asset>> grouped = {
        'Real Estate': [],
        'RRSP': [],
        'CELI': [],
        'CRI/FRV': [],
        'Cash': [],
      };

      for (final asset in assets) {
        asset.map(
          realEstate: (a) => grouped['Real Estate']!.add(a),
          rrsp: (a) => grouped['RRSP']!.add(a),
          celi: (a) => grouped['CELI']!.add(a),
          cri: (a) => grouped['CRI/FRV']!.add(a),
          cash: (a) => grouped['Cash']!.add(a),
        );
      }

      return grouped;
    },
    orElse: () => {
      'Real Estate': [],
      'RRSP': [],
      'CELI': [],
      'CRI/FRV': [],
      'Cash': [],
    },
  );
});
