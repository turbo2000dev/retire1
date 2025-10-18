import 'package:freezed_annotation/freezed_annotation.dart';

part 'wizard_section.freezed.dart';
part 'wizard_section.g.dart';

/// Definition of a wizard section
@freezed
class WizardSection with _$WizardSection {
  const factory WizardSection({
    required String id,
    required String titleKey,
    required String descriptionKey,
    required WizardSectionCategory category,
    required bool isRequired,
    required bool isEducational,
    @Default(0) int orderIndex,
    String? dependsOnSectionId,
  }) = _WizardSection;

  factory WizardSection.fromJson(Map<String, dynamic> json) =>
      _$WizardSectionFromJson(json);
}

/// Category of wizard sections for grouping
enum WizardSectionCategory {
  gettingStarted,
  individuals,
  financialSituation,
  retirementIncome,
  keyEvents,
  scenariosReview,
}
