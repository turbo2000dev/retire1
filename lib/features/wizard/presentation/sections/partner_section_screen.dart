import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/core/ui/responsive/responsive_text_field.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:uuid/uuid.dart';

/// Partner section - Spouse/partner information (optional)
class PartnerSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const PartnerSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<PartnerSectionScreen> createState() =>
      _PartnerSectionScreenState();
}

class _PartnerSectionScreenState extends ConsumerState<PartnerSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String? _individualId;
  DateTime? _selectedBirthdate;

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
    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception('No project selected');
      }

      final project = currentProjectState.project;

      // Check if partner already exists (second individual)
      if (project.individuals.length >= 2) {
        final partner = project.individuals[1];
        _individualId = partner.id;
        _nameController.text = partner.name;
        _selectedBirthdate = partner.birthdate;
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
              .updateSectionStatus('partner', WizardSectionStatus.inProgress());
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

  Future<bool> _validateAndSave() async {
    // Since this section is optional, allow skipping if no data entered
    final hasData =
        _nameController.text.trim().isNotEmpty || _selectedBirthdate != null;

    if (!hasData) {
      // No data entered, mark as skipped and allow navigation
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('partner', WizardSectionStatus.skipped());
      return true;
    }

    // If data entered, validate it
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

      if (repository == null) {
        throw Exception('Repository not available');
      }

      // Create or update individual
      final individual = Individual(
        id: _individualId ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        birthdate: _selectedBirthdate!,
      );

      // Update project with individual (as second individual - partner)
      List<Individual> updatedIndividuals;
      if (_individualId != null) {
        // Update existing partner
        updatedIndividuals = project.individuals
            .map((i) => i.id == _individualId ? individual : i)
            .toList();
      } else {
        // Add new partner as second individual
        if (project.individuals.isEmpty) {
          // No primary individual yet - this shouldn't happen but handle it
          updatedIndividuals = [individual];
        } else {
          // Insert partner as second individual
          updatedIndividuals = [
            project.individuals[0], // Primary individual
            individual, // Partner
            ...project.individuals.skip(1), // Any other individuals
          ];
        }
      }

      final updatedProject = project.copyWith(individuals: updatedIndividuals);
      await repository.updateProjectData(updatedProject);

      // Mark section as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('partner', WizardSectionStatus.complete());

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }

      return true;
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isSaving = false;
        });
      }
      return false;
    }
  }

  Future<void> _selectBirthdate() async {
    final now = DateTime.now();
    final initialDate =
        _selectedBirthdate ?? DateTime(now.year - 30, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedBirthdate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${l10n.error}: $_errorMessage',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _loadIndividualData,
              child: Text(l10n.retry),
            ),
          ],
        ),
      );
    }

    return ResponsiveContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.partnerInformation, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              l10n.partnerSectionDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Name field
            ResponsiveTextField(
              controller: _nameController,
              label: l10n.partnerName,
              hint: l10n.enterPartnerName,
              validator: (value) {
                // Only validate if user has entered something or selected a date
                final hasData =
                    value?.trim().isNotEmpty == true ||
                    _selectedBirthdate != null;
                if (!hasData) {
                  return null; // Allow empty for optional section
                }

                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterPartnerName;
                }
                if (value.trim().length < 2) {
                  return l10n.nameMinTwoCharacters;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Birthdate field
            InkWell(
              onTap: _selectBirthdate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.dateOfBirth,
                  hintText: l10n.selectPartnerBirthdate,
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _selectedBirthdate != null
                      ? '${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}'
                      : '',
                  style: _selectedBirthdate == null
                      ? theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        )
                      : theme.textTheme.bodyLarge,
                ),
              ),
            ),

            const SizedBox(height: 32),

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
                l10n.partnerSectionInstructions,
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
