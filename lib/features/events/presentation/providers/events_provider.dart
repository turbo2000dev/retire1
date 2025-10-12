import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/events/domain/event.dart';

/// Provider for managing events (Phase 15: Mock data only)
/// Will be replaced with Firebase integration in Phase 16
class EventsNotifier extends Notifier<List<Event>> {
  @override
  List<Event> build() {
    // Return empty list initially
    return [];
  }

  /// Add a new event
  void addEvent(Event event) {
    state = [...state, event];
  }

  /// Update an existing event
  void updateEvent(Event event) {
    final eventId = event.map(
      retirement: (e) => e.id,
      death: (e) => e.id,
      realEstateTransaction: (e) => e.id,
    );

    state = [
      for (final e in state)
        if (_getEventId(e) == eventId) event else e,
    ];
  }

  /// Delete an event by ID
  void deleteEvent(String eventId) {
    state = state.where((e) => _getEventId(e) != eventId).toList();
  }

  String _getEventId(Event event) {
    return event.map(
      retirement: (e) => e.id,
      death: (e) => e.id,
      realEstateTransaction: (e) => e.id,
    );
  }
}

/// Main events provider
final eventsProvider = NotifierProvider<EventsNotifier, List<Event>>(
  () => EventsNotifier(),
);

/// Provider that sorts events chronologically
/// Note: This is a simplified sort that only handles relative timing
/// In a real implementation, we'd need to resolve all timings to actual years
final sortedEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);

  // Create a copy and sort
  final sortedEvents = [...events];
  sortedEvents.sort((a, b) {
    // Extract timing from each event
    final aTiming = a.map(
      retirement: (e) => e.timing,
      death: (e) => e.timing,
      realEstateTransaction: (e) => e.timing,
    );
    final bTiming = b.map(
      retirement: (e) => e.timing,
      death: (e) => e.timing,
      realEstateTransaction: (e) => e.timing,
    );

    // Compare timings (simplified - only handles relative timing)
    return aTiming.map(
      relative: (at) => bTiming.map(
        relative: (bt) => at.yearsFromStart.compareTo(bt.yearsFromStart),
        absolute: (bt) => -1, // Relative before absolute (simplified)
        age: (bt) => -1, // Relative before age (simplified)
      ),
      absolute: (at) => bTiming.map(
        relative: (bt) => 1, // Absolute after relative (simplified)
        absolute: (bt) => at.calendarYear.compareTo(bt.calendarYear),
        age: (bt) => -1, // Absolute before age (simplified)
      ),
      age: (at) => bTiming.map(
        relative: (bt) => 1, // Age after relative (simplified)
        absolute: (bt) => 1, // Age after absolute (simplified)
        age: (bt) => at.age.compareTo(bt.age),
      ),
    );
  });

  return sortedEvents;
});
