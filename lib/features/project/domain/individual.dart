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
    required DateTime birthdate,
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
