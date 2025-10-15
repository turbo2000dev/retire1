import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'individual.freezed.dart';
part 'individual.g.dart';

/// Represents an individual in a retirement planning project
@freezed
class Individual with _$Individual {
  const Individual._();

  const factory Individual({
    required String id,
    required String name,
    @JsonKey(
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
    )
    required DateTime birthdate,
    @Default(0.0) double employmentIncome, // Annual salary
    @Default(65) int rrqStartAge, // RRQ start age (60-70)
    @Default(65) int psvStartAge, // PSV start age (65-70, OAS age)
    @Default(16000.0) double rrqAnnualBenefit, // Expected annual RRQ benefit at 65 (deprecated, kept for backward compatibility)
    @Default(12000.0) double projectedRrqAt60, // Projected annual RRQ benefit if starting at age 60
    @Default(16000.0) double projectedRrqAt65, // Projected annual RRQ benefit if starting at age 65
    @Default(0.0) double initialCeliRoom, // Initial CELI contribution room available
  }) = _Individual;

  factory Individual.fromJson(Map<String, dynamic> json) =>
      _$IndividualFromJson(json);

  /// Calculate age from birthdate
  int get age {
    final today = DateTime.now();
    int age = today.year - birthdate.year;
    if (today.month < birthdate.month ||
        (today.month == birthdate.month && today.day < birthdate.day)) {
      age--;
    }
    return age;
  }
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
