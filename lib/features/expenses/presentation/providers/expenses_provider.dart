import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/expenses/data/expense_repository.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';

/// Repository provider that creates ExpenseRepository based on current project
final expenseRepositoryProvider = Provider<ExpenseRepository?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final projectState = ref.watch(currentProjectProvider);

  if (authState is! Authenticated) {
    return null;
  }

  if (projectState is! ProjectSelected) {
    return null;
  }

  return ExpenseRepository(projectId: projectState.project.id);
});

/// Provider for managing expenses with Firestore integration
class ExpensesNotifier extends AsyncNotifier<List<Expense>> {
  StreamSubscription<List<Expense>>? _subscription;

  @override
  Future<List<Expense>> build() async {
    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    final repository = ref.watch(expenseRepositoryProvider);
    if (repository == null) {
      return [];
    }

    // Subscribe to Firestore stream
    final completer = Completer<List<Expense>>();
    _subscription = repository.getExpensesStream().listen(
      (expenses) {
        if (!completer.isCompleted) {
          completer.complete(expenses);
        }
        state = AsyncValue.data(expenses);
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
        state = AsyncValue.error(error, StackTrace.current);
      },
    );

    return completer.future;
  }

  /// Add a new expense
  Future<void> addExpense(Expense expense) async {
    final repository = ref.read(expenseRepositoryProvider);
    if (repository == null) {
      log('Cannot add expense: repository is null');
      return;
    }

    try {
      await repository.createExpense(expense);
      log('Expense added successfully');
    } catch (e) {
      log('Error adding expense: $e');
      rethrow;
    }
  }

  /// Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    final repository = ref.read(expenseRepositoryProvider);
    if (repository == null) {
      log('Cannot update expense: repository is null');
      return;
    }

    try {
      await repository.updateExpense(expense);
      log('Expense updated successfully');
    } catch (e) {
      log('Error updating expense: $e');
      rethrow;
    }
  }

  /// Delete an expense by ID
  Future<void> deleteExpense(String expenseId) async {
    final repository = ref.read(expenseRepositoryProvider);
    if (repository == null) {
      log('Cannot delete expense: repository is null');
      return;
    }

    try {
      await repository.deleteExpense(expenseId);
      log('Expense deleted successfully');
    } catch (e) {
      log('Error deleting expense: $e');
      rethrow;
    }
  }
}

/// Main expenses provider
final expensesProvider = AsyncNotifierProvider<ExpensesNotifier, List<Expense>>(
  () => ExpensesNotifier(),
);

/// Provider for expenses grouped by category
final expensesByCategoryProvider = Provider<Map<String, List<Expense>>>((ref) {
  final expensesAsync = ref.watch(expensesProvider);

  return expensesAsync.when(
    data: (expenses) {
      final Map<String, List<Expense>> grouped = {
        'Housing': [],
        'Transport': [],
        'Daily Living': [],
        'Recreation': [],
        'Health': [],
        'Family': [],
      };

      for (final expense in expenses) {
        grouped[expense.categoryName]!.add(expense);
      }

      // Remove empty categories
      grouped.removeWhere((key, value) => value.isEmpty);

      return grouped;
    },
    loading: () => {},
    error: (_, __) => {},
  );
});
