import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

/// Section 2: Project Basics
/// Allows user to set project name and description
class ProjectBasicsSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const ProjectBasicsSectionScreen({
    super.key,
    this.onRegisterCallback,
  });

  @override
  ConsumerState<ProjectBasicsSectionScreen> createState() =>
      _ProjectBasicsSectionScreenState();
}

class _ProjectBasicsSectionScreenState
    extends ConsumerState<ProjectBasicsSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProjectData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadProjectData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is ProjectSelected) {
        final project = currentProjectState.project;
        _nameController.text = project.name;
        _descriptionController.text = project.description ?? '';
      }

      // Mark section as in progress when user enters
      await ref.read(wizardProgressProvider.notifier).updateSectionStatus(
            'project-basics',
            WizardSectionStatus.inProgress(),
          );

      // Register validation callback for Next button
      widget.onRegisterCallback?.call(_validateAndSave);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  /// Validate and save - called by Next button
  Future<bool> _validateAndSave() async {
    if (!_formKey.currentState!.validate()) {
      return false; // Block navigation if validation fails
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception('No project selected');
      }

      final projectId = currentProjectState.project.id;
      final repository = ref.read(projectRepositoryProvider);

      // Save to repository
      await repository!.updateProject(
        projectId: projectId,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      // Mark section as complete
      await ref.read(wizardProgressProvider.notifier).updateSectionStatus(
            'project-basics',
            WizardSectionStatus.complete(),
          );

      return true; // Allow navigation
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
      return false; // Block navigation on error
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ResponsiveContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title and description
            Text(
              l10n.section2Title,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.section2Description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Error message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Project Name field
            ResponsiveTextField(
              controller: _nameController,
              label: l10n.projectName,
              hint: 'e.g., My Retirement Plan 2025',
              required: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredField;
                }
                if (value.trim().length < 3) {
                  return 'Project name must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Project Description field
            ResponsiveTextField(
              controller: _descriptionController,
              label: l10n.projectDescription,
              hint: 'Optional: Add notes about this planning scenario',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Info text
            if (_isSaving)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    Text(
                      'Saving...',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            else
              Text(
                'Click "Next" to save and continue',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
