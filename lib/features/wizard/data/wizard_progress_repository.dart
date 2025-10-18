import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/user_profile_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

/// Repository for managing wizard progress in Firestore
///
/// Firestore structure:
/// users/{userId}/wizardProgress/{projectId}
class WizardProgressRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  WizardProgressRepository({required this.userId, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get the wizard progress collection reference for the current user
  CollectionReference<Map<String, dynamic>> get _progressCollection =>
      _firestore.collection('users').doc(userId).collection('wizardProgress');

  /// Get or create wizard progress for a project
  Future<WizardProgress> getOrCreateProgress(String projectId) async {
    try {
      final doc = await _progressCollection.doc(projectId).get();

      if (doc.exists) {
        final data = _convertTimestampsToDateTimes(doc.data()!);
        return WizardProgress.fromJson({...data, 'projectId': doc.id});
      }

      // Create new progress
      final progress = WizardProgress.create(
        projectId: projectId,
        userId: userId,
      );

      await _saveProgress(progress);
      return progress;
    } catch (e, stack) {
      log(
        'Failed to get or create wizard progress',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  /// Get a stream of wizard progress for a project
  Stream<WizardProgress?> getProgressStream(String projectId) {
    try {
      return _progressCollection.doc(projectId).snapshots().map((snapshot) {
        if (!snapshot.exists) {
          return null;
        }

        try {
          final data = _convertTimestampsToDateTimes(snapshot.data()!);
          return WizardProgress.fromJson({...data, 'projectId': snapshot.id});
        } catch (e, stack) {
          log(
            'Failed to parse wizard progress ${snapshot.id}',
            error: e,
            stackTrace: stack,
          );
          rethrow;
        }
      });
    } catch (e, stack) {
      log('Failed to get wizard progress stream', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Update section status
  Future<void> updateSectionStatus(
    String projectId,
    String sectionId,
    WizardSectionStatus status,
  ) async {
    try {
      final progress = await getOrCreateProgress(projectId);
      final updatedStatuses = Map<String, WizardSectionStatus>.from(
        progress.sectionStatuses,
      );
      updatedStatuses[sectionId] = status;

      final updatedProgress = progress.copyWith(
        sectionStatuses: updatedStatuses,
        currentSectionId: sectionId,
        lastUpdated: DateTime.now(),
      );

      await _saveProgress(updatedProgress);
      log('Section status updated: $sectionId -> ${status.state}');
    } catch (e, stack) {
      log('Failed to update section status', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Navigate to a section (updates current section)
  Future<void> navigateToSection(String projectId, String sectionId) async {
    try {
      await _progressCollection.doc(projectId).update({
        'currentSectionId': sectionId,
        'lastUpdated': Timestamp.fromDate(DateTime.now()),
      });

      log('Navigated to section: $sectionId');
    } catch (e, stack) {
      log('Failed to navigate to section', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Mark wizard as complete
  Future<void> completeWizard(String projectId) async {
    try {
      final now = DateTime.now();
      await _progressCollection.doc(projectId).update({
        'wizardCompleted': true,
        'completedAt': Timestamp.fromDate(now),
        'lastUpdated': Timestamp.fromDate(now),
      });

      log('Wizard completed for project: $projectId');
    } catch (e, stack) {
      log('Failed to complete wizard', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Reset wizard progress (for re-running wizard)
  Future<void> resetProgress(String projectId) async {
    try {
      final progress = WizardProgress.create(
        projectId: projectId,
        userId: userId,
      );

      await _saveProgress(progress);
      log('Wizard progress reset for project: $projectId');
    } catch (e, stack) {
      log('Failed to reset wizard progress', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Save progress to Firestore
  Future<void> _saveProgress(WizardProgress progress) async {
    try {
      final json = progress.toJson();
      final firestoreData = _convertDateTimesToTimestamps(json);

      await _progressCollection.doc(progress.projectId).set(firestoreData);
    } catch (e, stack) {
      log('Failed to save wizard progress', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Convert DateTime objects to Firestore Timestamps recursively
  Map<String, dynamic> _convertDateTimesToTimestamps(
    Map<String, dynamic> data,
  ) {
    final result = <String, dynamic>{};

    for (final entry in data.entries) {
      final value = entry.value;

      if (value is DateTime) {
        result[entry.key] = Timestamp.fromDate(value);
      } else if (value is Map) {
        // Handle both Map<String, dynamic> and Map<String, Object>
        final map = Map<String, dynamic>.from(value);
        result[entry.key] = _convertDateTimesToTimestamps(map);
      } else if (value is List) {
        result[entry.key] = value.map((item) {
          if (item is DateTime) {
            return Timestamp.fromDate(item);
          } else if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            return _convertDateTimesToTimestamps(map);
          } else {
            return item;
          }
        }).toList();
      } else {
        result[entry.key] = value;
      }
    }

    return result;
  }

  /// Convert Firestore Timestamps to DateTime objects recursively
  Map<String, dynamic> _convertTimestampsToDateTimes(
    Map<String, dynamic> data,
  ) {
    final result = <String, dynamic>{};

    for (final entry in data.entries) {
      final value = entry.value;

      if (value is Timestamp) {
        result[entry.key] = value.toDate();
      } else if (value is Map) {
        // Handle both Map<String, dynamic> and other Map types
        final map = Map<String, dynamic>.from(value);
        result[entry.key] = _convertTimestampsToDateTimes(map);
      } else if (value is List) {
        result[entry.key] = value.map((item) {
          if (item is Timestamp) {
            return item.toDate();
          } else if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            return _convertTimestampsToDateTimes(map);
          } else {
            return item;
          }
        }).toList();
      } else {
        result[entry.key] = value;
      }
    }

    return result;
  }
}

/// Provider for WizardProgressRepository
final wizardProgressRepositoryProvider = Provider<WizardProgressRepository>((ref) {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    throw Exception('User must be authenticated to access wizard progress');
  }

  return WizardProgressRepository(userId: user.id);
});
