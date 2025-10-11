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
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
