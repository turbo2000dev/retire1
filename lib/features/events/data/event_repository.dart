import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retire1/features/events/domain/event.dart';

/// Repository for managing events in Firestore
class EventRepository {
  final FirebaseFirestore _firestore;
  final String projectId;

  EventRepository({required this.projectId, FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get the events collection reference
  CollectionReference<Map<String, dynamic>> get _eventsCollection {
    return _firestore
        .collection('projects')
        .doc(projectId)
        .collection('events');
  }

  /// Create a new event
  Future<void> createEvent(Event event) async {
    try {
      final eventJson = event.toJson();
      // Manually serialize the timing field since Freezed doesn't do it automatically for nested unions
      final timing = event.map(
        retirement: (e) => e.timing,
        death: (e) => e.timing,
        realEstateTransaction: (e) => e.timing,
      );
      eventJson['timing'] = timing.toJson();

      await _eventsCollection.doc(event.id).set(eventJson);
      log('Event created: ${event.id}');
    } catch (e) {
      log('Error creating event: $e');
      rethrow;
    }
  }

  /// Get a stream of all events for this project
  Stream<List<Event>> getEventsStream() {
    try {
      return _eventsCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            final data = doc.data();
            return Event.fromJson(data);
          } catch (e) {
            log('Error parsing event ${doc.id}: $e');
            rethrow;
          }
        }).toList();
      });
    } catch (e) {
      log('Error getting events stream: $e');
      rethrow;
    }
  }

  /// Update an existing event
  Future<void> updateEvent(Event event) async {
    try {
      final eventJson = event.toJson();
      // Manually serialize the timing field since Freezed doesn't do it automatically for nested unions
      final timing = event.map(
        retirement: (e) => e.timing,
        death: (e) => e.timing,
        realEstateTransaction: (e) => e.timing,
      );
      eventJson['timing'] = timing.toJson();

      await _eventsCollection.doc(event.id).update(eventJson);
      log('Event updated: ${event.id}');
    } catch (e) {
      log('Error updating event: $e');
      rethrow;
    }
  }

  /// Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      await _eventsCollection.doc(eventId).delete();
      log('Event deleted: $eventId');
    } catch (e) {
      log('Error deleting event: $e');
      rethrow;
    }
  }

  /// Get a single event by ID
  Future<Event?> getEvent(String eventId) async {
    try {
      final doc = await _eventsCollection.doc(eventId).get();
      if (!doc.exists) {
        return null;
      }
      return Event.fromJson(doc.data()!);
    } catch (e) {
      log('Error getting event: $e');
      rethrow;
    }
  }
}
