import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_progress_provider.dart';

/// Summary section - Review wizard configuration and complete setup
class SummarySectionScreen extends ConsumerStatefulWidget {
  final void Function(Future<bool> Function()?)? onRegisterCallback;

  const SummarySectionScreen({super.key, this.onRegisterCallback});

  @override
  ConsumerState<SummarySectionScreen> createState() =>
      _SummarySectionScreenState();
}

class _SummarySectionScreenState extends ConsumerState<SummarySectionScreen> {
  bool _isLoading = true;
  bool _isCompleting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Just mark as in progress - data will be loaded via providers
      widget.onRegisterCallback?.call(_completeWizard);

      if (mounted) {
        setState(() => _isLoading = false);

        // Mark section as in progress
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(wizardProgressProvider.notifier)
              .updateSectionStatus('summary', WizardSectionStatus.inProgress());
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

  Future<bool> _completeWizard() async {
    if (_isCompleting) return false;

    setState(() => _isCompleting = true);

    try {
      // Mark wizard as complete
      await ref
          .read(wizardProgressProvider.notifier)
          .updateSectionStatus('summary', WizardSectionStatus.complete());

      if (mounted) {
        setState(() => _isCompleting = false);
      }

      return true;
    } catch (e) {
      if (mounted) {
        setState(() => _isCompleting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to complete: $e')));
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

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

    final currentProjectState = ref.watch(currentProjectProvider);
    final assetsAsync = ref.watch(assetsProvider);
    final eventsAsync = ref.watch(eventsProvider);
    final expensesAsync = ref.watch(expensesProvider);

    if (currentProjectState is! ProjectSelected) {
      return Center(
        child: Text('No project selected', style: theme.textTheme.bodyLarge),
      );
    }

    final project = currentProjectState.project;

    return ResponsiveContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary & Review', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Review your retirement planning configuration. You can modify any section later from the main dashboard.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 32),

          Expanded(
            child: ListView(
              children: [
                // Project Info
                _buildSummaryCard(
                  theme: theme,
                  icon: Icons.folder,
                  iconColor: theme.colorScheme.primary,
                  title: 'Project',
                  children: [
                    _buildInfoRow('Name', project.name, theme),
                    _buildInfoRow(
                      'Individuals',
                      project.individuals.map((i) => i.name).join(', '),
                      theme,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Assets Summary
                assetsAsync.when(
                  data: (assets) {
                    final totalValue = assets.fold<double>(
                      0,
                      (sum, asset) =>
                          sum +
                          asset.map(
                            realEstate: (a) => a.value,
                            rrsp: (a) => a.value,
                            celi: (a) => a.value,
                            cri: (a) => a.value,
                            cash: (a) => a.value,
                          ),
                    );
                    return _buildSummaryCard(
                      theme: theme,
                      icon: Icons.account_balance,
                      iconColor: Colors.green,
                      title: 'Assets',
                      children: [
                        _buildInfoRow(
                          'Total Assets',
                          '${assets.length} accounts',
                          theme,
                        ),
                        _buildInfoRow(
                          'Total Value',
                          currencyFormat.format(totalValue),
                          theme,
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingCard(theme, 'Assets'),
                  error: (_, __) => _buildErrorCard(theme, 'Assets'),
                ),
                const SizedBox(height: 16),

                // Expenses Summary
                expensesAsync.when(
                  data: (expenses) {
                    final totalAnnual = expenses.fold<double>(
                      0,
                      (sum, expense) => sum + expense.annualAmount,
                    );
                    return _buildSummaryCard(
                      theme: theme,
                      icon: Icons.shopping_cart,
                      iconColor: Colors.orange,
                      title: 'Annual Expenses',
                      children: [
                        _buildInfoRow(
                          'Categories',
                          '${expenses.length} configured',
                          theme,
                        ),
                        _buildInfoRow(
                          'Total Annual',
                          currencyFormat.format(totalAnnual),
                          theme,
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingCard(theme, 'Expenses'),
                  error: (_, __) => _buildErrorCard(theme, 'Expenses'),
                ),
                const SizedBox(height: 16),

                // Events Summary
                eventsAsync.when(
                  data: (events) {
                    final retirements = events.where(
                      (e) => e.map(
                        retirement: (_) => true,
                        death: (_) => false,
                        realEstateTransaction: (_) => false,
                      ),
                    );
                    final deaths = events.where(
                      (e) => e.map(
                        retirement: (_) => false,
                        death: (_) => true,
                        realEstateTransaction: (_) => false,
                      ),
                    );

                    return _buildSummaryCard(
                      theme: theme,
                      icon: Icons.event,
                      iconColor: Colors.purple,
                      title: 'Life Events',
                      children: [
                        _buildInfoRow(
                          'Retirement',
                          '${retirements.length} configured',
                          theme,
                        ),
                        _buildInfoRow(
                          'Life Planning',
                          '${deaths.length} configured',
                          theme,
                        ),
                      ],
                    );
                  },
                  loading: () => _buildLoadingCard(theme, 'Events'),
                  error: (_, __) => _buildErrorCard(theme, 'Events'),
                ),
                const SizedBox(height: 32),

                // Completion message
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.3,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ready to Complete',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'ve configured the essential elements for your retirement plan. Click Complete to finish the wizard and access your full retirement dashboard.',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (_isCompleting) ...[
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required ThemeData theme,
    required IconData icon,
    required Color iconColor,
    required String title,
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(ThemeData theme, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('Loading $title...', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(ThemeData theme, String title) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Text(
              'Error loading $title',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
