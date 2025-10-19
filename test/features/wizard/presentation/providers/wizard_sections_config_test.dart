import 'package:flutter_test/flutter_test.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';
import 'package:retire1/features/wizard/presentation/providers/wizard_sections_config.dart';

void main() {
  group('WizardSectionsConfig', () {
    group('Section Definitions', () {
      test('should have exactly 12 sections', () {
        expect(WizardSectionsConfig.sections.length, 12);
      });

      test('should have sections in correct order', () {
        final sections = WizardSectionsConfig.sections;

        for (int i = 0; i < sections.length; i++) {
          expect(sections[i].orderIndex, i + 1);
        }
      });

      test('should have unique section IDs', () {
        final ids = WizardSectionsConfig.sections.map((s) => s.id).toList();
        final uniqueIds = ids.toSet();

        expect(ids.length, uniqueIds.length);
      });

      test('should have all required fields populated', () {
        for (final section in WizardSectionsConfig.sections) {
          expect(section.id, isNotEmpty);
          expect(section.titleKey, isNotEmpty);
          expect(section.descriptionKey, isNotEmpty);
          expect(section.category, isNotNull);
          expect(section.orderIndex, greaterThan(0));
        }
      });
    });

    group('Section Categories', () {
      test('Getting Started should have 2 sections', () {
        final sections = WizardSectionsConfig.getSectionsByCategory(
          WizardSectionCategory.gettingStarted,
        );
        expect(sections.length, 2);
        expect(sections[0].id, 'welcome');
        expect(sections[1].id, 'project-basics');
      });

      test('Individuals should have 2 sections', () {
        final sections = WizardSectionsConfig.getSectionsByCategory(
          WizardSectionCategory.individuals,
        );
        expect(sections.length, 2);
        expect(sections[0].id, 'primary-individual');
        expect(sections[1].id, 'partner');
      });

      test('Financial Situation should have 3 sections', () {
        final sections = WizardSectionsConfig.getSectionsByCategory(
          WizardSectionCategory.financialSituation,
        );
        expect(sections.length, 3);
        expect(sections[0].id, 'assets');
        expect(sections[1].id, 'employment');
        expect(sections[2].id, 'benefits-education');
      });

      test('Retirement Income should have 2 sections', () {
        final sections = WizardSectionsConfig.getSectionsByCategory(
          WizardSectionCategory.retirementIncome,
        );
        expect(sections.length, 2);
        expect(sections[0].id, 'government-benefits');
        expect(sections[1].id, 'expenses');
      });

      test('Key Events should have 2 sections', () {
        final sections = WizardSectionsConfig.getSectionsByCategory(
          WizardSectionCategory.keyEvents,
        );
        expect(sections.length, 2);
        expect(sections[0].id, 'retirement-timing');
        expect(sections[1].id, 'life-events');
      });

      test('Scenarios Review should have 1 section', () {
        final sections = WizardSectionsConfig.getSectionsByCategory(
          WizardSectionCategory.scenariosReview,
        );
        expect(sections.length, 1);
        expect(sections[0].id, 'summary');
      });
    });

    group('Required vs Optional', () {
      test('should have correct number of required sections', () {
        final required = WizardSectionsConfig.getRequiredSections();
        // project-basics, primary-individual, government-benefits, expenses, retirement-timing, summary
        expect(required.length, 6);
      });

      test('required sections should be marked as required', () {
        final required = WizardSectionsConfig.getRequiredSections();

        for (final section in required) {
          expect(section.isRequired, isTrue);
        }
      });

      test('project-basics should be required', () {
        final section = WizardSectionsConfig.getSectionById('project-basics');
        expect(section, isNotNull);
        expect(section!.isRequired, isTrue);
      });

      test('primary-individual should be required', () {
        final section = WizardSectionsConfig.getSectionById(
          'primary-individual',
        );
        expect(section, isNotNull);
        expect(section!.isRequired, isTrue);
      });

      test('government-benefits should be required', () {
        final section = WizardSectionsConfig.getSectionById(
          'government-benefits',
        );
        expect(section, isNotNull);
        expect(section!.isRequired, isTrue);
      });

      test('expenses should be required', () {
        final section = WizardSectionsConfig.getSectionById('expenses');
        expect(section, isNotNull);
        expect(section!.isRequired, isTrue);
      });

      test('retirement-timing should be required', () {
        final section = WizardSectionsConfig.getSectionById(
          'retirement-timing',
        );
        expect(section, isNotNull);
        expect(section!.isRequired, isTrue);
      });

      test('summary should be required', () {
        final section = WizardSectionsConfig.getSectionById('summary');
        expect(section, isNotNull);
        expect(section!.isRequired, isTrue);
      });

      test('optional sections should not be required', () {
        final optional = [
          'welcome',
          'partner',
          'assets',
          'employment',
          'benefits-education',
          'life-events',
        ];

        for (final id in optional) {
          final section = WizardSectionsConfig.getSectionById(id);
          expect(section, isNotNull);
          expect(
            section!.isRequired,
            isFalse,
            reason: '$id should be optional',
          );
        }
      });
    });

    group('Educational Sections', () {
      test('should have correct educational sections', () {
        final educational = WizardSectionsConfig.getEducationalSections();
        expect(educational.length, 2);
      });

      test('welcome should be educational', () {
        final section = WizardSectionsConfig.getSectionById('welcome');
        expect(section, isNotNull);
        expect(section!.isEducational, isTrue);
      });

      test('benefits-education should be educational', () {
        final section = WizardSectionsConfig.getSectionById(
          'benefits-education',
        );
        expect(section, isNotNull);
        expect(section!.isEducational, isTrue);
      });

      test('non-educational sections should be marked correctly', () {
        final nonEducational = [
          'project-basics',
          'primary-individual',
          'partner',
          'assets',
          'employment',
          'government-benefits',
          'expenses',
          'retirement-timing',
          'life-events',
          'summary',
        ];

        for (final id in nonEducational) {
          final section = WizardSectionsConfig.getSectionById(id);
          expect(section, isNotNull);
          expect(
            section!.isEducational,
            isFalse,
            reason: '$id should not be educational',
          );
        }
      });
    });

    group('Section Dependencies', () {
      test('primary-individual should depend on project-basics', () {
        final section = WizardSectionsConfig.getSectionById(
          'primary-individual',
        );
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, 'project-basics');
      });

      test('partner should depend on primary-individual', () {
        final section = WizardSectionsConfig.getSectionById('partner');
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, 'primary-individual');
      });

      test('assets should depend on primary-individual', () {
        final section = WizardSectionsConfig.getSectionById('assets');
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, 'primary-individual');
      });

      test('employment should depend on primary-individual', () {
        final section = WizardSectionsConfig.getSectionById('employment');
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, 'primary-individual');
      });

      test('government-benefits should depend on primary-individual', () {
        final section = WizardSectionsConfig.getSectionById(
          'government-benefits',
        );
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, 'primary-individual');
      });

      test('retirement-timing should depend on primary-individual', () {
        final section = WizardSectionsConfig.getSectionById(
          'retirement-timing',
        );
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, 'primary-individual');
      });

      test('welcome should have no dependencies', () {
        final section = WizardSectionsConfig.getSectionById('welcome');
        expect(section, isNotNull);
        expect(section!.dependsOnSectionId, isNull);
      });
    });

    group('getSectionById', () {
      test('should return section for valid ID', () {
        final section = WizardSectionsConfig.getSectionById('project-basics');
        expect(section, isNotNull);
        expect(section!.id, 'project-basics');
      });

      test('should return null for invalid ID', () {
        final section = WizardSectionsConfig.getSectionById('invalid-id');
        expect(section, isNull);
      });

      test('should work for all section IDs', () {
        final allIds = [
          'welcome',
          'project-basics',
          'primary-individual',
          'partner',
          'assets',
          'employment',
          'benefits-education',
          'government-benefits',
          'expenses',
          'retirement-timing',
          'life-events',
          'summary',
        ];

        for (final id in allIds) {
          final section = WizardSectionsConfig.getSectionById(id);
          expect(section, isNotNull, reason: 'Section $id should exist');
          expect(section!.id, id);
        }
      });
    });

    group('getNextSection', () {
      test('should return next section in order', () {
        final next = WizardSectionsConfig.getNextSection('welcome');
        expect(next, isNotNull);
        expect(next!.id, 'project-basics');
      });

      test('should return null for last section', () {
        final next = WizardSectionsConfig.getNextSection('summary');
        expect(next, isNull);
      });

      test('should return null for invalid section', () {
        final next = WizardSectionsConfig.getNextSection('invalid-id');
        expect(next, isNull);
      });

      test('should navigate through all sections', () {
        String? currentId = 'welcome';
        int count = 0;

        while (currentId != null && count < 20) {
          final next = WizardSectionsConfig.getNextSection(currentId);
          if (next == null) break;
          currentId = next.id;
          count++;
        }

        expect(
          count,
          11,
        ); // Should navigate through 11 sections (12 total - 1 starting)
      });
    });

    group('getPreviousSection', () {
      test('should return previous section in order', () {
        final prev = WizardSectionsConfig.getPreviousSection('project-basics');
        expect(prev, isNotNull);
        expect(prev!.id, 'welcome');
      });

      test('should return null for first section', () {
        final prev = WizardSectionsConfig.getPreviousSection('welcome');
        expect(prev, isNull);
      });

      test('should return null for invalid section', () {
        final prev = WizardSectionsConfig.getPreviousSection('invalid-id');
        expect(prev, isNull);
      });

      test('should navigate backwards through all sections', () {
        String? currentId = 'summary';
        int count = 0;

        while (currentId != null && count < 20) {
          final prev = WizardSectionsConfig.getPreviousSection(currentId);
          if (prev == null) break;
          currentId = prev.id;
          count++;
        }

        expect(count, 11); // Should navigate through 11 sections backwards
      });
    });

    group('Category Metadata', () {
      test('should have title keys for all categories', () {
        for (final category in WizardSectionCategory.values) {
          expect(
            WizardSectionsConfig.categoryTitleKeys.containsKey(category),
            isTrue,
            reason: 'Missing title key for $category',
          );
        }
      });

      test('should have icons for all categories', () {
        for (final category in WizardSectionCategory.values) {
          expect(
            WizardSectionsConfig.categoryIcons.containsKey(category),
            isTrue,
            reason: 'Missing icon for $category',
          );
        }
      });

      test('category icons should not be empty', () {
        for (final icon in WizardSectionsConfig.categoryIcons.values) {
          expect(icon, isNotEmpty);
        }
      });

      test('category title keys should not be empty', () {
        for (final key in WizardSectionsConfig.categoryTitleKeys.values) {
          expect(key, isNotEmpty);
        }
      });
    });
  });
}
