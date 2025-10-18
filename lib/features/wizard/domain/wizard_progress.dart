import 'package:freezed_annotation/freezed_annotation.dart';
import 'wizard_section_status.dart';

part 'wizard_progress.freezed.dart';
part 'wizard_progress.g.dart';

/// Tracks user's progress through the wizard for a specific project
@freezed
class WizardProgress with _$WizardProgress {
  const factory WizardProgress({
    required String projectId,
    required String userId,
    @Default('welcome') String currentSectionId,
    @Default({}) Map<String, WizardSectionStatus> sectionStatuses,
    required DateTime lastUpdated,
    required DateTime createdAt,
    bool? wizardCompleted,
    DateTime? completedAt,
  }) = _WizardProgress;

  factory WizardProgress.fromJson(Map<String, dynamic> json) =>
      _$WizardProgressFromJson(json);

  const WizardProgress._();

  /// Create a new wizard progress for a project
  factory WizardProgress.create({
    required String projectId,
    required String userId,
  }) {
    final now = DateTime.now();
    return WizardProgress(
      projectId: projectId,
      userId: userId,
      currentSectionId: 'welcome',
      sectionStatuses: {},
      lastUpdated: now,
      createdAt: now,
      wizardCompleted: false,
    );
  }

  /// Get status for a specific section
  WizardSectionStatus getStatus(String sectionId) {
    return sectionStatuses[sectionId] ?? WizardSectionStatus.notStarted();
  }

  /// Calculate overall completion percentage
  double calculateProgress(int totalRequiredSections) {
    if (totalRequiredSections == 0) return 0.0;

    final completedCount = sectionStatuses.values
        .where((status) => status.state == WizardSectionState.complete)
        .length;

    return (completedCount / totalRequiredSections) * 100;
  }

  /// Check if all required sections are complete
  bool areRequiredSectionsComplete(List<String> requiredSectionIds) {
    return requiredSectionIds.every((id) {
      final status = getStatus(id);
      return status.state == WizardSectionState.complete;
    });
  }
}
