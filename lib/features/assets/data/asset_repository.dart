import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retire1/features/assets/domain/asset.dart';

/// Repository for managing assets in Firestore
/// Assets are stored in projects/{projectId}/assets collection
class AssetRepository {
  final FirebaseFirestore _firestore;
  final String projectId;

  AssetRepository({
    required this.projectId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get reference to the assets collection for this project
  CollectionReference get _assetsCollection =>
      _firestore.collection('projects').doc(projectId).collection('assets');

  /// Get a stream of all assets for the current project
  Stream<List<Asset>> getAssetsStream() {
    return _assetsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          return Asset.fromJson(data);
        } catch (e) {
          log('Error parsing asset ${doc.id}: $e');
          rethrow;
        }
      }).toList();
    });
  }

  /// Create a new asset
  Future<void> createAsset(Asset asset) async {
    try {
      final id = asset.map(
        realEstate: (a) => a.id,
        rrsp: (a) => a.id,
        celi: (a) => a.id,
        cash: (a) => a.id,
      );

      await _assetsCollection.doc(id).set(asset.toJson());
      log('Asset created: $id');
    } catch (e) {
      log('Error creating asset: $e');
      rethrow;
    }
  }

  /// Update an existing asset
  Future<void> updateAsset(Asset asset) async {
    try {
      final id = asset.map(
        realEstate: (a) => a.id,
        rrsp: (a) => a.id,
        celi: (a) => a.id,
        cash: (a) => a.id,
      );

      await _assetsCollection.doc(id).set(asset.toJson());
      log('Asset updated: $id');
    } catch (e) {
      log('Error updating asset: $e');
      rethrow;
    }
  }

  /// Delete an asset
  Future<void> deleteAsset(String assetId) async {
    try {
      await _assetsCollection.doc(assetId).delete();
      log('Asset deleted: $assetId');
    } catch (e) {
      log('Error deleting asset: $e');
      rethrow;
    }
  }

  /// Get a single asset by ID
  Future<Asset?> getAsset(String assetId) async {
    try {
      final doc = await _assetsCollection.doc(assetId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return Asset.fromJson(data);
    } catch (e) {
      log('Error getting asset $assetId: $e');
      rethrow;
    }
  }
}
