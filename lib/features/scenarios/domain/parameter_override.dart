import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/events/domain/event_timing.dart';

part 'parameter_override.freezed.dart';
part 'parameter_override.g.dart';

/// Parameter overrides for scenario variations
/// Uses Freezed unions to support different override types
@freezed
class ParameterOverride with _$ParameterOverride {
  /// Override an asset value
  const factory ParameterOverride.assetValue({
    required String assetId,
    required double value,
  }) = AssetValueOverride;

  /// Override event timing
  const factory ParameterOverride.eventTiming({
    required String eventId,
    required int yearsFromStart, // Simplified to just relative timing for now
  }) = EventTimingOverride;

  /// Override expense amount (absolute or multiplier)
  /// Only one of overrideAmount or amountMultiplier should be set
  const factory ParameterOverride.expenseAmount({
    required String expenseId,
    double? overrideAmount, // Absolute amount (e.g., $25,000)
    double? amountMultiplier, // Multiplier (e.g., 1.5 = 150%, 0.0 = eliminate)
  }) = ExpenseAmountOverride;

  /// Override expense timing (start and/or end)
  const factory ParameterOverride.expenseTiming({
    required String expenseId,
    EventTiming? overrideStartTiming,
    EventTiming? overrideEndTiming,
  }) = ExpenseTimingOverride;

  factory ParameterOverride.fromJson(Map<String, dynamic> json) =>
      _$ParameterOverrideFromJson(json);
}
