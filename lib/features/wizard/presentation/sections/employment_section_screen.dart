import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Employment section - Enter employment income for individuals (optional)
class EmploymentSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const EmploymentSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<EmploymentSectionScreen> createState() =>
      _EmploymentSectionScreenState();
}

class _EmploymentSectionScreenState
    extends ConsumerState<EmploymentSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _incomeControllers = {};
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  List<Individual> _individuals = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    for (var controller in _incomeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception(AppLocalizations.of(context).noProjectSelected);
      }

      final project = currentProjectState.project;
      _individuals = project.individuals;

      // Initialize controllers for each individual
      for (var individual in _individuals) {
        _incomeControllers[individual.id] = TextEditingController(
          text: individual.employmentIncome > 0
              ? individual.employmentIncome.toStringAsFixed(0)
              : '',
        );
      }

      // Register validation callback for Next button
      widget.onRegisterCallback?.call(_validateAndContinue);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Mark section as in progress after first frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus(
                'employment',
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

  Future<bool> _validateAndContinue() async {
    if (_isSaving) return false;

    // Employment section is optional - check if any income was entered
    final hasAnyIncome = _incomeControllers.values.any(
      (controller) => controller.text.trim().isNotEmpty,
    );

    if (!hasAnyIncome) {
      // No income entered - mark as skipped
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('employment', WizardSectionStatus.skipped());
      return true;
    }

    // Validate form if income was entered
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    // Save the employment income
    setState(() => _isSaving = true);

    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception(AppLocalizations.of(context).noProjectSelected);
      }

      final project = currentProjectState.project;

      // Update individuals with employment income
      final updatedIndividuals = _individuals.map((individual) {
        final controller = _incomeControllers[individual.id];
        final incomeText = controller?.text.trim() ?? '';
        final income = incomeText.isEmpty ? 0.0 : double.parse(incomeText);

        return individual.copyWith(employmentIncome: income);
      }).toList();

      // Update project with new individuals data
      final updatedProject = project.copyWith(individuals: updatedIndividuals);

      final repository = ref.read(projectRepositoryProvider);
      if (repository == null) {
        throw Exception('Repository not available');
      }
      await repository.updateProjectData(updatedProject);

      // Mark section as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('employment', WizardSectionStatus.complete());

      if (mounted) {
        setState(() => _isSaving = false);
      }

      return true;
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context).failedToSave}: $e'),
          ),
        );
      }
      return false;
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
            FilledButton(onPressed: _loadData, child: Text(l10n.retry)),
          ],
        ),
      );
    }

    if (_individuals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(l10n.noIndividualsFound, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              l10n.pleaseAddIndividuals,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
            Text(l10n.employmentIncome, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              l10n.employmentSectionDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Individual income fields
            Expanded(
              child: ListView.separated(
                itemCount: _individuals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final individual = _individuals[index];
                  final controller = _incomeControllers[individual.id]!;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  individual.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller,
                            enabled: !_isSaving,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: l10n.annualEmploymentIncome,
                              hintText: l10n.enterAnnualSalary,
                              prefixIcon: const Icon(Icons.attach_money),
                              suffixText: l10n.cadPerYear,
                              border: const OutlineInputBorder(),
                              helperText: l10n.leaveEmptyIfNotEmployed,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null; // Optional field
                              }
                              final income = double.tryParse(value);
                              if (income == null) {
                                return l10n.pleaseEnterValidNumber;
                              }
                              if (income < 0) {
                                return l10n.incomeCannotBeNegative;
                              }
                              if (income > 1000000) {
                                return l10n.pleaseEnterRealisticIncome;
                              }
                              return null;
                            },
                          ),
                          if (controller.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      l10n.incomeUsedUntilRetirement,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Info text
            Text(
              l10n.clickNextOrSkipEmployment,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),

            if (_isSaving) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }
}
