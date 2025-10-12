import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/projection/presentation/providers/projection_provider.dart';
import 'package:retire1/features/projection/presentation/widgets/projection_chart.dart';
import 'package:retire1/features/projection/presentation/widgets/projection_table.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Screen for displaying retirement projections
class ProjectionScreen extends ConsumerWidget {
  const ProjectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scenariosAsync = ref.watch(scenariosProvider);
    final selectedScenarioId = ref.watch(selectedScenarioIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projection'),
        actions: [
          // Scenario selector
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: scenariosAsync.when(
              loading: () => const SizedBox(
                width: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => const SizedBox.shrink(),
              data: (scenarios) {
                if (scenarios.isEmpty) {
                  return const SizedBox.shrink();
                }

                return SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedScenarioId,
                    decoration: const InputDecoration(
                      labelText: 'Scenario',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: scenarios.map((scenario) {
                      return DropdownMenuItem(
                        value: scenario.id,
                        child: Row(
                          children: [
                            if (scenario.isBase)
                              Icon(
                                Icons.star,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            if (scenario.isBase) const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                scenario.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(selectedScenarioIdProvider.notifier).selectScenario(value);
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: selectedScenarioId == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No scenario selected',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please select a scenario to view projection',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : _ProjectionContent(scenarioId: selectedScenarioId),
    );
  }
}

/// Content widget that displays the projection for a selected scenario
class _ProjectionContent extends ConsumerWidget {
  final String scenarioId;

  const _ProjectionContent({required this.scenarioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final projectionAsync = ref.watch(projectionProvider(scenarioId));

    return projectionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading projection',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error.toString(),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.refresh(projectionProvider(scenarioId)),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (projection) {
        if (projection == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No projection available',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Unable to calculate projection for this scenario',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Projection info header
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Projection: ${projection.startYear} - ${projection.endYear}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${projection.years.length} years • ${projection.useConstantDollars ? 'Constant' : 'Current'} dollars',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Chart section
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: ProjectionChart(projection: projection),
                ),
              ),
            ),
            // Table section
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: ProjectionTable(projection: projection),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        );
      },
    );
  }
}
