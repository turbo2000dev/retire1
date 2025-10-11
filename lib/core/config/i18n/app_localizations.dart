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

  // Get the appropriate localizations based on locale
  static AppLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'fr') {
      return AppLocalizationsFr();
    }
    return AppLocalizationsEn();
  }

  // Delegate for localizations
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Supported locales
  static const List<Locale> supportedLocales = [Locale('en', ''), Locale('fr', '')];
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
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
