// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wizard_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WizardProgressImpl _$$WizardProgressImplFromJson(Map<String, dynamic> json) =>
    _$WizardProgressImpl(
      projectId: json['projectId'] as String,
      userId: json['userId'] as String,
      currentSectionId: json['currentSectionId'] as String? ?? 'welcome',
      sectionStatuses:
          (json['sectionStatuses'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              WizardSectionStatus.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      wizardCompleted: json['wizardCompleted'] as bool?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$WizardProgressImplToJson(
  _$WizardProgressImpl instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'userId': instance.userId,
  'currentSectionId': instance.currentSectionId,
  'sectionStatuses': instance.sectionStatuses.map(
    (k, e) => MapEntry(k, e.toJson()),
  ),
  'lastUpdated': instance.lastUpdated.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'wizardCompleted': instance.wizardCompleted,
  'completedAt': instance.completedAt?.toIso8601String(),
};
