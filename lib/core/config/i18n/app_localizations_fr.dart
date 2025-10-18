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
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

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

  // Wizard - UI strings
  @override
  String get wizard => 'Assistant de configuration';

  @override
  String get loadingWizard => 'Chargement de l\'assistant...';

  @override
  String get failedToLoadWizard => 'Échec du chargement de l\'assistant';

  @override
  String get retry => 'Réessayer';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get finish => 'Terminer';

  @override
  String get required => 'Requis';

  @override
  String get optional => 'Optionnel';

  @override
  String get errorLoadingSections => 'Erreur lors du chargement des sections';

  @override
  String get sections => 'Sections';

  // Wizard - Section titles
  @override
  String get section1Title => 'Bienvenue';

  @override
  String get section2Title => 'Informations de base';

  @override
  String get section3Title => 'Vos informations';

  @override
  String get section4Title => 'Informations sur le conjoint';

  @override
  String get section5Title => 'Actifs';

  @override
  String get section6Title => 'Emploi';

  @override
  String get section7Title => 'Prestations du Québec';

  @override
  String get section8Title => 'Prestations gouvernementales';

  @override
  String get section9Title => 'Dépenses';

  @override
  String get section10Title => 'Moment de la retraite';

  @override
  String get section11Title => 'Événements de vie';

  @override
  String get section12Title => 'Sommaire';

  // Wizard - Section descriptions
  @override
  String get section1Description =>
      'Découvrez le processus de planification de la retraite et à quoi vous attendre';

  @override
  String get section2Description =>
      'Configurez le nom de votre projet et les informations de base';

  @override
  String get section3Description =>
      'Entrez vos informations personnelles, y compris votre date de naissance';

  @override
  String get section4Description =>
      'Ajoutez les informations de votre conjoint si vous planifiez ensemble';

  @override
  String get section5Description =>
      'Ajoutez vos biens immobiliers, comptes REER, CELI et autres actifs';

  @override
  String get section6Description =>
      'Entrez vos revenus d\'emploi actuels et les détails';

  @override
  String get section7Description =>
      'Découvrez le Régime de rentes du Québec et autres prestations provinciales';

  @override
  String get section8Description =>
      'Configurez le Régime de pensions du Canada, la Sécurité de la vieillesse et autres prestations';

  @override
  String get section9Description =>
      'Estimez vos dépenses de vie avant et après la retraite';

  @override
  String get section10Description =>
      'Planifiez quand vous et votre conjoint prendrez votre retraite';

  @override
  String get section11Description =>
      'Ajoutez des événements majeurs comme la vente d\'une maison ou de grandes dépenses';

  @override
  String get section12Description =>
      'Révisez vos informations et complétez la configuration';

  // Wizard - Category titles
  @override
  String get categoryGettingStarted => 'Pour commencer';

  @override
  String get categoryIndividuals => 'Individus';

  @override
  String get categoryFinancialSituation => 'Situation financière';

  @override
  String get categoryRetirementIncome => 'Revenu de retraite';

  @override
  String get categoryKeyEvents => 'Événements clés';

  @override
  String get categoryScenariosReview => 'Révision et sommaire';
}
