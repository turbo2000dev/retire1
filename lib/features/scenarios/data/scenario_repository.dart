import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

/// Repository for managing scenarios in Firestore
class ScenarioRepository {
  final FirebaseFirestore _firestore;
  final String projectId;

  ScenarioRepository({required this.projectId, FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _scenariosCollection =>
      _firestore.collection('projects').doc(projectId).collection('scenarios');

  /// Create a new scenario
  Future<void> createScenario(Scenario scenario) async {
    try {
      developer.log('Creating scenario: ${scenario.id}');
      await _scenariosCollection.doc(scenario.id).set(scenario.toJson());
    } catch (e) {
      developer.log('Error creating scenario: $e');
      rethrow;
    }
  }

  /// Get a stream of all scenarios for the project
  Stream<List<Scenario>> getScenariosStream() {
    try {
      return _scenariosCollection
          .orderBy('createdAt', descending: false)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return Scenario.fromJson(data);
            }).toList();
          });
    } catch (e) {
      developer.log('Error getting scenarios stream: $e');
      rethrow;
    }
  }

  /// Get a single scenario by ID
  Future<Scenario?> getScenario(String scenarioId) async {
    try {
      final doc = await _scenariosCollection.doc(scenarioId).get();
      if (!doc.exists) return null;
      return Scenario.fromJson(doc.data()!);
    } catch (e) {
      developer.log('Error getting scenario: $e');
      rethrow;
    }
  }

  /// Update an existing scenario
  Future<void> updateScenario(Scenario scenario) async {
    try {
      developer.log('Updating scenario: ${scenario.id}');
      await _scenariosCollection.doc(scenario.id).set(scenario.toJson());
    } catch (e) {
      developer.log('Error updating scenario: $e');
      rethrow;
    }
  }

  /// Delete a scenario
  Future<void> deleteScenario(String scenarioId) async {
    try {
      developer.log('Deleting scenario: $scenarioId');
      await _scenariosCollection.doc(scenarioId).delete();
    } catch (e) {
      developer.log('Error deleting scenario: $e');
      rethrow;
    }
  }

  /// Ensure base scenario exists for the project
  Future<void> ensureBaseScenario() async {
    try {
      final scenariosSnapshot = await _scenariosCollection
          .where('isBase', isEqualTo: true)
          .limit(1)
          .get();

      if (scenariosSnapshot.docs.isEmpty) {
        // Create base scenario
        final baseScenario = Scenario(
          id: 'base',
          name: 'Base Scenario',
          isBase: true,
          overrides: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await createScenario(baseScenario);
        developer.log('Created base scenario for project: $projectId');
      }
    } catch (e) {
      developer.log('Error ensuring base scenario: $e');
      rethrow;
    }
  }
}
