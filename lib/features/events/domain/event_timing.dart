import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_timing.freezed.dart';
part 'event_timing.g.dart';

/// Event timing types using Freezed unions
@freezed
class EventTiming with _$EventTiming {
  /// Relative timing - years from start of projection
  const factory EventTiming.relative({
    required int yearsFromStart,
  }) = RelativeTiming;

  /// Absolute timing - specific calendar year
  const factory EventTiming.absolute({
    required int calendarYear,
  }) = AbsoluteTiming;

  /// Age-based timing - when an individual reaches a specific age
  const factory EventTiming.age({
    required String individualId,
    required int age,
  }) = AgeTiming;

  factory EventTiming.fromJson(Map<String, dynamic> json) =>
      _$EventTimingFromJson(json);
}
