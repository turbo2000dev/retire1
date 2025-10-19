import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:uuid/uuid.dart';

/// Section 3: Primary Individual
/// Allows user to enter primary individual information
class PrimaryIndividualSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const PrimaryIndividualSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<PrimaryIndividualSectionScreen> createState() =>
      _PrimaryIndividualSectionScreenState();
}

class _PrimaryIndividualSectionScreenState
    extends ConsumerState<PrimaryIndividualSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedBirthdate;

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String? _individualId;

  @override
  void initState() {
    super.initState();
    _loadIndividualData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadIndividualData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is ProjectSelected) {
        final project = currentProjectState.project;

        // Load existing primary individual if it exists
        if (project.individuals.isNotEmpty) {
          final primaryIndividual = project.individuals.first;
          _individualId = primaryIndividual.id;
          _nameController.text = primaryIndividual.name;
          _selectedBirthdate = primaryIndividual.birthdate;
        }
      }

      // Register validation callback for Next button
      widget.onRegisterCallback?.call(_validateAndSave);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Mark section as in progress after first frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus(
                'primary-individual',
                WizardSectionStatus.inProgress(),
              );
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

  Future<void> _selectBirthdate() async {
    final now = DateTime.now();
    final initialDate =
        _selectedBirthdate ?? DateTime(now.year - 40, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppLocalizations.of(context).selectBirthdate,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  /// Validate and save - called by Next button
  Future<bool> _validateAndSave() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedBirthdate == null) {
      setState(() {
        _errorMessage = AppLocalizations.of(context).pleaseSelectBirthdate;
      });
      return false;
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

      final project = currentProjectState.project;
      final repository = ref.read(projectRepositoryProvider);

      // Create or update individual
      final individual = Individual(
        id: _individualId ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        birthdate: _selectedBirthdate!,
      );

      // Update project with individual
      List<Individual> updatedIndividuals;
      if (_individualId != null) {
        // Update existing individual
        updatedIndividuals = project.individuals
            .map((i) => i.id == _individualId ? individual : i)
            .toList();
      } else {
        // Add new individual as first in list
        updatedIndividuals = [individual, ...project.individuals];
      }

      // Save updated project with new individuals list
      final updatedProject = project.copyWith(
        individuals: updatedIndividuals,
        updatedAt: DateTime.now(),
      );

      await repository!.updateProjectData(updatedProject);

      // Mark section as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus(
            'primary-individual',
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
            Text(l10n.section3Title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              l10n.section3Description,
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
                    Icon(Icons.error_outline, color: theme.colorScheme.error),
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

            // Name field
            ResponsiveTextField(
              controller: _nameController,
              label: l10n.individualName,
              hint: l10n.exampleName,
              required: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.requiredField;
                }
                if (value.trim().length < 2) {
                  return l10n.nameMinTwoCharacters;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Birthdate field
            Text(
              '${l10n.birthdate} *',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectBirthdate,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedBirthdate != null
                            ? '${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}'
                            : l10n.selectBirthdate,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: _selectedBirthdate != null
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Show age if birthdate selected
            if (_selectedBirthdate != null) ...[
              const SizedBox(height: 8),
              Text(
                '${l10n.age}: ${_calculateAge(_selectedBirthdate!)} ${l10n.yearsLabel}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Info text
            if (_isSaving)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    Text(l10n.saving, style: theme.textTheme.bodySmall),
                  ],
                ),
              )
            else
              Text(
                l10n.clickNextToSaveAndContinue,
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

  int _calculateAge(DateTime birthdate) {
    final today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    return age;
  }
}
