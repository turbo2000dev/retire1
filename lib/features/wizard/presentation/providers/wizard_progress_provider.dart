import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/data/wizard_progress_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

/// Wizard progress stream notifier with Firestore integration
/// Watches progress for the currently selected project
class WizardProgressNotifier extends AsyncNotifier<WizardProgress?> {
  WizardProgressRepository? _repository;
  StreamSubscription<WizardProgress?>? _streamSubscription;

  @override
  Future<WizardProgress?> build() async {
    // Get repository from provider
    try {
      _repository = ref.watch(wizardProgressRepositoryProvider);
    } catch (e) {
      // User not authenticated
      return null;
    }

    // Get current project
    final currentProjectState = ref.watch(currentProjectProvider);
    String? projectId;

    if (currentProjectState is ProjectSelected) {
      projectId = currentProjectState.project.id;
    }

    // Clean up subscription when notifier is disposed
    ref.onDispose(() {
      _streamSubscription?.cancel();
    });

    // If no project selected, return null
    if (projectId == null) {
      return null;
    }

    // Listen to wizard progress stream for current project
    try {
      final completer = Completer<WizardProgress?>();

      _streamSubscription = _repository!.getProgressStream(projectId).listen(
        (progress) {
          if (!completer.isCompleted) {
            completer.complete(progress);
          }
          // Update state with new data from stream
          state = AsyncValue.data(progress);
        },
        onError: (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
          log('Error in wizard progress stream', error: error, stackTrace: stackTrace);
          state = AsyncValue.error(error, stackTrace);
        },
      );

      return await completer.future;
    } catch (e, stack) {
      log('Failed to initialize wizard progress stream', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get or create progress for current project
  Future<WizardProgress> getOrCreateProgress() async {
    if (_repository == null) {
      throw Exception('Cannot access wizard progress: user not authenticated');
    }

    final currentProjectState = ref.read(currentProjectProvider);

    if (currentProjectState is! ProjectSelected) {
      throw Exception('Cannot access wizard progress: no project selected');
    }

    return await _repository!.getOrCreateProgress(currentProjectState.project.id);
  }

  /// Update section status
  Future<void> updateSectionStatus(
    String sectionId,
    WizardSectionStatus status,
  ) async {
    if (_repository == null) {
      log('Cannot update section status: user not authenticated');
      return;
    }

    final currentProjectState = ref.read(currentProjectProvider);

    if (currentProjectState is! ProjectSelected) {
      log('Cannot update section status: no project selected');
      return;
    }

    try {
      await _repository!.updateSectionStatus(
        currentProjectState.project.id,
        sectionId,
        status,
      );
      // Stream will automatically update with changes
      log('Section status updated: $sectionId');
    } catch (e, stack) {
      log('Failed to update section status', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Navigate to a section
  Future<void> navigateToSection(String sectionId) async {
    if (_repository == null) {
      log('Cannot navigate: user not authenticated');
      return;
    }

    final currentProjectState = ref.read(currentProjectProvider);

    if (currentProjectState is! ProjectSelected) {
      log('Cannot navigate: no project selected');
      return;
    }

    try {
      await _repository!.navigateToSection(
        currentProjectState.project.id,
        sectionId,
      );
      log('Navigated to section: $sectionId');
    } catch (e, stack) {
      log('Failed to navigate to section', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Mark wizard as complete
  Future<void> completeWizard() async {
    if (_repository == null) {
      log('Cannot complete wizard: user not authenticated');
      return;
    }

    final currentProjectState = ref.read(currentProjectProvider);

    if (currentProjectState is! ProjectSelected) {
      log('Cannot complete wizard: no project selected');
      return;
    }

    try {
      await _repository!.completeWizard(currentProjectState.project.id);
      log('Wizard completed');
    } catch (e, stack) {
      log('Failed to complete wizard', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Reset wizard progress (for re-running wizard)
  Future<void> resetProgress() async {
    if (_repository == null) {
      log('Cannot reset wizard: user not authenticated');
      return;
    }

    final currentProjectState = ref.read(currentProjectProvider);

    if (currentProjectState is! ProjectSelected) {
      log('Cannot reset wizard: no project selected');
      return;
    }

    try {
      await _repository!.resetProgress(currentProjectState.project.id);
      log('Wizard progress reset');
    } catch (e, stack) {
      log('Failed to reset wizard progress', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

/// Provider for wizard progress (watches current project)
final wizardProgressProvider =
    AsyncNotifierProvider<WizardProgressNotifier, WizardProgress?>(
  () => WizardProgressNotifier(),
);
