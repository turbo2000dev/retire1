import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';

part 'scenario.freezed.dart';
part 'scenario.g.dart';

/// A scenario represents a set of assumptions for retirement planning
/// The base scenario uses actual project values
/// Variation scenarios override specific parameters to explore "what-if" situations
@freezed
class Scenario with _$Scenario {
  const factory Scenario({
    required String id,
    required String name,
    required bool isBase,
    @Default([]) List<ParameterOverride> overrides,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);
}
