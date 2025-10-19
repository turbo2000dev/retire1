import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:uuid/uuid.dart';

/// Retirement section - Set retirement age for each individual
class RetirementSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const RetirementSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<RetirementSectionScreen> createState() =>
      _RetirementSectionScreenState();
}

class _RetirementSectionScreenState
    extends ConsumerState<RetirementSectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  List<Individual> _individuals = [];
  List<Event> _existingEvents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
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

      // Load existing events
      final eventsAsync = ref.read(eventsProvider);
      await eventsAsync.when(
        data: (events) async {
          _existingEvents = events;
        },
        loading: () async {
          _existingEvents = [];
        },
        error: (e, s) => throw e,
      );

      // Initialize controllers for each individual
      for (var individual in _individuals) {
        final existingRetirement = _getRetirementEventForIndividual(
          individual.id,
        );
        final retirementAge = existingRetirement != null
            ? _getAgeFromTiming(existingRetirement.timing, individual.id)
            : 65; // Default retirement age

        _controllers[individual.id] = TextEditingController(
          text: retirementAge?.toString() ?? '65',
        );
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
                'retirement-timing',
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

  Event? _getRetirementEventForIndividual(String individualId) {
    try {
      return _existingEvents.firstWhere(
        (event) => event.map(
          retirement: (e) => e.individualId == individualId,
          death: (_) => false,
          realEstateTransaction: (_) => false,
        ),
      );
    } catch (e) {
      return null; // No retirement event found
    }
  }

  int? _getAgeFromTiming(EventTiming timing, String individualId) {
    return timing.map(
      relative: (_) => null,
      absolute: (_) => null,
      age: (t) => t.individualId == individualId ? t.age : null,
      eventRelative: (_) => null,
      projectionEnd: (_) => null,
    );
  }

  Future<bool> _validateAndContinue() async {
    if (_isSaving) return false;

    if (!_formKey.currentState!.validate()) {
      return false;
    }

    setState(() => _isSaving = true);

    try {
      final uuid = const Uuid();
      final notifier = ref.read(eventsProvider.notifier);

      // Create or update retirement events for each individual
      for (var individual in _individuals) {
        final controller = _controllers[individual.id]!;
        final ageText = controller.text.trim();

        if (ageText.isEmpty) {
          // Skip if no retirement age specified
          continue;
        }

        final age = int.parse(ageText);
        final timing = EventTiming.age(individualId: individual.id, age: age);
        final existingRetirement = _getRetirementEventForIndividual(
          individual.id,
        );

        if (existingRetirement != null) {
          // Update existing retirement event
          final updatedEvent = Event.retirement(
            id: existingRetirement.id,
            individualId: individual.id,
            timing: timing,
          );
          await notifier.updateEvent(updatedEvent);
        } else {
          // Create new retirement event
          final newEvent = Event.retirement(
            id: uuid.v4(),
            individualId: individual.id,
            timing: timing,
          );
          await notifier.addEvent(newEvent);
        }
      }

      // Mark section as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus(
            'retirement-timing',
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
            Text('Retirement Planning', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Set the retirement age for each individual. This will affect income calculations and tax planning.',
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
                  final controller = _controllers[individual.id]!;
                  final currentAge = individual.age;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.beach_access,
                                  color: theme.colorScheme.primary,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      individual.name,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Current age: $currentAge',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'Retirement Age',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: controller,
                            enabled: !_isSaving,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: InputDecoration(
                              labelText: 'Age',
                              hintText: '55-75',
                              helperText: 'Typical retirement age is 60-67',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.cake),
                              suffixText: 'years',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a retirement age';
                              }
                              final age = int.tryParse(value);
                              if (age == null) {
                                return 'Please enter a valid number';
                              }
                              if (age < currentAge) {
                                return 'Retirement age must be at least $currentAge';
                              }
                              if (age < 55 || age > 75) {
                                return 'Age must be between 55 and 75';
                              }
                              return null;
                            },
                          ),

                          // Info about years to retirement
                          const SizedBox(height: 12),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: controller,
                            builder: (context, value, child) {
                              final retirementAge = int.tryParse(value.text);
                              if (retirementAge == null || value.text.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final yearsToRetirement =
                                  retirementAge - currentAge;

                              String displayText;
                              if (yearsToRetirement > 0) {
                                displayText =
                                    '$yearsToRetirement years until retirement';
                              } else if (yearsToRetirement == 0) {
                                displayText = 'Retiring this year';
                              } else {
                                displayText = '-';
                              }

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: theme.colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        displayText,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSecondaryContainer,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                    Icons.lightbulb_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Consider coordinating retirement ages for couples to maximize benefits and tax efficiency.',
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
