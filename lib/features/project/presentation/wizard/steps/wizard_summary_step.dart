import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_state.dart';

/// Step 6: Summary and review before final commitment
class WizardSummaryStep extends ConsumerWidget {
  const WizardSummaryStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final wizardState = ref.watch(wizardProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final dateFormat = DateFormat.yMMMd();

    if (wizardState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.isPhone ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brief step description
              Text(
                'Review your retirement plan setup',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can edit any section later from the main screens',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Individuals Summary
              _buildSummaryCard(
                theme: theme,
                title: 'Individuals',
                icon: Icons.people_outline,
                iconColor: theme.colorScheme.primary,
                onEdit: () => ref.read(wizardProvider.notifier).goToStep(0),
                children: [
                  if (wizardState.individual1 != null)
                    _buildIndividualSummary(
                      theme,
                      dateFormat,
                      wizardState.individual1!,
                      'Individual 1',
                    ),
                  if (wizardState.individual2 != null) ...[
                    const Divider(height: 24),
                    _buildIndividualSummary(
                      theme,
                      dateFormat,
                      wizardState.individual2!,
                      'Partner/Spouse',
                    ),
                  ],
                  if (wizardState.individual1 == null &&
                      wizardState.individual2 == null)
                    _buildEmptyState(theme, 'No individuals added'),
                ],
              ),
              const SizedBox(height: 16),

              // Revenue Sources Summary
              _buildSummaryCard(
                theme: theme,
                title: 'Revenue Sources',
                icon: Icons.account_balance_wallet_outlined,
                iconColor: Colors.green,
                onEdit: () => ref.read(wizardProvider.notifier).goToStep(1),
                children: [
                  _buildRevenueSourcesSummary(theme, wizardState),
                ],
              ),
              const SizedBox(height: 16),

              // Assets Summary
              _buildSummaryCard(
                theme: theme,
                title: 'Assets',
                icon: Icons.account_balance_outlined,
                iconColor: Colors.blue,
                onEdit: () => ref.read(wizardProvider.notifier).goToStep(2),
                children: [
                  _buildAssetsSummary(theme, currencyFormat, wizardState),
                ],
              ),
              const SizedBox(height: 16),

              // Expenses Summary
              _buildSummaryCard(
                theme: theme,
                title: 'Expenses',
                icon: Icons.shopping_cart_outlined,
                iconColor: Colors.orange,
                onEdit: () => ref.read(wizardProvider.notifier).goToStep(3),
                children: [
                  _buildExpensesSummary(theme, currencyFormat, wizardState),
                ],
              ),
              const SizedBox(height: 16),

              // Scenarios Summary
              _buildSummaryCard(
                theme: theme,
                title: 'Scenarios',
                icon: Icons.assessment_outlined,
                iconColor: Colors.purple,
                onEdit: () => ref.read(wizardProvider.notifier).goToStep(4),
                children: [
                  _buildScenariosSummary(theme, wizardState),
                ],
              ),
              const SizedBox(height: 24),

              // Ready to complete message
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ready to create your project!',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Click "Complete Setup" below to finalize your retirement plan',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
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
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualSummary(
    ThemeData theme,
    DateFormat dateFormat,
    individual,
    String label,
  ) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    final age = DateTime.now().year - individual.birthdate.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(theme, 'Name', individual.name),
        _buildInfoRow(
          theme,
          'Birthdate',
          '${dateFormat.format(individual.birthdate)} (Age $age)',
        ),
        _buildInfoRow(
          theme,
          'Employment Income',
          currencyFormat.format(individual.employmentIncome),
        ),
      ],
    );
  }

  Widget _buildRevenueSourcesSummary(ThemeData theme, wizardState) {
    final revSources = wizardState.revenueSources;
    final ind1 = wizardState.individual1;
    final ind2 = wizardState.individual2;

    final ind1Sources = <String>[];
    if (revSources.individual1HasRrq) ind1Sources.add('RRQ');
    if (revSources.individual1HasPsv) ind1Sources.add('PSV');
    if (revSources.individual1HasRrpe) ind1Sources.add('RRPE');
    if (revSources.individual1HasEmployment) ind1Sources.add('Employment');
    if (revSources.individual1HasOther) ind1Sources.add('Other');

    final ind2Sources = <String>[];
    if (ind2 != null) {
      if (revSources.individual2HasRrq) ind2Sources.add('RRQ');
      if (revSources.individual2HasPsv) ind2Sources.add('PSV');
      if (revSources.individual2HasRrpe) ind2Sources.add('RRPE');
      if (revSources.individual2HasEmployment) ind2Sources.add('Employment');
      if (revSources.individual2HasOther) ind2Sources.add('Other');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ind1 != null) ...[
          Text(
            ind1.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          if (ind1Sources.isEmpty)
            _buildInfoRow(theme, 'Sources', 'None selected')
          else
            _buildInfoRow(theme, 'Sources', ind1Sources.join(', ')),
        ],
        if (ind2 != null) ...[
          const Divider(height: 24),
          Text(
            ind2.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          if (ind2Sources.isEmpty)
            _buildInfoRow(theme, 'Sources', 'None selected')
          else
            _buildInfoRow(theme, 'Sources', ind2Sources.join(', ')),
        ],
      ],
    );
  }

  Widget _buildAssetsSummary(
    ThemeData theme,
    NumberFormat currencyFormat,
    wizardState,
  ) {
    final assets = wizardState.assets;

    if (assets.isEmpty) {
      return _buildEmptyState(theme, 'No assets added');
    }

    final realEstate = assets.whereType<WizardRealEstateData>().toList();
    final rrsps = assets.whereType<WizardRrspData>().toList();
    final celis = assets.whereType<WizardCeliData>().toList();
    final cris = assets.whereType<WizardCriData>().toList();
    final cash = assets.whereType<WizardCashData>().toList();

    final totalValue = assets.fold<double>(
      0,
      (sum, asset) => sum + asset.map(
        realEstate: (a) => a.value,
        rrsp: (a) => a.value,
        celi: (a) => a.value,
        cri: (a) => a.value,
        cash: (a) => a.value,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (realEstate.isNotEmpty)
          _buildInfoRow(theme, 'Real Estate', '1 property'),
        if (rrsps.isNotEmpty)
          _buildInfoRow(theme, 'RRSP Accounts', '${rrsps.length}'),
        if (celis.isNotEmpty)
          _buildInfoRow(theme, 'CELI Accounts', '${celis.length}'),
        if (cris.isNotEmpty)
          _buildInfoRow(theme, 'CRI Accounts', '${cris.length}'),
        if (cash.isNotEmpty)
          _buildInfoRow(theme, 'Cash Accounts', '${cash.length}'),
        const Divider(height: 16),
        _buildInfoRow(
          theme,
          'Total Asset Value',
          currencyFormat.format(totalValue),
          bold: true,
        ),
      ],
    );
  }

  Widget _buildExpensesSummary(
    ThemeData theme,
    NumberFormat currencyFormat,
    wizardState,
  ) {
    final expenses = wizardState.expenses;
    final total = expenses.housingAmount +
        expenses.transportAmount +
        expenses.dailyLivingAmount +
        expenses.recreationAmount +
        expenses.healthAmount +
        expenses.familyAmount;

    String timingText = 'Now (projection start)'; // Default
    switch (expenses.startTiming) {
      case ExpenseStartTiming.now:
        timingText = 'Now (projection start)';
        break;
      case ExpenseStartTiming.atRetirement:
        timingText = 'At retirement';
        break;
      case ExpenseStartTiming.custom:
        timingText = 'Custom year: ${expenses.customStartYear ?? "N/A"}';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          theme,
          'Total Annual',
          currencyFormat.format(total),
          bold: true,
        ),
        _buildInfoRow(theme, 'Start Timing', timingText),
        if (total > 0) ...[
          const Divider(height: 16),
          Text(
            'Breakdown:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          if (expenses.housingAmount > 0)
            _buildInfoRow(
              theme,
              '  Housing',
              currencyFormat.format(expenses.housingAmount),
            ),
          if (expenses.transportAmount > 0)
            _buildInfoRow(
              theme,
              '  Transport',
              currencyFormat.format(expenses.transportAmount),
            ),
          if (expenses.dailyLivingAmount > 0)
            _buildInfoRow(
              theme,
              '  Daily Living',
              currencyFormat.format(expenses.dailyLivingAmount),
            ),
          if (expenses.recreationAmount > 0)
            _buildInfoRow(
              theme,
              '  Recreation',
              currencyFormat.format(expenses.recreationAmount),
            ),
          if (expenses.healthAmount > 0)
            _buildInfoRow(
              theme,
              '  Health',
              currencyFormat.format(expenses.healthAmount),
            ),
          if (expenses.familyAmount > 0)
            _buildInfoRow(
              theme,
              '  Family',
              currencyFormat.format(expenses.familyAmount),
            ),
        ],
      ],
    );
  }

  Widget _buildScenariosSummary(ThemeData theme, wizardState) {
    final scenarios = wizardState.scenarios;
    final scenariosList = <String>['Base (required)'];

    if (scenarios.createOptimistic) scenariosList.add('Optimistic');
    if (scenarios.createPessimistic) scenariosList.add('Pessimistic');
    if (scenarios.createEarlyRetirement) scenariosList.add('Early Retirement');
    if (scenarios.createLateRetirement) scenariosList.add('Late Retirement');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          theme,
          'Scenarios to create',
          '${scenariosList.length}',
          bold: true,
        ),
        const SizedBox(height: 8),
        ...scenariosList.map((name) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
