import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

void main() {
  group('WizardSectionStatus', () {
    group('Factory Constructors', () {
      test('notStarted creates correct status', () {
        final status = WizardSectionStatus.notStarted();

        expect(status.state, WizardSectionState.notStarted);
        expect(status.lastVisited, isNull);
        expect(status.completedAt, isNull);
        expect(status.validationWarnings, isEmpty);
      });

      test('inProgress creates correct status with timestamp', () {
        final before = DateTime.now();
        final status = WizardSectionStatus.inProgress();
        final after = DateTime.now();

        expect(status.state, WizardSectionState.inProgress);
        expect(status.lastVisited, isNotNull);
        expect(status.lastVisited!.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(status.lastVisited!.isBefore(after.add(const Duration(seconds: 1))), isTrue);
        expect(status.completedAt, isNull);
        expect(status.validationWarnings, isEmpty);
      });

      test('skipped creates correct status with timestamp', () {
        final before = DateTime.now();
        final status = WizardSectionStatus.skipped();
        final after = DateTime.now();

        expect(status.state, WizardSectionState.skipped);
        expect(status.lastVisited, isNotNull);
        expect(status.lastVisited!.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(status.lastVisited!.isBefore(after.add(const Duration(seconds: 1))), isTrue);
        expect(status.completedAt, isNull);
      });

      test('complete creates correct status with timestamps', () {
        final before = DateTime.now();
        final status = WizardSectionStatus.complete();
        final after = DateTime.now();

        expect(status.state, WizardSectionState.complete);
        expect(status.lastVisited, isNotNull);
        expect(status.completedAt, isNotNull);
        expect(status.lastVisited!.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(status.completedAt!.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(status.lastVisited!.isBefore(after.add(const Duration(seconds: 1))), isTrue);
        expect(status.completedAt!.isBefore(after.add(const Duration(seconds: 1))), isTrue);
      });

      test('needsAttention creates correct status with warnings', () {
        final warnings = ['Missing field', 'Invalid value'];
        final status = WizardSectionStatus.needsAttention(warnings);

        expect(status.state, WizardSectionState.needsAttention);
        expect(status.validationWarnings, equals(warnings));
        expect(status.lastVisited, isNotNull);
      });
    });

    group('Icon Getter', () {
      test('returns correct icon for each state', () {
        expect(WizardSectionStatus.notStarted().icon, '⏹️');
        expect(WizardSectionStatus.inProgress().icon, '🔄');
        expect(WizardSectionStatus.skipped().icon, '⏸️');
        expect(WizardSectionStatus.complete().icon, '✅');
        expect(WizardSectionStatus.needsAttention([]).icon, '⚠️');
      });
    });

    group('isDone Getter', () {
      test('returns true for complete status', () {
        expect(WizardSectionStatus.complete().isDone, isTrue);
      });

      test('returns true for skipped status', () {
        expect(WizardSectionStatus.skipped().isDone, isTrue);
      });

      test('returns false for not started status', () {
        expect(WizardSectionStatus.notStarted().isDone, isFalse);
      });

      test('returns false for in progress status', () {
        expect(WizardSectionStatus.inProgress().isDone, isFalse);
      });

      test('returns false for needs attention status', () {
        expect(WizardSectionStatus.needsAttention([]).isDone, isFalse);
      });
    });

    group('JSON Serialization', () {
      test('serializes and deserializes correctly', () {
        final now = DateTime.now();
        final original = WizardSectionStatus(
          state: WizardSectionState.complete,
          lastVisited: now,
          completedAt: now,
          validationWarnings: ['warning1', 'warning2'],
        );

        final json = original.toJson();
        final deserialized = WizardSectionStatus.fromJson(json);

        expect(deserialized.state, original.state);
        expect(deserialized.lastVisited, original.lastVisited);
        expect(deserialized.completedAt, original.completedAt);
        expect(deserialized.validationWarnings, original.validationWarnings);
      });

      test('handles null optional fields', () {
        final original = WizardSectionStatus(
          state: WizardSectionState.notStarted,
        );

        final json = original.toJson();
        final deserialized = WizardSectionStatus.fromJson(json);

        expect(deserialized.state, WizardSectionState.notStarted);
        expect(deserialized.lastVisited, isNull);
        expect(deserialized.completedAt, isNull);
        expect(deserialized.validationWarnings, isEmpty);
      });
    });
  });
}
