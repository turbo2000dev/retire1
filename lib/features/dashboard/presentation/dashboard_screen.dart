import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/presentation/providers/projects_provider.dart';
import 'package:retire1/features/project/presentation/widgets/project_dialog.dart';

/// Dashboard screen - shows executive summary of current project
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  void _navigateToBaseParameters(BuildContext context) {
    context.go(AppRoutes.baseParameters);
  }

  Future<void> _createNewProject(BuildContext context, WidgetRef ref) async {
    final result = await ProjectDialog.showCreate(context);
    if (result == null || !context.mounted) return;

    await ref.read(projectsProvider.notifier).createProject(
          result['name']!,
          result['description'],
        );

    if (!context.mounted) return;

    // Get the newly created project and select it
    final projectsAsync = ref.read(projectsProvider);
    projectsAsync.whenData((projects) {
      if (projects.isNotEmpty) {
        ref.read(currentProjectProvider.notifier).selectProject(projects.first.id);
      }
    });

    // Navigate to Base Parameters to configure the project
    if (!context.mounted) return;
    context.go(AppRoutes.baseParameters);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project created')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentProjectState = ref.watch(currentProjectProvider);

    return Scaffold(
      body: ResponsiveContainer(
        child: switch (currentProjectState) {
          NoProjectSelected() => _buildEmptyState(context, ref),
          ProjectLoading() => const Center(child: CircularProgressIndicator()),
          ProjectError(:final message) => _buildErrorState(context, message),
          ProjectSelected(:final project) => _buildSummary(context, theme, project),
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
          Text(
            'No project selected',
            style: theme.textTheme.headlineMedium,
          ),
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
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading project',
            style: theme.textTheme.titleLarge,
          ),
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

  Widget _buildSummary(BuildContext context, ThemeData theme, project) {
    return CustomScrollView(
      slivers: [
        // Header with project name
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  style: theme.textTheme.headlineMedium,
                ),
                if (project.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    project.description!,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Summary cards
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Executive Summary',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Project summary and key metrics will be displayed here.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => _navigateToBaseParameters(context),
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Project Details'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
