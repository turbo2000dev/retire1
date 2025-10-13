import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/service/projection_calculator.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Provider for the projection calculator service
final projectionCalculatorProvider = Provider<ProjectionCalculator>((ref) {
  return ProjectionCalculator();
});

/// Provider for calculating projection for a specific scenario with caching
final projectionProvider = FutureProvider.family<Projection?, String>((ref, scenarioId) async {
  // Watch all dependencies
  final projectState = ref.watch(currentProjectProvider);
  final assetsAsync = ref.watch(assetsProvider);
  final eventsAsync = ref.watch(eventsProvider);
  final scenariosAsync = ref.watch(scenariosProvider);

  // Return null if project not selected
  if (projectState is! ProjectSelected) {
    return null;
  }

  final project = projectState.project;

  // Wait for async data to load
  final assets = await assetsAsync.when(
    data: (data) => Future.value(data),
    loading: () => Future.value(<Asset>[]),
    error: (_, __) => Future.value(<Asset>[]),
  );

  final events = await eventsAsync.when(
    data: (data) => Future.value(data),
    loading: () => Future.value(<Event>[]),
    error: (_, __) => Future.value(<Event>[]),
  );

  final scenarios = await scenariosAsync.when(
    data: (data) => Future.value(data),
    loading: () => Future.value(<Scenario>[]),
    error: (_, __) => Future.value(<Scenario>[]),
  );

  // Find the requested scenario
  final scenario = scenarios.where((s) => s.id == scenarioId).firstOrNull;
  if (scenario == null) {
    return null;
  }

  // Calculate projection (caching logic is inside the calculator)
  final calculator = ref.read(projectionCalculatorProvider);
  return calculator.calculateProjection(
    project: project,
    scenario: scenario,
    assets: assets,
    events: events,
  );
});

/// Provider for the currently selected scenario ID for projection view
final selectedScenarioIdProvider = StateNotifierProvider<SelectedScenarioIdNotifier, String?>((ref) {
  return SelectedScenarioIdNotifier(ref);
});

/// Notifier for managing the selected scenario ID
class SelectedScenarioIdNotifier extends StateNotifier<String?> {
  final Ref _ref;

  SelectedScenarioIdNotifier(this._ref) : super(null) {
    // Default to base scenario
    final scenariosAsync = _ref.read(scenariosProvider);
    scenariosAsync.whenData((scenarios) {
      final baseScenario = scenarios.where((s) => s.isBase).firstOrNull;
      if (baseScenario != null && state == null) {
        state = baseScenario.id;
      }
    });
  }

  void selectScenario(String scenarioId) {
    state = scenarioId;
  }
}
