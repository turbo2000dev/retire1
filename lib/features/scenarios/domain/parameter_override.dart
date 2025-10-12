import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory ParameterOverride.fromJson(Map<String, dynamic> json) =>
      _$ParameterOverrideFromJson(json);
}
