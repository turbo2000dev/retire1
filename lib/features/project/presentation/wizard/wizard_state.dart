import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:retire1/features/project/domain/individual.dart';

part 'wizard_state.freezed.dart';

/// Wizard state for collecting project setup data
/// Data is held in memory and only committed to Firestore at the end
@freezed
class WizardState with _$WizardState {
  const factory WizardState({
    // Current step in the wizard (0-based index)
    @Default(0) int currentStep,

    // Project ID that wizard is populating
    required String projectId,

    // Step 1: Individuals (1-2 individuals)
    Individual? individual1,
    Individual? individual2,

    // Step 2: Revenue Sources (tracked per individual)
    @Default(WizardRevenueSourcesData()) WizardRevenueSourcesData revenueSources,

    // Step 3: Assets
    @Default([]) List<WizardAssetData> assets,

    // Step 4: Expenses
    @Default(WizardExpensesData()) WizardExpensesData expenses,

    // Step 5: Scenarios (which scenario templates to create)
    @Default(WizardScenariosData()) WizardScenariosData scenarios,
  }) = _WizardState;
}

/// Revenue sources configuration per individual
@freezed
class WizardRevenueSourcesData with _$WizardRevenueSourcesData {
  const factory WizardRevenueSourcesData({
    // Individual 1 revenue sources
    @Default(true) bool individual1HasRrq,
    @Default(true) bool individual1HasPsv,
    @Default(false) bool individual1HasRrpe,
    @Default(false) bool individual1HasEmployment,
    @Default(false) bool individual1HasOther,

    // Individual 2 revenue sources (if applicable)
    @Default(true) bool individual2HasRrq,
    @Default(true) bool individual2HasPsv,
    @Default(false) bool individual2HasRrpe,
    @Default(false) bool individual2HasEmployment,
    @Default(false) bool individual2HasOther,

    // RRQ details for Individual 1
    @Default(65) int individual1RrqStartAge,
    @Default(12000.0) double individual1RrqAmountAt60,
    @Default(16000.0) double individual1RrqAmountAt65,

    // PSV details for Individual 1
    @Default(65) int individual1PsvStartAge,

    // RRPE details for Individual 1
    DateTime? individual1RrpeStartDate,

    // RRQ details for Individual 2
    @Default(65) int individual2RrqStartAge,
    @Default(12000.0) double individual2RrqAmountAt60,
    @Default(16000.0) double individual2RrqAmountAt65,

    // PSV details for Individual 2
    @Default(65) int individual2PsvStartAge,

    // RRPE details for Individual 2
    DateTime? individual2RrpeStartDate,
  }) = _WizardRevenueSourcesData;
}

/// Asset data collected in wizard (simplified compared to full Asset model)
@freezed
class WizardAssetData with _$WizardAssetData {
  const factory WizardAssetData.realEstate({
    required String id,
    required double value,
  }) = WizardRealEstateData;

  const factory WizardAssetData.rrsp({
    required String id,
    required String individualId, // References Individual 1 or 2
    required double value,
    double? annualContribution,
  }) = WizardRrspData;

  const factory WizardAssetData.celi({
    required String id,
    required String individualId,
    required double value,
    double? annualContribution,
  }) = WizardCeliData;

  const factory WizardAssetData.cri({
    required String id,
    required String individualId,
    required double value,
  }) = WizardCriData;

  const factory WizardAssetData.cash({
    required String id,
    required String individualId,
    required double value,
  }) = WizardCashData;
}

/// Expenses configuration
@freezed
class WizardExpensesData with _$WizardExpensesData {
  const factory WizardExpensesData({
    @Default(0.0) double housingAmount,
    @Default(0.0) double transportAmount,
    @Default(0.0) double dailyLivingAmount,
    @Default(0.0) double recreationAmount,
    @Default(0.0) double healthAmount,
    @Default(0.0) double familyAmount,

    // Timing: when expenses start
    @Default(ExpenseStartTiming.now) ExpenseStartTiming startTiming,
    int? customStartYear,
  }) = _WizardExpensesData;
}

/// When expenses should start
enum ExpenseStartTiming {
  now, // Projection start
  atRetirement, // At earliest retirement
  custom, // Custom year
}

/// Scenarios to create
@freezed
class WizardScenariosData with _$WizardScenariosData {
  const factory WizardScenariosData({
    @Default(true) bool createBase, // Always true (required)
    @Default(false) bool createOptimistic,
    @Default(false) bool createPessimistic,
    @Default(false) bool createEarlyRetirement,
    @Default(false) bool createLateRetirement,
  }) = _WizardScenariosData;
}
