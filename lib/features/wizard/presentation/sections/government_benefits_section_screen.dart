import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Government Benefits section - Configure QPP/RRQ and OAS/PSV start ages
class GovernmentBenefitsSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const GovernmentBenefitsSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<GovernmentBenefitsSectionScreen> createState() =>
      _GovernmentBenefitsSectionScreenState();
}

class _GovernmentBenefitsSectionScreenState
    extends ConsumerState<GovernmentBenefitsSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, Map<String, TextEditingController>> _controllers = {};
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
    for (var controllerMap in _controllers.values) {
      for (var controller in controllerMap.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception('No project selected');
      }

      final project = currentProjectState.project;
      _individuals = project.individuals;

      // Initialize controllers for each individual
      for (var individual in _individuals) {
        _controllers[individual.id] = {
          'rrqAge': TextEditingController(
            text: individual.rrqStartAge.toString(),
          ),
          'psvAge': TextEditingController(
            text: individual.psvStartAge.toString(),
          ),
          'rrqAt60': TextEditingController(
            text: individual.projectedRrqAt60.toStringAsFixed(0),
          ),
          'rrqAt65': TextEditingController(
            text: individual.projectedRrqAt65.toStringAsFixed(0),
          ),
        };
      }

      // Register validation callback
      widget.onRegisterCallback?.call(_validateAndContinue);

      if (mounted) {
        setState(() => _isLoading = false);

        // Mark section as in progress
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus(
                'government-benefits',
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

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    setState(() => _isSaving = true);

    try {
      final currentProjectState = ref.read(currentProjectProvider);
      if (currentProjectState is! ProjectSelected) {
        throw Exception('No project selected');
      }

      final project = currentProjectState.project;

      // Update individuals with benefit settings
      final updatedIndividuals = _individuals.map((individual) {
        final controllers = _controllers[individual.id]!;
        return individual.copyWith(
          rrqStartAge: int.parse(controllers['rrqAge']!.text),
          psvStartAge: int.parse(controllers['psvAge']!.text),
          projectedRrqAt60: double.parse(controllers['rrqAt60']!.text),
          projectedRrqAt65: double.parse(controllers['rrqAt65']!.text),
        );
      }).toList();

      // Update project
      final updatedProject = project.copyWith(individuals: updatedIndividuals);

      final repository = ref.read(projectRepositoryProvider);
      if (repository == null) {
        throw Exception('Repository not available');
      }
      await repository.updateProjectData(updatedProject);

      // Mark section as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus(
            'government-benefits',
            WizardSectionStatus.complete(),
          );

      if (mounted) {
        setState(() => _isSaving = false);
      }

      return true;
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_errorMessage',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_individuals.isEmpty) {
      return Center(
        child: Text(
          'No individuals found. Please add individuals first.',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return ResponsiveContainer(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Government Benefits', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Configure when each individual will start receiving QPP/RRQ and OAS/PSV benefits.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),

            Expanded(
              child: ListView.separated(
                itemCount: _individuals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final individual = _individuals[index];
                  final controllers = _controllers[individual.id]!;
                  final currentAge = individual.age;

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
                              Text(
                                'Age: $currentAge',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // QPP/RRQ Start Age
                          Text(
                            'QPP/RRQ Start Age',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controllers['rrqAge'],
                            enabled: !_isSaving,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              hintText: '60-70',
                              helperText: 'Age 60 (reduced) to 70 (increased)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an age';
                              }
                              final age = int.tryParse(value);
                              if (age == null) {
                                return 'Please enter a valid number';
                              }
                              if (age < 60 || age > 70) {
                                return 'Age must be between 60 and 70';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // OAS/PSV Start Age
                          Text(
                            'OAS/PSV Start Age',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controllers['psvAge'],
                            enabled: !_isSaving,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              hintText: '65-70',
                              helperText: 'Age 65 (standard) to 70 (increased)',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an age';
                              }
                              final age = int.tryParse(value);
                              if (age == null) {
                                return 'Please enter a valid number';
                              }
                              if (age < 65 || age > 70) {
                                return 'Age must be between 65 and 70';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Projected QPP amounts
                          Text(
                            'Projected QPP/RRQ Amounts (Annual)',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: controllers['rrqAt60'],
                                  enabled: !_isSaving,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'At age 60',
                                    prefixText: '\$ ',
                                    helperText: 'Reduced amount',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null || amount < 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: controllers['rrqAt65'],
                                  enabled: !_isSaving,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'At age 65',
                                    prefixText: '\$ ',
                                    helperText: 'Full amount',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    final amount = double.tryParse(value);
                                    if (amount == null || amount < 0) {
                                      return 'Invalid';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Help text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.3,
                ),
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
                      'Tip: Starting QPP earlier (age 60) reduces monthly amount by ~36%. Starting later (age 70) increases it by ~42%.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
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
