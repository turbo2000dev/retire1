import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/responsive_dialog.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/features/project/domain/project.dart';

/// Project dialog for creating or editing a project
class ProjectDialog extends StatefulWidget {
  final Project? project; // null for create, non-null for edit

  const ProjectDialog({
    super.key,
    this.project,
  });

  /// Show create project dialog
  static Future<Map<String, String>?> showCreate(BuildContext context) {
    return showDialog<Map<String, String>>(
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
