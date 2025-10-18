import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/project/domain/project.dart';

/// Projects stream notifier with Firestore integration
class ProjectsNotifier extends AsyncNotifier<List<Project>> {
  ProjectRepository? _repository;
  StreamSubscription<List<Project>>? _streamSubscription;

  @override
  Future<List<Project>> build() async {
    // Get repository from provider
    _repository = ref.watch(projectRepositoryProvider);

    // Clean up subscription when notifier is disposed
    ref.onDispose(() {
      _streamSubscription?.cancel();
    });

    // If no repository (user not authenticated), return empty list
    if (_repository == null) {
      return [];
    }

    // Listen to projects stream
    try {
      final completer = Completer<List<Project>>();

      _streamSubscription = _repository!.getProjectsStream().listen(
        (projects) {
          if (!completer.isCompleted) {
            completer.complete(projects);
          }
          // Update state with new data from stream
          state = AsyncValue.data(projects);
        },
        onError: (error, stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
          log('Error in projects stream', error: error, stackTrace: stackTrace);
          state = AsyncValue.error(error, stackTrace);
        },
      );

      return await completer.future;
    } catch (e, stack) {
      log('Failed to initialize projects stream', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Create a new project
  Future<void> createProject(String name, String? description) async {
    if (_repository == null) {
      log('Cannot create project: user not authenticated');
      return;
    }

    try {
      await _repository!.createProject(name: name, description: description);
      // Stream will automatically update with new project
      log('Project created successfully');
    } catch (e, stack) {
      log('Failed to create project', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Update an existing project
  Future<void> updateProject(
    String projectId,
    String name,
    String? description,
  ) async {
    if (_repository == null) {
      log('Cannot update project: user not authenticated');
      return;
    }

    try {
      await _repository!.updateProject(
        projectId: projectId,
        name: name,
        description: description,
      );
      // Stream will automatically update with changes
      log('Project updated successfully');
    } catch (e, stack) {
      log('Failed to update project', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Update project with full project data
  /// Useful for updating nested fields like individuals list
  Future<void> updateProjectData(Project project) async {
    if (_repository == null) {
      log('Cannot update project: user not authenticated');
      return;
    }

    try {
      await _repository!.updateProjectData(project);
      // Stream will automatically update with changes
      log('Project data updated successfully');
    } catch (e, stack) {
      log('Failed to update project data', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    if (_repository == null) {
      log('Cannot delete project: user not authenticated');
      return;
    }

    try {
      await _repository!.deleteProject(projectId);
      // Stream will automatically update (project removed)
      log('Project deleted successfully');
    } catch (e, stack) {
      log('Failed to delete project', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Reload projects (not needed with stream, kept for compatibility)
  Future<void> reload() async {
    // Stream automatically updates, but we can invalidate self to force rebuild
    ref.invalidateSelf();
  }
}

/// Provider for projects list with Firestore real-time updates
final projectsProvider = AsyncNotifierProvider<ProjectsNotifier, List<Project>>(
  () {
    return ProjectsNotifier();
  },
);
