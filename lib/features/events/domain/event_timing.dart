import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_timing.freezed.dart';
part 'event_timing.g.dart';

/// Event boundary type for event-relative timing
enum EventBoundary { start, end }

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

  /// Event-relative timing - tied to the start or end of another event
  const factory EventTiming.eventRelative({
    required String eventId,
    required EventBoundary boundary, // start or end of the event
  }) = EventRelativeTiming;

  factory EventTiming.fromJson(Map<String, dynamic> json) =>
      _$EventTimingFromJson(json);
}
