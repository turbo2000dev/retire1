import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/projection/domain/yearly_projection.dart';

part 'projection.freezed.dart';
part 'projection.g.dart';

/// Complete projection for a scenario over the planning period
@freezed
class Projection with _$Projection {
  const factory Projection({
    /// ID of the scenario this projection is for
    required String scenarioId,

    /// ID of the project this projection belongs to
    required String projectId,

    /// Start year of the projection
    required int startYear,

    /// End year of the projection
    required int endYear,

    /// Whether projection is in current or constant dollars
    required bool useConstantDollars,

    /// Assumed inflation rate (as decimal, e.g., 0.02 for 2%)
    required double inflationRate,

    /// Yearly projections from start to end
    required List<YearlyProjection> years,

    /// When this projection was calculated
    required DateTime calculatedAt,
  }) = _Projection;

  factory Projection.fromJson(Map<String, dynamic> json) =>
      _$ProjectionFromJson(json);
}
