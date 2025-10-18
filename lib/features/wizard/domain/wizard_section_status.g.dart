// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wizard_section_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WizardSectionStatusImpl _$$WizardSectionStatusImplFromJson(
  Map<String, dynamic> json,
) => _$WizardSectionStatusImpl(
  state: $enumDecode(_$WizardSectionStateEnumMap, json['state']),
  lastVisited: json['lastVisited'] == null
      ? null
      : DateTime.parse(json['lastVisited'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  validationWarnings:
      (json['validationWarnings'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$WizardSectionStatusImplToJson(
  _$WizardSectionStatusImpl instance,
) => <String, dynamic>{
  'state': _$WizardSectionStateEnumMap[instance.state]!,
  'lastVisited': instance.lastVisited?.toIso8601String(),
  'completedAt': instance.completedAt?.toIso8601String(),
  'validationWarnings': instance.validationWarnings,
};

const _$WizardSectionStateEnumMap = {
  WizardSectionState.notStarted: 'notStarted',
  WizardSectionState.inProgress: 'inProgress',
  WizardSectionState.skipped: 'skipped',
  WizardSectionState.complete: 'complete',
  WizardSectionState.needsAttention: 'needsAttention',
};
