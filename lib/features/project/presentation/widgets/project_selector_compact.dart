import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Compact project selector widget for dashboard
/// Displays current project in a dropdown with create/delete/wizard actions
class ProjectSelectorCompact extends ConsumerWidget {
  final List<Project> projects;
  final Project selectedProject;
  final VoidCallback onCreateProject;
  final VoidCallback onDeleteProject;
  final VoidCallback onLaunchWizard;

  const ProjectSelectorCompact({
    super.key,
    required this.projects,
    required this.selectedProject,
    required this.onCreateProject,
    required this.onDeleteProject,
    required this.onLaunchWizard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final wizardProgressAsync = ref.watch(wizardProgressProvider);

    // Determine wizard button text based on progress
    final wizardButtonText = wizardProgressAsync.maybeWhen(
      data: (progress) {
        if (progress == null) return l10n.launchWizard;
        if (progress.wizardCompleted == true) return l10n.resumeWizard;
        // Check if any sections have been started
        final hasStarted = progress.sectionStatuses.isNotEmpty;
        return hasStarted ? l10n.resumeWizard : l10n.launchWizard;
      },
      orElse: () => l10n.launchWizard,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCreateProject,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n.create),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onLaunchWizard,
                    icon: const Icon(Icons.auto_awesome, size: 18),
                    label: Text(wizardButtonText),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDeleteProject,
                    icon: const Icon(Icons.delete, size: 18),
                    label: Text(l10n.delete),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
