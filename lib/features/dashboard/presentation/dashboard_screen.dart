import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/presentation/providers/projects_provider.dart';
import 'package:retire1/features/project/presentation/widgets/project_dialog.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/projection_kpis_calculator.dart';
import 'package:retire1/features/projection/presentation/providers/projection_provider.dart';
import 'package:retire1/features/projection/presentation/widgets/projection_kpi_card.dart';
import 'package:retire1/features/projection/presentation/widgets/projection_warnings_section.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';
import 'package:retire1/features/dashboard/presentation/widgets/scenario_selector.dart';
import 'package:retire1/features/dashboard/presentation/widgets/kpi_comparison_card.dart';
import 'package:retire1/features/projection/presentation/widgets/multi_scenario_projection_chart.dart';

/// Dashboard screen - shows KPIs and scenario comparison for current project
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Set<String> _selectedScenarioIds = {};

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

  void _navigateToBaseParameters(BuildContext context) {
    context.go(AppRoutes.baseParameters);
  }

  void _navigateToProjection(BuildContext context, {int? scrollToYear}) {
    context.go(AppRoutes.projection);
    // TODO: Implement scroll to specific year when warning is tapped
  }

  Future<void> _createNewProject(BuildContext context, WidgetRef ref) async {
    final result = await ProjectDialog.showCreate(context);
    if (result == null || !context.mounted) return;

    await ref
        .read(projectsProvider.notifier)
        .createProject(result['name']!, result['description']);

    if (!context.mounted) return;

    // Get the newly created project and select it
    final projectsAsync = ref.read(projectsProvider);
    projectsAsync.whenData((projects) {
      if (projects.isNotEmpty) {
        ref
            .read(currentProjectProvider.notifier)
            .selectProject(projects.first.id);
      }
    });

    // Navigate to Base Parameters to configure the project
    if (!context.mounted) return;
    context.go(AppRoutes.baseParameters);

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Project created')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentProjectState = ref.watch(currentProjectProvider);

    return Scaffold(
      body: ResponsiveContainer(
        child: switch (currentProjectState) {
          NoProjectSelected() => _buildEmptyState(context, ref),
          ProjectLoading() => const Center(child: CircularProgressIndicator()),
          ProjectError(:final message) => _buildErrorState(context, message),
          ProjectSelected() => _buildDashboard(context, theme),
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text('No project selected', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Create one to get started',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _createNewProject(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Create New Project'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('Error loading project', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, ThemeData theme) {
    // Get base scenario
    final baseScenario = ref.watch(baseScenarioProvider);

    // If no base scenario, show loading or error
    if (baseScenario == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Get projection for base scenario
    final projectionAsync = ref.watch(projectionProvider(baseScenario.id));

    return Column(
      children: [
        // Tab bar
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'KPIs'),
            Tab(text: 'Comparison'),
          ],
        ),
        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildKpisTab(context, theme, projectionAsync),
              _buildComparisonTab(context, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKpisTab(
    BuildContext context,
    ThemeData theme,
    AsyncValue<Projection?> projectionAsync,
  ) {
    return projectionAsync.when(
      data: (projection) {
        if (projection == null) {
          return _buildNoProjectionState(context, theme);
        }

        // Calculate KPIs using extension method
        final kpis = projection.calculateKpis();

        // Apply dollar mode conversion if needed
        // For simplicity in Phase 35A, we'll show current dollars
        // TODO: Add dollar mode conversion in future iteration
        // final useConstantDollars = ref.watch(dollarModeProvider);

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Key Performance Indicators',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quick summary of your projection',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // KPI cards in grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive columns: 3 on desktop, 2 on tablet, 1 on mobile
                        final crossAxisCount = constraints.maxWidth > 1024
                            ? 3
                            : constraints.maxWidth > 600
                            ? 2
                            : 1;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.5,
                          children: [
                            ProjectionKpiCard.currency(
                              icon: Icons.account_balance_wallet,
                              label: 'Final Net Worth',
                              amount: kpis.finalNetWorth,
                              subtitle: 'At end of projection',
                              status: kpis.finalNetWorth > 500000
                                  ? KpiStatus.good
                                  : kpis.finalNetWorth > 100000
                                  ? KpiStatus.neutral
                                  : KpiStatus.warning,
                            ),
                            ProjectionKpiCard.currency(
                              icon: Icons.trending_down,
                              label: 'Lowest Net Worth',
                              amount: kpis.lowestNetWorth,
                              subtitle: 'Year ${kpis.yearOfLowestNetWorth}',
                              status: kpis.lowestNetWorth < 0
                                  ? KpiStatus.critical
                                  : kpis.lowestNetWorth < 100000
                                  ? KpiStatus.warning
                                  : KpiStatus.neutral,
                            ),
                            ProjectionKpiCard.year(
                              icon: Icons.warning_amber,
                              label: 'Money Runs Out',
                              year: kpis.yearMoneyRunsOut,
                              status: kpis.yearMoneyRunsOut != null
                                  ? KpiStatus.critical
                                  : KpiStatus.good,
                            ),
                            ProjectionKpiCard.currency(
                              icon: Icons.account_balance,
                              label: 'Total Taxes Paid',
                              amount: kpis.totalTaxesPaid,
                              status: KpiStatus.neutral,
                            ),
                            ProjectionKpiCard.currency(
                              icon: Icons.attach_money,
                              label: 'Total Withdrawals',
                              amount: kpis.totalWithdrawals,
                              status: KpiStatus.neutral,
                            ),
                            ProjectionKpiCard.percentage(
                              icon: Icons.percent,
                              label: 'Average Tax Rate',
                              rate: kpis.averageTaxRate,
                              status: kpis.averageTaxRate > 0.45
                                  ? KpiStatus.warning
                                  : KpiStatus.neutral,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Warnings section
                    ProjectionWarningsSection(
                      kpis: kpis,
                      projection: projection,
                      onMoneyRunsOutTap: () => _navigateToProjection(
                        context,
                        scrollToYear: kpis.yearMoneyRunsOut,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading projection: $error')),
    );
  }

  Widget _buildComparisonTab(BuildContext context, ThemeData theme) {
    final scenariosAsync = ref.watch(scenariosProvider);

    return scenariosAsync.when(
      data: (scenarios) {
        if (scenarios.isEmpty) {
          return _buildNoScenariosState(context, theme);
        }

        // Base scenario is always first
        final baseScenario = scenarios.firstWhere((s) => s.isBase);
        final alternativeScenarios = scenarios.where((s) => !s.isBase).toList();

        // Initialize selected scenarios if empty (include base + first alternative if available)
        if (_selectedScenarioIds.isEmpty) {
          _selectedScenarioIds = {
            baseScenario.id,
            if (alternativeScenarios.isNotEmpty) alternativeScenarios.first.id,
          };
        }

        // Get selected scenarios in order (base first, then alternatives)
        final selectedScenarios = [
          baseScenario,
          ...alternativeScenarios.where(
            (s) => _selectedScenarioIds.contains(s.id),
          ),
        ];

        // If only 1 scenario exists, show message
        if (scenarios.length == 1) {
          return _buildSingleScenarioState(context, theme);
        }

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      'Scenario Comparison',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Compare KPIs across different scenarios',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Scenario selector
                    ScenarioSelector(
                      baseScenario: baseScenario,
                      alternativeScenarios: alternativeScenarios,
                      selectedScenarioIds: _selectedScenarioIds,
                      onScenarioToggled: (scenarioId) {
                        setState(() {
                          if (_selectedScenarioIds.contains(scenarioId)) {
                            _selectedScenarioIds.remove(scenarioId);
                          } else {
                            _selectedScenarioIds.add(scenarioId);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // KPI comparison cards
                    _buildKpiComparisonGrid(context, theme, selectedScenarios),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading scenarios: $error')),
    );
  }

  Widget _buildKpiComparisonGrid(
    BuildContext context,
    ThemeData theme,
    List<dynamic> selectedScenarios,
  ) {
    // Create a Consumer widget to watch projections
    return Consumer(
      builder: (context, ref, child) {
        // Load projections for all selected scenarios
        final projectionAsyncValues = selectedScenarios.map((scenario) {
          return ref.watch(projectionProvider(scenario.id));
        }).toList();

        // Check if all projections are loaded
        final allLoaded = projectionAsyncValues.every(
          (async) => async.hasValue,
        );
        final anyError = projectionAsyncValues.any((async) => async.hasError);

        if (anyError) {
          return const Center(child: Text('Error loading projections'));
        }

        if (!allLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        // Calculate KPIs for each scenario
        final scenarioKpis = projectionAsyncValues
            .map((async) => async.value?.calculateKpis())
            .toList();

        return _buildComparisonCardsGrid(
          context,
          theme,
          selectedScenarios,
          scenarioKpis,
        );
      },
    );
  }

  Widget _buildComparisonCardsGrid(
    BuildContext context,
    ThemeData theme,
    List<dynamic> selectedScenarios,
    List<dynamic> scenarioKpis,
  ) {
    return Consumer(
      builder: (context, ref, child) {
        // Get projections for chart
        final projectionAsyncValues = selectedScenarios.map((scenario) {
          return ref.watch(projectionProvider(scenario.id));
        }).toList();

        final allProjectionsLoaded = projectionAsyncValues.every(
          (async) => async.hasValue,
        );

        // Build comparison cards and chart
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI comparison cards grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 1024
                    ? 2
                    : constraints.maxWidth > 600
                    ? 2
                    : 1;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  children: [
                    // Final Net Worth
                    KpiComparisonCard(
                      label: 'Final Net Worth',
                      icon: Icons.account_balance_wallet,
                      type: KpiComparisonType.currency,
                      scenariosData: List.generate(
                        selectedScenarios.length,
                        (i) => ScenarioKpiData(
                          scenarioName: selectedScenarios[i].name,
                          value: scenarioKpis[i]?.finalNetWorth,
                        ),
                      ),
                    ),
                    // Lowest Net Worth
                    KpiComparisonCard(
                      label: 'Lowest Net Worth',
                      icon: Icons.trending_down,
                      type: KpiComparisonType.currency,
                      scenariosData: List.generate(
                        selectedScenarios.length,
                        (i) => ScenarioKpiData(
                          scenarioName: selectedScenarios[i].name,
                          value: scenarioKpis[i]?.lowestNetWorth,
                        ),
                      ),
                    ),
                    // Money Runs Out
                    KpiComparisonCard(
                      label: 'Money Runs Out',
                      icon: Icons.warning_amber,
                      type: KpiComparisonType.year,
                      scenariosData: List.generate(
                        selectedScenarios.length,
                        (i) => ScenarioKpiData(
                          scenarioName: selectedScenarios[i].name,
                          value: scenarioKpis[i]?.yearMoneyRunsOut?.toDouble(),
                        ),
                      ),
                    ),
                    // Total Taxes Paid
                    KpiComparisonCard(
                      label: 'Total Taxes Paid',
                      icon: Icons.account_balance,
                      type: KpiComparisonType.currency,
                      scenariosData: List.generate(
                        selectedScenarios.length,
                        (i) => ScenarioKpiData(
                          scenarioName: selectedScenarios[i].name,
                          value: scenarioKpis[i]?.totalTaxesPaid,
                        ),
                      ),
                    ),
                    // Total Withdrawals
                    KpiComparisonCard(
                      label: 'Total Withdrawals',
                      icon: Icons.attach_money,
                      type: KpiComparisonType.currency,
                      scenariosData: List.generate(
                        selectedScenarios.length,
                        (i) => ScenarioKpiData(
                          scenarioName: selectedScenarios[i].name,
                          value: scenarioKpis[i]?.totalWithdrawals,
                        ),
                      ),
                    ),
                    // Average Tax Rate
                    KpiComparisonCard(
                      label: 'Average Tax Rate',
                      icon: Icons.percent,
                      type: KpiComparisonType.percentage,
                      scenariosData: List.generate(
                        selectedScenarios.length,
                        (i) => ScenarioKpiData(
                          scenarioName: selectedScenarios[i].name,
                          value: scenarioKpis[i]?.averageTaxRate,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            // Chart section
            if (allProjectionsLoaded) ...[
              const SizedBox(height: 32),
              Text(
                'Net Worth Projection',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: MultiScenarioProjectionChart(
                    scenarioProjections: projectionAsyncValues
                        .asMap()
                        .entries
                        .where(
                          (entry) =>
                              entry.value.hasValue && entry.value.value != null,
                        )
                        .map((entry) {
                          final index = entry.key;
                          final projection = entry.value.value!;
                          return ScenarioProjectionData(
                            scenarioName: selectedScenarios[index].name,
                            projection: projection,
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNoScenariosState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text('No scenarios available', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Create scenarios to compare them',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleScenarioState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare_arrows,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Only one scenario exists',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Create alternative scenarios to compare',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoProjectionState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calculate,
            size: 64,
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No projection available',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your project setup to view KPIs',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _navigateToBaseParameters(context),
            icon: const Icon(Icons.edit),
            label: const Text('Setup Project'),
          ),
        ],
      ),
    );
  }
}
