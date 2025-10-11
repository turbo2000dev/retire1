import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/project/domain/project.dart';

/// Mock projects state notifier
class ProjectsNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final String? _userId;

  ProjectsNotifier(this._userId) : super(const AsyncValue.loading()) {
    _loadProjects();
  }

  /// Load mock projects
  Future<void> _loadProjects() async {
    if (_userId == null) {
      if (mounted) {
        state = const AsyncValue.data([]);
      }
      return;
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock projects
      final projects = [
        Project(
          id: '1',
          name: 'Main Retirement Plan',
          description: 'Our primary retirement planning scenario',
          ownerId: _userId,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Project(
          id: '2',
          name: 'Early Retirement Option',
          description: 'Exploring retiring at 60 instead of 65',
          ownerId: _userId,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Project(
          id: '3',
          name: 'Cottage Purchase Scenario',
          description: 'Planning with a cottage purchase in 5 years',
          ownerId: _userId,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
      ];

      if (mounted) {
        state = AsyncValue.data(projects);
      }
    } catch (e, stack) {
      log('Failed to load projects', error: e, stackTrace: stack);
      if (mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Create a new project
  Future<void> createProject(String name, String? description) async {
    if (!mounted || _userId == null) {
      log('Cannot create project: user not logged in or notifier disposed');
      return;
    }

    final currentProjects = state.value ?? [];

    // Create new project
    final newProject = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      ownerId: _userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Optimistically update state
    if (mounted) {
      state = AsyncValue.data([...currentProjects, newProject]);
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      log('Project created: ${newProject.name}');
    } catch (e, stack) {
      log('Failed to create project', error: e, stackTrace: stack);
      // Revert on error
      if (mounted) {
        state = AsyncValue.data(currentProjects);
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Update an existing project
  Future<void> updateProject(String projectId, String name, String? description) async {
    if (!mounted || _userId == null) {
      log('Cannot update project: user not logged in or notifier disposed');
      return;
    }

    final currentProjects = state.value ?? [];
    final projectIndex = currentProjects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) {
      log('Project not found: $projectId');
      return;
    }

    final oldProject = currentProjects[projectIndex];

    // Create updated project
    final updatedProject = oldProject.copyWith(
      name: name,
      description: description,
      updatedAt: DateTime.now(),
    );

    // Optimistically update state
    final updatedProjects = [...currentProjects];
    updatedProjects[projectIndex] = updatedProject;

    if (mounted) {
      state = AsyncValue.data(updatedProjects);
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      log('Project updated: ${updatedProject.name}');
    } catch (e, stack) {
      log('Failed to update project', error: e, stackTrace: stack);
      // Revert on error
      if (mounted) {
        state = AsyncValue.data(currentProjects);
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    if (!mounted || _userId == null) {
      log('Cannot delete project: user not logged in or notifier disposed');
      return;
    }

    final currentProjects = state.value ?? [];
    final projectIndex = currentProjects.indexWhere((p) => p.id == projectId);

    if (projectIndex == -1) {
      log('Project not found: $projectId');
      return;
    }

    // Optimistically update state
    final updatedProjects = [...currentProjects]..removeAt(projectIndex);

    if (mounted) {
      state = AsyncValue.data(updatedProjects);
    }

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      log('Project deleted: $projectId');
    } catch (e, stack) {
      log('Failed to delete project', error: e, stackTrace: stack);
      // Revert on error
      if (mounted) {
        state = AsyncValue.data(currentProjects);
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Reload projects
  Future<void> reload() async {
    await _loadProjects();
  }
}

/// Provider for projects list
final projectsProvider =
    StateNotifierProvider<ProjectsNotifier, AsyncValue<List<Project>>>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final userId = authState is Authenticated ? authState.user.id : null;
  return ProjectsNotifier(userId);
});
