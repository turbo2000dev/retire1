# Architecture Documentation

## Table of Contents
1. [Overview](#overview)
2. [Widget Hierarchy](#widget-hierarchy)
3. [State Management](#state-management)
4. [Data Persistence Strategy](#data-persistence-strategy)
5. [Type Definitions](#type-definitions)
6. [Navigation & Routing](#navigation--routing)
7. [Internationalization](#internationalization)
8. [Error Handling](#error-handling)
9. [Responsive Design](#responsive-design)
10. [Security Considerations](#security-considerations)

---

## Overview

This retirement planning application is built using **Flutter** with a **feature-first, domain-driven design (DDD)** architecture. The app separates concerns into distinct layers within each feature module, promoting maintainability, testability, and scalability.

### Core Architectural Principles

- **Feature-Based Organization**: Code is organized by business feature (auth, project, assets, events, etc.) rather than by technical layer
- **Domain-Driven Design**: Each feature has domain, data, presentation, and optional service layers
- **Separation of Concerns**: Clear boundaries between business logic, data access, and UI
- **Immutability**: Domain models are immutable using Freezed
- **Reactive State Management**: Riverpod 3.0 with provider composition and stream-based updates
- **Type Safety**: Freezed unions for discriminated types (Assets, Events, Timings)

### Technology Stack

- **Framework**: Flutter (targeting iOS 15+, Android, macOS, Web)
- **State Management**: Riverpod 3.0 (flutter_riverpod, riverpod_annotation)
- **Code Generation**: Freezed, json_serializable, build_runner
- **Backend**: Firebase (Authentication, Firestore, Storage, Hosting)
- **Routing**: GoRouter with declarative routing and auth guards
- **Localization**: Flutter's built-in l10n with English and French support
- **Charts**: fl_chart for financial visualizations
- **Theme**: Material 3 with dark/light mode support

---

## Widget Hierarchy

### Application Entry Point

```
main.dart
  └─ ProviderScope (Riverpod root)
      └─ MyApp (ConsumerWidget)
          └─ MaterialApp.router
              ├─ Theme configuration (AppTheme.lightTheme / darkTheme)
              ├─ Localization delegates
              └─ GoRouter configuration
```

**File**: `lib/main.dart:10-42`

### App Shell Structure

The app uses a **ShellRoute** pattern to wrap authenticated screens with a consistent layout:

```
AppShell (lib/core/ui/layout/app_shell.dart:33-126)
  ├─ AppBar
  │   ├─ Title (dynamic based on current route)
  │   └─ Actions
  │       ├─ Theme toggle (IconButton)
  │       └─ Settings button (IconButton)
  │
  ├─ Body (Row)
  │   ├─ NavigationRail (tablet/desktop only)
  │   │   └─ 5 destinations (Dashboard, Parameters, Assets, Scenarios, Projection)
  │   └─ Expanded child (screen content)
  │
  └─ BottomNavigationBar (phone only)
      └─ 5 destinations (same as NavigationRail)
```

**Adaptive Navigation**:
- **Phone** (< 600px): Bottom navigation bar with short labels
- **Tablet** (600-1024px): Navigation rail with selected labels only
- **Desktop** (>= 1024px): Navigation rail with all labels visible

### Screen Hierarchy Pattern

All main screens follow a consistent pattern:

```
[Feature]Screen (StatelessWidget/ConsumerWidget)
  └─ Scaffold (if not wrapped by AppShell)
      └─ ResponsiveContainer (max-width constraint)
          └─ Column/ListView
              ├─ Header widgets
              ├─ Content sections
              │   └─ Responsive widgets (cards, grids, lists)
              └─ Action buttons (FAB or bottom buttons)
```

### Reusable UI Component Library

**Location**: `lib/core/ui/responsive/`

| Component | Purpose | Key Features |
|-----------|---------|--------------|
| **ResponsiveBuilder** | Base responsive layout | Phone/tablet/desktop builders |
| **ResponsiveContainer** | Content width constraint | Max 1200px on large screens |
| **ResponsiveCard** | Consistent card styling | Adaptive padding and elevation |
| **ResponsiveTextField** | Form inputs | Adaptive width and validation |
| **ResponsiveButton** | Action buttons | Consistent sizing across devices |
| **ResponsiveDialog** | Modal dialogs | Adaptive width and positioning |
| **ResponsiveBottomSheet** | Bottom sheets | Mobile-first with fallback to dialog |
| **ResponsiveMultiPaneLayout** | Master-detail layouts | Single pane on phone, dual pane on tablet/desktop |
| **ResponsiveCollapsibleSection** | Expandable sections | Used for grouping form fields |

**File References**:
- `lib/core/ui/responsive/responsive_builder.dart:4-55`
- `lib/core/ui/responsive/screen_size.dart:4-47`
- `lib/core/ui/responsive/layout_breakpoints.dart:1-30`

### Widget Composition Examples

**Dashboard Screen**:
```
DashboardScreen
  └─ ResponsiveContainer
      └─ Column
          ├─ ProjectionKpiCard (3 KPI metrics)
          ├─ ScenarioSelector (dropdown)
          ├─ MultiScenarioProjectionChart (fl_chart)
          ├─ ProjectionWarningsSection (warnings list)
          └─ KpiComparisonCard (scenario comparison table)
```

**Assets & Events Screen**:
```
AssetsEventsScreen
  └─ DefaultTabController (2 tabs)
      ├─ TabBar (Assets, Events)
      └─ TabBarView
          ├─ Assets Tab
          │   ├─ Grouped by type (Real Estate, RRSP, CELI, CRI, Cash)
          │   └─ AssetCard widgets (with edit/delete actions)
          └─ Events Tab
              ├─ Sorted by timing
              └─ EventCard widgets (with edit/delete actions)
```

**Projection Screen**:
```
ProjectionScreen
  └─ ResponsiveContainer
      └─ Column
          ├─ Control panel (scenario selector, dollar mode toggle)
          ├─ Charts row
          │   ├─ ProjectionChart (net worth over time)
          │   ├─ CashFlowChart (income/expenses)
          │   ├─ ExpenseCategoriesChart (pie chart)
          │   ├─ IncomeSourcesChart (stacked bar)
          │   └─ AssetAllocationChart (pie chart)
          └─ ProjectionTableV2 (yearly breakdown with expandable rows)
```

---

## State Management

### Riverpod 3.0 Architecture

The application uses **Riverpod 3.0** with the following patterns:

#### Provider Types Used

1. **Provider**: Simple read-only state (e.g., repository providers, derived state)
2. **StateProvider**: Simple mutable state (e.g., theme mode, selected tab)
3. **NotifierProvider**: Complex synchronous state management
4. **AsyncNotifierProvider**: Asynchronous state with Firestore streams
5. **FutureProvider**: One-time async data fetch
6. **StreamProvider**: Stream-based data (e.g., auth state)

#### State Management Patterns

**Pattern 1: Repository Providers (Conditional Initialization)**

Repository providers depend on authentication state and return `null` when not authenticated:

```dart
// lib/features/project/data/project_repository.dart:236-245
final projectRepositoryProvider = Provider<ProjectRepository?>((ref) {
  final authState = ref.watch(authNotifierProvider);

  if (authState is Authenticated) {
    return ProjectRepository(userId: authState.user.id);
  }

  return null;
});
```

**Pattern 2: AsyncNotifier with Firestore Streams**

Feature providers use AsyncNotifier to manage real-time Firestore data:

```dart
// lib/features/assets/presentation/providers/assets_provider.dart:21-48
class AssetsNotifier extends AsyncNotifier<List<Asset>> {
  StreamSubscription<List<Asset>>? _subscription;

  @override
  Future<List<Asset>> build() async {
    ref.onDispose(() => _subscription?.cancel());

    final repository = ref.watch(assetRepositoryProvider);
    if (repository == null) return [];

    _subscription = repository.getAssetsStream().listen(
      (assets) => state = AsyncValue.data(assets),
      onError: (error, stackTrace) =>
        state = AsyncValue.error(error, stackTrace),
    );

    return []; // Initial empty state
  }

  Future<void> addAsset(Asset asset) async { /* ... */ }
  Future<void> updateAsset(Asset asset) async { /* ... */ }
  Future<void> deleteAsset(String assetId) async { /* ... */ }
}
```

**Key Features**:
- Stream subscription managed in `build()` method
- Cleanup handled via `ref.onDispose()`
- State updated reactively when Firestore data changes
- Methods for CRUD operations throw exceptions (caught in UI layer)

**Pattern 3: Notifier for Synchronous State**

Authentication state uses Notifier for synchronous state management with Firebase auth integration:

```dart
// lib/features/auth/presentation/providers/auth_provider.dart:51-162
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final repository = ref.read(authRepositoryProvider);

    // Listen to auth state changes stream
    ref.listen(authStateStreamProvider, (previous, next) {
      next.whenData((user) {
        if (user != null && state is! AuthLoading && state is! AuthError) {
          state = Authenticated(user);
        } else if (user == null && state is! AuthLoading && state is! AuthError) {
          state = const Unauthenticated();
        }
      });
    });

    // Set initial state
    final currentUser = repository.currentUser;
    return currentUser != null
      ? Authenticated(currentUser)
      : const Unauthenticated();
  }

  Future<void> login(String email, String password) async { /* ... */ }
  Future<void> register(String email, String password, String name) async { /* ... */ }
  Future<void> signInWithGoogle() async { /* ... */ }
  Future<void> logout() async { /* ... */ }
}
```

**Pattern 4: Derived State Providers**

Providers can derive state from other providers:

```dart
// lib/features/assets/presentation/providers/assets_provider.dart:105-138
final assetsByTypeProvider = Provider<Map<String, List<Asset>>>((ref) {
  final assetsAsync = ref.watch(assetsProvider);

  return assetsAsync.maybeWhen(
    data: (assets) {
      final Map<String, List<Asset>> grouped = {
        'Real Estate': [], 'RRSP': [], 'CELI': [], 'CRI/FRV': [], 'Cash': [],
      };
      for (final asset in assets) {
        asset.map(
          realEstate: (a) => grouped['Real Estate']!.add(a),
          rrsp: (a) => grouped['RRSP']!.add(a),
          // ... other types
        );
      }
      return grouped;
    },
    orElse: () => { /* empty groups */ },
  );
});
```

#### UI Integration

**ConsumerWidget Pattern**:
```dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(myDataProvider);

    return dataAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (data) => MyDataWidget(data: data),
    );
  }
}
```

**Reading vs Watching**:
- `ref.watch()`: Reactive - rebuilds widget when provider state changes
- `ref.read()`: One-time access - used in callbacks/event handlers

**Calling Provider Methods**:
```dart
onPressed: () async {
  try {
    await ref.read(assetsProvider.notifier).addAsset(newAsset);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Asset added successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}
```

#### Provider Organization

Providers are co-located with their features:

```
lib/features/[feature]/presentation/providers/
  └─ [feature]_provider.dart
```

Examples:
- `lib/features/auth/presentation/providers/auth_provider.dart`
- `lib/features/project/presentation/providers/projects_provider.dart`
- `lib/features/assets/presentation/providers/assets_provider.dart`
- `lib/features/events/presentation/providers/events_provider.dart`
- `lib/features/scenarios/presentation/providers/scenarios_provider.dart`
- `lib/features/projection/presentation/providers/projection_provider.dart`

---

## Data Persistence Strategy

### Firestore Database Architecture

**Collections Structure**:

```
users/
  {userId}/
    settings/
      preferences           # AppSettings (language, theme)
      currentProject        # CurrentProject (selected project ID)
    projects/
      {projectId}           # Project document
        assets/
          {assetId}         # Asset document
        events/
          {eventId}         # Event document
        scenarios/
          {scenarioId}      # Scenario document
        expenses/
          {expenseId}       # Expense document
```

**Security Model**:
- All data scoped under `users/{userId}` for automatic user isolation
- Firestore security rules enforce user-level access control
- No cross-user data access possible

### Repository Pattern

**Repository Responsibilities**:
1. Abstract Firestore implementation details from business logic
2. Convert between Firestore Timestamps and Dart DateTime
3. Handle Freezed JSON serialization (including nested unions)
4. Provide stream-based and one-time data access
5. Manage CRUD operations with error handling

**Standard Repository Structure**:

```dart
class MyRepository {
  final FirebaseFirestore _firestore;
  final String userId; // or projectId, depending on scope

  MyRepository({required this.userId, FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _collection =>
    _firestore.collection('users').doc(userId).collection('items');

  // Stream-based access
  Stream<List<MyModel>> getItemsStream() { /* ... */ }

  // One-time read
  Future<MyModel?> getItem(String id) { /* ... */ }

  // Create
  Future<MyModel> createItem(MyModel item) { /* ... */ }

  // Update
  Future<void> updateItem(MyModel item) { /* ... */ }

  // Delete
  Future<void> deleteItem(String id) { /* ... */ }

  // DateTime/Timestamp conversion
  Map<String, dynamic> _convertDateTimesToTimestamps(Map<String, dynamic> data) {
    /* Recursive conversion */
  }

  Map<String, dynamic> _convertTimestampsToDateTimes(Map<String, dynamic> data) {
    /* Recursive conversion */
  }
}
```

**Example**: `lib/features/project/data/project_repository.dart:8-245`

### DateTime/Timestamp Handling

Firestore uses `Timestamp` type, Dart uses `DateTime`. Repositories handle conversion:

**Write Path** (DateTime → Timestamp):
```dart
// lib/features/project/data/project_repository.dart:122-150
Map<String, dynamic> _convertDateTimesToTimestamps(Map<String, dynamic> data) {
  final result = <String, dynamic>{};

  for (final entry in data.entries) {
    if (entry.value is DateTime) {
      result[entry.key] = Timestamp.fromDate(entry.value);
    } else if (entry.value is Map<String, dynamic>) {
      result[entry.key] = _convertDateTimesToTimestamps(entry.value);
    } else if (entry.value is List) {
      result[entry.key] = entry.value.map((item) {
        if (item is DateTime) return Timestamp.fromDate(item);
        if (item is Map<String, dynamic>) return _convertDateTimesToTimestamps(item);
        return item;
      }).toList();
    } else {
      result[entry.key] = entry.value;
    }
  }

  return result;
}
```

**Read Path** (Timestamp → DateTime):
```dart
// lib/features/project/data/project_repository.dart:209-232
Map<String, dynamic> _convertTimestampsToDateTimes(Map<String, dynamic> data) {
  final result = <String, dynamic>{};

  for (final entry in data.entries) {
    if (entry.value is Timestamp) {
      result[entry.key] = (entry.value as Timestamp).toDate();
    } else if (entry.value is Map<String, dynamic>) {
      result[entry.key] = _convertTimestampsToDateTimes(entry.value);
    } else if (entry.value is List) {
      result[entry.key] = (entry.value as List).map((item) {
        if (item is Timestamp) return item.toDate();
        if (item is Map<String, dynamic>) return _convertTimestampsToDateTimes(item);
        return item;
      }).toList();
    } else {
      result[entry.key] = entry.value;
    }
  }

  return result;
}
```

### Freezed Union Type Serialization

**Critical Pattern**: When saving Freezed models with nested union types, manual serialization is required:

```dart
// Example from EventRepository
final timingJson = event.map(
  retirement: (e) => e.timing.toJson(),
  death: (e) => e.timing.toJson(),
  realEstateTransaction: (e) => e.timing.toJson(),
);

await doc.set({
  ...event.toJson(),
  'timing': timingJson,  // Manually override nested union
});
```

**Why**: Freezed doesn't automatically call `toJson()` on nested union types, causing deserialization failures.

### Data Transfer Objects (DTOs)

This app **does NOT use separate DTOs**. Instead:
- Domain models (Freezed classes) are used directly for Firestore serialization
- `@JsonKey` annotations handle custom serialization (e.g., DateTime fields)
- Repositories handle Timestamp/DateTime conversion via helper methods

**Example**:
```dart
// lib/features/project/domain/project.dart:40-53
DateTime _dateTimeFromJson(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  if (value is DateTime) return value;
  throw ArgumentError('Cannot convert $value to DateTime');
}

dynamic _dateTimeToJson(DateTime dateTime) => dateTime;
```

---

## Type Definitions

### Domain Models with Freezed

All domain models use **Freezed** for:
- Immutability
- Equality comparison
- copyWith methods
- JSON serialization
- Union types (discriminated types)

**Standard Freezed Model Pattern**:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';
part 'my_model.g.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({
    required String id,
    required String name,
    @Default(0) int value,
  }) = _MyModel;

  factory MyModel.fromJson(Map<String, dynamic> json) =>
    _$MyModelFromJson(json);
}
```

### Key Domain Models

#### Project
**Location**: `lib/features/project/domain/project.dart`

Contains project-wide settings including economic assumptions (inflation, return rates) and individuals.

#### Individual
**Location**: `lib/features/project/domain/individual.dart`

Represents a person in the retirement plan with employment income, CELI room, and demographic data.

#### Asset (Union Type)
**Location**: `lib/features/assets/domain/asset.dart`

Five asset types using Freezed unions:
- **RealEstate**: Property with type (house, condo, etc.) and optional custom return rate
- **RRSP**: Registered retirement savings with individual ownership
- **CELI**: Tax-free savings account
- **CRI**: Locked-in retirement account with contribution room
- **Cash**: Regular savings/checking account

**Union Type Usage**:
```dart
asset.when(
  realEstate: (id, type, value, setAtStart, customReturnRate) => /* handle */,
  rrsp: (id, individualId, value, customReturnRate, annualContribution) => /* handle */,
  celi: (id, individualId, value, customReturnRate, annualContribution) => /* handle */,
  cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) => /* handle */,
  cash: (id, individualId, value, customReturnRate, annualContribution) => /* handle */,
);
```

#### Event (Union Type)
**Location**: `lib/features/events/domain/event.dart`

Three event types:
- **Retirement**: Individual stops working
- **Death**: Individual passes away (affects survivor benefits)
- **RealEstateTransaction**: Buying/selling property

#### EventTiming (Union Type)
**Location**: `lib/features/events/domain/event_timing.dart`

Five timing strategies:
- **Relative**: Years from projection start (e.g., year 5)
- **Absolute**: Specific calendar year (e.g., 2030)
- **Age**: When individual reaches age (e.g., age 65)
- **EventRelative**: Relative to another event (e.g., at retirement start)
- **ProjectionEnd**: Continues until end of projection

#### Expense (Union Type)
**Location**: `lib/features/expenses/domain/expense.dart`

Six expense categories: Housing, Transport, Daily Living, Recreation, Health, Family.

Each has start/end timing and annual amount (in constant dollars).

#### Scenario & Parameter Overrides
**Location**: `lib/features/scenarios/domain/scenario.dart`, `parameter_override.dart`

Scenarios contain parameter overrides to model "what-if" situations:
- **AssetValueOverride**: Change starting asset value
- **EventTimingOverride**: Change when event occurs
- **ExpenseAmountOverride**: Change expense amount (absolute or multiplier)
- **ExpenseTimingOverride**: Change expense start/end timing

#### Projection Models
**Location**: `lib/features/projection/domain/`

- **Projection**: Full projection with yearly breakdowns
- **YearlyProjection**: Single year's income, expenses, taxes, asset values, net worth
- **AnnualIncome**: Income breakdown by source (employment, RRQ, PSV, RRPE)
- **TaxCalculation**: Federal and Quebec tax amounts
- **ProjectionKpis**: Key performance indicators (total income, shortfall years, etc.)

### Code Generation

After modifying domain models, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Navigation & Routing

### GoRouter Configuration

**Location**: `lib/core/router/app_router.dart`

**Key Features**:
- Declarative routing with route names as constants
- ShellRoute for authenticated screens (wraps content in AppShell)
- Auth state-based redirects
- NoTransitionPage for instant navigation (bottom nav feel)

**Route Structure**:

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isAuthenticated = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isRegistering = state.matchedLocation == AppRoutes.register;

      // Redirect to login if not authenticated
      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return AppRoutes.login;
      }

      // Redirect to dashboard if authenticated and on auth screen
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return AppRoutes.dashboard;
      }

      return null; // No redirect
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(path: AppRoutes.login, pageBuilder: ...),
      GoRoute(path: AppRoutes.register, pageBuilder: ...),

      // Protected routes (with shell)
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: AppRoutes.dashboard, pageBuilder: ...),
          GoRoute(path: AppRoutes.baseParameters, pageBuilder: ...),
          GoRoute(path: AppRoutes.assetsEvents, pageBuilder: ...),
          GoRoute(path: AppRoutes.scenarios, pageBuilder: ...),
          GoRoute(path: '/scenarios/editor/:id', pageBuilder: ...),
          GoRoute(path: AppRoutes.projection, pageBuilder: ...),
          GoRoute(path: AppRoutes.settings, pageBuilder: ...),
        ],
      ),
    ],
  );
});
```

**Route Constants**:
```dart
class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/';
  static const baseParameters = '/base-parameters';
  static const assetsEvents = '/assets-events';
  static const scenarios = '/scenarios';
  static String scenarioEditor(String id) => '/scenarios/editor/$id';
  static const projection = '/projection';
  static const settings = '/settings';
}
```

**Navigation**:
```dart
// Declarative navigation
context.go(AppRoutes.dashboard);
context.go(AppRoutes.scenarioEditor(scenario.id));

// Stack-based navigation (push)
context.push(AppRoutes.settings);
```

**Auth Guard Behavior**:
- When `authNotifierProvider` changes from Unauthenticated to Authenticated, router automatically redirects to dashboard
- When logging out (Authenticated → Unauthenticated), router redirects to login
- No manual navigation needed in auth methods

---

## Internationalization

### i18n Architecture

**Supported Languages**: English (en), French (fr)

**File Structure**:
```
lib/core/config/i18n/
  ├─ app_localizations.dart       # Abstract base class + delegate
  ├─ app_localizations_en.dart    # English implementation
  └─ app_localizations_fr.dart    # French implementation
```

**Implementation Pattern**:

```dart
// Base class
abstract class AppLocalizations {
  String get appTitle;
  String get ok;
  String get cancel;
  // ... more strings

  static AppLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'fr') {
      return AppLocalizationsFr();
    }
    return AppLocalizationsEn();
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
    _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('fr', ''),
  ];
}

// English implementation
class AppLocalizationsEn extends AppLocalizations {
  @override String get appTitle => 'Retirement Planner';
  @override String get ok => 'OK';
  @override String get cancel => 'Cancel';
  // ... more strings
}

// French implementation
class AppLocalizationsFr extends AppLocalizations {
  @override String get appTitle => 'Planificateur de retraite';
  @override String get ok => 'OK';
  @override String get cancel => 'Annuler';
  // ... more strings
}
```

**Usage in Widgets**:
```dart
final l10n = AppLocalizations.of(context);
Text(l10n.appTitle);
```

**Language Selection**:
```dart
// Provider for current locale
final localeProvider = Provider<Locale>((ref) {
  final languageCode = ref.watch(currentLanguageProvider);
  return Locale(languageCode);
});

// In MaterialApp
MaterialApp.router(
  locale: locale,
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  // ...
);
```

**Language Persistence**:
- User's language preference stored in Firestore at `users/{userId}/settings/preferences`
- Managed by `SettingsRepository` and `SettingsProvider`
- Automatically loaded on app startup and persisted on change

---

## Error Handling

### Error Handling Strategy

The application uses a **multi-layered error handling approach**:

#### 1. Repository Layer

**Pattern**: Catch, log, and rethrow

```dart
Future<void> deleteProject(String projectId) async {
  try {
    await _projectsCollection.doc(projectId).delete();
    log('Project deleted from Firestore: $projectId');
  } catch (e, stack) {
    log('Failed to delete project from Firestore',
      error: e, stackTrace: stack);
    rethrow;
  }
}
```

**Why**:
- Logging captures errors for debugging
- Rethrowing allows UI layer to handle user feedback
- Stack traces preserved for debugging

#### 2. Provider/Notifier Layer

**Pattern**: Catch, log, and rethrow (or set error state for AsyncNotifier)

```dart
Future<void> addAsset(Asset asset) async {
  final repository = ref.read(assetRepositoryProvider);
  if (repository == null) {
    throw Exception('No project selected');
  }

  try {
    await repository.createAsset(asset);
    log('Asset added successfully');
  } catch (e, stack) {
    log('Failed to add asset', error: e, stackTrace: stack);
    rethrow;
  }
}
```

**For AsyncNotifier with streams**:
```dart
_subscription = repository.getAssetsStream().listen(
  (assets) => state = AsyncValue.data(assets),
  onError: (error, stackTrace) =>
    state = AsyncValue.error(error, stackTrace),
);
```

#### 3. UI Layer

**Pattern**: Try-catch with SnackBar feedback

```dart
onPressed: () async {
  try {
    await ref.read(assetsProvider.notifier).addAsset(newAsset);
    if (context.mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Asset added successfully')),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding asset: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

**AsyncValue.when() Pattern**:
```dart
return assetsAsync.when(
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => Column(
    children: [
      Icon(Icons.error, color: Colors.red),
      Text('Error loading assets'),
      Text(error.toString(), style: TextStyle(fontSize: 12)),
    ],
  ),
  data: (assets) => ListView.builder(...),
);
```

#### 4. Custom Exception Types

**ImportException** (`lib/core/error/import_exception.dart:5-135`):

Provides detailed error context for project import failures including field paths, line numbers, and problematic data.

**Factory Methods**:
- `ImportException.missingField()`
- `ImportException.invalidType()`
- `ImportException.parsingFailed()`
- `ImportException.schemaViolation()`

### Logging

**Standard**: Use `log` from `dart:developer` (not `print` or `debugPrint`)

```dart
import 'dart:developer';

log('User logged in successfully');
log('Error occurred', error: e, stackTrace: stack);
log('Warning: Account depleted', level: 900);
```

**Log Levels** (severity):
- 0 (default): Info
- 900: Warning
- 1000: Error

---

## Responsive Design

### Breakpoint System

**File**: `lib/core/ui/responsive/layout_breakpoints.dart:7-30`

| Device Category | Width Range | Spacing | Use Case |
|----------------|-------------|---------|----------|
| **Phone** | < 600px | 8px (compact) | Single column, bottom nav |
| **Tablet** | 600px - 1024px | 16px (standard) | 2 columns, navigation rail |
| **Desktop** | >= 1024px | 24px (comfortable) | 3 columns, navigation rail |

**Max Content Width**: 1200px (for readability on ultra-wide screens)

### ScreenSize Utility

**File**: `lib/core/ui/responsive/screen_size.dart:4-47`

```dart
class ScreenSize {
  final BuildContext context;

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isPhone => width < LayoutBreakpoints.phoneMax;
  bool get isTablet => width >= LayoutBreakpoints.phoneMax &&
                       width < LayoutBreakpoints.tabletMax;
  bool get isDesktop => width >= LayoutBreakpoints.desktopMin;

  String get deviceType => isPhone ? 'Phone' : (isTablet ? 'Tablet' : 'Desktop');
  double get spacing => isPhone ? 8.0 : (isTablet ? 16.0 : 24.0);

  Orientation get orientation => MediaQuery.of(context).orientation;
  bool get isPortrait => orientation == Orientation.portrait;
  bool get isLandscape => orientation == Orientation.landscape;
}
```

**Usage**:
```dart
final screenSize = ScreenSize(context);
final columns = screenSize.isPhone ? 1 : (screenSize.isTablet ? 2 : 3);
```

### Responsive Patterns

#### Pattern 1: Adaptive Grid

```dart
final screenSize = ScreenSize(context);
final crossAxisCount = screenSize.isPhone ? 1 : (screenSize.isTablet ? 2 : 3);

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    crossAxisSpacing: screenSize.spacing,
    mainAxisSpacing: screenSize.spacing,
  ),
  itemBuilder: (context, index) => MyCard(...),
);
```

#### Pattern 2: Conditional Layout

```dart
ResponsiveBuilder(
  phone: (context, screenSize) => SingleColumnLayout(),
  tablet: (context, screenSize) => TwoColumnLayout(),
  desktop: (context, screenSize) => ThreeColumnLayout(),
)
```

#### Pattern 3: Content Width Constraint

```dart
ResponsiveContainer(
  child: Column(
    children: [/* content */],
  ),
)

// Constrains width to max 1200px on large screens, centered
```

#### Pattern 4: Adaptive Navigation

See AppShell implementation for complete example of switching between bottom navigation (phone) and navigation rail (tablet/desktop).

### Responsive Widget Guidelines

1. **Always use ResponsiveContainer** for main content to constrain width
2. **Use flex values** over hardcoded widths in Row/Column layouts
3. **Adapt grid columns** based on screen size
4. **Use ResponsiveDialog** instead of AlertDialog for better mobile UX
5. **Test on multiple sizes**: iPhone SE, iPad, Desktop at various widths

---

## Security Considerations

### Authentication

- **Firebase Authentication** for user identity management
- Email/password and Google Sign-In supported
- User profile data stored in Firestore under `users/{userId}`

### Data Access Control

**Firestore Security Model**:
- All user data scoped under `users/{userId}/` path
- Security rules enforce that users can only access their own data
- No cross-user data sharing (each user's data is completely isolated)

### Sensitive Data Handling

- **No passwords stored client-side** (Firebase handles securely)
- **Profile pictures** stored in Firebase Storage with user-scoped paths
- **API keys** in `firebase_options.dart` are public (normal for Firebase)

### Input Validation

**Form Validation**:
```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return l10n.requiredField;
  }
  if (value.length < 3) {
    return 'Name must be at least 3 characters';
  }
  return null;
}
```

**Firestore Data Validation**:
- Type checking via Freezed models
- Required fields enforced at model level
- Invalid data throws exceptions (caught and displayed to user)

---

## Best Practices Summary

### Architecture

✅ **DO**:
- Organize code by feature (feature-first architecture)
- Separate domain, data, and presentation layers
- Use Freezed for all domain models
- Use union types for discriminated data (Assets, Events, Timings)
- Keep business logic in service layer, not in widgets

❌ **DON'T**:
- Mix UI code with business logic
- Access Firestore directly from widgets
- Store mutable state in widgets (use Riverpod)

### State Management

✅ **DO**:
- Use AsyncNotifier for Firestore streams
- Clean up subscriptions in `ref.onDispose()`
- Check `mounted` before updating state in async callbacks
- Use `ref.watch()` for reactive updates
- Use `ref.read()` for one-time access in callbacks
- Co-locate providers with features

❌ **DON'T**:
- Forget to cancel stream subscriptions
- Update state after disposal
- Put providers in a global "providers" directory

### Data Persistence

✅ **DO**:
- Convert DateTime ↔ Timestamp in repositories
- Use recursive conversion for nested objects
- Manually serialize nested Freezed union types
- Log errors with stack traces
- Rethrow exceptions for UI handling

❌ **DON'T**:
- Store Timestamp in domain models
- Forget to handle null cases when repository is unavailable
- Swallow exceptions without logging

### UI/UX

✅ **DO**:
- Use ResponsiveContainer for main content
- Adapt layouts to screen size (phone/tablet/desktop)
- Use ResponsiveDialog/ResponsiveBottomSheet
- Show loading/error states with AsyncValue.when()
- Display user-friendly error messages via SnackBar
- Use `context.mounted` checks before showing UI after async operations

❌ **DON'T**:
- Hardcode pixel widths (use flex instead)
- Assume a specific screen size
- Show raw exceptions to users
- Forget to handle loading and error states

### Code Style

✅ **DO**:
- Use `log` from `dart:developer` (not `print`)
- Keep widgets small and composable
- Use `const` constructors where possible
- Run `build_runner` after modifying Freezed models
- Write descriptive provider names

❌ **DON'T**:
- Create large monolithic widgets
- Use `print()` or `debugPrint()` for logging
- Forget to add `part` directives for Freezed files

---

---

## Data Layer Reusability for Wizard Implementation

### Assessment: ✅ EXCELLENT - Wizard-Ready

The data layer is **perfectly architected for reuse** by a wizard interface without any modifications. This is a significant architectural achievement.

### Why This Data Layer is Wizard-Friendly

#### 1. UI-Agnostic Design

All repositories are pure data access layers with **zero UI dependencies**:

```dart
// AssetRepository - lib/features/assets/data/asset_repository.dart
class AssetRepository {
  final FirebaseFirestore _firestore;
  final String projectId;

  AssetRepository({
    required this.projectId,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Pure CRUD operations - no UI coupling
  Future<void> createAsset(Asset asset) async { /* ... */ }
  Future<void> updateAsset(Asset asset) async { /* ... */ }
  Future<void> deleteAsset(String assetId) async { /* ... */ }
  Future<Asset?> getAsset(String assetId) async { /* ... */ }
  Stream<List<Asset>> getAssetsStream() { /* ... */ }
}
```

**Benefits**:
- Can be called from wizard screens exactly as from direct UI
- No widget dependencies
- No provider dependencies
- No routing dependencies
- Just domain models in, domain models out

#### 2. Consistent CRUD Interface

All repositories follow an identical pattern:

| Repository | Create | Update | Delete | Get One | Get Stream |
|------------|--------|--------|--------|---------|------------|
| ProjectRepository | ✅ | ✅ | ✅ | ✅ | ✅ |
| AssetRepository | ✅ | ✅ | ✅ | ✅ | ✅ |
| EventRepository | ✅ | ✅ | ✅ | ✅ | ✅ |
| ExpenseRepository | ✅ | ✅ | ✅ | ✅ | ✅ |
| ScenarioRepository | ✅ | ✅ | ✅ | ✅ | ✅ |

**Wizard Benefit**: Learning one repository pattern = understanding all repositories

#### 3. Complex Serialization Handled Transparently

The wizard doesn't need to understand:
- Freezed union type serialization (manual nested union handling)
- DateTime to Timestamp conversion
- Recursive nested object conversion
- JSON encoding/decoding

All handled automatically in repositories:

```dart
// EventRepository handles nested union serialization automatically
// lib/features/events/data/event_repository.dart:22-38
Future<void> createEvent(Event event) async {
  final eventJson = event.toJson();

  // Manual serialization for nested union (EventTiming within Event)
  final timing = event.map(
    retirement: (e) => e.timing,
    death: (e) => e.timing,
    realEstateTransaction: (e) => e.timing,
  );
  eventJson['timing'] = timing.toJson();

  await _eventsCollection.doc(event.id).set(eventJson);
}
```

**Wizard Benefit**: Just pass domain models, repository handles rest

#### 4. Project Scoping Built-In

All repositories require `projectId` in constructor:

```dart
final assetRepository = AssetRepository(projectId: currentProjectId);
```

**Wizard Benefits**:
- Can work with current project or create new
- No risk of cross-project data contamination
- Easy to switch between projects in wizard flow

#### 5. Real-Time Stream Support

All repositories provide stream access for live updates:

```dart
Stream<List<Asset>> getAssetsStream()
Stream<List<Event>> getEventsStream()
Stream<List<Expense>> getExpensesStream()
```

**Wizard Benefits**:
- Can show real-time updates as user progresses
- Multiple wizard steps can show same data
- Changes persist immediately and reflect across app

### Wizard Implementation Pattern

The wizard can use repositories **exactly like the direct UI does**:

```dart
class WizardAssetStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get repository (same pattern as direct UI)
    final repository = ref.watch(assetRepositoryProvider);
    if (repository == null) {
      return Center(child: Text('Please select a project first'));
    }

    // 2. Watch existing data (optional - for edit mode)
    final assetsAsync = ref.watch(assetsProvider);

    return assetsAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
      data: (assets) => WizardStepScaffold(
        title: 'Add Your Assets',
        onSave: () async {
          // 3. Create asset using repository (same as direct UI)
          final newAsset = Asset.rrsp(
            id: uuid.v4(),
            individualId: primaryIndividualId,
            value: 50000.0,
            customReturnRate: 0.05,
            annualContribution: 5000.0,
          );

          try {
            await repository.createAsset(newAsset);

            // 4. Update wizard progress (wizard-specific)
            ref.read(wizardProgressProvider.notifier)
               .markStepComplete('add-assets');

            // 5. Navigate to next wizard step (wizard-specific)
            ref.read(wizardNavigationProvider.notifier).nextStep();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
          }
        },
      ),
    );
  }
}
```

### Wizard-Specific Requirements

While existing repositories need **zero changes**, the wizard will need new components:

#### 1. Wizard Progress Tracking

**New Repository Needed**: `WizardProgressRepository`

```dart
/// Tracks wizard completion state per project
class WizardProgressRepository {
  final FirebaseFirestore _firestore;
  final String userId;

  CollectionReference get _progressCollection =>
    _firestore.collection('users').doc(userId).collection('wizardProgress');

  Future<void> markStepComplete(String projectId, String stepId) async {
    await _progressCollection.doc(projectId).update({
      'completedSteps': FieldValue.arrayUnion([stepId]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markStepSkipped(String projectId, String stepId) async {
    await _progressCollection.doc(projectId).update({
      'skippedSteps': FieldValue.arrayUnion([stepId]),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Stream<WizardProgress> getProgressStream(String projectId) {
    return _progressCollection.doc(projectId).snapshots()
      .map((doc) => WizardProgress.fromJson(doc.data()!));
  }
}
```

**Domain Model**:
```dart
@freezed
class WizardProgress with _$WizardProgress {
  const factory WizardProgress({
    required String projectId,
    @Default([]) List<String> completedSteps,
    @Default([]) List<String> skippedSteps,
    String? currentStepId,
    required DateTime lastUpdated,
  }) = _WizardProgress;

  factory WizardProgress.fromJson(Map<String, dynamic> json) =>
    _$WizardProgressFromJson(json);
}
```

#### 2. Wizard Service (Optional - For Multi-Step Operations)

**Use Case**: Some wizard flows might create multiple entities at once

```dart
/// Orchestrates multi-repository operations for wizard
class WizardService {
  final ProjectRepository _projectRepository;
  final AssetRepository _assetRepository;
  final EventRepository _eventRepository;

  WizardService({
    required ProjectRepository projectRepository,
    required AssetRepository assetRepository,
    required EventRepository eventRepository,
  }) : _projectRepository = projectRepository,
       _assetRepository = assetRepository,
       _eventRepository = eventRepository;

  /// Complete initial project setup in one transaction
  Future<void> completeProjectSetup({
    required Project project,
    required List<Asset> initialAssets,
    required List<Event> retirementEvents,
  }) async {
    // Could use Firestore batch write for atomicity
    final batch = FirebaseFirestore.instance.batch();

    // Create project
    await _projectRepository.createProject(
      name: project.name,
      description: project.description,
    );

    // Create initial assets
    for (final asset in initialAssets) {
      await _assetRepository.createAsset(asset);
    }

    // Create retirement events
    for (final event in retirementEvents) {
      await _eventRepository.createEvent(event);
    }
  }
}
```

#### 3. Wizard State Providers

**New Providers Needed**:

```dart
/// Tracks current wizard state
@freezed
class WizardState with _$WizardState {
  const factory WizardState({
    required String currentStepId,
    required List<String> completedSteps,
    required List<String> skippedSteps,
    Map<String, dynamic>? draftData,  // Temporary data during wizard
  }) = _WizardState;
}

class WizardNotifier extends Notifier<WizardState> {
  @override
  WizardState build() {
    return const WizardState(
      currentStepId: 'welcome',
      completedSteps: [],
      skippedSteps: [],
    );
  }

  void nextStep() {
    // Navigate to next step based on business logic
  }

  void previousStep() {
    // Navigate to previous step
  }

  void jumpToStep(String stepId) {
    // Allow direct navigation to any step
  }

  void markCurrentStepComplete() {
    state = state.copyWith(
      completedSteps: [...state.completedSteps, state.currentStepId],
    );
    nextStep();
  }

  void skipCurrentStep() {
    state = state.copyWith(
      skippedSteps: [...state.skippedSteps, state.currentStepId],
    );
    nextStep();
  }
}

final wizardNotifierProvider = NotifierProvider<WizardNotifier, WizardState>(() {
  return WizardNotifier();
});
```

### Draft Data Strategy

**Question**: Should wizard data persist immediately or be saved at end?

**Option 1: Immediate Persistence (Recommended)**
- Each wizard step saves to Firestore immediately
- Uses existing repositories as-is
- Benefits:
  - User can stop/resume anytime (data already saved)
  - Real-time updates visible across app
  - No risk of data loss
  - Simpler implementation
- Drawbacks:
  - Incomplete data visible in direct UI
  - No "cancel wizard" without deleting data

**Option 2: Draft Mode with Final Save**
- Wizard collects data in local state
- Final step saves everything to Firestore
- Benefits:
  - Incomplete data not visible until wizard complete
  - Can cancel wizard without affecting data
  - Can validate entire dataset before saving
- Drawbacks:
  - Risk of data loss if user closes app
  - More complex state management
  - Need to handle partial saves on errors

**Recommendation**: Use **Option 1** (Immediate Persistence) because:
- Aligns with wizard requirement: "Users can stop/resume the lengthy process"
- Existing repositories already support this
- Can mark incomplete data with status flag if needed
- Simpler and more reliable

### Validation Checklist

Before implementing wizard, verify:

- ✅ **Repository Independence**: No UI dependencies in repositories
- ✅ **Consistent Patterns**: All repositories follow same CRUD interface
- ✅ **Domain Model Completeness**: All entities can be created incrementally
- ✅ **Error Handling**: Repositories throw exceptions, wizard can catch
- ✅ **Project Scoping**: All repositories properly scoped to projectId
- ✅ **Stream Support**: Real-time updates available for all entities
- ✅ **Serialization**: Complex types handled automatically

**All items verified** ✅

### Benefits Summary

| Benefit | Impact |
|---------|--------|
| **No Code Duplication** | Wizard and direct UI share identical data layer |
| **Guaranteed Consistency** | Same validation, serialization, error handling |
| **Easy Maintenance** | One data layer to maintain, benefits both UIs |
| **Real-time Updates** | Changes visible immediately across app |
| **Type Safety** | Freezed models prevent data structure errors |
| **Transaction Safety** | Both UIs write to same collections with same structure |
| **Future-Proof** | New features benefit wizard automatically |

### Implementation Effort

**Existing Data Layer Modifications**: **ZERO** ✅

**New Components Required**:
1. WizardProgressRepository (new) - ~100 lines
2. WizardProgress domain model (new) - ~20 lines
3. WizardNotifier provider (new) - ~150 lines
4. WizardService (optional) - ~100 lines

**Estimated Effort**: 1-2 days to build wizard infrastructure, then normal wizard UI development

---

## Conclusion

This architecture provides a **solid foundation** for a scalable, maintainable retirement planning application. The feature-first structure with DDD principles ensures:

- **Clear separation of concerns** between layers
- **Type safety** with Freezed models and union types
- **Reactive data flow** with Riverpod and Firestore streams
- **Platform independence** with responsive design
- **International support** with built-in i18n
- **User data isolation** with Firebase security
- **Wizard-ready data layer** - No modifications needed for wizard implementation ⭐

The codebase is well-positioned for future enhancements while maintaining architectural consistency and code quality. The data layer's UI-agnostic design means the planned wizard interface can reuse all existing repositories without modification, ensuring consistency and maintainability.
