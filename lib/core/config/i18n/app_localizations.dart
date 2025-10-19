import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/config/i18n/app_localizations_en.dart';
import 'package:retire1/core/config/i18n/app_localizations_fr.dart';
import 'package:retire1/features/settings/presentation/providers/settings_provider.dart';

/// Provider to manage locale state based on user settings
final localeProvider = Provider<Locale>((ref) {
  final languageCode = ref.watch(currentLanguageProvider);
  return Locale(languageCode);
});

/// Base class for app localizations
/// Provides localized strings for the application in English and French
abstract class AppLocalizations {
  // Common strings
  String get appTitle;
  String get ok;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get create;
  String get yes;
  String get no;
  String get close;

  // Navigation
  String get dashboard;
  String get baseParameters;
  String get assetsAndEvents;
  String get scenarios;
  String get projection;
  String get settings;

  // Authentication
  String get login;
  String get logout;
  String get register;
  String get email;
  String get password;
  String get displayName;

  // Projects
  String get projects;
  String get createProject;
  String get editProject;
  String get deleteProject;
  String get projectName;
  String get projectDescription;

  // Individuals
  String get individuals;
  String get addIndividual;
  String get editIndividual;
  String get deleteIndividual;
  String get individualName;
  String get birthdate;
  String get age;

  // Assets
  String get assets;
  String get addAsset;
  String get editAsset;
  String get deleteAsset;
  String get realEstate;
  String get rrspAccount;
  String get celiAccount;
  String get cashAccount;
  String get value;

  // Events
  String get events;
  String get addEvent;
  String get editEvent;
  String get deleteEvent;
  String get retirement;
  String get death;
  String get realEstateTransaction;
  String get timing;

  // Settings
  String get language;
  String get english;
  String get french;

  // Validation
  String get requiredField;
  String get invalidEmail;
  String get passwordTooShort;
  String get passwordsDoNotMatch;

  // Empty states
  String get noProjects;
  String get noIndividuals;
  String get noAssets;
  String get noEvents;
  String get noScenarios;

  // Wizard - UI strings
  String get wizard;
  String get loadingWizard;
  String get failedToLoadWizard;
  String get launchWizard;
  String get resumeWizard;
  String get retry;
  String get previous;
  String get next;
  String get skip;
  String get finish;
  String get required;
  String get optional;
  String get errorLoadingSections;
  String get sections;

  // Wizard - Section titles
  String get section1Title;
  String get section2Title;
  String get section3Title;
  String get section4Title;
  String get section5Title;
  String get section6Title;
  String get section7Title;
  String get section8Title;
  String get section9Title;
  String get section10Title;
  String get section11Title;
  String get section12Title;

  // Wizard - Section descriptions
  String get section1Description;
  String get section2Description;
  String get section3Description;
  String get section4Description;
  String get section5Description;
  String get section6Description;
  String get section7Description;
  String get section8Description;
  String get section9Description;
  String get section10Description;
  String get section11Description;
  String get section12Description;

  // Wizard - Category titles
  String get categoryGettingStarted;
  String get categoryIndividuals;
  String get categoryFinancialSituation;
  String get categoryRetirementIncome;
  String get categoryKeyEvents;
  String get categoryScenariosReview;

  // Dashboard
  String get welcomeBack;
  String get selectProject;
  String get currentProject;
  String get executiveSummary;
  String get keyMetrics;
  String get quickActions;
  String get viewDetails;
  String get netWorth;
  String get monthlyIncome;
  String get monthlyExpenses;
  String get retirementAge;
  String get yearsToRetirement;

  // Project / Base Parameters
  String get projectDetails;
  String get economicAssumptions;
  String get inflationRate;
  String get investmentReturn;
  String get editProjectDetails;
  String get editIndividualDetails;
  String get editEconomicAssumptions;
  String get saveChanges;
  String get discardChanges;
  String get primary;
  String get partner;
  String get addPartner;
  String get removePartner;
  String get importData;
  String get exportData;
  String get importFromFile;
  String get exportToFile;
  String get selectFile;
  String get fileImported;
  String get fileExported;
  String get importFailed;
  String get exportFailed;
  String get invalidFileFormat;
  String get confirmDelete;
  String get confirmDeleteMessage;
  String get deleteSuccess;
  String get deleteFailed;
  String get updateSuccess;
  String get updateFailed;
  String get invalidInput;
  String get valueMustBePositive;
  String get valueMustBeNonNegative;
  String get enterValidNumber;
  String get enterValidDate;
  String get dateCannotBeInPast;
  String get dateCannotBeInFuture;
  String get startDateMustBeBeforeEndDate;
  String get pleaseSelectOption;
  String get pleaseEnterValue;

  // Assets
  String get assetName;
  String get assetType;
  String get currentValue;
  String get purchasePrice;
  String get purchaseDate;
  String get address;
  String get accountType;
  String get institution;
  String get accountNumber;
  String get owner;
  String get contribution;
  String get withdrawal;
  String get annualReturn;
  String get addContribution;
  String get addWithdrawal;
  String get selectOwner;
  String get assetCreated;
  String get assetUpdated;
  String get assetDeleted;
  String get failedToCreateAsset;
  String get failedToUpdateAsset;
  String get failedToDeleteAsset;

  // Events
  String get eventName;
  String get eventType;
  String get eventDate;
  String get amount;
  String get description;
  String get recurring;
  String get frequency;
  String get endDate;
  String get oneTime;
  String get monthly;
  String get yearly;
  String get individual;
  String get transactionType;
  String get buy;
  String get sell;
  String get selectAsset;
  String get salePrice;
  String get eventCreated;
  String get eventUpdated;
  String get eventDeleted;
  String get failedToCreateEvent;
  String get failedToUpdateEvent;
  String get failedToDeleteEvent;

  // Expenses
  String get expenses;
  String get monthlyExpense;
  String get annualExpense;
  String get category;
  String get housing;
  String get transportation;
  String get food;
  String get healthcare;
  String get entertainment;
  String get other;
  String get totalExpenses;
  String get preRetirement;
  String get postRetirement;

  // Scenarios
  String get baseScenario;
  String get scenarioVariations;
  String get createScenario;
  String get editScenario;
  String get deleteScenario;
  String get scenarioName;
  String get scenarioDescription;
  String get compareScenarios;
  String get selectScenarios;
  String get parameterOverrides;
  String get addOverride;
  String get removeOverride;
  String get parameter;
  String get baseValue;
  String get overrideValue;
  String get scenarioCreated;
  String get scenarioUpdated;
  String get scenarioDeleted;
  String get failedToCreateScenario;
  String get failedToUpdateScenario;
  String get failedToDeleteScenario;

  // Projection
  String get yearlyProjection;
  String get cashFlow;
  String get income;
  String get netCashFlow;
  String get cumulativeNetWorth;
  String get year;
  String get viewChart;
  String get viewTable;
  String get currentDollars;
  String get constantDollars;
  String get selectYear;
  String get incomeBreakdown;
  String get expenseBreakdown;
  String get assetAllocation;
  String get employmentIncome;
  String get pensionIncome;
  String get investmentIncome;
  String get governmentBenefits;
  String get totalIncome;
  String get projectionPeriod;
  String get startYear;
  String get endYear;

  // Settings
  String get profile;
  String get accountSettings;
  String get appSettings;
  String get theme;
  String get light;
  String get dark;
  String get system;
  String get notifications;
  String get emailNotifications;
  String get pushNotifications;
  String get privacyPolicy;
  String get termsOfService;
  String get about;
  String get version;
  String get contactSupport;
  String get changePassword;
  String get currentPassword;
  String get newPassword;
  String get confirmPassword;
  String get passwordChanged;
  String get failedToChangePassword;
  String get profileUpdated;
  String get failedToUpdateProfile;
  String get uploadPhoto;
  String get removePhoto;
  String get photoUpdated;
  String get failedToUploadPhoto;

  // Authentication
  String get signInWithGoogle;
  String get signInWithEmail;
  String get dontHaveAccount;
  String get alreadyHaveAccount;
  String get forgotPassword;
  String get resetPassword;
  String get sendResetLink;
  String get resetLinkSent;
  String get backToLogin;
  String get confirmEmail;
  String get loginFailed;
  String get registrationFailed;
  String get emailAlreadyInUse;
  String get weakPassword;
  String get userNotFound;
  String get wrongPassword;
  String get tooManyRequests;
  String get networkError;
  String get unknownError;

  // Wizard Specific
  String get getStarted;
  String get letsBegin;
  String get welcomeToWizard;
  String get wizardIntro;
  String get continueButton;
  String get backButton;
  String get skipSection;
  String get completeSection;
  String get sectionCompleted;
  String get sectionSkipped;
  String get allRequiredComplete;
  String get wizardComplete;
  String get congratulations;
  String get reviewAndFinish;
  String get educational;
  String get notStarted;
  String get inProgress;
  String get complete;
  String get skipped;

  // Forms & Validation
  String get fieldRequired;
  String get invalidValue;
  String get valueTooLow;
  String get valueTooHigh;
  String get invalidDateFormat;
  String get pleaseEnterName;
  String get pleaseEnterEmail;
  String get pleaseEnterPassword;
  String get pleaseEnterAmount;
  String get pleaseSelectDate;
  String get nameTooShort;
  String get nameMinLength;
  String get amountMustBePositive;
  String get percentageMustBeBetween;
  String get invalidPercentage;

  // Common Actions
  String get add;
  String get update;
  String get remove;
  String get duplicate;
  String get share;
  String get export;
  String get import;
  String get refresh;
  String get search;
  String get filter;
  String get sort;
  String get apply;
  String get reset;
  String get clear;
  String get selectAll;
  String get deselectAll;
  String get showMore;
  String get showLess;
  String get loading;
  String get saving;
  String get deleting;
  String get processing;
  String get success;
  String get error;
  String get warning;
  String get info;

  // Date & Time
  String get today;
  String get yesterday;
  String get tomorrow;
  String get thisWeek;
  String get thisMonth;
  String get thisYear;
  String get lastMonth;
  String get lastYear;
  String get nextMonth;
  String get nextYear;
  String get selectDate;
  String get selectTime;
  String get dateRange;
  String get from;
  String get to;

  // Numbers & Currency
  String get total;
  String get subtotal;
  String get balance;
  String get perMonth;
  String get perYear;
  String get currency;
  String get percentage;

  // Error messages
  String get errorLoadingProject;
  String get errorLoadingProjection;
  String get errorLoadingScenarios;
  String get errorLoadingProjections;
  String get noScenariosAvailable;
  String get createScenariosToCompare;
  String get setupProject;

  // Dashboard KPIs
  String get kpis;
  String get comparison;
  String get keyPerformanceIndicators;
  String get quickSummaryProjection;
  String get finalNetWorth;
  String get atEndOfProjection;
  String get lowestNetWorth;
  String get moneyRunsOut;
  String get totalTaxesPaid;
  String get totalWithdrawals;
  String get averageTaxRate;
  String get netWorthProjection;
  String get onlyOneScenarioExists;
  String get createAlternativeScenarios;
  String get noProjectionAvailable;
  String get completeProjectSetup;

  // Account type labels
  String get reerReturnRate;
  String get celiReturnRate;
  String get criReturnRate;
  String get cashReturnRateLabel;

  // Helper text
  String get expectedAnnualInflation;
  String get expectedReerReturn;
  String get expectedCeliReturn;
  String get expectedCriReturn;
  String get expectedCashReturn;

  // Validation messages
  String get mustBeBetweenRange;

  // Clipboard
  String get copiedToClipboard;
  String get copyToClipboard;

  // Import/Export descriptions
  String get importExportDescription;
  String get fileSelectionNotSupported;
  String get assetsNotLoaded;
  String get eventsNotLoaded;
  String get expensesNotLoaded;
  String get scenariosNotLoaded;
  String get dataExportedTo;
  String get dataExportedWithWarnings;
  String get warnings;

  // Authentication
  String get userNotAuthenticated;
  String get repositoryNotAvailable;
  String get invalidRateValues;

  // Empty state descriptions
  String get createFirstProject;
  String get addPeopleToRetirementPlan;

  // Wizard - Common
  String get comingSoon;
  String get noProjectSelected;
  String get selectBirthdate;
  String get pleaseSelectBirthdate;
  String get clickNextToSaveAndContinue;
  String get clickNextOrSkip;
  String get nameMinTwoCharacters;
  String get projectNameMinLength;
  String get pleaseEnterValidNumber;
  String get incomeCannotBeNegative;
  String get pleaseEnterRealisticIncome;
  String get failedToSave;

  // Wizard - Partner Section
  String get partnerInformation;
  String get partnerSectionDescription;
  String get partnerName;
  String get enterPartnerName;
  String get pleaseEnterPartnerName;
  String get dateOfBirth;
  String get selectPartnerBirthdate;
  String get partnerSectionInstructions;

  // Wizard - Primary Individual Section
  String get exampleName;
  String get ageYears;

  // Wizard - Project Basics Section
  String get projectNameHint;
  String get projectDescriptionHint;

  // Wizard - Assets Section
  String get yourAssets;
  String get assetsSectionDescription;
  String get deleteAssetTitle;
  String get deleteAssetConfirmation;
  String get noAssetsYet;
  String get addFirstAssetOrSkip;
  String get errorLoadingAssets;
  String get clickNextOrSkipAssets;

  // Wizard - Employment Section
  String get employmentSectionDescription;
  String get noIndividualsFound;
  String get pleaseAddIndividuals;
  String get annualEmploymentIncome;
  String get enterAnnualSalary;
  String get cadPerYear;
  String get leaveEmptyIfNotEmployed;
  String get incomeUsedUntilRetirement;
  String get clickNextOrSkipEmployment;

  // Wizard - Expenses Section
  String get annualExpenses;
  String get expensesSectionDescription;
  String get annualAmount;
  String get housingExpenseHint;
  String get transportationExpenseHint;
  String get foodExpenseHint;
  String get leisureExpenseHint;
  String get healthExpenseHint;
  String get familyExpenseHint;
  String get errorLoadingExpenses;

  // Wizard - Government Benefits Section
  String get governmentBenefitsTitle;
  String get governmentBenefitsSectionDescription;
  String get ageLabel;
  String get rrqAgeHint;
  String get rrqAgeHelper;
  String get psvAgeHint;
  String get psvAgeHelper;
  String get atAge60;
  String get atAge65;
  String get reducedAmount;
  String get fullAmount;

  // Wizard - Retirement Section
  String get retirementPlanning;
  String get retirementSectionDescription;
  String get retirementAgeHint;
  String get typicalRetirementAge;
  String get yearsLabel;
  String get retiringThisYear;

  // Wizard - Life Events Section
  String get lifePlanning;
  String get lifeEventsSectionDescription;
  String get lifeExpectancyHint;
  String get averageLifeExpectancy;

  // Wizard - Summary Section
  String get summaryAndReview;
  String get loadingSection;
  String get failedToComplete;

  // Get the appropriate localizations based on locale
  static AppLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'fr') {
      return AppLocalizationsFr();
    }
    return AppLocalizationsEn();
  }

  // Delegate for localizations
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('fr', ''),
  ];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    if (locale.languageCode == 'fr') {
      return AppLocalizationsFr();
    }
    return AppLocalizationsEn();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
