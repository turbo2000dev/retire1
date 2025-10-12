import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Provider for scenarios state management (mock data)
final scenariosProvider =
    StateNotifierProvider<ScenariosNotifier, List<Scenario>>((ref) {
  return ScenariosNotifier();
});

/// Notifier for managing scenarios with mock data
class ScenariosNotifier extends StateNotifier<List<Scenario>> {
  ScenariosNotifier() : super([]) {
    _initializeBaseScenario();
  }

  /// Initialize with base scenario
  void _initializeBaseScenario() {
    final now = DateTime.now();
    final baseScenario = Scenario(
      id: 'base',
      name: 'Base Scenario',
      isBase: true,
      overrides: const [],
      createdAt: now,
      updatedAt: now,
    );
    state = [baseScenario];
  }

  /// Create a new variation scenario
  Future<void> createScenario(String name) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final now = DateTime.now();
    final newScenario = Scenario(
      id: _uuid.v4(),
      name: name,
      isBase: false,
      overrides: const [],
      createdAt: now,
      updatedAt: now,
    );

    state = [...state, newScenario];
  }

  /// Update a scenario (name and/or overrides)
  Future<void> updateScenario(Scenario scenario) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final updatedScenario = scenario.copyWith(
      updatedAt: DateTime.now(),
    );

    state = [
      for (final s in state)
        if (s.id == scenario.id) updatedScenario else s,
    ];
  }

  /// Delete a variation scenario (cannot delete base scenario)
  Future<void> deleteScenario(String scenarioId) async {
    final scenario = state.firstWhere((s) => s.id == scenarioId);
    if (scenario.isBase) {
      throw Exception('Cannot delete base scenario');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    state = state.where((s) => s.id != scenarioId).toList();
  }

  /// Add or update an override in a scenario
  Future<void> addOverride(
      String scenarioId, ParameterOverride override) async {
    final scenario = state.firstWhere((s) => s.id == scenarioId);

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

    state = [
      for (final s in state)
        if (s.id == scenarioId) updatedScenario else s,
    ];
  }

  /// Remove an override from a scenario
  Future<void> removeOverride(
      String scenarioId, ParameterOverride override) async {
    final scenario = state.firstWhere((s) => s.id == scenarioId);

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

    state = [
      for (final s in state)
        if (s.id == scenarioId) updatedScenario else s,
    ];
  }
}

/// Provider for the base scenario
final baseScenarioProvider = Provider<Scenario?>((ref) {
  final scenarios = ref.watch(scenariosProvider);
  return scenarios.where((s) => s.isBase).firstOrNull;
});

/// Provider for variation scenarios (non-base)
final variationScenariosProvider = Provider<List<Scenario>>((ref) {
  final scenarios = ref.watch(scenariosProvider);
  return scenarios.where((s) => !s.isBase).toList();
});
