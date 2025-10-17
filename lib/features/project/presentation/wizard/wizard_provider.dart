import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_state.dart';

/// Provider for wizard state management
final wizardProvider = StateNotifierProvider<WizardNotifier, WizardState?>((ref) {
  return WizardNotifier();
});

/// Wizard state notifier - manages the wizard flow and data collection
class WizardNotifier extends StateNotifier<WizardState?> {
  WizardNotifier() : super(null);

  /// Initialize wizard for a project
  void initialize(String projectId) {
    state = WizardState(projectId: projectId);
  }

  /// Clear wizard state (on completion or cancellation)
  void clear() {
    state = null;
  }

  /// Navigate to a specific step
  void goToStep(int step) {
    if (state == null) return;
    if (step < 0 || step > 5) return; // 6 steps (0-5)
    state = state!.copyWith(currentStep: step);
  }

  /// Move to next step
  void nextStep() {
    if (state == null) return;
    if (state!.currentStep < 5) {
      state = state!.copyWith(currentStep: state!.currentStep + 1);
    }
  }

  /// Move to previous step
  void previousStep() {
    if (state == null) return;
    if (state!.currentStep > 0) {
      state = state!.copyWith(currentStep: state!.currentStep - 1);
    }
  }

  // ============================================================================
  // Step 1: Individuals
  // ============================================================================

  /// Update Individual 1 (required)
  void updateIndividual1(Individual individual) {
    if (state == null) return;
    state = state!.copyWith(individual1: individual);
  }

  /// Update Individual 2 (optional)
  void updateIndividual2(Individual? individual) {
    if (state == null) return;
    state = state!.copyWith(individual2: individual);
  }

  /// Remove Individual 2
  void removeIndividual2() {
    if (state == null) return;
    state = state!.copyWith(individual2: null);
  }

  // ============================================================================
  // Step 2: Revenue Sources
  // ============================================================================

  /// Update revenue sources data
  void updateRevenueSources(WizardRevenueSourcesData revenueSourcesData) {
    if (state == null) return;
    state = state!.copyWith(revenueSources: revenueSourcesData);
  }

  // ============================================================================
  // Step 3: Assets
  // ============================================================================

  /// Add an asset
  void addAsset(WizardAssetData asset) {
    if (state == null) return;
    state = state!.copyWith(assets: [...state!.assets, asset]);
  }

  /// Update an asset at index
  void updateAsset(int index, WizardAssetData asset) {
    if (state == null) return;
    if (index < 0 || index >= state!.assets.length) return;
    final updatedAssets = [...state!.assets];
    updatedAssets[index] = asset;
    state = state!.copyWith(assets: updatedAssets);
  }

  /// Remove an asset at index
  void removeAsset(int index) {
    if (state == null) return;
    if (index < 0 || index >= state!.assets.length) return;
    final updatedAssets = [...state!.assets];
    updatedAssets.removeAt(index);
    state = state!.copyWith(assets: updatedAssets);
  }

  /// Clear all assets
  void clearAssets() {
    if (state == null) return;
    state = state!.copyWith(assets: []);
  }

  // ============================================================================
  // Step 4: Expenses
  // ============================================================================

  /// Update expenses data
  void updateExpenses(WizardExpensesData expensesData) {
    if (state == null) return;
    state = state!.copyWith(expenses: expensesData);
  }

  // ============================================================================
  // Step 5: Scenarios
  // ============================================================================

  /// Update scenarios data
  void updateScenarios(WizardScenariosData scenariosData) {
    if (state == null) return;
    state = state!.copyWith(scenarios: scenariosData);
  }

  // ============================================================================
  // Validation Helpers
  // ============================================================================

  /// Check if Individual 1 is filled
  bool hasIndividual1() {
    return state?.individual1 != null;
  }

  /// Check if Individual 2 is filled
  bool hasIndividual2() {
    return state?.individual2 != null;
  }

  /// Check if current step is valid and can proceed to next
  bool canProceedFromCurrentStep() {
    if (state == null) return false;

    switch (state!.currentStep) {
      case 0: // Individuals step - must have at least Individual 1
        return hasIndividual1();
      case 1: // Revenue sources - always can proceed (all optional)
        return true;
      case 2: // Assets - always can proceed (all optional)
        return true;
      case 3: // Expenses - always can proceed (defaults used)
        return true;
      case 4: // Scenarios - always can proceed (base scenario required, auto-selected)
        return true;
      case 5: // Summary - always can proceed to completion
        return true;
      default:
        return false;
    }
  }

  /// Check if wizard has any data entered
  bool hasAnyData() {
    if (state == null) return false;
    return state!.individual1 != null || state!.individual2 != null;
  }
}
