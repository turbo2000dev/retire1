import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/data/wizard_progress_repository.dart';
import 'package:retire1/features/wizard/domain/wizard_section_status.dart';

void main() {
  group('WizardProgressRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late WizardProgressRepository repository;
    const testUserId = 'test-user-123';
    const testProjectId = 'test-project-456';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = WizardProgressRepository(
        userId: testUserId,
        firestore: fakeFirestore,
      );
    });

    group('Get or Create Progress', () {
      test('should create new progress when none exists', () async {
        final progress = await repository.getOrCreateProgress(testProjectId);

        expect(progress.projectId, testProjectId);
        expect(progress.userId, testUserId);
        expect(progress.currentSectionId, 'welcome');
        expect(progress.sectionStatuses, isEmpty);
        expect(progress.wizardCompleted, false);
        expect(progress.completedAt, isNull);
        expect(progress.createdAt, isNotNull);
        expect(progress.lastUpdated, isNotNull);
      });

      test('should store new progress in Firestore', () async {
        await repository.getOrCreateProgress(testProjectId);

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        expect(doc.exists, true);
        expect(doc.data()!['userId'], testUserId);
        expect(doc.data()!['currentSectionId'], 'welcome');
      });

      test('should return existing progress when it exists', () async {
        // Create initial progress
        final first = await repository.getOrCreateProgress(testProjectId);

        // Wait a bit to ensure different timestamp
        await Future.delayed(const Duration(milliseconds: 10));

        // Get progress again
        final second = await repository.getOrCreateProgress(testProjectId);

        // Should be same progress (same creation time)
        expect(second.projectId, first.projectId);
        expect(second.userId, first.userId);
        expect(second.createdAt, first.createdAt);
      });
    });

    group('Get Progress Stream', () {
      test('should return null for non-existent progress', () async {
        final stream = repository.getProgressStream(testProjectId);
        final progress = await stream.first;

        expect(progress, isNull);
      });

      test('should stream existing progress', () async {
        // Create progress
        await repository.getOrCreateProgress(testProjectId);

        // Get stream
        final stream = repository.getProgressStream(testProjectId);
        final progress = await stream.first;

        expect(progress, isNotNull);
        expect(progress!.projectId, testProjectId);
      });

      test('should stream updates to progress', () async {
        // Create progress
        await repository.getOrCreateProgress(testProjectId);

        // Update section status
        await repository.updateSectionStatus(
          testProjectId,
          'test-section',
          WizardSectionStatus.complete(),
        );

        // Get stream and read updated progress
        final stream = repository.getProgressStream(testProjectId);
        final progress = await stream.first;

        expect(progress, isNotNull);
        expect(progress!.sectionStatuses.containsKey('test-section'), isTrue);
        expect(
          progress.sectionStatuses['test-section']!.state,
          WizardSectionState.complete,
        );
      });
    });

    group('Update Section Status', () {
      test('should update section status', () async {
        // Create initial progress
        await repository.getOrCreateProgress(testProjectId);

        // Update status
        final status = WizardSectionStatus.complete();
        await repository.updateSectionStatus(
          testProjectId,
          'project-basics',
          status,
        );

        // Verify in Firestore
        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        expect(doc.exists, true);
        final data = doc.data()!;
        expect(data['sectionStatuses'], isNotNull);
        expect(data['sectionStatuses']['project-basics'], isNotNull);
        expect(
          data['sectionStatuses']['project-basics']['state'],
          'complete',
        );
      });

      test('should not update current section (use navigateToSection for that)', () async {
        await repository.getOrCreateProgress(testProjectId);

        await repository.updateSectionStatus(
          testProjectId,
          'partner',
          WizardSectionStatus.inProgress(),
        );

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        // updateSectionStatus should NOT change currentSectionId
        // Use navigateToSection for that
        expect(doc.data()!['currentSectionId'], 'welcome');
      });

      test('should update lastUpdated timestamp', () async {
        final initial = await repository.getOrCreateProgress(testProjectId);

        await Future.delayed(const Duration(milliseconds: 10));

        await repository.updateSectionStatus(
          testProjectId,
          'test-section',
          WizardSectionStatus.inProgress(),
        );

        final updated = await repository.getOrCreateProgress(testProjectId);

        expect(updated.lastUpdated.isAfter(initial.lastUpdated), isTrue);
      });

      test('should handle multiple section updates', () async {
        await repository.getOrCreateProgress(testProjectId);

        await repository.updateSectionStatus(
          testProjectId,
          'section1',
          WizardSectionStatus.complete(),
        );

        await repository.updateSectionStatus(
          testProjectId,
          'section2',
          WizardSectionStatus.inProgress(),
        );

        await repository.updateSectionStatus(
          testProjectId,
          'section3',
          WizardSectionStatus.skipped(),
        );

        final progress = await repository.getOrCreateProgress(testProjectId);

        expect(progress.sectionStatuses.length, 3);
        expect(progress.sectionStatuses['section1']!.state, WizardSectionState.complete);
        expect(progress.sectionStatuses['section2']!.state, WizardSectionState.inProgress);
        expect(progress.sectionStatuses['section3']!.state, WizardSectionState.skipped);
      });
    });

    group('Navigate to Section', () {
      test('should update current section ID', () async {
        await repository.getOrCreateProgress(testProjectId);

        await repository.navigateToSection(testProjectId, 'expenses');

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        expect(doc.data()!['currentSectionId'], 'expenses');
      });

      test('should update lastUpdated timestamp', () async {
        final initial = await repository.getOrCreateProgress(testProjectId);

        await Future.delayed(const Duration(milliseconds: 10));

        await repository.navigateToSection(testProjectId, 'assets');

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        final lastUpdatedString = doc.data()!['lastUpdated'] as String;
        final lastUpdated = DateTime.parse(lastUpdatedString);
        expect(lastUpdated.isAfter(initial.lastUpdated), isTrue);
      });
    });

    group('Complete Wizard', () {
      test('should mark wizard as completed', () async {
        await repository.getOrCreateProgress(testProjectId);

        await repository.completeWizard(testProjectId);

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        expect(doc.data()!['wizardCompleted'], true);
        expect(doc.data()!['completedAt'], isNotNull);
      });

      test('should set completedAt timestamp', () async {
        final before = DateTime.now();
        await repository.getOrCreateProgress(testProjectId);

        await repository.completeWizard(testProjectId);

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('wizardProgress')
            .doc(testProjectId)
            .get();

        final completedAtString = doc.data()!['completedAt'] as String;
        final completedAt = DateTime.parse(completedAtString);
        final after = DateTime.now();

        expect(completedAt.isAfter(before.subtract(const Duration(seconds: 1))), isTrue);
        expect(completedAt.isBefore(after.add(const Duration(seconds: 1))), isTrue);
      });
    });

    group('Reset Progress', () {
      test('should reset wizard progress to initial state', () async {
        // Create and update progress
        await repository.getOrCreateProgress(testProjectId);
        await repository.updateSectionStatus(
          testProjectId,
          'section1',
          WizardSectionStatus.complete(),
        );
        await repository.completeWizard(testProjectId);

        // Reset
        await repository.resetProgress(testProjectId);

        // Verify reset
        final progress = await repository.getOrCreateProgress(testProjectId);

        expect(progress.currentSectionId, 'welcome');
        expect(progress.sectionStatuses, isEmpty);
        expect(progress.wizardCompleted, false);
        expect(progress.completedAt, isNull);
      });

      test('should create new createdAt timestamp on reset', () async {
        final initial = await repository.getOrCreateProgress(testProjectId);

        await Future.delayed(const Duration(milliseconds: 10));

        await repository.resetProgress(testProjectId);

        final reset = await repository.getOrCreateProgress(testProjectId);

        expect(reset.createdAt.isAfter(initial.createdAt), isTrue);
      });
    });

    group('Timestamp Conversion', () {
      test('should handle DateTime fields correctly', () async {
        // Note: FakeFirebaseFirestore doesn't convert DateTime to Timestamp
        // like real Firestore does, so we just verify DateTime fields work
        final progress = await repository.getOrCreateProgress(testProjectId);

        // Progress should have DateTime objects
        expect(progress.createdAt, isA<DateTime>());
        expect(progress.lastUpdated, isA<DateTime>());
      });

      test('should handle nested timestamp conversion in section statuses', () async {
        await repository.getOrCreateProgress(testProjectId);

        await repository.updateSectionStatus(
          testProjectId,
          'test-section',
          WizardSectionStatus.complete(),
        );

        // Read back from repository
        final progress = await repository.getOrCreateProgress(testProjectId);

        // Status timestamps should be DateTime
        final status = progress.sectionStatuses['test-section']!;
        expect(status.lastVisited, isA<DateTime>());
        expect(status.completedAt, isA<DateTime>());
      });
    });

    group('Data Integrity', () {
      test('should maintain section status details through round-trip', () async {
        await repository.getOrCreateProgress(testProjectId);

        final warnings = ['Warning 1', 'Warning 2'];
        final originalStatus = WizardSectionStatus.needsAttention(warnings);

        await repository.updateSectionStatus(
          testProjectId,
          'test-section',
          originalStatus,
        );

        final progress = await repository.getOrCreateProgress(testProjectId);
        final retrievedStatus = progress.sectionStatuses['test-section']!;

        expect(retrievedStatus.state, WizardSectionState.needsAttention);
        expect(retrievedStatus.validationWarnings, warnings);
        expect(retrievedStatus.lastVisited, isNotNull);
      });

      test('should handle empty section statuses map', () async {
        final progress = await repository.getOrCreateProgress(testProjectId);

        expect(progress.sectionStatuses, isEmpty);
      });

      test('should handle large section statuses map', () async {
        await repository.getOrCreateProgress(testProjectId);

        // Add statuses for all 12 sections
        for (int i = 1; i <= 12; i++) {
          await repository.updateSectionStatus(
            testProjectId,
            'section$i',
            i % 2 == 0
                ? WizardSectionStatus.complete()
                : WizardSectionStatus.inProgress(),
          );
        }

        final progress = await repository.getOrCreateProgress(testProjectId);

        expect(progress.sectionStatuses.length, 12);
      });
    });
  });
}
