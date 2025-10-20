import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations.dart';
import 'package:retire1/core/ui/responsive/responsive_container.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/assets/presentation/providers/assets_provider.dart';
import 'package:retire1/features/assets/presentation/widgets/add_asset_dialog.dart';
import 'package:retire1/features/assets/presentation/widgets/asset_card.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/presentation/providers/events_provider.dart';
import 'package:retire1/features/events/presentation/widgets/add_event_dialog.dart';
import 'package:retire1/features/events/presentation/widgets/event_card.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/expenses/presentation/providers/expenses_provider.dart';
import 'package:retire1/features/expenses/presentation/widgets/add_expense_dialog.dart';
import 'package:retire1/features/expenses/presentation/widgets/expense_card.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';

/// Assets & Events screen - manages assets and life events
/// Phase 13-15: Assets and Events UI with mock/Firebase data
class AssetsEventsScreen extends ConsumerStatefulWidget {
  const AssetsEventsScreen({super.key});

  @override
  ConsumerState<AssetsEventsScreen> createState() => _AssetsEventsScreenState();
}

class _AssetsEventsScreenState extends ConsumerState<AssetsEventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Listen to tab changes to update FAB label
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _addAsset(BuildContext context, WidgetRef ref) async {
    bool createAnother = true;

    while (createAnother) {
      if (!context.mounted) break;

      final result = await AddAssetDialog.show(context);

      if (result == null) {
        // User cancelled
        break;
      }

      if (!context.mounted) break;

      try {
        await ref.read(assetsProvider.notifier).addAsset(result.asset);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).assetCreated)),
          );
        }

        // Check if user wants to create another
        createAnother = result.createAnother;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToCreateAsset}: $e',
              ),
            ),
          );
        }
        // Break on error
        break;
      }
    }
  }

  Future<void> _editAsset(
    BuildContext context,
    WidgetRef ref,
    Asset asset,
  ) async {
    final result = await AddAssetDialog.show(context, asset: asset);
    if (result != null && context.mounted) {
      try {
        await ref.read(assetsProvider.notifier).updateAsset(result.asset);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).assetUpdated)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToUpdateAsset}: $e',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteAsset(
    BuildContext context,
    WidgetRef ref,
    Asset asset,
  ) async {
    final assetId = asset.map(
      realEstate: (a) => a.id,
      rrsp: (a) => a.id,
      celi: (a) => a.id,
      cri: (a) => a.id,
      cash: (a) => a.id,
    );

    final assetName = asset.map(
      realEstate: (a) => 'this property',
      rrsp: (a) => 'this RRSP account',
      celi: (a) => 'this CELI account',
      cri: (a) => 'this CRI/FRV account',
      cash: (a) => 'this cash account',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete $assetName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(assetsProvider.notifier).deleteAsset(assetId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).assetDeleted)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToDeleteAsset}: $e',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _addEvent(BuildContext context, WidgetRef ref) async {
    bool createAnother = true;

    while (createAnother) {
      if (!context.mounted) break;

      final projectState = ref.read(currentProjectProvider);
      final individuals = switch (projectState) {
        ProjectSelected(project: final project) => project.individuals,
        _ => <Individual>[],
      };
      final assetsAsync = ref.read(assetsProvider);
      final assets = assetsAsync.maybeWhen(
        data: (assets) => assets,
        orElse: () => <Asset>[],
      );

      final result = await AddEventDialog.show(
        context,
        individuals: individuals,
        assets: assets,
      );

      if (result == null) {
        // User cancelled
        break;
      }

      if (!context.mounted) break;

      try {
        await ref.read(eventsProvider.notifier).addEvent(result.event);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).eventCreated)),
          );
        }

        // Check if user wants to create another
        createAnother = result.createAnother;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToCreateEvent}: $e',
              ),
            ),
          );
        }
        // Break on error
        break;
      }
    }
  }

  Future<void> _editEvent(
    BuildContext context,
    WidgetRef ref,
    Event event,
  ) async {
    final projectState = ref.read(currentProjectProvider);
    final individuals = switch (projectState) {
      ProjectSelected(project: final project) => project.individuals,
      _ => <Individual>[],
    };
    final assetsAsync = ref.read(assetsProvider);
    final assets = assetsAsync.maybeWhen(
      data: (assets) => assets,
      orElse: () => <Asset>[],
    );

    final result = await AddEventDialog.show(
      context,
      event: event,
      individuals: individuals,
      assets: assets,
    );

    if (result != null && context.mounted) {
      try {
        await ref.read(eventsProvider.notifier).updateEvent(result.event);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).eventUpdated)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToUpdateEvent}: $e',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _deleteEvent(
    BuildContext context,
    WidgetRef ref,
    Event event,
  ) async {
    final eventId = event.when(
      retirement: (id, _, __) => id,
      death: (id, _, __) => id,
      realEstateTransaction: (id, _, __, ___, ____, _____) => id,
    );

    final eventName = event.when(
      retirement: (_, __, ___) => 'this retirement event',
      death: (_, __, ___) => 'this death event',
      realEstateTransaction: (_, __, ___, ____, _____, ______) =>
          'this real estate transaction',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete $eventName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(eventsProvider.notifier).deleteEvent(eventId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).eventDeleted)),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).failedToDeleteEvent}: $e',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _addExpense(BuildContext context, WidgetRef ref) async {
    bool createAnother = true;

    while (createAnother) {
      if (!context.mounted) break;

      final projectState = ref.read(currentProjectProvider);
      final individuals = switch (projectState) {
        ProjectSelected(project: final project) => project.individuals,
        _ => <Individual>[],
      };
      final eventsAsync = ref.read(sortedEventsProvider);
      final events = eventsAsync.maybeWhen(
        data: (events) => events,
        orElse: () => <Event>[],
      );

      final result = await AddExpenseDialog.show(
        context,
        individuals: individuals,
        events: events,
      );

      if (result == null) {
        // User cancelled
        break;
      }

      if (!context.mounted) break;

      try {
        await ref.read(expensesProvider.notifier).addExpense(result.expense);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense added successfully')),
          );
        }

        // Check if user wants to create another
        createAnother = result.createAnother;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to add expense: $e')));
        }
        // Break on error
        break;
      }
    }
  }

  Future<void> _editExpense(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final projectState = ref.read(currentProjectProvider);
    final individuals = switch (projectState) {
      ProjectSelected(project: final project) => project.individuals,
      _ => <Individual>[],
    };
    final eventsAsync = ref.read(sortedEventsProvider);
    final events = eventsAsync.maybeWhen(
      data: (events) => events,
      orElse: () => <Event>[],
    );

    final result = await AddExpenseDialog.show(
      context,
      expense: expense,
      individuals: individuals,
      events: events,
    );

    if (result != null && context.mounted) {
      try {
        await ref.read(expensesProvider.notifier).updateExpense(result.expense);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense updated successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update expense: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteExpense(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final expenseId = expense.when(
      housing: (id, _, __, ___) => id,
      transport: (id, _, __, ___) => id,
      dailyLiving: (id, _, __, ___) => id,
      recreation: (id, _, __, ___) => id,
      health: (id, _, __, ___) => id,
      family: (id, _, __, ___) => id,
    );

    final expenseName = '${expense.categoryName} expense';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete this $expenseName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref.read(expensesProvider.notifier).deleteExpense(expenseId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete expense: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final assetsAsync = ref.watch(assetsProvider);
    final assetsByType = ref.watch(assetsByTypeProvider);
    final eventsAsync = ref.watch(sortedEventsProvider);
    final expensesAsync = ref.watch(expensesProvider);
    final expensesByCategory = ref.watch(expensesByCategoryProvider);
    final projectState = ref.watch(currentProjectProvider);
    final individuals = switch (projectState) {
      ProjectSelected(project: final project) => project.individuals,
      _ => <Individual>[],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets & Events'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Assets', icon: Icon(Icons.account_balance_wallet)),
            Tab(text: 'Events', icon: Icon(Icons.event)),
            Tab(text: 'Expenses', icon: Icon(Icons.receipt_long)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Assets tab
          assetsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load assets',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => ref.invalidate(assetsProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (assets) => CustomScrollView(
              slivers: [
                // Assets grouped by type
                ...assetsByType.entries.map((entry) {
                  final typeName = entry.key;
                  final assets = entry.value;

                  return SliverToBoxAdapter(
                    child: ResponsiveContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Section header
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  Text(
                                    typeName,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '${assets.length}',
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Asset cards
                            if (assets.isEmpty)
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Center(
                                    child: Text(
                                      'No ${typeName.toLowerCase()} assets yet',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...assets.map((asset) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AssetCard(
                                    asset: asset,
                                    onEdit: () =>
                                        _editAsset(context, ref, asset),
                                    onDelete: () =>
                                        _deleteAsset(context, ref, asset),
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          // Events tab
          eventsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load events',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => ref.invalidate(eventsProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (events) => CustomScrollView(
              slivers: [
                // Events timeline
                SliverToBoxAdapter(
                  child: ResponsiveContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Timeline',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Events sorted chronologically',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (events.isEmpty)
                  SliverToBoxAdapter(
                    child: ResponsiveContainer(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(48),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.event_busy,
                                    size: 64,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No events yet',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Add your first event to get started',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  ...events.map((event) {
                    return SliverToBoxAdapter(
                      child: ResponsiveContainer(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 4,
                          ),
                          child: EventCard(
                            event: event,
                            individuals: individuals,
                            onEdit: () => _editEvent(context, ref, event),
                            onDelete: () => _deleteEvent(context, ref, event),
                          ),
                        ),
                      ),
                    );
                  }),
                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
          // Expenses tab
          expensesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: ResponsiveContainer(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load expenses',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => ref.invalidate(expensesProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            data: (expenses) => expenses.isEmpty
                ? Center(
                    child: ResponsiveContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 64,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No expenses yet',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add your first expense to get started',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : CustomScrollView(
                    slivers: [
                      // Expenses grouped by category
                      ...expensesByCategory.entries.map((entry) {
                        final categoryName = entry.key;
                        final categoryExpenses = entry.value;

                        return SliverToBoxAdapter(
                          child: ResponsiveContainer(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category header
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          categoryName,
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme
                                                .colorScheme
                                                .primaryContainer,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            '${categoryExpenses.length}',
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onPrimaryContainer,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Expense cards
                                  ...categoryExpenses.map((expense) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: ExpenseCard(
                                        expense: expense,
                                        individuals: individuals,
                                        onEdit: () =>
                                            _editExpense(context, ref, expense),
                                        onDelete: () => _deleteExpense(
                                          context,
                                          ref,
                                          expense,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      // Bottom padding
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _addAsset(context, ref);
          } else if (_tabController.index == 1) {
            _addEvent(context, ref);
          } else {
            _addExpense(context, ref);
          }
        },
        icon: const Icon(Icons.add),
        label: Text(
          _tabController.index == 0
              ? AppLocalizations.of(context).addAsset
              : _tabController.index == 1
              ? AppLocalizations.of(context).addEvent
              : l10n.add,
        ),
      ),
    );
  }
}
