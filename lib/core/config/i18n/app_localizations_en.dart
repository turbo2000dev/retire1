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
}
