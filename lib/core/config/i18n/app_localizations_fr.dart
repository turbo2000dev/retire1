import 'package:retire1/core/config/i18n/app_localizations.dart';

/// French localizations
class AppLocalizationsFr extends AppLocalizations {
  // Common strings
  @override
  String get appTitle => 'Planificateur de retraite';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get create => 'Créer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get close => 'Fermer';

  // Navigation
  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get baseParameters => 'Paramètres de base';

  @override
  String get assetsAndEvents => 'Actifs et événements';

  @override
  String get scenarios => 'Scénarios';

  @override
  String get projection => 'Projection';

  @override
  String get settings => 'Paramètres';

  // Authentication
  @override
  String get login => 'Connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'Courriel';

  @override
  String get password => 'Mot de passe';

  @override
  String get displayName => 'Nom d\'affichage';

  // Projects
  @override
  String get projects => 'Projets';

  @override
  String get createProject => 'Créer un projet';

  @override
  String get editProject => 'Modifier le projet';

  @override
  String get deleteProject => 'Supprimer le projet';

  @override
  String get projectName => 'Nom du projet';

  @override
  String get projectDescription => 'Description';

  // Individuals
  @override
  String get individuals => 'Individus';

  @override
  String get addIndividual => 'Ajouter un individu';

  @override
  String get editIndividual => 'Modifier l\'individu';

  @override
  String get deleteIndividual => 'Supprimer l\'individu';

  @override
  String get individualName => 'Nom';

  @override
  String get birthdate => 'Date de naissance';

  @override
  String get age => 'Âge';

  // Assets
  @override
  String get assets => 'Actifs';

  @override
  String get addAsset => 'Ajouter un actif';

  @override
  String get editAsset => 'Modifier l\'actif';

  @override
  String get deleteAsset => 'Supprimer l\'actif';

  @override
  String get realEstate => 'Immobilier';

  @override
  String get rrspAccount => 'Compte REER';

  @override
  String get celiAccount => 'Compte CELI';

  @override
  String get cashAccount => 'Compte de liquidités';

  @override
  String get value => 'Valeur';

  // Events
  @override
  String get events => 'Événements';

  @override
  String get addEvent => 'Ajouter un événement';

  @override
  String get editEvent => 'Modifier l\'événement';

  @override
  String get deleteEvent => 'Supprimer l\'événement';

  @override
  String get retirement => 'Retraite';

  @override
  String get death => 'Décès';

  @override
  String get realEstateTransaction => 'Transaction immobilière';

  @override
  String get timing => 'Moment';

  // Settings
  @override
  String get language => 'Langue';

  @override
  String get english => 'English';

  @override
  String get french => 'Français';

  // Validation
  @override
  String get requiredField => 'Ce champ est requis';

  @override
  String get invalidEmail => 'Adresse courriel invalide';

  @override
  String get passwordTooShort => 'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  // Empty states
  @override
  String get noProjects => 'Aucun projet. Créez votre premier projet!';

  @override
  String get noIndividuals => 'Aucun individu. Ajoutez votre premier individu!';

  @override
  String get noAssets => 'Aucun actif. Ajoutez votre premier actif!';

  @override
  String get noEvents => 'Aucun événement. Ajoutez votre premier événement!';

  @override
  String get noScenarios => 'Aucune variation de scénario. Créez un scénario!';
}
