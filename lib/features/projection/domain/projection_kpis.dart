import 'package:freezed_annotation/freezed_annotation.dart';

part 'projection_kpis.freezed.dart';
part 'projection_kpis.g.dart';

/// Key Performance Indicators for a projection
///
/// These metrics provide a quick summary of the projection's outcomes.
@freezed
class ProjectionKpis with _$ProjectionKpis {
  const factory ProjectionKpis({
    /// Year when money runs out (null if never runs out)
    int? yearMoneyRunsOut,

    /// Lowest net worth throughout the projection
    required double lowestNetWorth,

    /// Year when lowest net worth occurs
    required int yearOfLowestNetWorth,

    /// Final net worth at end of projection
    required double finalNetWorth,

    /// Total taxes paid across all years
    required double totalTaxesPaid,

    /// Total withdrawals across all years
    required double totalWithdrawals,

    /// Average effective tax rate (total tax / total income)
    required double averageTaxRate,
  }) = _ProjectionKpis;

  factory ProjectionKpis.fromJson(Map<String, dynamic> json) =>
      _$ProjectionKpisFromJson(json);
}
