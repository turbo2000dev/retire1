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
        try {
          final data = doc.data()!;
          return WizardProgress.fromJson({...data, 'projectId': doc.id});
        } catch (parseError) {
          // If parsing fails, delete corrupted document and recreate
          log('Corrupted wizard progress detected, recreating: $parseError');
          await _progressCollection.doc(projectId).delete();
        }
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
      return _progressCollection.doc(projectId).snapshots().asyncMap((
        snapshot,
      ) async {
        if (!snapshot.exists) {
          return null;
        }

        try {
          final data = snapshot.data()!;
          return WizardProgress.fromJson({...data, 'projectId': snapshot.id});
        } catch (e, stack) {
          log(
            'Failed to parse wizard progress ${snapshot.id}, recreating',
            error: e,
            stackTrace: stack,
          );

          // Delete corrupted document and recreate
          await _progressCollection.doc(projectId).delete();
          final newProgress = WizardProgress.create(
            projectId: projectId,
            userId: userId,
          );
          await _saveProgress(newProgress);
          return newProgress;
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
      final progress = await getOrCreateProgress(projectId);
      final updatedProgress = progress.copyWith(
        currentSectionId: sectionId,
        lastUpdated: DateTime.now(),
      );
      await _saveProgress(updatedProgress);

      log('Navigated to section: $sectionId');
    } catch (e, stack) {
      log('Failed to navigate to section', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Mark wizard as complete
  Future<void> completeWizard(String projectId) async {
    try {
      final progress = await getOrCreateProgress(projectId);
      final now = DateTime.now();
      final updatedProgress = progress.copyWith(
        wizardCompleted: true,
        completedAt: now,
        lastUpdated: now,
      );
      await _saveProgress(updatedProgress);

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
      // Freezed already converts DateTime to ISO8601 strings, which work with Firestore
      await _progressCollection.doc(progress.projectId).set(json);
    } catch (e, stack) {
      log('Failed to save wizard progress', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

/// Provider for WizardProgressRepository
final wizardProgressRepositoryProvider = Provider<WizardProgressRepository>((
  ref,
) {
  final user = ref.watch(currentUserProvider);

  if (user == null) {
    throw Exception('User must be authenticated to access wizard progress');
  }

  return WizardProgressRepository(userId: user.id);
});
