import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';

/// Repository for managing user settings in Firestore
///
/// Firestore structure:
/// users/{userId}/settings/currentProject
class SettingsRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  SettingsRepository({
    required this.userId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get the settings document reference for the current user
  DocumentReference<Map<String, dynamic>> get _settingsDoc =>
      _firestore.collection('users').doc(userId).collection('settings').doc('currentProject');

  /// Get the currently selected project ID
  Future<String?> getCurrentProjectId() async {
    try {
      final doc = await _settingsDoc.get();
      if (!doc.exists) {
        return null;
      }
      return doc.data()?['projectId'] as String?;
    } catch (e, stack) {
      log('Failed to get current project ID', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Set the currently selected project ID
  Future<void> setCurrentProjectId(String? projectId) async {
    try {
      if (projectId == null) {
        await _settingsDoc.delete();
        log('Current project ID cleared');
      } else {
        await _settingsDoc.set({
          'projectId': projectId,
          'updatedAt': Timestamp.fromDate(DateTime.now()),
        });
        log('Current project ID set to: $projectId');
      }
    } catch (e, stack) {
      log('Failed to set current project ID', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Stream of current project ID changes
  Stream<String?> getCurrentProjectIdStream() {
    try {
      return _settingsDoc.snapshots().map((snapshot) {
        if (!snapshot.exists) {
          return null;
        }
        return snapshot.data()?['projectId'] as String?;
      });
    } catch (e, stack) {
      log('Failed to get current project ID stream', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

/// Provider for the settings repository
/// Depends on the current user being authenticated
final settingsRepositoryProvider = Provider<SettingsRepository?>((ref) {
  final authState = ref.watch(authNotifierProvider);

  if (authState is Authenticated) {
    return SettingsRepository(userId: authState.user.id);
  }

  return null;
});
