import 'package:freezed_annotation/freezed_annotation.dart';

part 'wizard_section_status.freezed.dart';
part 'wizard_section_status.g.dart';

/// Status of a wizard section
@freezed
class WizardSectionStatus with _$WizardSectionStatus {
  const factory WizardSectionStatus({
    required WizardSectionState state,
    DateTime? lastVisited,
    DateTime? completedAt,
    @Default([]) List<String> validationWarnings,
  }) = _WizardSectionStatus;

  factory WizardSectionStatus.fromJson(Map<String, dynamic> json) =>
      _$WizardSectionStatusFromJson(json);

  const WizardSectionStatus._();

  /// Create a new "not started" status
  factory WizardSectionStatus.notStarted() => const WizardSectionStatus(
        state: WizardSectionState.notStarted,
      );

  /// Create a new "in progress" status
  factory WizardSectionStatus.inProgress() => WizardSectionStatus(
        state: WizardSectionState.inProgress,
        lastVisited: DateTime.now(),
      );

  /// Create a new "skipped" status
  factory WizardSectionStatus.skipped() => WizardSectionStatus(
        state: WizardSectionState.skipped,
        lastVisited: DateTime.now(),
      );

  /// Create a new "complete" status
  factory WizardSectionStatus.complete() => WizardSectionStatus(
        state: WizardSectionState.complete,
        completedAt: DateTime.now(),
        lastVisited: DateTime.now(),
      );

  /// Create a new "needs attention" status with warnings
  factory WizardSectionStatus.needsAttention(List<String> warnings) =>
      WizardSectionStatus(
        state: WizardSectionState.needsAttention,
        lastVisited: DateTime.now(),
        validationWarnings: warnings,
      );

  /// Icon for this status
  String get icon => switch (state) {
        WizardSectionState.notStarted => '⏹️',
        WizardSectionState.inProgress => '🔄',
        WizardSectionState.skipped => '⏸️',
        WizardSectionState.complete => '✅',
        WizardSectionState.needsAttention => '⚠️',
      };

  /// Whether this section is considered done
  bool get isDone =>
      state == WizardSectionState.complete ||
      state == WizardSectionState.skipped;
}

/// State of a wizard section
enum WizardSectionState {
  notStarted,
  inProgress,
  skipped,
  complete,
  needsAttention,
}
