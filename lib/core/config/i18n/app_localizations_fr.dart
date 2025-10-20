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
  String get launchWizard => 'Lancer l\'assistant';

  @override
  String get resumeWizard => 'Reprendre l\'assistant';

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

  // Dashboard
  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get selectProject => 'Sélectionner un projet';

  @override
  String get currentProject => 'Projet actuel';

  @override
  String get executiveSummary => 'Résumé exécutif';

  @override
  String get keyMetrics => 'Indicateurs clés';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get viewDetails => 'Voir les détails';

  @override
  String get netWorth => 'Valeur nette';

  @override
  String get monthlyIncome => 'Revenu mensuel';

  @override
  String get monthlyExpenses => 'Dépenses mensuelles';

  @override
  String get retirementAge => 'Âge de retraite';

  @override
  String get yearsToRetirement => 'Années avant la retraite';

  // Project / Base Parameters
  @override
  String get projectDetails => 'Détails du projet';

  @override
  String get economicAssumptions => 'Hypothèses économiques';

  @override
  String get inflationRate => 'Taux d\'inflation';

  @override
  String get investmentReturn => 'Rendement des investissements';

  @override
  String get editProjectDetails => 'Modifier les détails du projet';

  @override
  String get editIndividualDetails =>
      'Modifier les informations de l\'individu';

  @override
  String get editEconomicAssumptions => 'Modifier les hypothèses économiques';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get discardChanges => 'Annuler les modifications';

  @override
  String get primary => 'Principal';

  @override
  String get partner => 'Conjoint';

  @override
  String get addPartner => 'Ajouter un conjoint';

  @override
  String get removePartner => 'Retirer le conjoint';

  @override
  String get importData => 'Importer des données';

  @override
  String get exportData => 'Exporter des données';

  @override
  String get importFromFile => 'Importer depuis un fichier';

  @override
  String get exportToFile => 'Exporter vers un fichier';

  @override
  String get selectFile => 'Sélectionner un fichier';

  @override
  String get fileImported => 'Fichier importé avec succès';

  @override
  String get fileExported => 'Fichier exporté avec succès';

  @override
  String get importFailed => 'Échec de l\'importation du fichier';

  @override
  String get exportFailed => 'Échec de l\'exportation du fichier';

  @override
  String get invalidFileFormat => 'Format de fichier invalide';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get confirmDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer cet élément?';

  @override
  String get deleteSuccess => 'Supprimé avec succès';

  @override
  String get deleteFailed => 'Échec de la suppression';

  @override
  String get updateSuccess => 'Mis à jour avec succès';

  @override
  String get updateFailed => 'Échec de la mise à jour';

  @override
  String get invalidInput => 'Entrée invalide';

  @override
  String get valueMustBePositive => 'La valeur doit être positive';

  @override
  String get valueMustBeNonNegative => 'La valeur ne peut pas être négative';

  @override
  String get enterValidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get enterValidDate => 'Veuillez entrer une date valide';

  @override
  String get dateCannotBeInPast => 'La date ne peut pas être dans le passé';

  @override
  String get dateCannotBeInFuture => 'La date ne peut pas être dans le futur';

  @override
  String get startDateMustBeBeforeEndDate =>
      'La date de début doit être avant la date de fin';

  @override
  String get pleaseSelectOption => 'Veuillez sélectionner une option';

  @override
  String get pleaseEnterValue => 'Veuillez entrer une valeur';

  // Assets
  @override
  String get assetName => 'Nom de l\'actif';

  @override
  String get assetType => 'Type d\'actif';

  @override
  String get currentValue => 'Valeur actuelle';

  @override
  String get purchasePrice => 'Prix d\'achat';

  @override
  String get purchaseDate => 'Date d\'achat';

  @override
  String get address => 'Adresse';

  @override
  String get accountType => 'Type de compte';

  @override
  String get institution => 'Institution';

  @override
  String get accountNumber => 'Numéro de compte';

  @override
  String get owner => 'Propriétaire';

  @override
  String get contribution => 'Contribution';

  @override
  String get withdrawal => 'Retrait';

  @override
  String get annualReturn => 'Rendement annuel';

  @override
  String get addContribution => 'Ajouter une contribution';

  @override
  String get addWithdrawal => 'Ajouter un retrait';

  @override
  String get selectOwner => 'Sélectionner le propriétaire';

  @override
  String get assetCreated => 'Actif créé avec succès';

  @override
  String get assetUpdated => 'Actif mis à jour avec succès';

  @override
  String get assetDeleted => 'Actif supprimé avec succès';

  @override
  String get failedToCreateAsset => 'Échec de la création de l\'actif';

  @override
  String get failedToUpdateAsset => 'Échec de la mise à jour de l\'actif';

  @override
  String get failedToDeleteAsset => 'Échec de la suppression de l\'actif';

  // Events
  @override
  String get eventName => 'Nom de l\'événement';

  @override
  String get eventType => 'Type d\'événement';

  @override
  String get eventDate => 'Date de l\'événement';

  @override
  String get amount => 'Montant';

  @override
  String get description => 'Description';

  @override
  String get recurring => 'Récurrent';

  @override
  String get frequency => 'Fréquence';

  @override
  String get endDate => 'Date de fin';

  @override
  String get oneTime => 'Unique';

  @override
  String get monthly => 'Mensuel';

  @override
  String get yearly => 'Annuel';

  @override
  String get individual => 'Individu';

  @override
  String get transactionType => 'Type de transaction';

  @override
  String get buy => 'Achat';

  @override
  String get sell => 'Vente';

  @override
  String get selectAsset => 'Sélectionner un actif';

  @override
  String get salePrice => 'Prix de vente';

  @override
  String get eventCreated => 'Événement créé avec succès';

  @override
  String get eventUpdated => 'Événement mis à jour avec succès';

  @override
  String get eventDeleted => 'Événement supprimé avec succès';

  @override
  String get failedToCreateEvent => 'Échec de la création de l\'événement';

  @override
  String get failedToUpdateEvent => 'Échec de la mise à jour de l\'événement';

  @override
  String get failedToDeleteEvent => 'Échec de la suppression de l\'événement';

  // Expenses
  @override
  String get expenses => 'Dépenses';

  @override
  String get monthlyExpense => 'Dépense mensuelle';

  @override
  String get annualExpense => 'Dépense annuelle';

  @override
  String get category => 'Catégorie';

  @override
  String get housing => 'Logement';

  @override
  String get transportation => 'Transport';

  @override
  String get food => 'Alimentation';

  @override
  String get healthcare => 'Santé';

  @override
  String get entertainment => 'Divertissement';

  @override
  String get family => 'Famille';

  @override
  String get other => 'Autre';

  @override
  String get totalExpenses => 'Dépenses totales';

  @override
  String get preRetirement => 'Avant la retraite';

  @override
  String get postRetirement => 'Après la retraite';

  // Scenarios
  @override
  String get baseScenario => 'Scénario de base';

  @override
  String get scenarioVariations => 'Variations de scénarios';

  @override
  String get createScenario => 'Créer un scénario';

  @override
  String get editScenario => 'Modifier le scénario';

  @override
  String get deleteScenario => 'Supprimer le scénario';

  @override
  String get scenarioName => 'Nom du scénario';

  @override
  String get scenarioDescription => 'Description du scénario';

  @override
  String get compareScenarios => 'Comparer les scénarios';

  @override
  String get selectScenarios => 'Sélectionner des scénarios';

  @override
  String get parameterOverrides => 'Remplacement de paramètres';

  @override
  String get addOverride => 'Ajouter un remplacement';

  @override
  String get removeOverride => 'Retirer le remplacement';

  @override
  String get parameter => 'Paramètre';

  @override
  String get baseValue => 'Valeur de base';

  @override
  String get overrideValue => 'Valeur de remplacement';

  @override
  String get scenarioCreated => 'Scénario créé avec succès';

  @override
  String get scenarioUpdated => 'Scénario mis à jour avec succès';

  @override
  String get scenarioDeleted => 'Scénario supprimé avec succès';

  @override
  String get failedToCreateScenario => 'Échec de la création du scénario';

  @override
  String get failedToUpdateScenario => 'Échec de la mise à jour du scénario';

  @override
  String get failedToDeleteScenario => 'Échec de la suppression du scénario';

  // Projection
  @override
  String get yearlyProjection => 'Projection annuelle';

  @override
  String get cashFlow => 'Flux de trésorerie';

  @override
  String get income => 'Revenu';

  @override
  String get netCashFlow => 'Flux de trésorerie net';

  @override
  String get cumulativeNetWorth => 'Valeur nette cumulative';

  @override
  String get year => 'Année';

  @override
  String get viewChart => 'Voir le graphique';

  @override
  String get viewTable => 'Voir le tableau';

  @override
  String get currentDollars => 'Dollars actuels';

  @override
  String get constantDollars => 'Dollars constants';

  @override
  String get selectYear => 'Sélectionner l\'année';

  @override
  String get incomeBreakdown => 'Répartition des revenus';

  @override
  String get expenseBreakdown => 'Répartition des dépenses';

  @override
  String get assetAllocation => 'Répartition des actifs';

  @override
  String get employmentIncome => 'Revenu d\'emploi';

  @override
  String get pensionIncome => 'Revenu de pension';

  @override
  String get investmentIncome => 'Revenu de placement';

  @override
  String get governmentBenefits => 'Prestations gouvernementales';

  @override
  String get totalIncome => 'Revenu total';

  @override
  String get projectionPeriod => 'Période de projection';

  @override
  String get startYear => 'Année de début';

  @override
  String get endYear => 'Année de fin';

  // Settings
  @override
  String get profile => 'Profil';

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get appSettings => 'Paramètres de l\'application';

  @override
  String get theme => 'Thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get system => 'Système';

  @override
  String get notifications => 'Notifications';

  @override
  String get emailNotifications => 'Notifications par courriel';

  @override
  String get pushNotifications => 'Notifications push';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get passwordChanged => 'Mot de passe modifié avec succès';

  @override
  String get failedToChangePassword =>
      'Échec de la modification du mot de passe';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get failedToUpdateProfile => 'Échec de la mise à jour du profil';

  @override
  String get uploadPhoto => 'Télécharger une photo';

  @override
  String get removePhoto => 'Retirer la photo';

  @override
  String get photoUpdated => 'Photo mise à jour avec succès';

  @override
  String get failedToUploadPhoto => 'Échec du téléchargement de la photo';

  // Authentication
  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get signInWithEmail => 'Se connecter avec un courriel';

  @override
  String get dontHaveAccount => 'Vous n\'avez pas de compte?';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte?';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get sendResetLink => 'Envoyer le lien de réinitialisation';

  @override
  String get resetLinkSent =>
      'Lien de réinitialisation envoyé à votre courriel';

  @override
  String get backToLogin => 'Retour à la connexion';

  @override
  String get confirmEmail => 'Confirmer le courriel';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get registrationFailed => 'Échec de l\'inscription';

  @override
  String get emailAlreadyInUse => 'Courriel déjà utilisé';

  @override
  String get weakPassword => 'Mot de passe trop faible';

  @override
  String get userNotFound => 'Utilisateur non trouvé';

  @override
  String get wrongPassword => 'Mot de passe incorrect';

  @override
  String get tooManyRequests =>
      'Trop de demandes. Veuillez réessayer plus tard';

  @override
  String get networkError => 'Erreur réseau. Veuillez vérifier votre connexion';

  @override
  String get unknownError => 'Une erreur inconnue s\'est produite';

  // Wizard Specific
  @override
  String get getStarted => 'Commencer';

  @override
  String get letsBegin => 'Commençons';

  @override
  String get welcomeToWizard => 'Bienvenue dans l\'assistant de configuration';

  @override
  String get wizardIntro =>
      'Cet assistant vous aidera à configurer votre projet de planification de retraite';

  @override
  String get continueButton => 'Continuer';

  @override
  String get backButton => 'Retour';

  @override
  String get skipSection => 'Passer la section';

  @override
  String get completeSection => 'Compléter la section';

  @override
  String get sectionCompleted => 'Section complétée';

  @override
  String get sectionSkipped => 'Section passée';

  @override
  String get allRequiredComplete =>
      'Toutes les sections requises sont complètes';

  @override
  String get wizardComplete => 'Assistant terminé';

  @override
  String get congratulations => 'Félicitations';

  @override
  String get reviewAndFinish => 'Réviser et terminer';

  @override
  String get educational => 'Éducatif';

  @override
  String get notStarted => 'Non commencé';

  @override
  String get inProgress => 'En cours';

  @override
  String get complete => 'Complet';

  @override
  String get skipped => 'Passé';

  // Forms & Validation
  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get invalidValue => 'Valeur invalide';

  @override
  String get valueTooLow => 'Valeur trop basse';

  @override
  String get valueTooHigh => 'Valeur trop élevée';

  @override
  String get invalidDateFormat => 'Format de date invalide';

  @override
  String get pleaseEnterName => 'Veuillez entrer un nom';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer un courriel';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer un mot de passe';

  @override
  String get pleaseEnterAmount => 'Veuillez entrer un montant';

  @override
  String get pleaseSelectDate => 'Veuillez sélectionner une date';

  @override
  String get nameTooShort => 'Nom trop court';

  @override
  String get nameMinLength => 'Le nom doit contenir au moins 3 caractères';

  @override
  String get amountMustBePositive => 'Le montant doit être positif';

  @override
  String get percentageMustBeBetween =>
      'Le pourcentage doit être entre 0 et 100';

  @override
  String get invalidPercentage => 'Pourcentage invalide';

  // Common Actions
  @override
  String get add => 'Ajouter';

  @override
  String get update => 'Mettre à jour';

  @override
  String get remove => 'Retirer';

  @override
  String get duplicate => 'Dupliquer';

  @override
  String get share => 'Partager';

  @override
  String get export => 'Exporter';

  @override
  String get import => 'Importer';

  @override
  String get refresh => 'Actualiser';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get apply => 'Appliquer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get clear => 'Effacer';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get deselectAll => 'Tout désélectionner';

  @override
  String get showMore => 'Afficher plus';

  @override
  String get showLess => 'Afficher moins';

  @override
  String get loading => 'Chargement';

  @override
  String get saving => 'Enregistrement';

  @override
  String get deleting => 'Suppression';

  @override
  String get processing => 'Traitement';

  @override
  String get success => 'Succès';

  @override
  String get error => 'Erreur';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Information';

  // Date & Time
  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get tomorrow => 'Demain';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get thisYear => 'Cette année';

  @override
  String get lastMonth => 'Le mois dernier';

  @override
  String get lastYear => 'L\'année dernière';

  @override
  String get nextMonth => 'Le mois prochain';

  @override
  String get nextYear => 'L\'année prochaine';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get selectTime => 'Sélectionner une heure';

  @override
  String get dateRange => 'Plage de dates';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  // Numbers & Currency
  @override
  String get total => 'Total';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get balance => 'Solde';

  @override
  String get perMonth => 'par mois';

  @override
  String get perYear => 'par année';

  @override
  String get currency => 'Devise';

  @override
  String get percentage => 'Pourcentage';

  // Error messages
  @override
  String get errorLoadingProject => 'Erreur de chargement du projet';

  @override
  String get errorLoadingProjection => 'Erreur de chargement de la projection';

  @override
  String get errorLoadingScenarios => 'Erreur de chargement des scénarios';

  @override
  String get errorLoadingProjections => 'Erreur de chargement des projections';

  @override
  String get noScenariosAvailable => 'Aucun scénario disponible';

  @override
  String get createScenariosToCompare =>
      'Créez des scénarios pour les comparer';

  @override
  String get setupProject => 'Configurer le projet';

  // Dashboard KPIs
  @override
  String get kpis => 'ICP';

  @override
  String get comparison => 'Comparaison';

  @override
  String get keyPerformanceIndicators => 'Indicateurs clés de performance';

  @override
  String get quickSummaryProjection => 'Résumé rapide de votre projection';

  @override
  String get finalNetWorth => 'Valeur nette finale';

  @override
  String get atEndOfProjection => 'À la fin de la projection';

  @override
  String get lowestNetWorth => 'Valeur nette la plus basse';

  @override
  String get moneyRunsOut => 'Épuisement des fonds';

  @override
  String get totalTaxesPaid => 'Total des impôts payés';

  @override
  String get totalWithdrawals => 'Total des retraits';

  @override
  String get averageTaxRate => 'Taux d\'imposition moyen';

  @override
  String get netWorthProjection => 'Projection de la valeur nette';

  @override
  String get onlyOneScenarioExists => 'Un seul scénario existe';

  @override
  String get createAlternativeScenarios =>
      'Créez des scénarios alternatifs pour les comparer';

  @override
  String get noProjectionAvailable => 'Aucune projection disponible';

  @override
  String get completeProjectSetup =>
      'Complétez la configuration de votre projet pour voir les ICP';

  // Account type labels
  @override
  String get reerReturnRate => 'Taux de rendement REER';

  @override
  String get celiReturnRate => 'Taux de rendement CELI';

  @override
  String get criReturnRate => 'Taux de rendement CRI';

  @override
  String get cashReturnRateLabel => 'Taux de rendement liquidités';

  // Helper text
  @override
  String get expectedAnnualInflation => 'Taux d\'inflation annuel prévu';

  @override
  String get expectedReerReturn =>
      'Rendement annuel prévu pour les comptes REER';

  @override
  String get expectedCeliReturn =>
      'Rendement annuel prévu pour les comptes CELI';

  @override
  String get expectedCriReturn => 'Rendement annuel prévu pour les comptes CRI';

  @override
  String get expectedCashReturn =>
      'Rendement annuel prévu pour les comptes de liquidités';

  // Validation messages
  @override
  String get mustBeBetweenRange => 'Doit être entre -10% et 20%';

  // Clipboard
  @override
  String get copiedToClipboard => 'Copié dans le presse-papiers';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  // Import/Export descriptions
  @override
  String get importExportDescription =>
      'Importez ou exportez les données du projet pour la sauvegarde, le partage de cas de test ou le transfert entre comptes';

  @override
  String get fileSelectionNotSupported =>
      'La sélection de fichiers n\'est pas prise en charge sur cette plateforme';

  @override
  String get assetsNotLoaded =>
      'Les actifs n\'ont pas pu être chargés et ne seront pas inclus';

  @override
  String get eventsNotLoaded =>
      'Les événements n\'ont pas pu être chargés et ne seront pas inclus';

  @override
  String get expensesNotLoaded =>
      'Les dépenses n\'ont pas pu être chargées et ne seront pas incluses';

  @override
  String get scenariosNotLoaded =>
      'Les scénarios n\'ont pas pu être chargés et ne seront pas inclus';

  @override
  String get dataExportedTo => 'Données du projet exportées vers';

  @override
  String get dataExportedWithWarnings =>
      'Données du projet exportées avec des avertissements';

  @override
  String get warnings => 'Avertissements';

  // Authentication
  @override
  String get userNotAuthenticated => 'Utilisateur non authentifié';

  @override
  String get repositoryNotAvailable => 'Dépôt de projet non disponible';

  @override
  String get invalidRateValues => 'Valeurs de taux invalides';

  // Empty state descriptions
  @override
  String get createFirstProject =>
      'Créez votre premier projet de planification de retraite';

  @override
  String get addPeopleToRetirementPlan =>
      'Ajoutez les personnes impliquées dans ce plan de retraite';

  // Wizard - Common
  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get noProjectSelected => 'Aucun projet sélectionné';

  @override
  String get selectBirthdate => 'Sélectionner la date de naissance';

  @override
  String get pleaseSelectBirthdate =>
      'Veuillez sélectionner une date de naissance';

  @override
  String get clickNextToSaveAndContinue =>
      'Cliquez sur "Suivant" pour enregistrer et continuer';

  @override
  String get clickNextOrSkip =>
      'Cliquez sur "Suivant" pour continuer, ou "Passer" pour ignorer';

  @override
  String get nameMinTwoCharacters =>
      'Le nom doit contenir au moins 2 caractères';

  @override
  String get projectNameMinLength =>
      'Le nom du projet doit contenir au moins 3 caractères';

  @override
  String get pleaseEnterValidNumber => 'Veuillez entrer un nombre valide';

  @override
  String get incomeCannotBeNegative => 'Le revenu ne peut pas être négatif';

  @override
  String get pleaseEnterRealisticIncome => 'Veuillez entrer un revenu réaliste';

  @override
  String get failedToSave => 'Échec de l\'enregistrement';

  // Wizard - Partner Section
  @override
  String get partnerInformation => 'Informations sur le conjoint';

  @override
  String get partnerSectionDescription =>
      'Ajoutez votre conjoint(e) ou partenaire (optionnel). Laissez vide si vous n\'avez pas de partenaire ou préférez planifier individuellement.';

  @override
  String get partnerName => 'Nom du conjoint';

  @override
  String get enterPartnerName => 'Entrez le nom de votre conjoint(e)';

  @override
  String get pleaseEnterPartnerName => 'Veuillez entrer le nom du conjoint';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get selectPartnerBirthdate =>
      'Sélectionner la date de naissance du conjoint';

  @override
  String get partnerSectionInstructions =>
      'Cliquez sur "Suivant" pour enregistrer et continuer, ou "Passer" pour continuer sans ajouter de conjoint';

  // Wizard - Primary Individual Section
  @override
  String get exampleName => 'ex. Jean Tremblay';

  @override
  String get ageYears => 'Âge : {age} ans';

  // Wizard - Project Basics Section
  @override
  String get projectNameHint => 'ex. Mon plan de retraite 2025';

  @override
  String get projectDescriptionHint =>
      'Optionnel : Ajoutez des notes sur ce scénario de planification';

  // Wizard - Assets Section
  @override
  String get yourAssets => 'Vos actifs';

  @override
  String get assetsSectionDescription =>
      'Ajoutez vos actifs de retraite tels que l\'immobilier, REER, CELI et autres comptes (optionnel). Les actifs aident à calculer votre valeur nette et à projeter votre avenir financier.';

  @override
  String get deleteAssetTitle => 'Supprimer l\'actif';

  @override
  String get deleteAssetConfirmation =>
      'Êtes-vous sûr de vouloir supprimer cet actif ?\n\nCette action ne peut pas être annulée.';

  @override
  String get noAssetsYet => 'Aucun actif pour l\'instant';

  @override
  String get addFirstAssetOrSkip =>
      'Ajoutez votre premier actif pour commencer, ou passez cette section';

  @override
  String get errorLoadingAssets => 'Erreur lors du chargement des actifs';

  @override
  String get clickNextOrSkipAssets =>
      'Cliquez sur "Suivant" pour continuer, ou "Passer" pour ignorer l\'entrée des actifs';

  // Wizard - Employment Section
  @override
  String get employmentSectionDescription =>
      'Entrez le revenu d\'emploi annuel pour chaque personne (optionnel). Cela aide à projeter votre situation financière avant la retraite.';

  @override
  String get noIndividualsFound => 'Aucune personne trouvée';

  @override
  String get pleaseAddIndividuals =>
      'Veuillez ajouter des personnes dans les sections précédentes';

  @override
  String get annualEmploymentIncome => 'Revenu d\'emploi annuel';

  @override
  String get enterAnnualSalary => 'Entrez le salaire annuel';

  @override
  String get cadPerYear => 'CAD / an';

  @override
  String get leaveEmptyIfNotEmployed =>
      'Laissez vide si la personne n\'est pas employée';

  @override
  String get incomeUsedUntilRetirement =>
      'Ce revenu sera utilisé dans les projections jusqu\'à la retraite';

  @override
  String get clickNextOrSkipEmployment =>
      'Cliquez sur "Suivant" pour continuer, ou "Passer" pour ignorer le revenu d\'emploi';

  // Wizard - Expenses Section
  @override
  String get annualExpenses => 'Dépenses annuelles';

  @override
  String get expensesSectionDescription =>
      'Entrez vos dépenses annuelles approximatives par catégorie (optionnel). Cela aide à projeter vos besoins de trésorerie à la retraite.';

  @override
  String get annualAmount => 'Montant annuel';

  @override
  String get housingExpenseHint =>
      'Hypothèque, loyer, taxe foncière, services publics';

  @override
  String get transportationExpenseHint =>
      'Paiements auto, essence, assurance, transport en commun';

  @override
  String get foodExpenseHint => 'Épicerie, vêtements, soins personnels';

  @override
  String get leisureExpenseHint =>
      'Divertissement, loisirs, restaurants, voyages';

  @override
  String get healthExpenseHint => 'Assurance, médical, médicaments';

  @override
  String get familyExpenseHint =>
      'Garde d\'enfants, éducation, soutien familial';

  @override
  String get errorLoadingExpenses => 'Erreur lors du chargement des dépenses';

  // Wizard - Government Benefits Section
  @override
  String get governmentBenefitsTitle => 'Prestations gouvernementales';

  @override
  String get governmentBenefitsSectionDescription =>
      'Planifiez quand vous souhaitez commencer à recevoir les prestations gouvernementales (optionnel). Vous pourrez les ajuster plus tard.';

  @override
  String get ageLabel => 'Âge';

  @override
  String get rrqAgeHint => '60-70';

  @override
  String get rrqAgeHelper => 'Âge 60 (réduit) à 70 (augmenté)';

  @override
  String get psvAgeHint => '65-70';

  @override
  String get psvAgeHelper => 'Âge 65 (standard) à 70 (augmenté)';

  @override
  String get atAge60 => 'À 60 ans';

  @override
  String get atAge65 => 'À 65 ans';

  @override
  String get reducedAmount => 'Montant réduit';

  @override
  String get fullAmount => 'Montant complet';

  // Wizard - Retirement Section
  @override
  String get retirementPlanning => 'Planification de la retraite';

  @override
  String get retirementSectionDescription =>
      'Planifiez quand chaque personne prendra sa retraite (optionnel). Cela affecte les projections de revenus et l\'admissibilité aux prestations.';

  @override
  String get retirementAgeHint => '55-75';

  @override
  String get typicalRetirementAge =>
      'L\'âge typique de la retraite est de 60 à 67 ans';

  @override
  String get yearsLabel => 'ans';

  @override
  String get retiringThisYear => 'Retraite cette année';

  // Wizard - Life Events Section
  @override
  String get lifePlanning => 'Planification de vie';

  @override
  String get lifeEventsSectionDescription =>
      'Planifiez les événements majeurs de la vie (optionnel). Cela aide à projeter les besoins financiers à long terme et la planification successorale.';

  @override
  String get lifeExpectancyHint => '75-100';

  @override
  String get averageLifeExpectancy => 'Espérance de vie moyenne : 80-85 ans';

  // Wizard - Summary Section
  @override
  String get summaryAndReview => 'Résumé et révision';

  @override
  String get loadingSection => 'Chargement de {section}...';

  @override
  String get failedToComplete => 'Échec de la complétion';
}
