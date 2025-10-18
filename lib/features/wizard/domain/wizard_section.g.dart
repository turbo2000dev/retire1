// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wizard_section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WizardSectionImpl _$$WizardSectionImplFromJson(Map<String, dynamic> json) =>
    _$WizardSectionImpl(
      id: json['id'] as String,
      titleKey: json['titleKey'] as String,
      descriptionKey: json['descriptionKey'] as String,
      category: $enumDecode(_$WizardSectionCategoryEnumMap, json['category']),
      isRequired: json['isRequired'] as bool,
      isEducational: json['isEducational'] as bool,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
      dependsOnSectionId: json['dependsOnSectionId'] as String?,
    );

Map<String, dynamic> _$$WizardSectionImplToJson(_$WizardSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titleKey': instance.titleKey,
      'descriptionKey': instance.descriptionKey,
      'category': _$WizardSectionCategoryEnumMap[instance.category]!,
      'isRequired': instance.isRequired,
      'isEducational': instance.isEducational,
      'orderIndex': instance.orderIndex,
      'dependsOnSectionId': instance.dependsOnSectionId,
    };

const _$WizardSectionCategoryEnumMap = {
  WizardSectionCategory.gettingStarted: 'gettingStarted',
  WizardSectionCategory.individuals: 'individuals',
  WizardSectionCategory.financialSituation: 'financialSituation',
  WizardSectionCategory.retirementIncome: 'retirementIncome',
  WizardSectionCategory.keyEvents: 'keyEvents',
  WizardSectionCategory.scenariosReview: 'scenariosReview',
};
