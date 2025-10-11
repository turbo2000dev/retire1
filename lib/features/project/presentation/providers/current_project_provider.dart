import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/data/settings_repository.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/projects_provider.dart';

/// State for current project
sealed class CurrentProjectState {}

class NoProjectSelected extends CurrentProjectState {}

class ProjectLoading extends CurrentProjectState {}

class ProjectSelected extends CurrentProjectState {
  final Project project;
  ProjectSelected(this.project);
}

class ProjectError extends CurrentProjectState {
  final String message;
  ProjectError(this.message);
}

/// Notifier for managing the currently selected project
class CurrentProjectNotifier extends StateNotifier<CurrentProjectState> {
  final SettingsRepository? _settingsRepository;
  final ProjectRepository? _projectRepository;
  final Ref _ref;
  StreamSubscription<String?>? _settingsSubscription;
  StreamSubscription<Project?>? _projectSubscription;

  CurrentProjectNotifier(
    this._ref,
    this._settingsRepository,
    this._projectRepository,
  ) : super(NoProjectSelected()) {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_settingsRepository == null || _projectRepository == null) {
      state = NoProjectSelected();
      return;
    }

    // Listen to current project ID changes
    _settingsSubscription = _settingsRepository.getCurrentProjectIdStream().listen(
      (projectId) async {
        // Cancel previous project subscription
        await _projectSubscription?.cancel();
        _projectSubscription = null;

        if (projectId == null) {
          state = NoProjectSelected();
          return;
        }

        try {
          state = ProjectLoading();

          // Listen to project data changes
          _projectSubscription = _projectRepository.getProjectStream(projectId).listen(
            (project) {
              if (project != null) {
                state = ProjectSelected(project);
              } else {
                // Project was deleted, clear selection
                _settingsRepository.setCurrentProjectId(null);
                state = NoProjectSelected();
              }
            },
            onError: (error, stackTrace) {
              log('Error in project stream', error: error, stackTrace: stackTrace);
              state = ProjectError('Failed to load project');
            },
          );
        } catch (e, stack) {
          log('Failed to setup project stream', error: e, stackTrace: stack);
          state = ProjectError('Failed to load project');
        }
      },
      onError: (error, stackTrace) {
        log('Error in current project ID stream', error: error, stackTrace: stackTrace);
        state = ProjectError('Failed to load project');
      },
    );
  }

  /// Select a project by ID
  Future<void> selectProject(String projectId) async {
    if (_settingsRepository == null) {
      log('Cannot select project: user not authenticated');
      return;
    }

    try {
      await _settingsRepository.setCurrentProjectId(projectId);
      // Stream will automatically update state
    } catch (e, stack) {
      log('Failed to select project', error: e, stackTrace: stack);
      state = ProjectError('Failed to select project');
    }
  }

  /// Clear current project selection
  Future<void> clearSelection() async {
    if (_settingsRepository == null) {
      log('Cannot clear selection: user not authenticated');
      return;
    }

    try {
      await _settingsRepository.setCurrentProjectId(null);
      // Stream will automatically update state
    } catch (e, stack) {
      log('Failed to clear selection', error: e, stackTrace: stack);
      state = ProjectError('Failed to clear selection');
    }
  }

  /// Select the first available project if none is selected
  Future<void> selectFirstAvailableProject() async {
    if (state is! NoProjectSelected) {
      return; // Already have a project selected
    }

    // Wait for projects to load
    final projectsAsync = await _ref.read(projectsProvider.future);
    if (projectsAsync.isNotEmpty) {
      await selectProject(projectsAsync.first.id);
    }
  }

  @override
  void dispose() {
    _settingsSubscription?.cancel();
    _projectSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for the currently selected project
final currentProjectProvider =
    StateNotifierProvider<CurrentProjectNotifier, CurrentProjectState>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  final projectRepository = ref.watch(projectRepositoryProvider);

  return CurrentProjectNotifier(ref, settingsRepository, projectRepository);
});
