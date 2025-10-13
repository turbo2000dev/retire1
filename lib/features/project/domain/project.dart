import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/project/domain/individual.dart';

part 'project.freezed.dart';
part 'project.g.dart';

/// Project domain model
/// Represents a retirement planning project
@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String ownerId,
    String? description,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<Individual> individuals,
    // Economic assumptions (rates in decimal form, e.g., 0.02 = 2%)
    @Default(0.02) double inflationRate,
    @Default(0.05) double reerReturnRate,
    @Default(0.05) double celiReturnRate,
    @Default(0.05) double criReturnRate,
    @Default(0.015) double cashReturnRate,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
