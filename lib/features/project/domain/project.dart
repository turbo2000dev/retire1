import 'package:freezed_annotation/freezed_annotation.dart';

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
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
