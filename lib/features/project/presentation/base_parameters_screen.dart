import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/presentation/providers/projects_provider.dart';
import 'package:retire1/features/project/presentation/widgets/project_dialog.dart';

/// Base Parameters screen - manages projects and project-wide parameters
class BaseParametersScreen extends ConsumerStatefulWidget {
  const BaseParametersScreen({super.key});

  @override
  ConsumerState<BaseParametersScreen> createState() => _BaseParametersScreenState();
}

class _BaseParametersScreenState extends ConsumerState<BaseParametersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createNewProject() async {
    final result = await ProjectDialog.showCreate(context);
    if (result != null && mounted) {
      await ref.read(projectsProvider.notifier).createProject(
            result['name']!,
            result['description'],
          );

      if (mounted) {
        // Get the newly created project (should be first in list)
        final projectsAsync = ref.read(projectsProvider);
        projectsAsync.whenData((projects) {
          if (projects.isNotEmpty) {
            ref.read(currentProjectProvider.notifier).selectProject(projects.first.id);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created')),
        );
      }
    }
  }

  Future<void> _deleteCurrentProject(Project project) async {
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

    if (confirmed == true && mounted) {
      await ref.read(projectsProvider.notifier).deleteProject(project.id);
      // Clear selection - will automatically select another or show empty
      await ref.read(currentProjectProvider.notifier).clearSelection();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project deleted')),
        );
      }
    }
  }

  Future<void> _saveProjectChanges(Project project) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref.read(projectsProvider.notifier).updateProject(
            project.id,
            _nameController.text,
            _descriptionController.text.isEmpty ? null : _descriptionController.text,
          );

      if (mounted) {
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update project: $e')),
        );
      }
    }
  }

  void _loadProjectData(Project project) {
    _nameController.text = project.name;
    _descriptionController.text = project.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final projectsAsync = ref.watch(projectsProvider);
    final currentProjectState = ref.watch(currentProjectProvider);

    return Scaffold(
      body: ResponsiveContainer(
        child: projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyState(context, theme);
            }

            return switch (currentProjectState) {
              NoProjectSelected() => _buildNoSelection(context, theme, projects),
              ProjectLoading() => const Center(child: CircularProgressIndicator()),
              ProjectError(:final message) => _buildErrorState(context, theme, message),
              ProjectSelected(:final project) => _buildProjectEditor(context, theme, projects, project),
            };
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(context, theme, error.toString()),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
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
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _createNewProject,
            icon: const Icon(Icons.add),
            label: const Text('Create Project'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSelection(BuildContext context, ThemeData theme, List<Project> projects) {
    // Auto-select first project
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (projects.isNotEmpty) {
        ref.read(currentProjectProvider.notifier).selectProject(projects.first.id);
      }
    });

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String message) {
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
            'Error loading projects',
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

  Widget _buildProjectEditor(BuildContext context, ThemeData theme, List<Project> projects, Project selectedProject) {
    // Load project data when selected project changes
    if (!_isEditing) {
      _loadProjectData(selectedProject);
    }

    return CustomScrollView(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Text(
              'Base Parameters',
              style: theme.textTheme.headlineMedium,
            ),
          ),
        ),

        // Project selector and actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Project Selection',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      key: ValueKey(selectedProject.id),
                      initialValue: selectedProject.id,
                      decoration: const InputDecoration(
                        labelText: 'Current Project',
                        border: OutlineInputBorder(),
                      ),
                      items: projects.map((project) {
                        return DropdownMenuItem(
                          value: project.id,
                          child: Text(project.name),
                        );
                      }).toList(),
                      onChanged: (projectId) {
                        if (projectId != null) {
                          setState(() => _isEditing = false);
                          ref.read(currentProjectProvider.notifier).selectProject(projectId);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _createNewProject,
                            icon: const Icon(Icons.add),
                            label: const Text('New Project'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _deleteCurrentProject(selectedProject),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete Project'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Project details editor
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Project Details',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Project Name',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditing,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Project name is required';
                          }
                          return null;
                        },
                        onChanged: (_) {
                          if (!_isEditing) {
                            setState(() => _isEditing = true);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description (optional)',
                          border: OutlineInputBorder(),
                        ),
                        enabled: _isEditing,
                        maxLines: 3,
                        onChanged: (_) {
                          if (!_isEditing) {
                            setState(() => _isEditing = true);
                          }
                        },
                      ),
                      if (_isEditing) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() => _isEditing = false);
                                _loadProjectData(selectedProject);
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 8),
                            FilledButton.icon(
                              onPressed: () => _saveProjectChanges(selectedProject),
                              icon: const Icon(Icons.save),
                              label: const Text('Save Changes'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
