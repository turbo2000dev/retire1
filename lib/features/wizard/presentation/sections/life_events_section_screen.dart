import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';
import 'package:uuid/uuid.dart';

/// Life Events section - Configure expected lifespan for planning purposes
class LifeEventsSectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const LifeEventsSectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<LifeEventsSectionScreen> createState() =>
      _LifeEventsSectionScreenState();
}

class _LifeEventsSectionScreenState
    extends ConsumerState<LifeEventsSectionScreen> {
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
        throw Exception(AppLocalizations.of(context).noProjectSelected);
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
        final existingDeath = _getDeathEventForIndividual(individual.id);
        final deathAge = existingDeath != null
            ? _getAgeFromTiming(existingDeath.timing, individual.id)
            : 85; // Default expected lifespan

        _controllers[individual.id] = TextEditingController(
          text: deathAge?.toString() ?? '85',
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
                'life-events',
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

  Event? _getDeathEventForIndividual(String individualId) {
    try {
      return _existingEvents.firstWhere(
        (event) => event.map(
          retirement: (_) => false,
          death: (e) => e.individualId == individualId,
          realEstateTransaction: (_) => false,
        ),
      );
    } catch (e) {
      return null; // No death event found
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

      // Create or update death events for each individual
      for (var individual in _individuals) {
        final controller = _controllers[individual.id]!;
        final ageText = controller.text.trim();

        if (ageText.isEmpty) {
          // Skip if no age specified
          continue;
        }

        final age = int.parse(ageText);
        final timing = EventTiming.age(individualId: individual.id, age: age);
        final existingDeath = _getDeathEventForIndividual(individual.id);

        if (existingDeath != null) {
          // Update existing death event
          final updatedEvent = Event.death(
            id: existingDeath.id,
            individualId: individual.id,
            timing: timing,
          );
          await notifier.updateEvent(updatedEvent);
        } else {
          // Create new death event
          final newEvent = Event.death(
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
          .updateSectionStatus('life-events', WizardSectionStatus.complete());

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
            Text(l10n.lifePlanning, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Set expected lifespan for financial planning. This helps project when resources will be needed.',
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
                                  color: theme.colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.favorite,
                                  color: theme.colorScheme.secondary,
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
                            'Expected Lifespan',
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
                              hintText: l10n.lifeExpectancyHint,
                              helperText: 'Average life expectancy: 80-85',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.timeline),
                              suffixText: 'years',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an age';
                              }
                              final age = int.tryParse(value);
                              if (age == null) {
                                return 'Please enter a valid number';
                              }
                              if (age <= currentAge) {
                                return 'Must be greater than current age ($currentAge)';
                              }
                              if (age < 75 || age > 120) {
                                return 'Age must be between 75 and 120';
                              }
                              return null;
                            },
                          ),

                          // Info about planning horizon
                          const SizedBox(height: 12),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: controller,
                            builder: (context, value, child) {
                              final lifespan = int.tryParse(value.text);
                              if (lifespan == null || value.text.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final yearsRemaining = lifespan - currentAge;

                              String displayText;
                              if (yearsRemaining > 0) {
                                displayText =
                                    'Planning horizon: $yearsRemaining years';
                              } else {
                                displayText = '-';
                              }

                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryContainer
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 20,
                                      color: theme.colorScheme.tertiary,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        displayText,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onTertiaryContainer,
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
                      'Note: This is for planning purposes only. It helps estimate how long retirement savings need to last.',
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
