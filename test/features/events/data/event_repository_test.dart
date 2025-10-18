import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/events/data/event_repository.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';

void main() {
  group('EventRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late EventRepository repository;
    const testProjectId = 'test-project-123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = EventRepository(
        projectId: testProjectId,
        firestore: fakeFirestore,
      );
    });

    group('Create Event', () {
      test('should create retirement event with relative timing', () async {
        final event = Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        );

        await repository.createEvent(event);

        final retrieved = await repository.getEvent('event-1');
        expect(retrieved, isNotNull);
        retrieved!.map(
          retirement: (e) {
            expect(e.id, 'event-1');
            expect(e.individualId, 'ind-1');
            e.timing.map(
              relative: (t) => expect(t.yearsFromStart, 5),
              absolute: (_) => fail('Expected relative timing'),
              age: (_) => fail('Expected relative timing'),
              eventRelative: (_) => fail('Expected relative timing'),
              projectionEnd: (_) => fail('Expected relative timing'),
            );
          },
          death: (_) => fail('Expected retirement'),
          realEstateTransaction: (_) => fail('Expected retirement'),
        );
      });

      test('should create retirement event with absolute timing', () async {
        final event = Event.retirement(
          id: 'event-2',
          individualId: 'ind-1',
          timing: EventTiming.absolute(calendarYear: 2030),
        );

        await repository.createEvent(event);

        final retrieved = await repository.getEvent('event-2');
        expect(retrieved, isNotNull);
        retrieved!.map(
          retirement: (e) {
            e.timing.map(
              relative: (_) => fail('Expected absolute timing'),
              absolute: (t) => expect(t.calendarYear, 2030),
              age: (_) => fail('Expected absolute timing'),
              eventRelative: (_) => fail('Expected absolute timing'),
              projectionEnd: (_) => fail('Expected absolute timing'),
            );
          },
          death: (_) => fail('Expected retirement'),
          realEstateTransaction: (_) => fail('Expected retirement'),
        );
      });

      test('should create retirement event with age timing', () async {
        final event = Event.retirement(
          id: 'event-3',
          individualId: 'ind-1',
          timing: EventTiming.age(individualId: 'ind-1', age: 65),
        );

        await repository.createEvent(event);

        final retrieved = await repository.getEvent('event-3');
        expect(retrieved, isNotNull);
        retrieved!.map(
          retirement: (e) {
            e.timing.map(
              relative: (_) => fail('Expected age timing'),
              absolute: (_) => fail('Expected age timing'),
              age: (t) {
                expect(t.individualId, 'ind-1');
                expect(t.age, 65);
              },
              eventRelative: (_) => fail('Expected age timing'),
              projectionEnd: (_) => fail('Expected age timing'),
            );
          },
          death: (_) => fail('Expected retirement'),
          realEstateTransaction: (_) => fail('Expected retirement'),
        );
      });

      test('should create death event with event-relative timing', () async {
        final event = Event.death(
          id: 'event-4',
          individualId: 'ind-1',
          timing: EventTiming.eventRelative(
            eventId: 'event-retirement',
            boundary: EventBoundary.start,
          ),
        );

        await repository.createEvent(event);

        final retrieved = await repository.getEvent('event-4');
        expect(retrieved, isNotNull);
        retrieved!.map(
          retirement: (_) => fail('Expected death'),
          death: (e) {
            expect(e.id, 'event-4');
            expect(e.individualId, 'ind-1');
            e.timing.map(
              relative: (_) => fail('Expected event-relative timing'),
              absolute: (_) => fail('Expected event-relative timing'),
              age: (_) => fail('Expected event-relative timing'),
              eventRelative: (t) {
                expect(t.eventId, 'event-retirement');
                expect(t.boundary, EventBoundary.start);
              },
              projectionEnd: (_) => fail('Expected event-relative timing'),
            );
          },
          realEstateTransaction: (_) => fail('Expected death'),
        );
      });

      test('should create death event with projection end timing', () async {
        final event = Event.death(
          id: 'event-5',
          individualId: 'ind-1',
          timing: EventTiming.projectionEnd(),
        );

        await repository.createEvent(event);

        final retrieved = await repository.getEvent('event-5');
        expect(retrieved, isNotNull);
        retrieved!.map(
          retirement: (_) => fail('Expected death'),
          death: (e) {
            e.timing.map(
              relative: (_) => fail('Expected projection end timing'),
              absolute: (_) => fail('Expected projection end timing'),
              age: (_) => fail('Expected projection end timing'),
              eventRelative: (_) => fail('Expected projection end timing'),
              projectionEnd: (_) => expect(true, true),
            );
          },
          realEstateTransaction: (_) => fail('Expected death'),
        );
      });

      test('should create real estate transaction event', () async {
        final event = Event.realEstateTransaction(
          id: 'event-6',
          timing: EventTiming.relative(yearsFromStart: 10),
          assetSoldId: 'asset-house',
          assetPurchasedId: 'asset-condo',
          withdrawAccountId: 'account-rrsp',
          depositAccountId: 'account-cash',
        );

        await repository.createEvent(event);

        final retrieved = await repository.getEvent('event-6');
        expect(retrieved, isNotNull);
        retrieved!.map(
          retirement: (_) => fail('Expected real estate transaction'),
          death: (_) => fail('Expected real estate transaction'),
          realEstateTransaction: (e) {
            expect(e.id, 'event-6');
            expect(e.assetSoldId, 'asset-house');
            expect(e.assetPurchasedId, 'asset-condo');
            expect(e.withdrawAccountId, 'account-rrsp');
            expect(e.depositAccountId, 'account-cash');
            e.timing.map(
              relative: (t) => expect(t.yearsFromStart, 10),
              absolute: (_) => fail('Expected relative timing'),
              age: (_) => fail('Expected relative timing'),
              eventRelative: (_) => fail('Expected relative timing'),
              projectionEnd: (_) => fail('Expected relative timing'),
            );
          },
        );
      });
    });

    group('Read Event', () {
      test('should get event by ID', () async {
        final event = Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        );

        await repository.createEvent(event);
        final retrieved = await repository.getEvent('event-1');

        expect(retrieved, isNotNull);
        expect(retrieved!.id, 'event-1');
      });

      test('should return null for non-existent event', () async {
        final result = await repository.getEvent('non-existent-id');
        expect(result, isNull);
      });

      test('should get all events for project', () async {
        await repository.createEvent(Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        ));
        await repository.createEvent(Event.death(
          id: 'event-2',
          individualId: 'ind-1',
          timing: EventTiming.age(individualId: 'ind-1', age: 85),
        ));
        await repository.createEvent(Event.realEstateTransaction(
          id: 'event-3',
          timing: EventTiming.absolute(calendarYear: 2035),
          withdrawAccountId: 'account-cash',
          depositAccountId: 'account-cash',
        ));

        final events = await repository.getEventsStream().first;

        expect(events.length, 3);
        final ids = events.map((e) => e.id).toList();
        expect(ids, containsAll(['event-1', 'event-2', 'event-3']));
      });

      test('should stream event updates', () async {
        final stream = repository.getEventsStream();

        // Create initial event
        await repository.createEvent(Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        ));

        // Get first emission
        final firstEmission = await stream.first;
        expect(firstEmission.length, 1);
      });
    });

    group('Update Event', () {
      test('should update retirement event timing', () async {
        final original = Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        );

        await repository.createEvent(original);

        final updated = Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.age(individualId: 'ind-1', age: 65),
        );

        await repository.updateEvent(updated);

        final retrieved = await repository.getEvent('event-1');
        retrieved!.map(
          retirement: (e) {
            e.timing.map(
              relative: (_) => fail('Expected age timing'),
              absolute: (_) => fail('Expected age timing'),
              age: (t) {
                expect(t.individualId, 'ind-1');
                expect(t.age, 65);
              },
              eventRelative: (_) => fail('Expected age timing'),
              projectionEnd: (_) => fail('Expected age timing'),
            );
          },
          death: (_) => fail('Expected retirement'),
          realEstateTransaction: (_) => fail('Expected retirement'),
        );
      });

      test('should update real estate transaction details', () async {
        final original = Event.realEstateTransaction(
          id: 'event-1',
          timing: EventTiming.relative(yearsFromStart: 10),
          assetSoldId: 'asset-old',
          withdrawAccountId: 'account-1',
          depositAccountId: 'account-2',
        );

        await repository.createEvent(original);

        final updated = Event.realEstateTransaction(
          id: 'event-1',
          timing: EventTiming.absolute(calendarYear: 2030),
          assetSoldId: 'asset-new',
          assetPurchasedId: 'asset-purchased',
          withdrawAccountId: 'account-3',
          depositAccountId: 'account-4',
        );

        await repository.updateEvent(updated);

        final retrieved = await repository.getEvent('event-1');
        retrieved!.map(
          retirement: (_) => fail('Expected real estate transaction'),
          death: (_) => fail('Expected real estate transaction'),
          realEstateTransaction: (e) {
            expect(e.assetSoldId, 'asset-new');
            expect(e.assetPurchasedId, 'asset-purchased');
            expect(e.withdrawAccountId, 'account-3');
            expect(e.depositAccountId, 'account-4');
            e.timing.map(
              relative: (_) => fail('Expected absolute timing'),
              absolute: (t) => expect(t.calendarYear, 2030),
              age: (_) => fail('Expected absolute timing'),
              eventRelative: (_) => fail('Expected absolute timing'),
              projectionEnd: (_) => fail('Expected absolute timing'),
            );
          },
        );
      });
    });

    group('Delete Event', () {
      test('should delete event from Firestore', () async {
        final event = Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        );

        await repository.createEvent(event);
        await repository.deleteEvent('event-1');

        final retrieved = await repository.getEvent('event-1');
        expect(retrieved, isNull);
      });

      test('should remove event from stream', () async {
        await repository.createEvent(Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: EventTiming.relative(yearsFromStart: 5),
        ));
        await repository.createEvent(Event.death(
          id: 'event-2',
          individualId: 'ind-1',
          timing: EventTiming.age(individualId: 'ind-1', age: 85),
        ));

        await repository.deleteEvent('event-1');

        final events = await repository.getEventsStream().first;
        expect(events.length, 1);
        expect(events[0].id, 'event-2');
      });
    });

    group('Nested Union Serialization', () {
      test('should preserve all 5 timing types through serialization', () async {
        final timings = [
          EventTiming.relative(yearsFromStart: 5),
          EventTiming.absolute(calendarYear: 2030),
          EventTiming.age(individualId: 'ind-1', age: 65),
          EventTiming.eventRelative(
            eventId: 'event-other',
            boundary: EventBoundary.end,
          ),
          EventTiming.projectionEnd(),
        ];

        for (int i = 0; i < timings.length; i++) {
          final event = Event.retirement(
            id: 'event-$i',
            individualId: 'ind-1',
            timing: timings[i],
          );

          await repository.createEvent(event);
          final retrieved = await repository.getEvent('event-$i');

          expect(retrieved, isNotNull);
          expect(retrieved!.map(
            retirement: (e) => e.timing.toJson(),
            death: (e) => e.timing.toJson(),
            realEstateTransaction: (e) => e.timing.toJson(),
          ), equals(timings[i].toJson()));
        }
      });

      test('should handle event boundary enum values', () async {
        final boundaries = [EventBoundary.start, EventBoundary.end];

        for (int i = 0; i < boundaries.length; i++) {
          final event = Event.death(
            id: 'event-$i',
            individualId: 'ind-1',
            timing: EventTiming.eventRelative(
              eventId: 'event-other',
              boundary: boundaries[i],
            ),
          );

          await repository.createEvent(event);
          final retrieved = await repository.getEvent('event-$i');

          expect(retrieved, isNotNull);
          retrieved!.map(
            retirement: (_) => fail('Expected death'),
            death: (e) {
              e.timing.map(
                relative: (_) => fail('Expected event-relative timing'),
                absolute: (_) => fail('Expected event-relative timing'),
                age: (_) => fail('Expected event-relative timing'),
                eventRelative: (t) => expect(t.boundary, boundaries[i]),
                projectionEnd: (_) => fail('Expected event-relative timing'),
              );
            },
            realEstateTransaction: (_) => fail('Expected death'),
          );
        }
      });

      test('should handle nullable real estate transaction fields', () async {
        final event = Event.realEstateTransaction(
          id: 'event-1',
          timing: EventTiming.relative(yearsFromStart: 5),
          assetSoldId: null,
          assetPurchasedId: 'asset-new',
          withdrawAccountId: 'account-1',
          depositAccountId: 'account-2',
        );

        await repository.createEvent(event);
        final retrieved = await repository.getEvent('event-1');

        retrieved!.map(
          retirement: (_) => fail('Expected real estate transaction'),
          death: (_) => fail('Expected real estate transaction'),
          realEstateTransaction: (e) {
            expect(e.assetSoldId, isNull);
            expect(e.assetPurchasedId, 'asset-new');
          },
        );
      });
    });

    group('Data Integrity', () {
      test('should maintain all fields through round-trip for each event type', () async {
        final events = [
          Event.retirement(
            id: 'event-retirement',
            individualId: 'ind-1',
            timing: EventTiming.age(individualId: 'ind-1', age: 65),
          ),
          Event.death(
            id: 'event-death',
            individualId: 'ind-1',
            timing: EventTiming.age(individualId: 'ind-1', age: 85),
          ),
          Event.realEstateTransaction(
            id: 'event-transaction',
            timing: EventTiming.absolute(calendarYear: 2030),
            assetSoldId: 'asset-house',
            assetPurchasedId: 'asset-condo',
            withdrawAccountId: 'account-rrsp',
            depositAccountId: 'account-cash',
          ),
        ];

        for (final event in events) {
          await repository.createEvent(event);
          final retrieved = await repository.getEvent(event.id);

          expect(retrieved, isNotNull);
          expect(retrieved!.toJson(), equals(event.toJson()));
        }
      });

      test('should maintain timing through event type changes', () async {
        final timing = EventTiming.relative(yearsFromStart: 10);

        // Create retirement with timing
        await repository.createEvent(Event.retirement(
          id: 'event-1',
          individualId: 'ind-1',
          timing: timing,
        ));

        // Update to death with same timing
        await repository.updateEvent(Event.death(
          id: 'event-1',
          individualId: 'ind-1',
          timing: timing,
        ));

        final retrieved = await repository.getEvent('event-1');
        retrieved!.map(
          retirement: (_) => fail('Expected death'),
          death: (e) {
            e.timing.map(
              relative: (t) => expect(t.yearsFromStart, 10),
              absolute: (_) => fail('Expected relative timing'),
              age: (_) => fail('Expected relative timing'),
              eventRelative: (_) => fail('Expected relative timing'),
              projectionEnd: (_) => fail('Expected relative timing'),
            );
          },
          realEstateTransaction: (_) => fail('Expected death'),
        );
      });
    });

    group('Error Handling', () {
      test('should handle empty project collection', () async {
        final events = await repository.getEventsStream().first;
        expect(events, isEmpty);
      });
    });
  });
}
