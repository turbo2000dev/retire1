import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/services/project_export_service.dart';
import 'package:retire1/core/services/project_import_service.dart';
import 'package:retire1/core/ui/dialogs/import_preview_dialog.dart';
import 'package:retire1/core/ui/responsive/responsive_collapsible_section.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/utils/file_download_helper.dart';
import 'package:retire1/core/utils/file_picker_helper.dart';
import 'package:retire1/features/assets/data/asset_repository.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/events/data/event_repository.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/expenses/data/expense_repository.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/presentation/providers/projects_provider.dart';
import 'package:retire1/features/project/presentation/widgets/individual_card.dart';
import 'package:retire1/features/project/presentation/widgets/individual_dialog.dart';
import 'package:retire1/features/project/presentation/widgets/project_dialog.dart';
import 'package:retire1/features/project/presentation/wizard/project_wizard_screen.dart';
import 'package:retire1/features/scenarios/data/scenario_repository.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';
import 'package:retire1/features/scenarios/presentation/providers/scenarios_provider.dart';

/// Base Parameters screen - manages projects and project-wide parameters
class BaseParametersScreen extends ConsumerStatefulWidget {
  const BaseParametersScreen({super.key});

  @override
  ConsumerState<BaseParametersScreen> createState() => _BaseParametersScreenState();
}

class _BaseParametersScreenState extends ConsumerState<BaseParametersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _economicFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _inflationRateController = TextEditingController();
  final _reerReturnRateController = TextEditingController();
  final _celiReturnRateController = TextEditingController();
  final _criReturnRateController = TextEditingController();
  final _cashReturnRateController = TextEditingController();
  bool _isEditing = false;
  bool _isEditingEconomic = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _inflationRateController.dispose();
    _reerReturnRateController.dispose();
    _celiReturnRateController.dispose();
    _criReturnRateController.dispose();
    _cashReturnRateController.dispose();
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
        String? newProjectId;
        projectsAsync.whenData((projects) {
          if (projects.isNotEmpty) {
            newProjectId = projects.first.id;
            ref.read(currentProjectProvider.notifier).selectProject(newProjectId!);
          }
        });

        // Check if user chose wizard setup
        final useWizard = result['useWizard'] as bool? ?? false;
        if (useWizard && mounted && newProjectId != null) {
          // Launch wizard
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProjectWizardScreen(projectId: newProjectId!),
              fullscreenDialog: true,
            ),
          );
        } else {
          // User chose manual setup
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Project created')),
            );
          }
        }
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
    _inflationRateController.text = _formatPercentage(project.inflationRate);
    _reerReturnRateController.text = _formatPercentage(project.reerReturnRate);
    _celiReturnRateController.text = _formatPercentage(project.celiReturnRate);
    _criReturnRateController.text = _formatPercentage(project.criReturnRate);
    _cashReturnRateController.text = _formatPercentage(project.cashReturnRate);
  }

  Future<void> _addIndividual(Project project) async {
    bool createAnother = true;
    Project currentProject = project;

    while (createAnother) {
      if (!mounted) break;

      final result = await IndividualDialog.showCreate(context);

      if (result == null) {
        // User cancelled
        break;
      }

      if (!mounted) break;

      final updatedIndividuals = [...currentProject.individuals, result.individual];
      await _updateProjectIndividuals(currentProject, updatedIndividuals);

      // Check if user wants to create another
      createAnother = result.createAnother;

      // Get fresh project state for next iteration
      if (createAnother && mounted) {
        final projectState = ref.read(currentProjectProvider);
        if (projectState is ProjectSelected) {
          currentProject = projectState.project;
        } else {
          break;
        }
      }
    }
  }

  Future<void> _editIndividual(Project project, Individual individual) async {
    final result = await IndividualDialog.showEdit(context, individual);
    if (result != null && mounted) {
      final updatedIndividuals = project.individuals
          .map((i) => i.id == individual.id ? result.individual : i)
          .toList();
      await _updateProjectIndividuals(project, updatedIndividuals);
    }
  }

  Future<void> _deleteIndividual(Project project, Individual individual) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Individual'),
        content: Text(
          'Are you sure you want to delete "${individual.name}"?',
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
      final updatedIndividuals = project.individuals
          .where((i) => i.id != individual.id)
          .toList();
      await _updateProjectIndividuals(project, updatedIndividuals);
    }
  }

  Future<void> _updateProjectIndividuals(
    Project project,
    List<Individual> individuals,
  ) async {
    try {
      final updatedProject = project.copyWith(individuals: individuals);
      await ref.read(projectsProvider.notifier).updateProjectData(updatedProject);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Individuals updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update individuals: $e')),
        );
      }
    }
  }

  /// Converts decimal rate to percentage string (e.g., 0.02 -> "2")
  String _formatPercentage(double decimal) {
    return (decimal * 100).toStringAsFixed(2).replaceAll(RegExp(r'\.?0+$'), '');
  }

  /// Converts percentage string to decimal (e.g., "2" -> 0.02)
  double? _parsePercentage(String text) {
    final value = double.tryParse(text);
    if (value == null) return null;
    return value / 100;
  }

  Future<void> _saveEconomicAssumptions(Project project) async {
    if (!_economicFormKey.currentState!.validate()) {
      return;
    }

    try {
      final inflationRate = _parsePercentage(_inflationRateController.text);
      final reerReturnRate = _parsePercentage(_reerReturnRateController.text);
      final celiReturnRate = _parsePercentage(_celiReturnRateController.text);
      final criReturnRate = _parsePercentage(_criReturnRateController.text);
      final cashReturnRate = _parsePercentage(_cashReturnRateController.text);

      if (inflationRate == null || reerReturnRate == null ||
          celiReturnRate == null || criReturnRate == null ||
          cashReturnRate == null) {
        throw Exception('Invalid rate values');
      }

      final updatedProject = project.copyWith(
        inflationRate: inflationRate,
        reerReturnRate: reerReturnRate,
        celiReturnRate: celiReturnRate,
        criReturnRate: criReturnRate,
        cashReturnRate: cashReturnRate,
      );

      await ref.read(projectsProvider.notifier).updateProjectData(updatedProject);

      if (mounted) {
        setState(() => _isEditingEconomic = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Economic assumptions updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update economic assumptions: $e')),
        );
      }
    }
  }

  String? _validatePercentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    final percentage = double.tryParse(value);
    if (percentage == null) {
      return 'Must be a number';
    }
    if (percentage < -10 || percentage > 20) {
      return 'Must be between -10% and 20%';
    }
    return null;
  }

  /// Waits for a stream-based provider to have data available
  /// Polls the provider state until the Firestore stream emits data
  Future<T?> _waitForProviderData<T>(
    AsyncNotifierProvider<AsyncNotifier<T>, T> provider, {
    required Duration timeout,
  }) async {
    final startTime = DateTime.now();
    const pollInterval = Duration(milliseconds: 100);
    const minWaitTime = Duration(milliseconds: 1500); // Give stream time to emit

    T? lastData;
    bool hasSeenNonEmptyData = false;

    while (DateTime.now().difference(startTime) < timeout) {
      final elapsed = DateTime.now().difference(startTime);
      final state = ref.read(provider);

      state.maybeWhen(
        data: (data) {
          // For lists, check if we have data
          if (data is List) {
            if (data.isNotEmpty) {
              // We have real data! Return it immediately
              hasSeenNonEmptyData = true;
              lastData = data;
            } else {
              // Empty list - could be initial or real
              // After minimum wait time, trust that it's real
              if (elapsed >= minWaitTime) {
                lastData = data;
              }
            }
          } else {
            lastData = data;
          }
        },
        orElse: () {
          // Still loading or error - keep waiting
        },
      );

      // Return data if we have non-empty data, or empty data after min wait
      if (hasSeenNonEmptyData || (lastData != null && elapsed >= minWaitTime)) {
        return lastData;
      }

      await Future.delayed(pollInterval);
    }

    // Timeout - return whatever we have
    return lastData;
  }

  Future<void> _exportProjectData(Project project) async {
    try {
      List<Asset>? assets;
      List<Event>? events;
      List<Expense>? expenses;
      List<Scenario>? scenarios;
      final warnings = <String>[];

      // For stream-based providers, we need to ensure they're initialized and have
      // received at least one emission from Firestore. We can't tell the difference
      // between "not loaded yet" (initial []) and "loaded but empty" ([]),
      // so we always invalidate and wait for fresh data to be certain.

      // Refresh all providers to ensure fresh data
      ref.invalidate(assetsProvider);
      ref.invalidate(eventsProvider);
      ref.invalidate(expensesProvider);
      ref.invalidate(scenariosProvider);

      // Wait for stream-based providers to emit data (with generous timeout)
      assets = await _waitForProviderData<List<Asset>>(
        assetsProvider,
        timeout: const Duration(seconds: 10),
      ).catchError((e) {
        warnings.add('Assets could not be loaded and will not be included');
        return null;
      });

      events = await _waitForProviderData<List<Event>>(
        eventsProvider,
        timeout: const Duration(seconds: 10),
      ).catchError((e) {
        warnings.add('Events could not be loaded and will not be included');
        return null;
      });

      expenses = await _waitForProviderData<List<Expense>>(
        expensesProvider,
        timeout: const Duration(seconds: 10),
      ).catchError((e) {
        warnings.add('Expenses could not be loaded and will not be included');
        return null;
      });

      scenarios = await _waitForProviderData<List<Scenario>>(
        scenariosProvider,
        timeout: const Duration(seconds: 10),
      ).catchError((e) {
        warnings.add('Scenarios could not be loaded and will not be included');
        return null;
      });

      // Export with available data
      final exportService = ProjectExportService();
      final jsonContent = exportService.exportProject(
        project,
        assets: assets,
        events: events,
        expenses: expenses,
        scenarios: scenarios,
      );
      final filename = exportService.generateFilename(project);

      // Try to download file (works on web)
      try {
        FileDownloadHelper.downloadTextFile(jsonContent, filename);

        if (mounted) {
          final message = warnings.isEmpty
              ? 'Project data exported to $filename'
              : 'Project data exported with warnings:\n${warnings.join('\n')}';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: warnings.isEmpty
                  ? const Duration(seconds: 3)
                  : const Duration(seconds: 6),
            ),
          );
        }
      } on UnsupportedError {
        // On mobile/desktop, show dialog with content to copy
        if (mounted) {
          await _showExportDialog(jsonContent, filename, warnings);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export project: $e')),
        );
      }
    }
  }

  Future<void> _showExportDialog(
    String content,
    String filename,
    List<String> warnings,
  ) async {
    final theme = Theme.of(context);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Project Data'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (warnings.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_outlined,
                              color: theme.colorScheme.onErrorContainer,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Warnings:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...warnings.map((warning) => Padding(
                              padding: const EdgeInsets.only(left: 28, top: 4),
                              child: Text(
                                '• $warning',
                                style: TextStyle(
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                SelectableText(
                  content,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copied to clipboard')),
              );
            },
            child: const Text('Copy to Clipboard'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _importProjectData() async {
    try {
      // Step 1: Pick JSON file
      final jsonContent = await FilePickerHelper.pickJsonFile();

      // Step 2: Validate and generate preview
      final importService = ProjectImportService();
      final preview = importService.validateAndPreview(jsonContent);

      if (!mounted) return;

      // Step 3: Show preview dialog for confirmation
      final confirmed = await ImportPreviewDialog.show(context, preview);
      if (confirmed != true || !mounted) return;

      // Step 4: Get current user ID
      final authState = ref.read(authNotifierProvider);
      final userId = authState is Authenticated ? authState.user.id : null;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Step 5: Import and generate new entities with remapped IDs
      final importedData = importService.importProject(jsonContent, userId);

      // Step 6: Get the project repository and save project to Firestore
      // Note: Using updateProjectData which uses .set() to create the document
      final projectRepository = ref.read(projectRepositoryProvider);
      if (projectRepository == null) {
        throw Exception('Project repository not available');
      }
      await projectRepository.updateProjectData(importedData.project);

      // Step 7: Create repositories directly with the new project ID
      // (Can't use providers because they depend on currentProjectProvider being set)
      final assetRepository = AssetRepository(projectId: importedData.project.id);
      final eventRepository = EventRepository(projectId: importedData.project.id);
      final expenseRepository = ExpenseRepository(projectId: importedData.project.id);
      final scenarioRepository = ScenarioRepository(projectId: importedData.project.id);

      // Step 8: Save assets to Firestore
      for (final asset in importedData.assets) {
        await assetRepository.createAsset(asset);
      }

      // Step 9: Save events to Firestore
      for (final event in importedData.events) {
        await eventRepository.createEvent(event);
      }

      // Step 10: Save expenses to Firestore
      for (final expense in importedData.expenses) {
        await expenseRepository.createExpense(expense);
      }

      // Step 11: Save scenarios to Firestore
      for (final scenario in importedData.scenarios) {
        await scenarioRepository.createScenario(scenario);
      }

      // Step 12: Switch to the newly imported project
      ref.read(currentProjectProvider.notifier).selectProject(importedData.project.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${importedData.project.name}" imported successfully'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on UnsupportedError catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'File selection not supported on this platform'),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to import project: $e'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Project Details',
                            style: theme.textTheme.titleMedium,
                          ),
                          if (!_isEditing)
                            IconButton(
                              onPressed: () => setState(() => _isEditing = true),
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit project details',
                            ),
                        ],
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

        // Economic Assumptions section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _economicFormKey,
                  child: ResponsiveCollapsibleSection(
                    title: 'Economic Assumptions',
                    subtitle: 'Investment returns and inflation rates',
                    icon: Icons.analytics_outlined,
                    initiallyExpanded: false,
                    trailing: !_isEditingEconomic
                        ? IconButton(
                            onPressed: () => setState(() => _isEditingEconomic = true),
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit economic assumptions',
                          )
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _inflationRateController,
                          decoration: const InputDecoration(
                            labelText: 'Inflation Rate',
                            border: OutlineInputBorder(),
                            suffixText: '%',
                            helperText: 'Expected annual inflation rate',
                          ),
                          enabled: _isEditingEconomic,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                          ],
                          validator: _validatePercentage,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _reerReturnRateController,
                          decoration: const InputDecoration(
                            labelText: 'REER Return Rate',
                            border: OutlineInputBorder(),
                            suffixText: '%',
                            helperText: 'Expected annual return for REER accounts',
                          ),
                          enabled: _isEditingEconomic,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                          ],
                          validator: _validatePercentage,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _celiReturnRateController,
                          decoration: const InputDecoration(
                            labelText: 'CELI Return Rate',
                            border: OutlineInputBorder(),
                            suffixText: '%',
                            helperText: 'Expected annual return for CELI accounts',
                          ),
                          enabled: _isEditingEconomic,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                          ],
                          validator: _validatePercentage,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _criReturnRateController,
                          decoration: const InputDecoration(
                            labelText: 'CRI Return Rate',
                            border: OutlineInputBorder(),
                            suffixText: '%',
                            helperText: 'Expected annual return for CRI accounts',
                          ),
                          enabled: _isEditingEconomic,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                          ],
                          validator: _validatePercentage,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _cashReturnRateController,
                          decoration: const InputDecoration(
                            labelText: 'Cash Return Rate',
                            border: OutlineInputBorder(),
                            suffixText: '%',
                            helperText: 'Expected annual return for cash accounts',
                          ),
                          enabled: _isEditingEconomic,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
                          ],
                          validator: _validatePercentage,
                        ),
                        if (_isEditingEconomic) ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() => _isEditingEconomic = false);
                                  _loadProjectData(selectedProject);
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () => _saveEconomicAssumptions(selectedProject),
                                icon: const Icon(Icons.save),
                                label: const Text('Save'),
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
        ),

        // Individuals section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Individuals',
                          style: theme.textTheme.titleMedium,
                        ),
                        FilledButton.icon(
                          onPressed: () => _addIndividual(selectedProject),
                          icon: const Icon(Icons.person_add),
                          label: const Text('Add Individual'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (selectedProject.individuals.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No individuals yet',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add the people involved in this retirement plan',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...selectedProject.individuals.map((individual) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: IndividualCard(
                            individual: individual,
                            onEdit: () => _editIndividual(selectedProject, individual),
                            onDelete: () => _deleteIndividual(selectedProject, individual),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Import/Export section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Import/Export',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Import or export project data for backup, sharing test cases, or transferring between accounts',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _importProjectData,
                      icon: const Icon(Icons.upload),
                      label: const Text('Import Project Data'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _exportProjectData(selectedProject),
                      icon: const Icon(Icons.download),
                      label: const Text('Export Project Data'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
