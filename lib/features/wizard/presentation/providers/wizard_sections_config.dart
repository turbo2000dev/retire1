import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/wizard/domain/wizard_section.dart';

/// Configuration of all wizard sections
/// Defines the 12 sections with their metadata
class WizardSectionsConfig {
  /// All wizard sections in order
  static final List<WizardSection> sections = [
    // GETTING STARTED (2 sections)
    WizardSection(
      id: 'welcome',
      titleKey: 'section1Title',
      descriptionKey: 'section1Description',
      category: WizardSectionCategory.gettingStarted,
      isRequired: false,
      isEducational: true,
      orderIndex: 1,
    ),
    WizardSection(
      id: 'project-basics',
      titleKey: 'section2Title',
      descriptionKey: 'section2Description',
      category: WizardSectionCategory.gettingStarted,
      isRequired: true,
      isEducational: false,
      orderIndex: 2,
    ),

    // INDIVIDUALS (2 sections)
    WizardSection(
      id: 'primary-individual',
      titleKey: 'section3Title',
      descriptionKey: 'section3Description',
      category: WizardSectionCategory.individuals,
      isRequired: true,
      isEducational: false,
      orderIndex: 3,
      dependsOnSectionId: 'project-basics',
    ),
    WizardSection(
      id: 'partner',
      titleKey: 'section4Title',
      descriptionKey: 'section4Description',
      category: WizardSectionCategory.individuals,
      isRequired: false,
      isEducational: false,
      orderIndex: 4,
      dependsOnSectionId: 'primary-individual',
    ),

    // FINANCIAL SITUATION (3 sections)
    WizardSection(
      id: 'assets',
      titleKey: 'section5Title',
      descriptionKey: 'section5Description',
      category: WizardSectionCategory.financialSituation,
      isRequired: false,
      isEducational: false,
      orderIndex: 5,
      dependsOnSectionId: 'primary-individual',
    ),
    WizardSection(
      id: 'employment',
      titleKey: 'section6Title',
      descriptionKey: 'section6Description',
      category: WizardSectionCategory.financialSituation,
      isRequired: false,
      isEducational: false,
      orderIndex: 6,
      dependsOnSectionId: 'primary-individual',
    ),
    WizardSection(
      id: 'benefits-education',
      titleKey: 'section7Title',
      descriptionKey: 'section7Description',
      category: WizardSectionCategory.financialSituation,
      isRequired: false,
      isEducational: true,
      orderIndex: 7,
    ),

    // RETIREMENT INCOME (2 sections)
    WizardSection(
      id: 'government-benefits',
      titleKey: 'section8Title',
      descriptionKey: 'section8Description',
      category: WizardSectionCategory.retirementIncome,
      isRequired: true,
      isEducational: false,
      orderIndex: 8,
      dependsOnSectionId: 'primary-individual',
    ),
    WizardSection(
      id: 'expenses',
      titleKey: 'section9Title',
      descriptionKey: 'section9Description',
      category: WizardSectionCategory.retirementIncome,
      isRequired: true,
      isEducational: false,
      orderIndex: 9,
    ),

    // KEY EVENTS (2 sections)
    WizardSection(
      id: 'retirement-timing',
      titleKey: 'section10Title',
      descriptionKey: 'section10Description',
      category: WizardSectionCategory.keyEvents,
      isRequired: true,
      isEducational: false,
      orderIndex: 10,
      dependsOnSectionId: 'primary-individual',
    ),
    WizardSection(
      id: 'life-events',
      titleKey: 'section11Title',
      descriptionKey: 'section11Description',
      category: WizardSectionCategory.keyEvents,
      isRequired: false,
      isEducational: false,
      orderIndex: 11,
    ),

    // SCENARIOS & REVIEW (1 section)
    WizardSection(
      id: 'summary',
      titleKey: 'section12Title',
      descriptionKey: 'section12Description',
      category: WizardSectionCategory.scenariosReview,
      isRequired: true,
      isEducational: false,
      orderIndex: 12,
    ),
  ];

  /// Get section by ID
  static WizardSection? getSectionById(String id) {
    try {
      return sections.firstWhere((section) => section.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all required sections
  static List<WizardSection> getRequiredSections() {
    return sections.where((section) => section.isRequired).toList();
  }

  /// Get all educational sections
  static List<WizardSection> getEducationalSections() {
    return sections.where((section) => section.isEducational).toList();
  }

  /// Get sections by category
  static List<WizardSection> getSectionsByCategory(
    WizardSectionCategory category,
  ) {
    return sections.where((section) => section.category == category).toList();
  }

  /// Get next section after given section ID
  static WizardSection? getNextSection(String currentSectionId) {
    final currentIndex = sections.indexWhere((s) => s.id == currentSectionId);
    if (currentIndex == -1 || currentIndex == sections.length - 1) {
      return null;
    }
    return sections[currentIndex + 1];
  }

  /// Get previous section before given section ID
  static WizardSection? getPreviousSection(String currentSectionId) {
    final currentIndex = sections.indexWhere((s) => s.id == currentSectionId);
    if (currentIndex <= 0) {
      return null;
    }
    return sections[currentIndex - 1];
  }

  /// Category display names (i18n keys)
  static Map<WizardSectionCategory, String> categoryTitleKeys = {
    WizardSectionCategory.gettingStarted: 'categoryGettingStarted',
    WizardSectionCategory.individuals: 'categoryIndividuals',
    WizardSectionCategory.financialSituation: 'categoryFinancialSituation',
    WizardSectionCategory.retirementIncome: 'categoryRetirementIncome',
    WizardSectionCategory.keyEvents: 'categoryKeyEvents',
    WizardSectionCategory.scenariosReview: 'categoryScenariosReview',
  };

  /// Category icons
  static Map<WizardSectionCategory, String> categoryIcons = {
    WizardSectionCategory.gettingStarted: '🎯',
    WizardSectionCategory.individuals: '👥',
    WizardSectionCategory.financialSituation: '💰',
    WizardSectionCategory.retirementIncome: '📊',
    WizardSectionCategory.keyEvents: '🎯',
    WizardSectionCategory.scenariosReview: '📈',
  };
}

/// Provider for all wizard sections
final wizardSectionsProvider = Provider<List<WizardSection>>((ref) {
  return WizardSectionsConfig.sections;
});

/// Provider for required sections only
final requiredSectionsProvider = Provider<List<WizardSection>>((ref) {
  return WizardSectionsConfig.getRequiredSections();
});

/// Provider for educational sections only
final educationalSectionsProvider = Provider<List<WizardSection>>((ref) {
  return WizardSectionsConfig.getEducationalSections();
});

/// Provider for a specific section by ID
final sectionByIdProvider = Provider.family<WizardSection?, String>((ref, id) {
  return WizardSectionsConfig.getSectionById(id);
});
