import 'package:cloud_firestore/cloud_firestore.dart';
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
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    required DateTime createdAt,
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
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

/// Custom DateTime serialization that handles both Timestamp and String
DateTime _dateTimeFromJson(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is String) {
    return DateTime.parse(value);
  } else if (value is DateTime) {
    return value;
  }
  throw ArgumentError('Cannot convert $value to DateTime');
}

/// Custom DateTime deserialization - return as DateTime for repository to convert
dynamic _dateTimeToJson(DateTime dateTime) => dateTime;
