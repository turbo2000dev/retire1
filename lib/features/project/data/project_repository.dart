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

      // Convert DateTime objects to Timestamps for Firestore
      final json = project.toJson();
      final firestoreData = _convertDateTimesToTimestamps(json);

      await docRef.set(firestoreData);
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
            final data = _convertTimestampsToDateTimes(doc.data());
            return Project.fromJson({
              ...data,
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

  /// Update project with full project data (includes nested fields like individuals)
  Future<void> updateProjectData(Project project) async {
    try {
      final updatedProject = project.copyWith(updatedAt: DateTime.now());
      final json = updatedProject.toJson();

      // Convert DateTime objects to Timestamps for Firestore
      final firestoreData = _convertDateTimesToTimestamps(json);

      await _projectsCollection.doc(project.id).set(firestoreData);

      log('Project data updated in Firestore: ${project.id}');
    } catch (e, stack) {
      log('Failed to update project data in Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Convert DateTime objects to Firestore Timestamps recursively
  Map<String, dynamic> _convertDateTimesToTimestamps(Map<String, dynamic> data) {
    final result = <String, dynamic>{};

    for (final entry in data.entries) {
      final value = entry.value;

      if (value is DateTime) {
        result[entry.key] = Timestamp.fromDate(value);
      } else if (value is Map<String, dynamic>) {
        result[entry.key] = _convertDateTimesToTimestamps(value);
      } else if (value is List) {
        result[entry.key] = value.map((item) {
          if (item is DateTime) {
            return Timestamp.fromDate(item);
          } else if (item is Map<String, dynamic>) {
            return _convertDateTimesToTimestamps(item);
          } else {
            // Handle any other objects by converting them to dynamic
            // This will trigger their toJson() if they have one
            return item;
          }
        }).toList();
      } else {
        result[entry.key] = value;
      }
    }

    return result;
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

      final data = _convertTimestampsToDateTimes(doc.data()!);
      return Project.fromJson({
        ...data,
        'id': doc.id,
      });
    } catch (e, stack) {
      log('Failed to get project from Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Get a stream of a single project by ID
  Stream<Project?> getProjectStream(String projectId) {
    try {
      return _projectsCollection.doc(projectId).snapshots().map((snapshot) {
        if (!snapshot.exists) {
          return null;
        }

        try {
          final data = _convertTimestampsToDateTimes(snapshot.data()!);
          return Project.fromJson({
            ...data,
            'id': snapshot.id,
          });
        } catch (e, stack) {
          log('Failed to parse project ${snapshot.id}', error: e, stackTrace: stack);
          rethrow;
        }
      });
    } catch (e, stack) {
      log('Failed to get project stream', error: e, stackTrace: stack);
      rethrow;
    }
  }

  /// Convert Firestore Timestamps to DateTime objects recursively
  Map<String, dynamic> _convertTimestampsToDateTimes(Map<String, dynamic> data) {
    final result = <String, dynamic>{};

    for (final entry in data.entries) {
      if (entry.value is Timestamp) {
        result[entry.key] = (entry.value as Timestamp).toDate();
      } else if (entry.value is Map<String, dynamic>) {
        result[entry.key] = _convertTimestampsToDateTimes(entry.value);
      } else if (entry.value is List) {
        result[entry.key] = (entry.value as List).map((item) {
          if (item is Timestamp) {
            return item.toDate();
          } else if (item is Map<String, dynamic>) {
            return _convertTimestampsToDateTimes(item);
          }
          return item;
        }).toList();
      } else {
        result[entry.key] = entry.value;
      }
    }

    return result;
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
