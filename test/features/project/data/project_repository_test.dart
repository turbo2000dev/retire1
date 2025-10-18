import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/project/data/project_repository.dart';
import 'package:retire1/features/project/domain/individual.dart';

void main() {
  group('ProjectRepository', () {
    late FakeFirebaseFirestore fakeFirestore;
    late ProjectRepository repository;
    const testUserId = 'test-user-123';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      repository = ProjectRepository(
        userId: testUserId,
        firestore: fakeFirestore,
      );
    });

    group('Create Project', () {
      test('should create project with default values', () async {
        final project = await repository.createProject(
          name: 'My Retirement Plan',
          description: 'Test description',
        );

        expect(project.name, 'My Retirement Plan');
        expect(project.description, 'Test description');
        expect(project.ownerId, testUserId);
        expect(project.individuals, isEmpty);
        expect(project.inflationRate, 0.02);
        expect(project.reerReturnRate, 0.05);
        expect(project.celiReturnRate, 0.05);
        expect(project.criReturnRate, 0.05);
        expect(project.cashReturnRate, 0.015);
      });

      test('should store project in Firestore', () async {
        final project = await repository.createProject(name: 'Test Project');

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('projects')
            .doc(project.id)
            .get();

        expect(doc.exists, true);
        expect(doc.data()!['name'], 'Test Project');
        expect(doc.data()!['ownerId'], testUserId);
      });

      test('should convert DateTime to Timestamp in Firestore', () async {
        final project = await repository.createProject(name: 'DateTime Test');

        final doc = await fakeFirestore
            .collection('users')
            .doc(testUserId)
            .collection('projects')
            .doc(project.id)
            .get();

        // Verify timestamps are stored as Firestore Timestamp objects
        expect(doc.data()!['createdAt'], isA<Timestamp>());
        expect(doc.data()!['updatedAt'], isA<Timestamp>());
      });
    });

    group('Read Project', () {
      test('should get project by ID', () async {
        final created = await repository.createProject(name: 'Test Project');

        final retrieved = await repository.getProject(created.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, created.id);
        expect(retrieved.name, 'Test Project');
        expect(retrieved.ownerId, testUserId);
      });

      test('should return null for non-existent project', () async {
        final result = await repository.getProject('non-existent-id');

        expect(result, isNull);
      });

      test('should get all projects for user', () async {
        await repository.createProject(name: 'Project 1');
        await repository.createProject(name: 'Project 2');
        await repository.createProject(name: 'Project 3');

        final projects = await repository.getProjectsStream().first;

        expect(projects.length, 3);
        expect(
          projects.map((p) => p.name),
          containsAll(['Project 1', 'Project 2', 'Project 3']),
        );
      });

      test('should stream project updates', () async {
        final stream = repository.getProjectsStream();

        // Create initial project
        await repository.createProject(name: 'Initial');

        // Get first emission
        final firstEmission = await stream.first;
        expect(firstEmission.length, 1);
        expect(firstEmission[0].name, 'Initial');
      });
    });

    group('Update Project', () {
      test('should update project name and description', () async {
        final project = await repository.createProject(name: 'Original Name');

        await repository.updateProject(
          projectId: project.id,
          name: 'Updated Name',
          description: 'Updated Description',
        );

        final updated = await repository.getProject(project.id);
        expect(updated!.name, 'Updated Name');
        expect(updated.description, 'Updated Description');
      });

      test('should update project return rates', () async {
        final project = await repository.createProject(name: 'Test');

        final updatedProject = project.copyWith(
          inflationRate: 0.03,
          reerReturnRate: 0.06,
        );
        await repository.updateProjectData(updatedProject);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.inflationRate, 0.03);
        expect(retrieved.reerReturnRate, 0.06);
      });

      test('should update project individuals', () async {
        final project = await repository.createProject(name: 'Test');

        final updatedProject = project.copyWith(
          individuals: [
            Individual(
              id: 'ind-1',
              name: 'John Doe',
              birthdate: DateTime(1965, 1, 1),
              employmentIncome: 80000,
              rrqStartAge: 65,
              psvStartAge: 65,
              initialCeliRoom: 95000,
            ),
          ],
        );

        await repository.updateProjectData(updatedProject);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.individuals.length, 1);
        expect(retrieved.individuals[0].name, 'John Doe');
        expect(retrieved.individuals[0].employmentIncome, 80000);
      });

      test('should preserve nested individual data', () async {
        final project = await repository.createProject(name: 'Test');

        final individual = Individual(
          id: 'ind-1',
          name: 'Jane Doe',
          birthdate: DateTime(1970, 6, 15),
          employmentIncome: 75000,
          rrqStartAge: 65,
          psvStartAge: 67,
          initialCeliRoom: 88000,
          hasRrpe: true,
          rrpeParticipationStartDate: DateTime(2020, 1, 1),
        );

        final updatedProject = project.copyWith(individuals: [individual]);
        await repository.updateProjectData(updatedProject);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.individuals[0].birthdate, DateTime(1970, 6, 15));
        expect(retrieved.individuals[0].hasRrpe, true);
        expect(
          retrieved.individuals[0].rrpeParticipationStartDate,
          DateTime(2020, 1, 1),
        );
      });
    });

    group('Delete Project', () {
      test('should delete project from Firestore', () async {
        final project = await repository.createProject(name: 'To Delete');

        await repository.deleteProject(project.id);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved, isNull);
      });

      test('should remove project from stream', () async {
        final project1 = await repository.createProject(name: 'Project 1');
        final project2 = await repository.createProject(name: 'Project 2');

        await repository.deleteProject(project1.id);

        final projects = await repository.getProjectsStream().first;
        expect(projects.length, 1);
        expect(projects[0].id, project2.id);
      });
    });

    group('Timestamp Conversion', () {
      test('should handle DateTime fields in nested individuals', () async {
        final project = await repository.createProject(name: 'Test');

        final individual = Individual(
          id: 'ind-1',
          name: 'Test User',
          birthdate: DateTime(1980, 3, 15, 10, 30),
          employmentIncome: 60000,
          rrqStartAge: 65,
          psvStartAge: 65,
          initialCeliRoom: 70000,
          hasRrpe: true,
          rrpeParticipationStartDate: DateTime(2015, 6, 30, 17, 0),
        );

        final updatedProject = project.copyWith(individuals: [individual]);
        await repository.updateProjectData(updatedProject);

        final retrieved = await repository.getProject(project.id);

        // Verify DateTime values are preserved (not just dates)
        expect(retrieved!.individuals[0].birthdate.year, 1980);
        expect(retrieved.individuals[0].birthdate.month, 3);
        expect(retrieved.individuals[0].birthdate.day, 15);

        expect(retrieved.individuals[0].rrpeParticipationStartDate!.year, 2015);
        expect(retrieved.individuals[0].rrpeParticipationStartDate!.month, 6);
        expect(retrieved.individuals[0].rrpeParticipationStartDate!.day, 30);
      });

      test('should handle multiple individuals with different dates', () async {
        final project = await repository.createProject(name: 'Couple');

        final individuals = [
          Individual(
            id: 'ind-1',
            name: 'Person 1',
            birthdate: DateTime(1960, 1, 1),
            employmentIncome: 80000,
            rrqStartAge: 65,
            psvStartAge: 65,
            initialCeliRoom: 95000,
          ),
          Individual(
            id: 'ind-2',
            name: 'Person 2',
            birthdate: DateTime(1962, 12, 31),
            employmentIncome: 70000,
            rrqStartAge: 65,
            psvStartAge: 67,
            initialCeliRoom: 90000,
          ),
        ];

        final updatedProject = project.copyWith(individuals: individuals);
        await repository.updateProjectData(updatedProject);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.individuals.length, 2);
        expect(retrieved.individuals[0].birthdate, DateTime(1960, 1, 1));
        expect(retrieved.individuals[1].birthdate, DateTime(1962, 12, 31));
      });
    });

    group('Data Integrity', () {
      test('should maintain all project fields through round-trip', () async {
        final original = await repository.createProject(
          name: 'Complete Project',
          description: 'Full test',
        );

        // Update with custom rates
        final withRates = original.copyWith(
          inflationRate: 0.025,
          reerReturnRate: 0.055,
          celiReturnRate: 0.05,
          criReturnRate: 0.05,
          cashReturnRate: 0.018,
        );
        await repository.updateProjectData(withRates);

        final retrieved = await repository.getProject(original.id);

        expect(retrieved!.name, withRates.name);
        expect(retrieved.description, withRates.description);
        expect(retrieved.ownerId, withRates.ownerId);
        expect(retrieved.inflationRate, withRates.inflationRate);
        expect(retrieved.reerReturnRate, withRates.reerReturnRate);
        expect(retrieved.celiReturnRate, withRates.celiReturnRate);
        expect(retrieved.criReturnRate, withRates.criReturnRate);
        expect(retrieved.cashReturnRate, withRates.cashReturnRate);
      });

      test('should handle projects with no individuals', () async {
        final project = await repository.createProject(name: 'Solo');

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.individuals, isEmpty);
      });

      test('should handle projects with multiple individuals', () async {
        final project = await repository.createProject(name: 'Family');

        final individuals = List.generate(
          3,
          (i) => Individual(
            id: 'ind-$i',
            name: 'Person $i',
            birthdate: DateTime(1960 + i, 1, 1),
            employmentIncome: 50000.0 + (i * 10000),
            rrqStartAge: 65,
            psvStartAge: 65,
            initialCeliRoom: 80000 + (i * 5000.0),
          ),
        );

        final updatedProject = project.copyWith(individuals: individuals);
        await repository.updateProjectData(updatedProject);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.individuals.length, 3);
        for (int i = 0; i < 3; i++) {
          expect(retrieved.individuals[i].name, 'Person $i');
          expect(
            retrieved.individuals[i].employmentIncome,
            50000.0 + (i * 10000),
          );
        }
      });
    });

    group('Error Handling', () {
      test('should handle empty project name', () async {
        final project = await repository.createProject(name: '');
        expect(project.name, '');
      });

      test('should handle null description', () async {
        final project = await repository.createProject(
          name: 'Test',
          description: null,
        );
        expect(project.description, isNull);
      });

      test('should handle zero return rates', () async {
        final project = await repository.createProject(name: 'Zero Rates');

        final withZeroRates = project.copyWith(
          inflationRate: 0.0,
          reerReturnRate: 0.0,
        );
        await repository.updateProjectData(withZeroRates);

        final retrieved = await repository.getProject(project.id);
        expect(retrieved!.inflationRate, 0.0);
        expect(retrieved.reerReturnRate, 0.0);
      });
    });
  });
}
