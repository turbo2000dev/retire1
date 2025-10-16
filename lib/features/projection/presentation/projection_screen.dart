import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/utils/file_download_helper.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/projection/presentation/providers/column_visibility_provider.dart';
import 'package:retire1/features/projection/presentation/providers/projection_provider.dart';
import 'package:retire1/features/projection/presentation/providers/dollar_mode_provider.dart';
import 'package:retire1/features/projection/presentation/widgets/asset_allocation_chart.dart';
import 'package:retire1/features/projection/presentation/widgets/cash_flow_chart.dart';
import 'package:retire1/features/projection/presentation/widgets/column_visibility_dialog.dart';
import 'package:retire1/features/projection/presentation/widgets/dollar_mode_explanation_dialog.dart';
import 'package:retire1/features/projection/presentation/widgets/expanded_projection_table_v2.dart';
import 'package:retire1/features/projection/presentation/widgets/expense_categories_chart.dart';
import 'package:retire1/features/projection/presentation/widgets/export_projection_dialog.dart';
import 'package:retire1/features/projection/presentation/widgets/income_sources_chart.dart';
import 'package:retire1/features/projection/presentation/widgets/projection_chart.dart';
import 'package:retire1/features/projection/presentation/widgets/projection_table_v2.dart';
import 'package:retire1/features/projection/service/projection_csv_export.dart';
import 'package:retire1/features/projection/service/projection_export_service.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Apply dollar mode conversion to a monetary value
///
/// If [useConstantDollars] is true, deflate the value by dividing by the
/// inflation multiplier to show purchasing power in today's dollars.
/// Otherwise, return the nominal value as-is.
///
/// Formula for constant dollars: value / (1 + inflationRate)^yearsFromStart
double applyDollarMode(
  double value,
  int yearsFromStart,
  bool useConstantDollars,
  double inflationRate,
) {
  if (!useConstantDollars || yearsFromStart == 0) {
    return value; // Current dollars or year 0 (no deflation needed)
  }

  // Calculate inflation multiplier: (1 + rate)^years
  double multiplier = 1.0;
  for (int i = 0; i < yearsFromStart; i++) {
    multiplier *= (1 + inflationRate);
  }

  // Deflate value to constant dollars
  return value / multiplier;
}

/// Get dollar mode label for display
String getDollarModeLabel(bool useConstantDollars) {
  return useConstantDollars ? '(Constant \$)' : '(Current \$)';
}

/// Screen for displaying retirement projections
class ProjectionScreen extends ConsumerWidget {
  const ProjectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scenariosAsync = ref.watch(scenariosProvider);
    final selectedScenarioId = ref.watch(selectedScenarioIdProvider);

    // Auto-select base scenario if none selected
    scenariosAsync.whenData((scenarios) {
      if (selectedScenarioId == null && scenarios.isNotEmpty) {
        // Find base scenario, or use first scenario if no base found
        final baseScenario = scenarios.firstWhere(
          (s) => s.isBase,
          orElse: () => scenarios.first,
        );

        // Schedule selection after build completes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(selectedScenarioIdProvider.notifier).selectScenario(baseScenario.id);
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projection'),
        actions: [
          // Dollar mode toggle with explanation
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ref.watch(dollarModeProvider) ? 'Constant \$' : 'Current \$',
                style: theme.textTheme.bodySmall,
              ),
              Switch(
                value: ref.watch(dollarModeProvider),
                onChanged: (_) {
                  ref.read(dollarModeProvider.notifier).toggle();
                },
              ),
              IconButton(
                icon: const Icon(Icons.help_outline, size: 20),
                tooltip: 'Explain dollar modes',
                onPressed: () => DollarModeExplanationDialog.show(context),
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Export button
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Projection',
            onPressed: selectedScenarioId == null
                ? null
                : () => _handleExport(context, ref, selectedScenarioId),
          ),
          const SizedBox(width: 8),
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
                        child: Text(
                          scenario.isBase ? '${scenario.name} ⭐' : scenario.name,
                          overflow: TextOverflow.ellipsis,
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

  /// Handle export button press
  Future<void> _handleExport(
    BuildContext context,
    WidgetRef ref,
    String scenarioId,
  ) async {
    try {
      // Show format selection dialog
      final format = await ExportProjectionDialog.show(context);
      if (format == null || !context.mounted) return;

      // Get projection data
      final projectionAsync = ref.read(projectionProvider(scenarioId));
      final projection = projectionAsync.value;

      if (projection == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No projection data available to export'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Get scenario name
      final scenariosAsync = ref.read(scenariosProvider);
      final scenarios = scenariosAsync.value ?? [];
      final scenario = scenarios.firstWhere(
        (s) => s.id == scenarioId,
        orElse: () => scenarios.first,
      );

      // Get assets for CSV export (needed to categorize by type)
      final assetsAsync = ref.read(assetsProvider);
      final assets = assetsAsync.value ?? [];

      // Export using service
      final exportService = ProjectionExportService();
      String content;
      String filename;

      if (format == ExportFormat.json) {
        content = exportService.exportToJson(projection, scenario.name);
        filename = exportService.generateFilename(scenario.name, 'json');
        FileDownloadHelper.downloadJson(content, filename);
      } else {
        content = exportService.exportToCsv(projection, assets);
        filename = exportService.generateFilename(scenario.name, 'csv');
        FileDownloadHelper.downloadCsv(content, filename);
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Projection exported as $filename'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Content widget that displays the projection for a selected scenario
class _ProjectionContent extends ConsumerStatefulWidget {
  final String scenarioId;

  const _ProjectionContent({required this.scenarioId});

  @override
  ConsumerState<_ProjectionContent> createState() => _ProjectionContentState();
}

class _ProjectionContentState extends ConsumerState<_ProjectionContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectionAsync = ref.watch(projectionProvider(widget.scenarioId));
    final eventsAsync = ref.watch(eventsProvider);
    final assetsAsync = ref.watch(assetsProvider);
    final projectState = ref.watch(currentProjectProvider);

    // Get events, assets, and individuals lists
    final events = eventsAsync.value ?? [];
    final assets = assetsAsync.value ?? [];
    final individuals = projectState is ProjectSelected
        ? projectState.project.individuals.cast<Individual>().toList()
        : <Individual>[];

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
              onPressed: () => ref.refresh(projectionProvider(widget.scenarioId)),
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

        return Column(
          children: [
            // Tab bar with actions
            Container(
              color: theme.colorScheme.surface,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.table_chart_outlined),
                        text: 'Simple',
                      ),
                      Tab(
                        icon: Icon(Icons.table_view),
                        text: 'Detailed',
                      ),
                    ],
                  ),
                  // Action buttons for detailed tab
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      if (_tabController.index == 1) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Column visibility button
                              TextButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const ColumnVisibilityDialog(),
                                  );
                                },
                                icon: const Icon(Icons.visibility),
                                label: const Text('Column Visibility'),
                              ),
                              const SizedBox(width: 12),
                              // CSV export button
                              FilledButton.icon(
                                onPressed: () {
                                  // Get scenario name
                                  final scenariosAsync = ref.read(scenariosProvider);
                                  final scenarios = scenariosAsync.value ?? [];
                                  final scenario = scenarios.firstWhere(
                                    (s) => s.id == widget.scenarioId,
                                    orElse: () => scenarios.first,
                                  );

                                  // Get assets for CSV export
                                  final assetsAsync = ref.read(assetsProvider);
                                  final assets = assetsAsync.value ?? [];

                                  // Export to CSV
                                  ProjectionCsvExport.exportToCSV(
                                    projection,
                                    scenario.name,
                                    assets,
                                  );

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Projection exported to CSV'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.file_download),
                                label: const Text('Export CSV'),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // Tab views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Simple view
                  CustomScrollView(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Projection: ${projection.startYear} - ${projection.endYear}',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${projection.years.length} years • ${projection.useConstantDollars ? 'Constant' : 'Current'} dollars',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
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
                      // Chart section - Net Worth
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: ProjectionChart(projection: projection),
                          ),
                        ),
                      ),
                      // Income Sources Chart
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: IncomeSourcesChart(
                              projection: projection,
                              useConstantDollars: ref.watch(dollarModeProvider),
                            ),
                          ),
                        ),
                      ),
                      // Expense Categories Chart
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: ExpenseCategoriesChart(
                              projection: projection,
                              useConstantDollars: ref.watch(dollarModeProvider),
                            ),
                          ),
                        ),
                      ),
                      // Cash Flow Chart
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: CashFlowChart(
                              projection: projection,
                              useConstantDollars: ref.watch(dollarModeProvider),
                            ),
                          ),
                        ),
                      ),
                      // Asset Allocation Chart
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: AssetAllocationChart(
                              projection: projection,
                              assets: assets,
                              useConstantDollars: ref.watch(dollarModeProvider),
                            ),
                          ),
                        ),
                      ),
                      // Simple table
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: ProjectionTableV2(
                              projection: projection,
                              events: events,
                              individuals: individuals,
                              useConstantDollars: ref.watch(dollarModeProvider),
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
                  // Detailed view
                  CustomScrollView(
                    slivers: [
                      // Expanded table
                      SliverToBoxAdapter(
                        child: ResponsiveContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Consumer(
                              builder: (context, ref, child) {
                                final columnVisibility =
                                    ref.watch(columnVisibilityProvider);
                                return ExpandedProjectionTableV2(
                                  projection: projection,
                                  events: events,
                                  individuals: individuals,
                                  useConstantDollars: ref.watch(dollarModeProvider),
                                  visibleColumnGroups:
                                      columnVisibility.visibleColumnGroups,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
