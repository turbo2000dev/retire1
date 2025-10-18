import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retire1/features/expenses/domain/expense.dart';

/// Repository for managing expenses in Firestore
class ExpenseRepository {
  final FirebaseFirestore _firestore;
  final String projectId;

  ExpenseRepository({required this.projectId, FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get the expenses collection reference
  CollectionReference<Map<String, dynamic>> get _expensesCollection {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('expenses');
  }

  /// Create a new expense
  Future<void> createExpense(Expense expense) async {
    try {
      final expenseJson = expense.toJson();

      // Manually serialize the timing fields since Freezed doesn't do it automatically for nested unions
      final startTiming = expense.when(
        housing: (_, startTiming, __, ___) => startTiming,
        transport: (_, startTiming, __, ___) => startTiming,
        dailyLiving: (_, startTiming, __, ___) => startTiming,
        recreation: (_, startTiming, __, ___) => startTiming,
        health: (_, startTiming, __, ___) => startTiming,
        family: (_, startTiming, __, ___) => startTiming,
      );

      final endTiming = expense.when(
        housing: (_, __, endTiming, ___) => endTiming,
        transport: (_, __, endTiming, ___) => endTiming,
        dailyLiving: (_, __, endTiming, ___) => endTiming,
        recreation: (_, __, endTiming, ___) => endTiming,
        health: (_, __, endTiming, ___) => endTiming,
        family: (_, __, endTiming, ___) => endTiming,
      );

      expenseJson['startTiming'] = startTiming.toJson();
      expenseJson['endTiming'] = endTiming.toJson();

      await _expensesCollection.doc(expense.id).set(expenseJson);
      log('Expense created: ${expense.id}');
    } catch (e) {
      log('Error creating expense: $e');
      rethrow;
    }
  }

  /// Get a stream of all expenses for this project
  Stream<List<Expense>> getExpensesStream() {
    try {
      return _expensesCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            return Expense.fromJson(data);
          } catch (e) {
            log('Error parsing expense ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      log('Error getting expenses stream: $e');
      rethrow;
    }
  }

  /// Update an existing expense
  Future<void> updateExpense(Expense expense) async {
    try {
      final expenseJson = expense.toJson();

      // Manually serialize the timing fields since Freezed doesn't do it automatically for nested unions
      final startTiming = expense.when(
        housing: (_, startTiming, __, ___) => startTiming,
        transport: (_, startTiming, __, ___) => startTiming,
        dailyLiving: (_, startTiming, __, ___) => startTiming,
        recreation: (_, startTiming, __, ___) => startTiming,
        health: (_, startTiming, __, ___) => startTiming,
        family: (_, startTiming, __, ___) => startTiming,
      );

      final endTiming = expense.when(
        housing: (_, __, endTiming, ___) => endTiming,
        transport: (_, __, endTiming, ___) => endTiming,
        dailyLiving: (_, __, endTiming, ___) => endTiming,
        recreation: (_, __, endTiming, ___) => endTiming,
        health: (_, __, endTiming, ___) => endTiming,
        family: (_, __, endTiming, ___) => endTiming,
      );

      expenseJson['startTiming'] = startTiming.toJson();
      expenseJson['endTiming'] = endTiming.toJson();

      await _expensesCollection.doc(expense.id).update(expenseJson);
      log('Expense updated: ${expense.id}');
    } catch (e) {
      log('Error updating expense: $e');
      rethrow;
    }
  }

  /// Delete an expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      await _expensesCollection.doc(expenseId).delete();
      log('Expense deleted: $expenseId');
    } catch (e) {
      log('Error deleting expense: $e');
      rethrow;
    }
  }

  /// Get a single expense by ID
  Future<Expense?> getExpense(String expenseId) async {
    try {
      final doc = await _expensesCollection.doc(expenseId).get();
      if (!doc.exists) {
        return null;
      }
      return Expense.fromJson(doc.data()!);
    } catch (e) {
      log('Error getting expense: $e');
      rethrow;
    }
  }
}
