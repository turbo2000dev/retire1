import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/events/domain/event_timing.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// Represents a recurring expense category with start and end timing
@freezed
class Expense with _$Expense {
  /// Housing expenses (mortgage, rent, property tax, utilities, maintenance)
  const factory Expense.housing({
    required String id,
    required EventTiming startTiming,
    EventTiming? endTiming, // null = no end date, continues forever
    required double annualAmount,
  }) = HousingExpense;

  /// Transport expenses (car payments, gas, insurance, maintenance, public transit)
  const factory Expense.transport({
    required String id,
    required EventTiming startTiming,
    EventTiming? endTiming,
    required double annualAmount,
  }) = TransportExpense;

  /// Daily living expenses (groceries, clothing, personal care)
  const factory Expense.dailyLiving({
    required String id,
    required EventTiming startTiming,
    EventTiming? endTiming,
    required double annualAmount,
  }) = DailyLivingExpense;

  /// Recreation expenses (entertainment, hobbies, dining out, travel)
  const factory Expense.recreation({
    required String id,
    required EventTiming startTiming,
    EventTiming? endTiming,
    required double annualAmount,
  }) = RecreationExpense;

  /// Health expenses (insurance premiums, medical costs, prescriptions)
  const factory Expense.health({
    required String id,
    required EventTiming startTiming,
    EventTiming? endTiming,
    required double annualAmount,
  }) = HealthExpense;

  /// Family expenses (childcare, education, support for family members)
  const factory Expense.family({
    required String id,
    required EventTiming startTiming,
    EventTiming? endTiming,
    required double annualAmount,
  }) = FamilyExpense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}

/// Extension to get expense category name
extension ExpenseCategory on Expense {
  String get categoryName => when(
        housing: (_, __, ___, ____) => 'Housing',
        transport: (_, __, ___, ____) => 'Transport',
        dailyLiving: (_, __, ___, ____) => 'Daily Living',
        recreation: (_, __, ___, ____) => 'Recreation',
        health: (_, __, ___, ____) => 'Health',
        family: (_, __, ___, ____) => 'Family',
      );
}
