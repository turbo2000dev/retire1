import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/expenses/domain/expense.dart';

/// Mock in-memory expenses provider for Checkpoint 2
/// Will be replaced with Firestore integration in Checkpoint 3
class ExpensesNotifier extends StateNotifier<AsyncValue<List<Expense>>> {
  ExpensesNotifier() : super(const AsyncValue.data([]));

  /// Add a new expense
  Future<void> addExpense(Expense expense) async {
    state.whenData((expenses) {
      state = AsyncValue.data([...expenses, expense]);
    });
  }

  /// Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    state.whenData((expenses) {
      final index = expenses.indexWhere((e) {
        final expenseId = expense.when(
          housing: (id, _, __, ___) => id,
          transport: (id, _, __, ___) => id,
          dailyLiving: (id, _, __, ___) => id,
          recreation: (id, _, __, ___) => id,
          health: (id, _, __, ___) => id,
          family: (id, _, __, ___) => id,
        );

        final currentId = e.when(
          housing: (id, _, __, ___) => id,
          transport: (id, _, __, ___) => id,
          dailyLiving: (id, _, __, ___) => id,
          recreation: (id, _, __, ___) => id,
          health: (id, _, __, ___) => id,
          family: (id, _, __, ___) => id,
        );

        return currentId == expenseId;
      });

      if (index != -1) {
        final updatedExpenses = [...expenses];
        updatedExpenses[index] = expense;
        state = AsyncValue.data(updatedExpenses);
      }
    });
  }

  /// Delete an expense by ID
  Future<void> deleteExpense(String id) async {
    state.whenData((expenses) {
      final filtered = expenses.where((e) {
        final currentId = e.when(
          housing: (id, _, __, ___) => id,
          transport: (id, _, __, ___) => id,
          dailyLiving: (id, _, __, ___) => id,
          recreation: (id, _, __, ___) => id,
          health: (id, _, __, ___) => id,
          family: (id, _, __, ___) => id,
        );
        return currentId != id;
      }).toList();

      state = AsyncValue.data(filtered);
    });
  }
}

/// Provider for expenses
final expensesProvider = StateNotifierProvider<ExpensesNotifier, AsyncValue<List<Expense>>>((ref) {
  return ExpensesNotifier();
});

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
