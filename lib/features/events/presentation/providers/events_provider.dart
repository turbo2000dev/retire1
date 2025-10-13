import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/events/data/event_repository.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/project/presentation/providers/current_project_provider.dart';

/// Repository provider that creates EventRepository based on current project
final eventRepositoryProvider = Provider<EventRepository?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  final projectState = ref.watch(currentProjectProvider);

  if (authState is! Authenticated) {
    return null;
  }

  if (projectState is! ProjectSelected) {
    return null;
  }

  return EventRepository(projectId: projectState.project.id);
});

/// Provider for managing events with Firestore integration
class EventsNotifier extends AsyncNotifier<List<Event>> {
  StreamSubscription<List<Event>>? _subscription;

  @override
  Future<List<Event>> build() async {
    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      _subscription?.cancel();
    });

    final repository = ref.watch(eventRepositoryProvider);
    if (repository == null) {
      return [];
    }

    // Subscribe to Firestore stream
    final completer = Completer<List<Event>>();
    _subscription = repository.getEventsStream().listen(
      (events) {
        if (!completer.isCompleted) {
          completer.complete(events);
        }
        state = AsyncValue.data(events);
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
        state = AsyncValue.error(error, StackTrace.current);
      },
    );

    return completer.future;
  }

  /// Add a new event
  Future<void> addEvent(Event event) async {
    final repository = ref.read(eventRepositoryProvider);
    if (repository == null) {
      log('Cannot add event: repository is null');
      return;
    }

    try {
      await repository.createEvent(event);
      log('Event added successfully');
    } catch (e) {
      log('Error adding event: $e');
      rethrow;
    }
  }

  /// Update an existing event
  Future<void> updateEvent(Event event) async {
    final repository = ref.read(eventRepositoryProvider);
    if (repository == null) {
      log('Cannot update event: repository is null');
      return;
    }

    try {
      await repository.updateEvent(event);
      log('Event updated successfully');
    } catch (e) {
      log('Error updating event: $e');
      rethrow;
    }
  }

  /// Delete an event by ID
  Future<void> deleteEvent(String eventId) async {
    final repository = ref.read(eventRepositoryProvider);
    if (repository == null) {
      log('Cannot delete event: repository is null');
      return;
    }

    try {
      await repository.deleteEvent(eventId);
      log('Event deleted successfully');
    } catch (e) {
      log('Error deleting event: $e');
      rethrow;
    }
  }
}

/// Main events provider
final eventsProvider = AsyncNotifierProvider<EventsNotifier, List<Event>>(
  () => EventsNotifier(),
);

/// Provider that sorts events chronologically
/// Note: This is a simplified sort that only handles relative timing
/// In a real implementation, we'd need to resolve all timings to actual years
final sortedEventsProvider = Provider<AsyncValue<List<Event>>>((ref) {
  final eventsAsync = ref.watch(eventsProvider);

  return eventsAsync.whenData((events) {
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
          eventRelative: (bt) => -1, // Relative before event-relative (simplified)
          projectionEnd: (bt) => -1, // Relative before projection end
        ),
        absolute: (at) => bTiming.map(
          relative: (bt) => 1, // Absolute after relative (simplified)
          absolute: (bt) => at.calendarYear.compareTo(bt.calendarYear),
          age: (bt) => -1, // Absolute before age (simplified)
          eventRelative: (bt) => -1, // Absolute before event-relative (simplified)
          projectionEnd: (bt) => -1, // Absolute before projection end
        ),
        age: (at) => bTiming.map(
          relative: (bt) => 1, // Age after relative (simplified)
          absolute: (bt) => 1, // Age after absolute (simplified)
          age: (bt) => at.age.compareTo(bt.age),
          eventRelative: (bt) => -1, // Age before event-relative (simplified)
          projectionEnd: (bt) => -1, // Age before projection end
        ),
        eventRelative: (at) => bTiming.map(
          relative: (bt) => 1, // Event-relative after relative (simplified)
          absolute: (bt) => 1, // Event-relative after absolute (simplified)
          age: (bt) => 1, // Event-relative after age (simplified)
          eventRelative: (bt) => 0, // Event-relative equal to event-relative (simplified)
          projectionEnd: (bt) => -1, // Event-relative before projection end
        ),
        projectionEnd: (at) => bTiming.map(
          relative: (bt) => 1, // Projection end after relative
          absolute: (bt) => 1, // Projection end after absolute
          age: (bt) => 1, // Projection end after age
          eventRelative: (bt) => 1, // Projection end after event-relative
          projectionEnd: (bt) => 0, // Projection end equal to projection end
        ),
      );
    });

    return sortedEvents;
  });
});
