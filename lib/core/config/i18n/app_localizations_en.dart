import 'package:retire1/core/config/i18n/app_localizations.dart';

/// English localizations
class AppLocalizationsEn extends AppLocalizations {
  // Common strings
  @override
  String get appTitle => 'Retirement Planner';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get close => 'Close';

  // Navigation
  @override
  String get dashboard => 'Dashboard';

  @override
  String get baseParameters => 'Base Parameters';

  @override
  String get assetsAndEvents => 'Assets & Events';

  @override
  String get scenarios => 'Scenarios';

  @override
  String get projection => 'Projection';

  @override
  String get settings => 'Settings';

  // Authentication
  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Display Name';

  // Projects
  @override
  String get projects => 'Projects';

  @override
  String get createProject => 'Create Project';

  @override
  String get editProject => 'Edit Project';

  @override
  String get deleteProject => 'Delete Project';

  @override
  String get projectName => 'Project Name';

  @override
  String get projectDescription => 'Description';

  // Individuals
  @override
  String get individuals => 'Individuals';

  @override
  String get addIndividual => 'Add Individual';

  @override
  String get editIndividual => 'Edit Individual';

  @override
  String get deleteIndividual => 'Delete Individual';

  @override
  String get individualName => 'Name';

  @override
  String get birthdate => 'Birthdate';

  @override
  String get age => 'Age';

  // Assets
  @override
  String get assets => 'Assets';

  @override
  String get addAsset => 'Add Asset';

  @override
  String get editAsset => 'Edit Asset';

  @override
  String get deleteAsset => 'Delete Asset';

  @override
  String get realEstate => 'Real Estate';

  @override
  String get rrspAccount => 'RRSP Account';

  @override
  String get celiAccount => 'CELI Account';

  @override
  String get cashAccount => 'Cash Account';

  @override
  String get value => 'Value';

  // Events
  @override
  String get events => 'Events';

  @override
  String get addEvent => 'Add Event';

  @override
  String get editEvent => 'Edit Event';

  @override
  String get deleteEvent => 'Delete Event';

  @override
  String get retirement => 'Retirement';

  @override
  String get death => 'Death';

  @override
  String get realEstateTransaction => 'Real Estate Transaction';

  @override
  String get timing => 'Timing';

  // Settings
  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  // Validation
  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  // Empty states
  @override
  String get noProjects => 'No projects yet. Create your first project!';

  @override
  String get noIndividuals => 'No individuals yet. Add your first individual!';

  @override
  String get noAssets => 'No assets yet. Add your first asset!';

  @override
  String get noEvents => 'No events yet. Add your first event!';

  @override
  String get noScenarios => 'No scenario variations yet. Create a scenario!';

  // Wizard - UI strings
  @override
  String get wizard => 'Setup Wizard';

  @override
  String get leaveWizard => 'Leave Wizard';

  @override
  String get loadingWizard => 'Loading Wizard...';

  @override
  String get failedToLoadWizard => 'Failed to load wizard';

  @override
  String get launchWizard => 'Launch Wizard';

  @override
  String get resumeWizard => 'Resume Wizard';

  @override
  String get retry => 'Retry';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get finish => 'Finish';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get errorLoadingSections => 'Error loading sections';

  @override
  String get sections => 'Sections';

  // Wizard - Section titles
  @override
  String get section1Title => 'Welcome';

  @override
  String get section2Title => 'Project Basics';

  @override
  String get section3Title => 'Your Information';

  @override
  String get section4Title => 'Partner Information';

  @override
  String get section5Title => 'Assets';

  @override
  String get section6Title => 'Employment';

  @override
  String get section7Title => 'Quebec Benefits';

  @override
  String get section8Title => 'Government Benefits';

  @override
  String get section9Title => 'Expenses';

  @override
  String get section10Title => 'Retirement Timing';

  @override
  String get section11Title => 'Life Events';

  @override
  String get section12Title => 'Summary';

  // Wizard - Section descriptions
  @override
  String get section1Description =>
      'Learn about the retirement planning process and what to expect';

  @override
  String get section2Description =>
      'Set up your project name and basic information';

  @override
  String get section3Description =>
      'Enter your personal information including birth date';

  @override
  String get section4Description =>
      'Add your partner\'s information if planning together';

  @override
  String get section5Description =>
      'Add your real estate, RRSP, CELI, and other assets';

  @override
  String get section6Description =>
      'Enter your current employment income and details';

  @override
  String get section7Description =>
      'Learn about Quebec Pension Plan and other provincial benefits';

  @override
  String get section8Description =>
      'Configure Canada Pension Plan, Old Age Security, and other benefits';

  @override
  String get section9Description =>
      'Estimate your living expenses before and after retirement';

  @override
  String get section10Description =>
      'Plan when you and your partner will retire';

  @override
  String get section11Description =>
      'Add major life events like selling a home or large expenses';

  @override
  String get section12Description =>
      'Review your information and complete the setup';

  // Wizard - Category titles
  @override
  String get categoryGettingStarted => 'Getting Started';

  @override
  String get categoryIndividuals => 'Individuals';

  @override
  String get categoryFinancialSituation => 'Financial Situation';

  @override
  String get categoryRetirementIncome => 'Retirement Income';

  @override
  String get categoryKeyEvents => 'Key Events';

  @override
  String get categoryScenariosReview => 'Review & Summary';

  // Wizard - Welcome screen
  @override
  String get welcomeWizardTitle => 'Here\'s how we\'ll proceed together';

  @override
  String get welcomeWizardIntro =>
      'In the next few minutes, we\'ll build your personalized retirement plan. Think of it as a friendly conversation where I guide you through 5 major steps:';

  @override
  String get welcomeWizardStep1Title => 'Who are you?';

  @override
  String get welcomeWizardStep1Description => 'Your current situation';

  @override
  String get welcomeWizardStep2Title => 'Your income';

  @override
  String get welcomeWizardStep2Description => 'What you earn';

  @override
  String get welcomeWizardStep3Title => 'Your savings';

  @override
  String get welcomeWizardStep3Description => 'What you\'ve set aside';

  @override
  String get welcomeWizardStep4Title => 'Your goals';

  @override
  String get welcomeWizardStep4Description => 'Your retirement dreams';

  @override
  String get welcomeWizardStep5Title => 'Your plan';

  @override
  String get welcomeWizardStep5Description => 'Our personalized recommendation';

  @override
  String get welcomeWizardTimeEstimate => 'This will take about 20-30 minutes.';

  @override
  String get welcomeWizardReady => 'Ready?';

  // Dashboard
  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get selectProject => 'Select Project';

  @override
  String get currentProject => 'Current Project';

  @override
  String get executiveSummary => 'Executive Summary';

  @override
  String get keyMetrics => 'Key Metrics';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get viewDetails => 'View Details';

  @override
  String get netWorth => 'Net Worth';

  @override
  String get monthlyIncome => 'Monthly Income';

  @override
  String get monthlyExpenses => 'Monthly Expenses';

  @override
  String get retirementAge => 'Retirement Age';

  @override
  String get yearsToRetirement => 'Years to Retirement';

  // Project / Base Parameters
  @override
  String get projectDetails => 'Project Details';

  @override
  String get economicAssumptions => 'Economic Assumptions';

  @override
  String get inflationRate => 'Inflation Rate';

  @override
  String get investmentReturn => 'Investment Return';

  @override
  String get editProjectDetails => 'Edit Project Details';

  @override
  String get editIndividualDetails => 'Edit Individual Details';

  @override
  String get editEconomicAssumptions => 'Edit Economic Assumptions';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get discardChanges => 'Discard Changes';

  @override
  String get primary => 'Primary';

  @override
  String get partner => 'Partner';

  @override
  String get addPartner => 'Add Partner';

  @override
  String get removePartner => 'Remove Partner';

  @override
  String get importData => 'Import Data';

  @override
  String get exportData => 'Export Data';

  @override
  String get importFromFile => 'Import from File';

  @override
  String get exportToFile => 'Export to File';

  @override
  String get selectFile => 'Select File';

  @override
  String get fileImported => 'File imported successfully';

  @override
  String get fileExported => 'File exported successfully';

  @override
  String get importFailed => 'Failed to import file';

  @override
  String get exportFailed => 'Failed to export file';

  @override
  String get invalidFileFormat => 'Invalid file format';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this item?';

  @override
  String get deleteSuccess => 'Deleted successfully';

  @override
  String get deleteFailed => 'Failed to delete';

  @override
  String get updateSuccess => 'Updated successfully';

  @override
  String get updateFailed => 'Failed to update';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get valueMustBePositive => 'Value must be positive';

  @override
  String get valueMustBeNonNegative => 'Value must be non-negative';

  @override
  String get enterValidNumber => 'Please enter a valid number';

  @override
  String get enterValidDate => 'Please enter a valid date';

  @override
  String get dateCannotBeInPast => 'Date cannot be in the past';

  @override
  String get dateCannotBeInFuture => 'Date cannot be in the future';

  @override
  String get startDateMustBeBeforeEndDate =>
      'Start date must be before end date';

  @override
  String get pleaseSelectOption => 'Please select an option';

  @override
  String get pleaseEnterValue => 'Please enter a value';

  // Assets
  @override
  String get assetName => 'Asset Name';

  @override
  String get assetType => 'Asset Type';

  @override
  String get currentValue => 'Current Value';

  @override
  String get purchasePrice => 'Purchase Price';

  @override
  String get purchaseDate => 'Purchase Date';

  @override
  String get address => 'Address';

  @override
  String get accountType => 'Account Type';

  @override
  String get institution => 'Institution';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get owner => 'Owner';

  @override
  String get contribution => 'Contribution';

  @override
  String get withdrawal => 'Withdrawal';

  @override
  String get annualReturn => 'Annual Return';

  @override
  String get addContribution => 'Add Contribution';

  @override
  String get addWithdrawal => 'Add Withdrawal';

  @override
  String get selectOwner => 'Select Owner';

  @override
  String get assetCreated => 'Asset created successfully';

  @override
  String get assetUpdated => 'Asset updated successfully';

  @override
  String get assetDeleted => 'Asset deleted successfully';

  @override
  String get failedToCreateAsset => 'Failed to create asset';

  @override
  String get failedToUpdateAsset => 'Failed to update asset';

  @override
  String get failedToDeleteAsset => 'Failed to delete asset';

  // Events
  @override
  String get eventName => 'Event Name';

  @override
  String get eventType => 'Event Type';

  @override
  String get eventDate => 'Event Date';

  @override
  String get amount => 'Amount';

  @override
  String get description => 'Description';

  @override
  String get recurring => 'Recurring';

  @override
  String get frequency => 'Frequency';

  @override
  String get endDate => 'End Date';

  @override
  String get oneTime => 'One Time';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get individual => 'Individual';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get buy => 'Buy';

  @override
  String get sell => 'Sell';

  @override
  String get selectAsset => 'Select Asset';

  @override
  String get salePrice => 'Sale Price';

  @override
  String get eventCreated => 'Event created successfully';

  @override
  String get eventUpdated => 'Event updated successfully';

  @override
  String get eventDeleted => 'Event deleted successfully';

  @override
  String get failedToCreateEvent => 'Failed to create event';

  @override
  String get failedToUpdateEvent => 'Failed to update event';

  @override
  String get failedToDeleteEvent => 'Failed to delete event';

  // Expenses
  @override
  String get expenses => 'Expenses';

  @override
  String get monthlyExpense => 'Monthly Expense';

  @override
  String get annualExpense => 'Annual Expense';

  @override
  String get category => 'Category';

  @override
  String get housing => 'Housing';

  @override
  String get transportation => 'Transportation';

  @override
  String get food => 'Food';

  @override
  String get healthcare => 'Healthcare';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get family => 'Family';

  @override
  String get other => 'Other';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get preRetirement => 'Pre-Retirement';

  @override
  String get postRetirement => 'Post-Retirement';

  // Scenarios
  @override
  String get baseScenario => 'Base Scenario';

  @override
  String get scenarioVariations => 'Scenario Variations';

  @override
  String get createScenario => 'Create Scenario';

  @override
  String get editScenario => 'Edit Scenario';

  @override
  String get deleteScenario => 'Delete Scenario';

  @override
  String get scenarioName => 'Scenario Name';

  @override
  String get scenarioDescription => 'Scenario Description';

  @override
  String get compareScenarios => 'Compare Scenarios';

  @override
  String get selectScenarios => 'Select Scenarios';

  @override
  String get parameterOverrides => 'Parameter Overrides';

  @override
  String get addOverride => 'Add Override';

  @override
  String get removeOverride => 'Remove Override';

  @override
  String get parameter => 'Parameter';

  @override
  String get baseValue => 'Base Value';

  @override
  String get overrideValue => 'Override Value';

  @override
  String get scenarioCreated => 'Scenario created successfully';

  @override
  String get scenarioUpdated => 'Scenario updated successfully';

  @override
  String get scenarioDeleted => 'Scenario deleted successfully';

  @override
  String get failedToCreateScenario => 'Failed to create scenario';

  @override
  String get failedToUpdateScenario => 'Failed to update scenario';

  @override
  String get failedToDeleteScenario => 'Failed to delete scenario';

  // Projection
  @override
  String get yearlyProjection => 'Yearly Projection';

  @override
  String get cashFlow => 'Cash Flow';

  @override
  String get income => 'Income';

  @override
  String get netCashFlow => 'Net Cash Flow';

  @override
  String get cumulativeNetWorth => 'Cumulative Net Worth';

  @override
  String get year => 'Year';

  @override
  String get viewChart => 'View Chart';

  @override
  String get viewTable => 'View Table';

  @override
  String get currentDollars => 'Current Dollars';

  @override
  String get constantDollars => 'Constant Dollars';

  @override
  String get selectYear => 'Select Year';

  @override
  String get incomeBreakdown => 'Income Breakdown';

  @override
  String get expenseBreakdown => 'Expense Breakdown';

  @override
  String get assetAllocation => 'Asset Allocation';

  @override
  String get employmentIncome => 'Employment Income';

  @override
  String get pensionIncome => 'Pension Income';

  @override
  String get investmentIncome => 'Investment Income';

  @override
  String get governmentBenefits => 'Government Benefits';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get projectionPeriod => 'Projection Period';

  @override
  String get startYear => 'Start Year';

  @override
  String get endYear => 'End Year';

  // Settings
  @override
  String get profile => 'Profile';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get appSettings => 'App Settings';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get notifications => 'Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get failedToChangePassword => 'Failed to change password';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get failedToUpdateProfile => 'Failed to update profile';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get photoUpdated => 'Photo updated successfully';

  @override
  String get failedToUploadPhoto => 'Failed to upload photo';

  // Authentication
  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithEmail => 'Sign in with Email';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Reset link sent to your email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get confirmEmail => 'Confirm Email';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get emailAlreadyInUse => 'Email already in use';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get userNotFound => 'User not found';

  @override
  String get wrongPassword => 'Wrong password';

  @override
  String get tooManyRequests => 'Too many requests. Please try again later';

  @override
  String get networkError => 'Network error. Please check your connection';

  @override
  String get unknownError => 'An unknown error occurred';

  // Wizard Specific
  @override
  String get getStarted => 'Get Started';

  @override
  String get letsBegin => 'Let\'s Begin';

  @override
  String get welcomeToWizard => 'Welcome to the Setup Wizard';

  @override
  String get wizardIntro =>
      'This wizard will help you set up your retirement planning project';

  @override
  String get continueButton => 'Continue';

  @override
  String get backButton => 'Back';

  @override
  String get skipSection => 'Skip Section';

  @override
  String get completeSection => 'Complete Section';

  @override
  String get sectionCompleted => 'Section Completed';

  @override
  String get sectionSkipped => 'Section Skipped';

  @override
  String get allRequiredComplete => 'All Required Sections Complete';

  @override
  String get wizardComplete => 'Wizard Complete';

  @override
  String get congratulations => 'Congratulations';

  @override
  String get reviewAndFinish => 'Review and Finish';

  @override
  String get educational => 'Educational';

  @override
  String get notStarted => 'Not Started';

  @override
  String get inProgress => 'In Progress';

  @override
  String get complete => 'Complete';

  @override
  String get skipped => 'Skipped';

  // Forms & Validation
  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidValue => 'Invalid value';

  @override
  String get valueTooLow => 'Value is too low';

  @override
  String get valueTooHigh => 'Value is too high';

  @override
  String get invalidDateFormat => 'Invalid date format';

  @override
  String get pleaseEnterName => 'Please enter a name';

  @override
  String get pleaseEnterEmail => 'Please enter an email';

  @override
  String get pleaseEnterPassword => 'Please enter a password';

  @override
  String get pleaseEnterAmount => 'Please enter an amount';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get nameTooShort => 'Name is too short';

  @override
  String get nameMinLength => 'Name must be at least 3 characters';

  @override
  String get amountMustBePositive => 'Amount must be positive';

  @override
  String get percentageMustBeBetween => 'Percentage must be between 0 and 100';

  @override
  String get invalidPercentage => 'Invalid percentage';

  // Common Actions
  @override
  String get add => 'Add';

  @override
  String get update => 'Update';

  @override
  String get remove => 'Remove';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get share => 'Share';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get refresh => 'Refresh';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get apply => 'Apply';

  @override
  String get reset => 'Reset';

  @override
  String get clear => 'Clear';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get showMore => 'Show More';

  @override
  String get showLess => 'Show Less';

  @override
  String get loading => 'Loading';

  @override
  String get saving => 'Saving';

  @override
  String get deleting => 'Deleting';

  @override
  String get processing => 'Processing';

  @override
  String get success => 'Success';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  // Date & Time
  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get lastYear => 'Last Year';

  @override
  String get nextMonth => 'Next Month';

  @override
  String get nextYear => 'Next Year';

  @override
  String get selectDate => 'Select Date';

  @override
  String get selectTime => 'Select Time';

  @override
  String get dateRange => 'Date Range';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  // Numbers & Currency
  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get balance => 'Balance';

  @override
  String get perMonth => 'per month';

  @override
  String get perYear => 'per year';

  @override
  String get currency => 'Currency';

  @override
  String get percentage => 'Percentage';

  // Error messages
  @override
  String get errorLoadingProject => 'Error loading project';

  @override
  String get errorLoadingProjection => 'Error loading projection';

  @override
  String get errorLoadingScenarios => 'Error loading scenarios';

  @override
  String get errorLoadingProjections => 'Error loading projections';

  @override
  String get noScenariosAvailable => 'No scenarios available';

  @override
  String get createScenariosToCompare => 'Create scenarios to compare them';

  @override
  String get setupProject => 'Setup Project';

  // Dashboard KPIs
  @override
  String get kpis => 'KPIs';

  @override
  String get comparison => 'Comparison';

  @override
  String get keyPerformanceIndicators => 'Key Performance Indicators';

  @override
  String get quickSummaryProjection => 'Quick summary of your projection';

  @override
  String get finalNetWorth => 'Final Net Worth';

  @override
  String get atEndOfProjection => 'At end of projection';

  @override
  String get lowestNetWorth => 'Lowest Net Worth';

  @override
  String get moneyRunsOut => 'Money Runs Out';

  @override
  String get totalTaxesPaid => 'Total Taxes Paid';

  @override
  String get totalWithdrawals => 'Total Withdrawals';

  @override
  String get averageTaxRate => 'Average Tax Rate';

  @override
  String get netWorthProjection => 'Net Worth Projection';

  @override
  String get onlyOneScenarioExists => 'Only one scenario exists';

  @override
  String get createAlternativeScenarios =>
      'Create alternative scenarios to compare';

  @override
  String get noProjectionAvailable => 'No projection available';

  @override
  String get completeProjectSetup => 'Complete your project setup to view KPIs';

  // Account type labels
  @override
  String get reerReturnRate => 'REER Return Rate';

  @override
  String get celiReturnRate => 'CELI Return Rate';

  @override
  String get criReturnRate => 'CRI Return Rate';

  @override
  String get cashReturnRateLabel => 'Cash Return Rate';

  // Helper text
  @override
  String get expectedAnnualInflation => 'Expected annual inflation rate';

  @override
  String get expectedReerReturn => 'Expected annual return for REER accounts';

  @override
  String get expectedCeliReturn => 'Expected annual return for CELI accounts';

  @override
  String get expectedCriReturn => 'Expected annual return for CRI accounts';

  @override
  String get expectedCashReturn => 'Expected annual return for cash accounts';

  // Validation messages
  @override
  String get mustBeBetweenRange => 'Must be between -10% and 20%';

  // Clipboard
  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  // Import/Export descriptions
  @override
  String get importExportDescription =>
      'Import or export project data for backup, sharing test cases, or transferring between accounts';

  @override
  String get fileSelectionNotSupported =>
      'File selection not supported on this platform';

  @override
  String get assetsNotLoaded =>
      'Assets could not be loaded and will not be included';

  @override
  String get eventsNotLoaded =>
      'Events could not be loaded and will not be included';

  @override
  String get expensesNotLoaded =>
      'Expenses could not be loaded and will not be included';

  @override
  String get scenariosNotLoaded =>
      'Scenarios could not be loaded and will not be included';

  @override
  String get dataExportedTo => 'Project data exported to';

  @override
  String get dataExportedWithWarnings => 'Project data exported with warnings';

  @override
  String get warnings => 'Warnings';

  // Authentication
  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get repositoryNotAvailable => 'Project repository not available';

  @override
  String get invalidRateValues => 'Invalid rate values';

  // Empty state descriptions
  @override
  String get createFirstProject =>
      'Create your first retirement planning project';

  @override
  String get addPeopleToRetirementPlan =>
      'Add the people involved in this retirement plan';

  // Wizard - Common
  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get noProjectSelected => 'No project selected';

  @override
  String get selectBirthdate => 'Select birthdate';

  @override
  String get pleaseSelectBirthdate => 'Please select a birthdate';

  @override
  String get clickNextToSaveAndContinue => 'Click "Next" to save and continue';

  @override
  String get clickNextOrSkip => 'Click "Next" to continue, or "Skip" to skip';

  @override
  String get nameMinTwoCharacters => 'Name must be at least 2 characters';

  @override
  String get projectNameMinLength =>
      'Project name must be at least 3 characters';

  @override
  String get pleaseEnterValidNumber => 'Please enter a valid number';

  @override
  String get incomeCannotBeNegative => 'Income cannot be negative';

  @override
  String get pleaseEnterRealisticIncome => 'Please enter a realistic income';

  @override
  String get failedToSave => 'Failed to save';

  // Wizard - Partner Section
  @override
  String get partnerInformation => 'Partner Information';

  @override
  String get partnerSectionDescription =>
      'Add your spouse or partner (optional). Leave blank if you don\'t have a partner or prefer to plan individually.';

  @override
  String get partnerName => 'Partner Name';

  @override
  String get enterPartnerName => 'Enter your partner\'s name';

  @override
  String get pleaseEnterPartnerName => 'Please enter partner\'s name';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get selectPartnerBirthdate => 'Select partner\'s birthdate';

  @override
  String get partnerSectionInstructions =>
      'Click "Next" to save and continue, or "Skip" to continue without adding a partner';

  // Wizard - Primary Individual Section
  @override
  String get exampleName => 'e.g., Jean Tremblay';

  @override
  String get ageYears => 'Age: {age} years';

  // Wizard - Project Basics Section
  @override
  String get projectNameHint => 'e.g., My Retirement Plan 2025';

  @override
  String get projectDescriptionHint =>
      'Optional: Add notes about this planning scenario';

  // Wizard - Assets Section
  @override
  String get yourAssets => 'Your Assets';

  @override
  String get assetsSectionDescription =>
      'Add your retirement assets such as real estate, RRSP, CELI, and other accounts (optional). Assets help calculate your net worth and project your financial future.';

  @override
  String get deleteAssetTitle => 'Delete Asset';

  @override
  String get deleteAssetConfirmation =>
      'Are you sure you want to delete this asset?\n\nThis action cannot be undone.';

  @override
  String get noAssetsYet => 'No assets yet';

  @override
  String get addFirstAssetOrSkip =>
      'Add your first asset to get started, or skip this section';

  @override
  String get errorLoadingAssets => 'Error loading assets';

  @override
  String get clickNextOrSkipAssets =>
      'Click "Next" to continue, or "Skip" to skip asset entry';

  // Wizard - Employment Section
  @override
  String get employmentSectionDescription =>
      'Enter the annual employment income for each individual (optional). This helps project your pre-retirement financial situation.';

  @override
  String get noIndividualsFound => 'No individuals found';

  @override
  String get pleaseAddIndividuals =>
      'Please add individuals in the previous sections';

  @override
  String get annualEmploymentIncome => 'Annual Employment Income';

  @override
  String get enterAnnualSalary => 'Enter annual salary';

  @override
  String get cadPerYear => 'CAD / year';

  @override
  String get leaveEmptyIfNotEmployed => 'Leave empty if not employed';

  @override
  String get incomeUsedUntilRetirement =>
      'This income will be used in projections until retirement';

  @override
  String get clickNextOrSkipEmployment =>
      'Click "Next" to continue, or "Skip" to skip employment income';

  // Wizard - Expenses Section
  @override
  String get annualExpenses => 'Annual Expenses';

  @override
  String get expensesSectionDescription =>
      'Enter your approximate annual expenses by category (optional). This helps project your cash flow needs in retirement.';

  @override
  String get annualAmount => 'Annual Amount';

  @override
  String get housingExpenseHint => 'Mortgage, rent, property tax, utilities';

  @override
  String get transportationExpenseHint =>
      'Car payments, gas, insurance, transit';

  @override
  String get foodExpenseHint => 'Groceries, clothing, personal care';

  @override
  String get leisureExpenseHint => 'Entertainment, hobbies, dining, travel';

  @override
  String get healthExpenseHint => 'Insurance, medical, prescriptions';

  @override
  String get familyExpenseHint => 'Childcare, education, family support';

  @override
  String get errorLoadingExpenses => 'Error loading expenses';

  // Wizard - Government Benefits Section
  @override
  String get governmentBenefitsTitle => 'Government Benefits';

  @override
  String get governmentBenefitsSectionDescription =>
      'Plan when you want to start receiving government benefits (optional). You can adjust these later.';

  @override
  String get ageLabel => 'Age';

  @override
  String get rrqAgeHint => '60-70';

  @override
  String get rrqAgeHelper => 'Age 60 (reduced) to 70 (increased)';

  @override
  String get psvAgeHint => '65-70';

  @override
  String get psvAgeHelper => 'Age 65 (standard) to 70 (increased)';

  @override
  String get atAge60 => 'At age 60';

  @override
  String get atAge65 => 'At age 65';

  @override
  String get reducedAmount => 'Reduced amount';

  @override
  String get fullAmount => 'Full amount';

  // Wizard - Retirement Section
  @override
  String get retirementPlanning => 'Retirement Planning';

  @override
  String get retirementSectionDescription =>
      'Plan when each individual will retire (optional). This affects income projections and benefit eligibility.';

  @override
  String get retirementAgeHint => '55-75';

  @override
  String get typicalRetirementAge => 'Typical retirement age is 60-67';

  @override
  String get yearsLabel => 'years';

  @override
  String get retiringThisYear => 'Retiring this year';

  // Wizard - Life Events Section
  @override
  String get lifePlanning => 'Life Planning';

  @override
  String get lifeEventsSectionDescription =>
      'Plan for major life events (optional). This helps project long-term financial needs and estate planning.';

  @override
  String get lifeExpectancyHint => '75-100';

  @override
  String get averageLifeExpectancy => 'Average life expectancy: 80-85';

  // Wizard - Summary Section
  @override
  String get summaryAndReview => 'Summary & Review';

  @override
  String get loadingSection => 'Loading {section}...';

  @override
  String get failedToComplete => 'Failed to complete';
}
