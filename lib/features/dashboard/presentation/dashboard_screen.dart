import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';
import 'package:retire1/features/dashboard/presentation/widgets/project_card.dart';
import 'package:retire1/features/dashboard/presentation/widgets/project_dialog.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/projects_provider.dart';

/// Dashboard screen - shows list of projects
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _showCreateProjectDialog(BuildContext context, WidgetRef ref) async {
    final result = await ProjectDialog.showCreate(context);
    if (result != null && context.mounted) {
      await ref.read(projectsProvider.notifier).createProject(
            result['name']!,
            result['description'],
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created')),
        );
      }
    }
  }

  Future<void> _showEditProjectDialog(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    final result = await ProjectDialog.showEdit(context, project);
    if (result != null && context.mounted) {
      await ref.read(projectsProvider.notifier).updateProject(
            project.id,
            result['name']!,
            result['description'],
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated')),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Project project,
  ) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: Text(
          'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(projectsProvider.notifier).deleteProject(project.id);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project deleted')),
        );
      }
    }
  }

  void _openProject(BuildContext context, Project project) {
    context.go(AppRoutes.baseParameters);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenSize = ScreenSize(context);
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      body: ResponsiveContainer(
        child: projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyState(context);
            }

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text(
                      'My Projects',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                ),

                // Projects grid/list
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: screenSize.isPhone
                      ? _buildProjectList(context, ref, projects)
                      : _buildProjectGrid(context, ref, projects, screenSize),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
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
                  'Failed to load projects',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => ref.read(projectsProvider.notifier).reload(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New Project'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
            'No projects yet',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first retirement planning project',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectList(
    BuildContext context,
    WidgetRef ref,
    List<Project> projects,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = projects[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProjectCard(
              project: project,
              onTap: () => _openProject(context, project),
              onEdit: () => _showEditProjectDialog(context, ref, project),
              onDelete: () => _showDeleteConfirmation(context, ref, project),
            ),
          );
        },
        childCount: projects.length,
      ),
    );
  }

  Widget _buildProjectGrid(
    BuildContext context,
    WidgetRef ref,
    List<Project> projects,
    ScreenSize screenSize,
  ) {
    // Determine grid columns based on screen size
    int crossAxisCount;
    if (screenSize.isDesktop) {
      crossAxisCount = 3;
    } else {
      crossAxisCount = 2;
    }

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final project = projects[index];
          return ProjectCard(
            project: project,
            onTap: () => _openProject(context, project),
            onEdit: () => _showEditProjectDialog(context, ref, project),
            onDelete: () => _showDeleteConfirmation(context, ref, project),
          );
        },
        childCount: projects.length,
      ),
    );
  }
}
