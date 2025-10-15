import 'package:flutter/material.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

/// Widget for selecting scenarios to compare
/// Base scenario is always selected, user can toggle up to 2 alternatives
class ScenarioSelector extends StatelessWidget {
  final Scenario baseScenario;
  final List<Scenario> alternativeScenarios;
  final Set<String> selectedScenarioIds;
  final Function(String scenarioId) onScenarioToggled;

  const ScenarioSelector({
    super.key,
    required this.baseScenario,
    required this.alternativeScenarios,
    required this.selectedScenarioIds,
    required this.onScenarioToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.compare_arrows,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Scenarios to Compare',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Select up to 3 scenarios (Base + 2 alternatives)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Base scenario - always selected and disabled
                _buildScenarioChip(
                  context,
                  baseScenario,
                  isSelected: true,
                  isBase: true,
                  canToggle: false,
                ),
                // Alternative scenarios - can be toggled
                ...alternativeScenarios.map((scenario) {
                  final isSelected = selectedScenarioIds.contains(scenario.id);
                  final canSelect = isSelected || selectedScenarioIds.length < 3;

                  return _buildScenarioChip(
                    context,
                    scenario,
                    isSelected: isSelected,
                    isBase: false,
                    canToggle: canSelect,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioChip(
    BuildContext context,
    Scenario scenario, {
    required bool isSelected,
    required bool isBase,
    required bool canToggle,
  }) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(scenario.name),
          if (isBase) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.lock,
              size: 14,
              color: theme.colorScheme.primary,
            ),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: canToggle && !isBase
          ? (_) => onScenarioToggled(scenario.id)
          : null,
      showCheckmark: !isBase,
      backgroundColor: isBase
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      selectedColor: isBase
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onSecondaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: isBase ? FontWeight.w600 : FontWeight.normal,
      ),
      tooltip: isBase
          ? 'Base scenario (always included)'
          : isSelected
              ? 'Click to remove from comparison'
              : canToggle
                  ? 'Click to add to comparison'
                  : 'Maximum 3 scenarios selected',
    );
  }
}
