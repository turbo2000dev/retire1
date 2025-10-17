import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_state.dart';

/// Step 2: Select revenue sources for each individual
class WizardRevenueSourcesStep extends ConsumerStatefulWidget {
  const WizardRevenueSourcesStep({super.key});

  @override
  ConsumerState<WizardRevenueSourcesStep> createState() =>
      _WizardRevenueSourcesStepState();
}

class _WizardRevenueSourcesStepState
    extends ConsumerState<WizardRevenueSourcesStep> {
  // Individual 1 revenue sources
  bool _ind1RRQ = true; // Default checked (universal Quebec program)
  bool _ind1PSV = true; // Default checked (universal Quebec program)
  bool _ind1RRPE = false;
  bool _ind1Employment = false;
  bool _ind1Other = false;

  // Individual 2 revenue sources
  bool _ind2RRQ = true;
  bool _ind2PSV = true;
  bool _ind2RRPE = false;
  bool _ind2Employment = false;
  bool _ind2Other = false;

  // RRQ details - Individual 1
  final _ind1RrqStartAgeController = TextEditingController(text: '65');
  final _ind1RrqAmountAt60Controller = TextEditingController(text: '12000');
  final _ind1RrqAmountAt65Controller = TextEditingController(text: '16000');

  // PSV details - Individual 1
  final _ind1PsvStartAgeController = TextEditingController(text: '65');

  // RRQ details - Individual 2
  final _ind2RrqStartAgeController = TextEditingController(text: '65');
  final _ind2RrqAmountAt60Controller = TextEditingController(text: '12000');
  final _ind2RrqAmountAt65Controller = TextEditingController(text: '16000');

  // PSV details - Individual 2
  final _ind2PsvStartAgeController = TextEditingController(text: '65');

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _ind1RrqStartAgeController.dispose();
    _ind1RrqAmountAt60Controller.dispose();
    _ind1RrqAmountAt65Controller.dispose();
    _ind1PsvStartAgeController.dispose();
    _ind2RrqStartAgeController.dispose();
    _ind2RrqAmountAt60Controller.dispose();
    _ind2RrqAmountAt65Controller.dispose();
    _ind2PsvStartAgeController.dispose();
    super.dispose();
  }

  void _loadExistingData() {
    final wizardState = ref.read(wizardProvider);
    if (wizardState == null) return;

    final data = wizardState.revenueSources;

    // Load Individual 1 selections
    _ind1RRQ = data.individual1HasRrq;
    _ind1PSV = data.individual1HasPsv;
    _ind1RRPE = data.individual1HasRrpe;
    _ind1Employment = data.individual1HasEmployment;
    _ind1Other = data.individual1HasOther;

    // Load Individual 2 selections
    _ind2RRQ = data.individual2HasRrq;
    _ind2PSV = data.individual2HasPsv;
    _ind2RRPE = data.individual2HasRrpe;
    _ind2Employment = data.individual2HasEmployment;
    _ind2Other = data.individual2HasOther;

    // Load RRQ details
    _ind1RrqStartAgeController.text = data.individual1RrqStartAge.toString();
    _ind1RrqAmountAt60Controller.text = data.individual1RrqAmountAt60.toStringAsFixed(0);
    _ind1RrqAmountAt65Controller.text = data.individual1RrqAmountAt65.toStringAsFixed(0);

    _ind2RrqStartAgeController.text = data.individual2RrqStartAge.toString();
    _ind2RrqAmountAt60Controller.text = data.individual2RrqAmountAt60.toStringAsFixed(0);
    _ind2RrqAmountAt65Controller.text = data.individual2RrqAmountAt65.toStringAsFixed(0);

    // Load PSV details
    _ind1PsvStartAgeController.text = data.individual1PsvStartAge.toString();
    _ind2PsvStartAgeController.text = data.individual2PsvStartAge.toString();
  }

  void _saveData() {
    final data = WizardRevenueSourcesData(
      // Individual 1 selections
      individual1HasRrq: _ind1RRQ,
      individual1HasPsv: _ind1PSV,
      individual1HasRrpe: _ind1RRPE,
      individual1HasEmployment: _ind1Employment,
      individual1HasOther: _ind1Other,

      // Individual 2 selections
      individual2HasRrq: _ind2RRQ,
      individual2HasPsv: _ind2PSV,
      individual2HasRrpe: _ind2RRPE,
      individual2HasEmployment: _ind2Employment,
      individual2HasOther: _ind2Other,

      // RRQ details - Individual 1
      individual1RrqStartAge: int.tryParse(_ind1RrqStartAgeController.text) ?? 65,
      individual1RrqAmountAt60: double.tryParse(_ind1RrqAmountAt60Controller.text) ?? 12000.0,
      individual1RrqAmountAt65: double.tryParse(_ind1RrqAmountAt65Controller.text) ?? 16000.0,

      // PSV details - Individual 1
      individual1PsvStartAge: int.tryParse(_ind1PsvStartAgeController.text) ?? 65,

      // RRQ details - Individual 2
      individual2RrqStartAge: int.tryParse(_ind2RrqStartAgeController.text) ?? 65,
      individual2RrqAmountAt60: double.tryParse(_ind2RrqAmountAt60Controller.text) ?? 12000.0,
      individual2RrqAmountAt65: double.tryParse(_ind2RrqAmountAt65Controller.text) ?? 16000.0,

      // PSV details - Individual 2
      individual2PsvStartAge: int.tryParse(_ind2PsvStartAgeController.text) ?? 65,
    );

    ref.read(wizardProvider.notifier).updateRevenueSources(data);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = ref.watch(wizardProvider);

    if (wizardState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final hasIndividual2 = wizardState.individual2 != null;

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.isPhone ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brief step description
              Text(
                'Select the revenue sources that apply to each individual',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Layout: stacked on phone, side-by-side on tablet/desktop
              if (screenSize.isPhone)
                ..._buildStackedLayout(theme, wizardState)
              else
                _buildSideBySideLayout(theme, wizardState, hasIndividual2),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildStackedLayout(ThemeData theme, wizardState) {
    final hasIndividual2 = wizardState.individual2 != null;

    return [
      _buildIndividual1Card(theme, wizardState),
      if (hasIndividual2) ...[
        const SizedBox(height: 24),
        _buildIndividual2Card(theme, wizardState),
      ],
    ];
  }

  Widget _buildSideBySideLayout(
    ThemeData theme,
    wizardState,
    bool hasIndividual2,
  ) {
    if (!hasIndividual2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildIndividual1Card(theme, wizardState)),
          const Expanded(child: SizedBox.shrink()),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildIndividual1Card(theme, wizardState)),
        const SizedBox(width: 24),
        Expanded(child: _buildIndividual2Card(theme, wizardState)),
      ],
    );
  }

  Widget _buildIndividual1Card(ThemeData theme, wizardState) {
    final individual = wizardState.individual1;
    if (individual == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    individual.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildRevenueSourceCheckboxes(
              theme: theme,
              rrq: _ind1RRQ,
              psv: _ind1PSV,
              rrpe: _ind1RRPE,
              employment: _ind1Employment,
              other: _ind1Other,
              isIndividual1: true,
              onRRQChanged: (value) {
                setState(() => _ind1RRQ = value ?? false);
                _saveData();
              },
              onPSVChanged: (value) {
                setState(() => _ind1PSV = value ?? false);
                _saveData();
              },
              onRRPEChanged: (value) {
                setState(() => _ind1RRPE = value ?? false);
                _saveData();
              },
              onEmploymentChanged: (value) {
                setState(() => _ind1Employment = value ?? false);
                _saveData();
              },
              onOtherChanged: (value) {
                setState(() => _ind1Other = value ?? false);
                _saveData();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividual2Card(ThemeData theme, wizardState) {
    final individual = wizardState.individual2;
    if (individual == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people_outline, color: theme.colorScheme.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    individual.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildRevenueSourceCheckboxes(
              theme: theme,
              rrq: _ind2RRQ,
              psv: _ind2PSV,
              rrpe: _ind2RRPE,
              employment: _ind2Employment,
              other: _ind2Other,
              isIndividual1: false,
              onRRQChanged: (value) {
                setState(() => _ind2RRQ = value ?? false);
                _saveData();
              },
              onPSVChanged: (value) {
                setState(() => _ind2PSV = value ?? false);
                _saveData();
              },
              onRRPEChanged: (value) {
                setState(() => _ind2RRPE = value ?? false);
                _saveData();
              },
              onEmploymentChanged: (value) {
                setState(() => _ind2Employment = value ?? false);
                _saveData();
              },
              onOtherChanged: (value) {
                setState(() => _ind2Other = value ?? false);
                _saveData();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRevenueSourceCheckboxes({
    required ThemeData theme,
    required bool rrq,
    required bool psv,
    required bool rrpe,
    required bool employment,
    required bool other,
    required ValueChanged<bool?> onRRQChanged,
    required ValueChanged<bool?> onPSVChanged,
    required ValueChanged<bool?> onRRPEChanged,
    required ValueChanged<bool?> onEmploymentChanged,
    required ValueChanged<bool?> onOtherChanged,
    required bool isIndividual1,
  }) {
    return [
      // RRQ with details
      _buildCheckboxTile(
        theme: theme,
        value: rrq,
        title: 'RRQ (Régime de rentes du Québec)',
        description: 'Quebec pension plan',
        onChanged: onRRQChanged,
      ),
      if (rrq) ..._buildRRQDetailFields(theme, isIndividual1),
      const SizedBox(height: 8),

      // PSV with details
      _buildCheckboxTile(
        theme: theme,
        value: psv,
        title: 'PSV (Pension de la sécurité de la vieillesse)',
        description: 'Old Age Security pension',
        onChanged: onPSVChanged,
      ),
      if (psv) ..._buildPSVDetailFields(theme, isIndividual1),
      const SizedBox(height: 8),

      // RRPE
      _buildCheckboxTile(
        theme: theme,
        value: rrpe,
        title: 'RRPE (Régime de retraite du personnel d\'encadrement)',
        description: 'Management pension plan',
        onChanged: onRRPEChanged,
      ),
      const SizedBox(height: 8),

      // Employment
      _buildCheckboxTile(
        theme: theme,
        value: employment,
        title: 'Employment Income',
        description: 'Salary or wages',
        onChanged: onEmploymentChanged,
      ),
      const SizedBox(height: 8),

      // Other
      _buildCheckboxTile(
        theme: theme,
        value: other,
        title: 'Other Income',
        description: 'Additional revenue sources',
        onChanged: onOtherChanged,
      ),
    ];
  }

  List<Widget> _buildRRQDetailFields(ThemeData theme, bool isIndividual1) {
    final startAgeController = isIndividual1
        ? _ind1RrqStartAgeController
        : _ind2RrqStartAgeController;
    final amountAt60Controller = isIndividual1
        ? _ind1RrqAmountAt60Controller
        : _ind2RrqAmountAt60Controller;
    final amountAt65Controller = isIndividual1
        ? _ind1RrqAmountAt65Controller
        : _ind2RrqAmountAt65Controller;

    return [
      Padding(
        padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: startAgeController,
                    decoration: const InputDecoration(
                      labelText: 'Start Age',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => _saveData(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: amountAt60Controller,
                    decoration: const InputDecoration(
                      labelText: 'Amount at 60',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ],
                    onChanged: (_) => _saveData(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: amountAt65Controller,
                    decoration: const InputDecoration(
                      labelText: 'Amount at 65',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ],
                    onChanged: (_) => _saveData(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildPSVDetailFields(ThemeData theme, bool isIndividual1) {
    final startAgeController = isIndividual1
        ? _ind1PsvStartAgeController
        : _ind2PsvStartAgeController;

    return [
      Padding(
        padding: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: startAgeController,
                decoration: const InputDecoration(
                  labelText: 'Start Age',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => _saveData(),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox.shrink()),
          ],
        ),
      ),
    ];
  }

  Widget _buildCheckboxTile({
    required ThemeData theme,
    required bool value,
    required String title,
    required String description,
    required ValueChanged<bool?> onChanged,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        description,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
