import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';

/// Compact project selector widget for dashboard
/// Displays current project in a dropdown with minimal vertical spacing
class ProjectSelectorCompact extends ConsumerWidget {
  final List<Project> projects;
  final Project selectedProject;

  const ProjectSelectorCompact({
    super.key,
    required this.projects,
    required this.selectedProject,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(Icons.folder, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedProject.id,
                decoration: const InputDecoration(
                  labelText: 'Current Project',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  isDense: true,
                ),
                items: projects.map((project) {
                  return DropdownMenuItem(
                    value: project.id,
                    child: Text(project.name),
                  );
                }).toList(),
                onChanged: (projectId) {
                  if (projectId != null) {
                    ref
                        .read(currentProjectProvider.notifier)
                        .selectProject(projectId);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
