import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/features/project/domain/project.dart';

/// Project dialog for creating or editing a project
class ProjectDialog extends StatefulWidget {
  final Project? project; // null for create, non-null for edit

  const ProjectDialog({super.key, this.project});

  /// Show create project dialog
  /// Returns a map with 'name', 'description', and 'useWizard' keys
  static Future<Map<String, dynamic>?> showCreate(BuildContext context) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ProjectDialog(),
    );
  }

  /// Show edit project dialog
  static Future<Map<String, String>?> showEdit(
    BuildContext context,
    Project project,
  ) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => ProjectDialog(project: project),
    );
  }

  @override
  State<ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  bool _isLoading = false;
  bool _useWizard = true; // Default to wizard for new projects

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.project?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.project != null;

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = {
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'useWizard': _isEditing ? false : _useWizard, // Only for new projects
    };

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      child: ResponsiveDialogContent(
        title: _isEditing ? 'Edit Project' : 'Create Project',
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name field
              ResponsiveTextField(
                controller: _nameController,
                label: 'Project Name',
                hint: 'Enter project name',
                enabled: !_isLoading,
                autofocus: true,
                required: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a project name';
                  }
                  if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description field
              ResponsiveTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter project description (optional)',
                enabled: !_isLoading,
                maxLines: 3,
                onSubmitted: (_) => _handleSave(),
              ),

              // Setup method choice (only for new projects)
              if (!_isEditing) ...[
                const SizedBox(height: 24),
                Text(
                  'How would you like to set up your project?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),

                // Wizard option (recommended)
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () {
                          setState(() => _useWizard = true);
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _useWizard
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: _useWizard ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _useWizard
                          ? Theme.of(context).colorScheme.primaryContainer
                                .withValues(alpha: 0.3)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _useWizard,
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() => _useWizard = value!);
                                },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Quick Setup Wizard',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'RECOMMENDED',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Guided steps to quickly configure your project',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Manual setup option
                InkWell(
                  onTap: _isLoading
                      ? null
                      : () {
                          setState(() => _useWizard = false);
                        },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: !_useWizard
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: !_useWizard ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: !_useWizard
                          ? Theme.of(context).colorScheme.primaryContainer
                                .withValues(alpha: 0.3)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Radio<bool>(
                          value: false,
                          groupValue: _useWizard,
                          onChanged: _isLoading
                              ? null
                              : (value) {
                                  setState(() => _useWizard = value!);
                                },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tune,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Manual Setup',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Configure everything yourself at your own pace',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),

          // Save button
          FilledButton(
            onPressed: _isLoading ? null : _handleSave,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isEditing ? 'Save' : 'Create'),
          ),
        ],
      ),
    );
  }
}
