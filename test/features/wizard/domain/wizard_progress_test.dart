import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_progress.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

void main() {
  group('WizardProgress', () {
    const projectId = 'test-project-id';
    const userId = 'test-user-id';

    group('Factory Constructor', () {
      test('create initializes with correct defaults', () {
        final before = DateTime.now();
        final progress = WizardProgress.create(
          projectId: projectId,
          userId: userId,
        );
        final after = DateTime.now();

        expect(progress.projectId, projectId);
        expect(progress.userId, userId);
        expect(progress.currentSectionId, 'welcome');
        expect(progress.sectionStatuses, isEmpty);
        expect(progress.wizardCompleted, false);
        expect(progress.completedAt, isNull);
        expect(
          progress.createdAt.isAfter(
            before.subtract(const Duration(seconds: 1)),
          ),
          isTrue,
        );
        expect(
          progress.createdAt.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
        expect(
          progress.lastUpdated.isAfter(
            before.subtract(const Duration(seconds: 1)),
          ),
          isTrue,
        );
        expect(
          progress.lastUpdated.isBefore(after.add(const Duration(seconds: 1))),
          isTrue,
        );
      });
    });

    group('getStatus', () {
      test('returns existing status for section', () {
        final existingStatus = WizardSectionStatus.complete();
        final progress = WizardProgress.create(
          projectId: projectId,
          userId: userId,
        ).copyWith(sectionStatuses: {'test-section': existingStatus});

        final status = progress.getStatus('test-section');
        expect(status, existingStatus);
      });

      test('returns notStarted for unknown section', () {
        final progress = WizardProgress.create(
          projectId: projectId,
          userId: userId,
        );

        final status = progress.getStatus('unknown-section');
        expect(status.state, WizardSectionState.notStarted);
      });
    });

    group('calculateProgress', () {
      test('returns 0 when no sections completed', () {
        final progress = WizardProgress.create(
          projectId: projectId,
          userId: userId,
        );

        expect(progress.calculateProgress(5), 0.0);
      });

      test('returns 0 when total sections is 0', () {
        final progress = WizardProgress.create(
          projectId: projectId,
          userId: userId,
        );

        expect(progress.calculateProgress(0), 0.0);
      });

      test('calculates correct percentage', () {
        final progress =
            WizardProgress.create(
              projectId: projectId,
              userId: userId,
            ).copyWith(
              sectionStatuses: {
                'section1': WizardSectionStatus.complete(),
                'section2': WizardSectionStatus.complete(),
                'section3': WizardSectionStatus.inProgress(),
                'section4': WizardSectionStatus.notStarted(),
                'section5': WizardSectionStatus.skipped(),
              },
            );

        // 2 out of 5 complete = 40%
        expect(progress.calculateProgress(5), 40.0);
      });

      test('counts only complete sections, not skipped', () {
        final progress =
            WizardProgress.create(
              projectId: projectId,
              userId: userId,
            ).copyWith(
              sectionStatuses: {
                'section1': WizardSectionStatus.complete(),
                'section2': WizardSectionStatus.skipped(),
                'section3': WizardSectionStatus.skipped(),
              },
            );

        // Only 1 complete out of 3 = 33.33%
        expect(progress.calculateProgress(3), closeTo(33.33, 0.01));
      });
    });

    group('areRequiredSectionsComplete', () {
      test('returns true when all required sections complete', () {
        final progress =
            WizardProgress.create(
              projectId: projectId,
              userId: userId,
            ).copyWith(
              sectionStatuses: {
                'required1': WizardSectionStatus.complete(),
                'required2': WizardSectionStatus.complete(),
                'optional': WizardSectionStatus.notStarted(),
              },
            );

        expect(
          progress.areRequiredSectionsComplete(['required1', 'required2']),
          isTrue,
        );
      });

      test('returns false when any required section incomplete', () {
        final progress =
            WizardProgress.create(
              projectId: projectId,
              userId: userId,
            ).copyWith(
              sectionStatuses: {
                'required1': WizardSectionStatus.complete(),
                'required2': WizardSectionStatus.inProgress(),
              },
            );

        expect(
          progress.areRequiredSectionsComplete(['required1', 'required2']),
          isFalse,
        );
      });

      test('returns false when required section is skipped', () {
        final progress =
            WizardProgress.create(
              projectId: projectId,
              userId: userId,
            ).copyWith(
              sectionStatuses: {
                'required1': WizardSectionStatus.complete(),
                'required2': WizardSectionStatus.skipped(),
              },
            );

        expect(
          progress.areRequiredSectionsComplete(['required1', 'required2']),
          isFalse,
        );
      });

      test('returns false when required section not started', () {
        final progress =
            WizardProgress.create(
              projectId: projectId,
              userId: userId,
            ).copyWith(
              sectionStatuses: {'required1': WizardSectionStatus.complete()},
            );

        expect(
          progress.areRequiredSectionsComplete(['required1', 'required2']),
          isFalse,
        );
      });

      test('returns true for empty required sections list', () {
        final progress = WizardProgress.create(
          projectId: projectId,
          userId: userId,
        );

        expect(progress.areRequiredSectionsComplete([]), isTrue);
      });
    });

    group('JSON Serialization', () {
      test('serializes and deserializes correctly', () {
        final now = DateTime.now();
        final original = WizardProgress(
          projectId: projectId,
          userId: userId,
          currentSectionId: 'test-section',
          sectionStatuses: {
            'section1': WizardSectionStatus.complete(),
            'section2': WizardSectionStatus.inProgress(),
          },
          lastUpdated: now,
          createdAt: now,
          wizardCompleted: true,
          completedAt: now,
        );

        final json = original.toJson();
        final deserialized = WizardProgress.fromJson(json);

        expect(deserialized.projectId, original.projectId);
        expect(deserialized.userId, original.userId);
        expect(deserialized.currentSectionId, original.currentSectionId);
        expect(
          deserialized.sectionStatuses.length,
          original.sectionStatuses.length,
        );
        expect(deserialized.wizardCompleted, original.wizardCompleted);
        expect(deserialized.lastUpdated, original.lastUpdated);
        expect(deserialized.createdAt, original.createdAt);
        expect(deserialized.completedAt, original.completedAt);
      });

      test('handles null optional fields', () {
        final now = DateTime.now();
        final original = WizardProgress(
          projectId: projectId,
          userId: userId,
          lastUpdated: now,
          createdAt: now,
        );

        final json = original.toJson();
        final deserialized = WizardProgress.fromJson(json);

        expect(deserialized.currentSectionId, 'welcome');
        expect(deserialized.sectionStatuses, isEmpty);
        expect(deserialized.wizardCompleted, isNull);
        expect(deserialized.completedAt, isNull);
      });
    });
  });
}
