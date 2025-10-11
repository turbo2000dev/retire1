import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/project/domain/project.dart';

/// Repository for managing projects in Firestore
///
/// Firestore structure:
/// users/{userId}/projects/{projectId}
class ProjectRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  ProjectRepository({
    required this.userId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get the projects collection reference for the current user
  CollectionReference<Map<String, dynamic>> get _projectsCollection =>
      _firestore.collection('users').doc(userId).collection('projects');

  /// Create a new project
  Future<Project> createProject({
    required String name,
    String? description,
  }) async {
    try {
      final now = DateTime.now();
      final docRef = _projectsCollection.doc();

      final project = Project(
        id: docRef.id,
        name: name,
        description: description,
        ownerId: userId,
        createdAt: now,
        updatedAt: now,
      );

      await docRef.set(project.toJson());
      log('Project created in Firestore: ${project.name}');

      return project;
    } catch (e, stack) {
      log('Failed to create project in Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get a stream of all projects for the current user
  Stream<List<Project>> getProjectsStream() {
    try {
      return _projectsCollection
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return Project.fromJson({
              ...doc.data(),
              'id': doc.id,
            });
          } catch (e, stack) {
            log('Failed to parse project ${doc.id}', error: e, stackTrace: stack);
            rethrow;
          }
        }).toList();
      });
    } catch (e, stack) {
      log('Failed to get projects stream', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Update an existing project
  Future<void> updateProject({
    required String projectId,
    required String name,
    String? description,
  }) async {
    try {
      await _projectsCollection.doc(projectId).update({
        'name': name,
        'description': description,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      log('Project updated in Firestore: $projectId');
    } catch (e, stack) {
      log('Failed to update project in Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Delete a project
  Future<void> deleteProject(String projectId) async {
    try {
      await _projectsCollection.doc(projectId).delete();
      log('Project deleted from Firestore: $projectId');
    } catch (e, stack) {
      log('Failed to delete project from Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get a single project by ID
  Future<Project?> getProject(String projectId) async {
    try {
      final doc = await _projectsCollection.doc(projectId).get();

      if (!doc.exists) {
        return null;
      }

      return Project.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });
    } catch (e, stack) {
      log('Failed to get project from Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }
}

/// Provider for the project repository
/// Depends on the current user being authenticated
final projectRepositoryProvider = Provider<ProjectRepository?>((ref) {
  final authState = ref.watch(authNotifierProvider);

  if (authState is Authenticated) {
    return ProjectRepository(userId: authState.user.id);
  }

  return null;
});
