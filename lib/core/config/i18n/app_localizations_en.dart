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
}
