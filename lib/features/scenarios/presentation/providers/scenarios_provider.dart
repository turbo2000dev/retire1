import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/scenarios/data/scenario_repository.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Provider for scenario repository
final scenarioRepositoryProvider = Provider<ScenarioRepository?>((ref) {
  final projectState = ref.watch(currentProjectProvider);

  return switch (projectState) {
    ProjectSelected(project: final project) => ScenarioRepository(projectId: project.id),
    _ => null,
  };
});

/// Provider for scenarios with Firestore integration
final scenariosProvider =
    AsyncNotifierProvider<ScenariosNotifier, List<Scenario>>(() {
  return ScenariosNotifier();
});

/// Notifier for managing scenarios with Firestore
class ScenariosNotifier extends AsyncNotifier<List<Scenario>> {
  StreamSubscription<List<Scenario>>? _subscription;

  @override
  Future<List<Scenario>> build() async {
    final repository = ref.watch(scenarioRepositoryProvider);

    if (repository == null) {
      developer.log('No repository available, returning empty scenarios');
      return [];
    }

    // Ensure base scenario exists
    await repository.ensureBaseScenario();

    // Listen to Firestore stream
    _subscription?.cancel();
    _subscription = repository.getScenariosStream().listen(
      (scenarios) {
        state = AsyncData(scenarios);
      },
      onError: (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      },
    );

    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    // Return initial empty list, stream will update it
    return [];
  }

  /// Create a new variation scenario
  Future<void> createScenario(String name) async {
    final repository = ref.read(scenarioRepositoryProvider);
    if (repository == null) {
      throw Exception('No repository available');
    }

    try {
      final now = DateTime.now();
      final newScenario = Scenario(
        id: _uuid.v4(),
        name: name,
        isBase: false,
        overrides: const [],
        createdAt: now,
        updatedAt: now,
      );

      await repository.createScenario(newScenario);
    } catch (e) {
      developer.log('Error creating scenario: $e');
      rethrow;
    }
  }

  /// Update a scenario (name and/or overrides)
  Future<void> updateScenario(Scenario scenario) async {
    final repository = ref.read(scenarioRepositoryProvider);
    if (repository == null) {
      throw Exception('No repository available');
    }

    try {
      final updatedScenario = scenario.copyWith(
        updatedAt: DateTime.now(),
      );

      await repository.updateScenario(updatedScenario);
    } catch (e) {
      developer.log('Error updating scenario: $e');
      rethrow;
    }
  }

  /// Delete a variation scenario (cannot delete base scenario)
  Future<void> deleteScenario(String scenarioId) async {
    final repository = ref.read(scenarioRepositoryProvider);
    if (repository == null) {
      throw Exception('No repository available');
    }

    try {
      final scenarios = state.value ?? [];
      final scenario = scenarios.firstWhere((s) => s.id == scenarioId);

      if (scenario.isBase) {
        throw Exception('Cannot delete base scenario');
      }

      await repository.deleteScenario(scenarioId);
    } catch (e) {
      developer.log('Error deleting scenario: $e');
      rethrow;
    }
  }

  /// Add or update an override in a scenario
  Future<void> addOverride(
      String scenarioId, ParameterOverride override) async {
    final repository = ref.read(scenarioRepositoryProvider);
    if (repository == null) {
      throw Exception('No repository available');
    }

    try {
      final scenarios = state.value ?? [];
      final scenario = scenarios.firstWhere((s) => s.id == scenarioId);

      // Remove existing override for the same parameter
      final filteredOverrides = scenario.overrides.where((o) {
        return o.when(
          assetValue: (assetId, value) {
            return !override.maybeWhen(
              assetValue: (id, _) => id == assetId,
              orElse: () => false,
            );
          },
          eventTiming: (eventId, years) {
            return !override.maybeWhen(
              eventTiming: (id, _) => id == eventId,
              orElse: () => false,
            );
          },
        );
      }).toList();

      final updatedScenario = scenario.copyWith(
        overrides: [...filteredOverrides, override],
        updatedAt: DateTime.now(),
      );

      await repository.updateScenario(updatedScenario);
    } catch (e) {
      developer.log('Error adding override: $e');
      rethrow;
    }
  }

  /// Remove an override from a scenario
  Future<void> removeOverride(
      String scenarioId, ParameterOverride override) async {
    final repository = ref.read(scenarioRepositoryProvider);
    if (repository == null) {
      throw Exception('No repository available');
    }

    try {
      final scenarios = state.value ?? [];
      final scenario = scenarios.firstWhere((s) => s.id == scenarioId);

      final filteredOverrides = scenario.overrides.where((o) {
        return o.when(
          assetValue: (assetId, value) {
            return !override.maybeWhen(
              assetValue: (id, _) => id == assetId,
              orElse: () => false,
            );
          },
          eventTiming: (eventId, years) {
            return !override.maybeWhen(
              eventTiming: (id, _) => id == eventId,
              orElse: () => false,
            );
          },
        );
      }).toList();

      final updatedScenario = scenario.copyWith(
        overrides: filteredOverrides,
        updatedAt: DateTime.now(),
      );

      await repository.updateScenario(updatedScenario);
    } catch (e) {
      developer.log('Error removing override: $e');
      rethrow;
    }
  }
}

/// Provider for the base scenario
final baseScenarioProvider = Provider<Scenario?>((ref) {
  final scenariosAsync = ref.watch(scenariosProvider);
  return scenariosAsync.maybeWhen(
    data: (scenarios) => scenarios.where((s) => s.isBase).firstOrNull,
    orElse: () => null,
  );
});

/// Provider for variation scenarios (non-base)
final variationScenariosProvider = Provider<List<Scenario>>((ref) {
  final scenariosAsync = ref.watch(scenariosProvider);
  return scenariosAsync.maybeWhen(
    data: (scenarios) => scenarios.where((s) => !s.isBase).toList(),
    orElse: () => [],
  );
});
