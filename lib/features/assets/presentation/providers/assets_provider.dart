import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/assets/domain/asset.dart';

/// Mock assets provider for Phase 13 (UI only)
/// This will be replaced with Firestore integration in Phase 14
class AssetsNotifier extends StateNotifier<List<Asset>> {
  AssetsNotifier() : super(_getMockAssets());

  /// Generate some mock assets for testing
  static List<Asset> _getMockAssets() {
    return [
      Asset.realEstate(
        id: '1',
        type: RealEstateType.house,
        value: 450000,
        setAtStart: true,
      ),
      Asset.realEstate(
        id: '2',
        type: RealEstateType.cottage,
        value: 200000,
      ),
      Asset.rrsp(
        id: '3',
        individualId: 'mock-individual-1',
        value: 125000,
      ),
      Asset.celi(
        id: '4',
        individualId: 'mock-individual-1',
        value: 50000,
      ),
      Asset.cash(
        id: '5',
        individualId: 'mock-individual-2',
        value: 15000,
      ),
    ];
  }

  /// Add a new asset
  Future<void> addAsset(Asset asset) async {
    try {
      log('Adding asset: ${asset.toString()}');
      state = [...state, asset];
    } catch (e, stack) {
      log('Failed to add asset', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Update an existing asset
  Future<void> updateAsset(Asset updatedAsset) async {
    try {
      log('Updating asset: ${updatedAsset.toString()}');
      state = [
        for (final asset in state)
          if (asset.map(
            realEstate: (a) => a.id == updatedAsset.maybeMap(
              realEstate: (u) => u.id,
              orElse: () => null,
            ),
            rrsp: (a) => a.id == updatedAsset.maybeMap(
              rrsp: (u) => u.id,
              orElse: () => null,
            ),
            celi: (a) => a.id == updatedAsset.maybeMap(
              celi: (u) => u.id,
              orElse: () => null,
            ),
            cash: (a) => a.id == updatedAsset.maybeMap(
              cash: (u) => u.id,
              orElse: () => null,
            ),
          ))
            updatedAsset
          else
            asset,
      ];
    } catch (e, stack) {
      log('Failed to update asset', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Delete an asset
  Future<void> deleteAsset(String assetId) async {
    try {
      log('Deleting asset: $assetId');
      state = state.where((asset) {
        return asset.map(
          realEstate: (a) => a.id != assetId,
          rrsp: (a) => a.id != assetId,
          celi: (a) => a.id != assetId,
          cash: (a) => a.id != assetId,
        );
      }).toList();
    } catch (e, stack) {
      log('Failed to delete asset', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get assets grouped by type
  Map<String, List<Asset>> get assetsByType {
    final Map<String, List<Asset>> grouped = {
      'Real Estate': [],
      'RRSP': [],
      'CELI': [],
      'Cash': [],
    };

    for (final asset in state) {
      asset.map(
        realEstate: (a) => grouped['Real Estate']!.add(a),
        rrsp: (a) => grouped['RRSP']!.add(a),
        celi: (a) => grouped['CELI']!.add(a),
        cash: (a) => grouped['Cash']!.add(a),
      );
    }

    return grouped;
  }
}

/// Provider for assets
final assetsProvider = StateNotifierProvider<AssetsNotifier, List<Asset>>((ref) {
  return AssetsNotifier();
});

/// Provider for assets grouped by type
final assetsByTypeProvider = Provider<Map<String, List<Asset>>>((ref) {
  return ref.watch(assetsProvider.notifier).assetsByType;
});
