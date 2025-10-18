# Application Design

The application is designed with a features-first design, with
separation of concerns. Within features, there are:

-   **Domain** (directory: domain/): This layer represents the core
    business concepts, such as customers, products, invoices, and user
    profiles

-   **Data** (directory: data/): This layer handles data fetching,
    persistence, and conversion between domain models and the storage
    format (e.g., Firestore documents, Firebase Auth data, etc.).

-   **Presentation** (directory: presentation/): This layer builds the
    user interface and handles user interactions. The focus here is on
    widgets, routing, and displaying state provided by the state
    management solution (Riverpod).

-   **Service** (directory: service/): This layer encapsulate complex
    business operations, integrations with external services, or logic
    that doesn't neatly fit into domain or data. Examples include email
    sending, push notifications, analytics, or integrating with
    third-party APIs.

# Best Practices for Domain Layer

This layer encapsulates business logic, rules, and entities independent
of UI or data storage. Classes are immutable and created using freezed.
We encapsulate validations and business rules within value objects
(e.g., an Email type that validates format) so that business logic is
centralized and consistent.

Instead of scattering logic in widgets, we encapsulate key operations
(e.g., calculating totals, applying discounts, validating payment terms)
in dedicated classes or functions. This makes the logic easier to test
and reuse.

# Best practices for Data Layer

We implement repositories that abstract the details of data access. We
create Data Transfer Objects (DTOs) to match the Firestore or API
schema. Then, we implement mappers to convert between DTOs and the
domain models. This separation helps when the backend format changes.

We use Riverpod to create providers that expose repositories and data
services. The providers provide clear initialization to enable
mechanisms to protect us from racing conditions.

We define clear error classes (or use a Result/Either type pattern) so
that errors in data operations (like network issues or Firebase errors)
are handled gracefully. This also aids in unit testing.

# Best Practices for Presentation Layer

We use the Riverpod pattern to keep our widgets "dumb." We let Riverpod
providers or dedicated controllers handle state and logic, while out
widgets simply render state and dispatch events.

We build our UI using Flutter's widget composition and create reusable
widgets. We keep widgets focused on rendering rather than logic. We try
to keep widgets not too long, breaking them into separate widgets when
it makes sense.

We write widget tests to ensure our UI responds correctly to various
states provided by Riverpod. This ensures that refactoring logic in the
domain or data layers won't inadvertently break the UI.

# Best Practices for Services Layer

The service layer should not contain UI code. Instead, it should expose
methods that can be called from our business logic or controllers. For
example, a PaymentService might handle the registration of a payment
with Firestore and perform any necessary business logic (e.g.,
validating partial vs. full payment).

We integrate robust error handling and logging within service
operations. 

# Best Practices for Routing

We use GoRouter to manage deep linking and route transitions. We define
a clear routing table and leverage route guards if needed (for example,
to protect routes that require authentication).

Feature Routes are stored in the feature's directory and then integrated
in the main router configuration. This helps readability,
maintainability and reusability.

# Directory Structure

This Flutter project is organized using a **feature-based
architecture**, separating concerns into **core
functionalities**, **features**, and **app-level configuration**.

**📂 lib/**

The main directory containing the entire Flutter application.

**📄 main.dart**

-   The **entry point** of the application. It initializes the app and
    runs the Appwidget.

**📄  app.dart**

-   The root widget of the application, responsible for **app-wide state
    management and routing**.

**📂 lib/core/ (Shared Utilities & Configuration)**

This directory contains **foundational components** that are shared
across multiple features.

**📂 lib/core/config/ (Application Configuration)**

**📂 lib/core/error/ (Error Handling)**

**📂 lib/core/logger/ (Logging Services)**

**📂 lib/core/router/ (Navigation & Routing)**

**📂 lib/features/ (Feature Modules)**

Each feature in the app (e.g., **authentication**, **home screen**) is
structured into separate subdirectories following the **DDD
(Domain-Driven Design) approach**.

**📂 lib/features/auth/ (Authentication Feature)**

**📂 lib/features/home/ (Home Screen Feature)**

## Coding Style

- Prefer small composable widgets over large ones
- Prefer using flex values over hardcoded sizes when creating widgets inside rows/columns, ensuring the UI adapts to various screen sizes
- Use `log` from `dart.developer` rather than `print` or `debugPrint` for logging

# Riverpod 3.0 Best Practices (Flutter Mobile & Web)

## Project Setup
- Use `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`, `riverpod_lint`, `build_runner`.
- Always wrap app root in `ProviderScope`.
- Enable `riverpod_lint` in `analysis_options.yaml`.

## Provider Definitions
- Use `@riverpod` for all providers; prefer code generation.
- Use `Notifier` / `AsyncNotifier` (not `StateNotifier`).
- Use class-based providers for mutable or side-effect logic.
- Use function-based providers for derived or read-only state.
- Declare all providers as top-level `final` variables.
- Avoid initializing providers inside widgets.
- Default: providers are `autoDispose`; use `@Riverpod(keepAlive: true)` for persistent state.
- Keep providers pure; no direct side-effect calls or imperative UI actions.
- Avoid using providers for ephemeral, widget-local state.

## State Management Patterns
- Use `Notifier` for synchronous state logic.
- Use `AsyncNotifier` for async operations.
- Use `StateProvider` for simple primitives.
- Use `FutureProvider` / `StreamProvider` for derived async reads.
- Use `ref.mounted` before updating async state.
- Use `ref.invalidate()` to refresh or reset state.
- Use `ref.keepAlive()` manually when managing resource lifecycles.

## UI Integration
- Use `ConsumerWidget` or `ConsumerStatefulWidget` for access to `ref`.
- Use `ref.watch()` for reactive rebuilds.
- Use `ref.read()` for one-off access (e.g., in callbacks).
- Handle async data with `AsyncValue.when()` (loading/error/data).
- Call provider methods via `.notifier` (e.g., `ref.read(counterProvider.notifier).increment()`).
- Keep navigation, dialogs, and snackbars in UI, not in providers.
- Use widget-local `State` or hooks for ephemeral UI-only state.

## Architecture
- Separate business logic (providers) from presentation (widgets).
- Organize by feature/domain, not by type.
- Inject dependencies via providers (`RepositoryProvider`, `ServiceProvider`, etc.).
- Override providers for testing or platform differences.
- Compose providers declaratively (providers depending on other providers).
- Keep features loosely coupled; avoid circular dependencies.
- Keep the providers in the related module's source files

## Performance
- Use `ref.watch(provider.select(...))` to minimize rebuilds.
- Split large state objects into smaller providers.
- Use immutable state models with proper equality.
- Limit rebuild scope with `Consumer` or granular widgets.
- Use `AsyncNotifier` caching or memoization when beneficial.

## Testing
- Use `ProviderContainer` for unit testing providers.
- Override dependencies in tests.
- Test providers’ logic independently of UI.
- Use fake or mock repositories for isolation.

## Error Handling & Reliability
- Catch and represent errors in `AsyncValue`.
- Use `AsyncValue.guard` for safe async operations.
- Customize or disable provider retry strategies as needed.
- Expose user-facing errors via state, not logs or exceptions.

## Code Style & Naming
- Name providers descriptively (e.g., `userListProvider`, `authNotifierProvider`).
- Keep method names action-oriented (e.g., `fetchUsers()`, `toggleTheme()`).
- Group provider files by feature: `/features/auth/providers/auth_provider.dart`.
- Maintain immutability in state models (`copyWith`, `equatable` or `freezed`).

---

# Implementation Status & Findings

This section documents how the current codebase implements the best practices outlined above.

## ✅ Successfully Implemented Practices

### Architecture & Organization
- **Feature-first architecture**: All features properly organized under `lib/features/` with domain/data/presentation layers
- **Provider co-location**: Providers stored in `features/[feature]/presentation/providers/` as recommended
- **Separation of concerns**: Business logic in services/providers, UI in widgets, data access in repositories
- **Freezed models**: All domain models use Freezed for immutability
- **Union types**: Properly used for Assets, Events, EventTiming, Expenses, ParameterOverrides

### State Management
- **Notifier/AsyncNotifier**: Correctly using `Notifier` for sync state (AuthNotifier) and `AsyncNotifier` for Firestore streams
- **Stream cleanup**: `ref.onDispose()` properly used to cancel subscriptions in AsyncNotifier
- **Derived providers**: Well-implemented (e.g., `assetsByTypeProvider`, `localeProvider`)
- **Repository conditional initialization**: Repositories correctly return null when user not authenticated
- **Provider composition**: Providers properly depend on other providers (e.g., repository providers watch auth state)

### UI Integration
- **ConsumerWidget usage**: Consistently used throughout the app
- **ref.watch() vs ref.read()**: Properly distinguished - watch for reactive updates, read for callbacks
- **AsyncValue.when()**: Consistently handles loading/error/data states
- **Error handling**: UI layer uses try-catch with SnackBar feedback
- **Navigation in UI**: Kept in widgets, not in providers

### Data Persistence
- **Repository pattern**: Well-implemented with proper abstraction
- **Timestamp conversion**: Recursive DateTime ↔ Timestamp conversion in repositories
- **Nested union serialization**: Manual serialization for nested Freezed unions (critical for Events with EventTiming)
- **Error logging**: Consistent use of `log()` from `dart:developer` with stack traces

### Responsive Design
- **Breakpoint system**: Clear 600px (phone) / 1024px (tablet/desktop) breakpoints
- **Responsive widgets library**: Comprehensive set of adaptive components
- **Adaptive navigation**: AppShell switches between bottom nav (phone) and navigation rail (tablet/desktop)
- **ResponsiveContainer**: Used consistently to constrain content width

### Internationalization
- **Dual language support**: English and French properly implemented
- **Localization pattern**: Abstract base class with language-specific implementations
- **Persistence**: Language preference saved to Firestore

## ⚠️ Opportunities for Improvement

### Provider Patterns
1. **Code generation not used**: Currently using manual provider definitions instead of `@riverpod` annotations
   - **Impact**: More boilerplate, no compiler-checked autoDispose behavior
   - **Recommendation**: Consider migrating to riverpod_generator in future refactor

2. **ref.mounted checks**: Not consistently used before updating async state
   - **Impact**: Potential setState-after-dispose errors
   - **Location**: Some AsyncNotifier implementations
   - **Recommendation**: Add `if (mounted) state = ...` in async callbacks

3. **Performance optimizations**:
   - `ref.watch(provider.select(...))` not observed - could minimize rebuilds
   - Limited use of `Consumer` widget for granular rebuild scope
   - Projection calculations could benefit from memoization
   - **Recommendation**: Profile app and add `.select()` for expensive rebuilds

### Testing
1. **Limited test coverage**: Test infrastructure exists but minimal tests written
   - AuthRepositoryMock present but underutilized
   - No observed ProviderContainer usage in tests
   - **Recommendation**: Expand unit and widget test coverage

2. **Provider testing**: Providers not independently tested
   - **Recommendation**: Add tests for business logic in notifiers
   - Use ProviderContainer to test providers in isolation

### Error Handling
1. **AsyncValue.guard not used**: Could improve error handling consistency
   - **Current**: Manual try-catch in provider methods
   - **Potential**: Use `AsyncValue.guard(() => ...)` for cleaner error capture
   - **Impact**: Minor - current approach works but less idiomatic

2. **Error state recovery**: Some providers reset error state after 3 seconds (AuthNotifier)
   - **Observation**: Inconsistent pattern across providers
   - **Recommendation**: Standardize error state management

### Code Organization
1. **Service layer**: ProjectionCalculator and other services well-organized
   - **Finding**: Good separation of complex business logic
   - **Opportunity**: Could extract more calculation logic from providers to services

2. **Custom exceptions**: ImportException well-designed
   - **Opportunity**: Create more domain-specific exceptions (AssetException, EventException, etc.)
   - **Benefit**: Better error messages and handling

## 📋 Additional Findings

### Strengths
1. **Firestore integration**: Excellent handling of real-time streams with AsyncNotifier
2. **GoRouter setup**: Clean auth guards and route organization
3. **Responsive design**: Comprehensive and well-thought-out
4. **Type safety**: Heavy use of Freezed unions prevents runtime errors
5. **Logging**: Consistent use of `log()` with error context
6. **Data layer reusability**: ✅ **EXCELLENT FOR WIZARD** - Repositories are UI-agnostic and perfectly structured for reuse

### Notable Patterns
1. **Conditional repository providers**: Returning `null` when user not authenticated is elegant
2. **Manual union serialization**: Critical workaround for Freezed nested unions with Firestore
3. **DateTime custom serialization**: Handles Timestamp, String, and DateTime input flexibly
4. **Multi-platform file handling**: Stub/Web/Native pattern for file picker and download

### Documentation Quality
- CLAUDE.md provides comprehensive project overview
- PLAN.md tracks implementation phases well
- Code comments generally good but could be more extensive
- Now with ARCHITECTURE.md, documentation is very strong

## 🎯 Priority Recommendations

### High Priority
1. **Add `ref.mounted` checks** in async state updates to prevent disposal errors
2. **Expand test coverage** - Start with critical business logic (ProjectionCalculator, repositories)
3. **Profile and optimize** - Use DevTools to identify unnecessary rebuilds, add `.select()` where needed

### Medium Priority
4. **Consider riverpod_generator migration** for type safety and less boilerplate
5. **Standardize error handling** - Decide on consistent error state management strategy
6. **Add more domain exceptions** for better error context

### Low Priority
7. **Memoize expensive calculations** - Projection calculations could cache intermediate results
8. **Add more code comments** - Especially in complex business logic (ProjectionCalculator)
9. **Extract more services** - Move remaining business logic out of providers into service layer

---

# Data Layer Reusability for Wizard Implementation

## ✅ Assessment: EXCELLENT - Ready for Wizard

The data layer is **perfectly designed for reuse** by a wizard interface. Key strengths:

### Why the Data Layer is Wizard-Ready

1. **UI-Agnostic Repositories**
   - All repositories are pure data access layers with no UI dependencies
   - Accept domain models, return domain models
   - No reference to providers, widgets, or UI state
   - Can be used from wizard screens exactly as from direct UI screens

2. **Clean CRUD Interface**
   ```dart
   // All repositories follow this pattern:
   Future<void> createAsset(Asset asset)      // ✅ Accepts domain model
   Future<void> updateAsset(Asset asset)      // ✅ Accepts domain model
   Future<void> deleteAsset(String assetId)   // ✅ Simple ID reference
   Future<Asset?> getAsset(String assetId)    // ✅ Returns domain model
   Stream<List<Asset>> getAssetsStream()      // ✅ Real-time updates
   ```

3. **Consistent Patterns Across All Repositories**
   - ProjectRepository: Create/update/delete projects and individuals
   - AssetRepository: Manage all 5 asset types (RealEstate, RRSP, CELI, CRI, Cash)
   - EventRepository: Manage all 3 event types (Retirement, Death, RealEstateTransaction)
   - ExpenseRepository: Manage all 6 expense categories
   - ScenarioRepository: Manage scenarios and parameter overrides
   - All follow identical CRUD patterns

4. **Handles Complex Serialization Automatically**
   - Nested union types (Events with EventTiming, Expenses with EventTiming)
   - DateTime to Timestamp conversion
   - Freezed model serialization
   - Wizard doesn't need to worry about these details

5. **Project Scoping Built-In**
   - All repositories require `projectId` in constructor
   - Wizard can easily work with current project or create new ones
   - No risk of cross-project data contamination

### Recommended Wizard Implementation Pattern

```dart
// Wizard can use repositories EXACTLY like direct UI does:

class WizardAssetStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get repository (same as direct UI)
    final repository = ref.watch(assetRepositoryProvider);
    if (repository == null) return LoadingWidget();

    return WizardStepWidget(
      onSave: (Asset asset) async {
        // Use repository directly (same as direct UI)
        await repository.createAsset(asset);

        // Update wizard progress
        ref.read(wizardProgressProvider.notifier).markStepComplete('assets');

        // Navigate to next step
        ref.read(wizardNavigationProvider.notifier).nextStep();
      },
    );
  }
}
```

### Benefits for Wizard

1. **No Code Duplication**: Wizard uses same repositories as direct UI
2. **Consistency Guaranteed**: Same validation, same serialization, same error handling
3. **Easy Maintenance**: Changes to data layer automatically benefit both UIs
4. **Real-time Updates**: Wizard can show live data from Firestore streams
5. **Transaction Safety**: Both UIs write to same Firestore collections with same structure

### Wizard-Specific Considerations

1. **Wizard Progress Tracking** (NEW requirement)
   - Create `WizardProgressRepository` to track completion status
   - Store at `users/{userId}/wizardProgress/{projectId}`
   - Track: completed steps, skipped steps, current step, last updated
   - Repository pattern: Same as others but wizard-specific domain

2. **Multi-Step Transactions** (Consider)
   - Some wizard flows might create multiple entities (project + assets + events)
   - Consider adding a `WizardService` that orchestrates multiple repository calls
   - Use Firestore batch writes if atomicity needed

3. **Draft/Temporary Data** (Optional)
   - Current repositories immediately persist to Firestore
   - If wizard needs "draft" mode, consider:
     - Local state until final save
     - OR separate `drafts` collection in Firestore
   - Recommendation: Use local state + final save for better UX

### Action Items for Wizard Integration

**No changes needed to existing data layer** ✅

**New components to create:**
1. **WizardProgressRepository** - Track wizard completion state
   ```dart
   class WizardProgressRepository {
     Future<void> updateStepStatus(String stepId, StepStatus status)
     Future<void> markStepComplete(String stepId)
     Future<void> markStepSkipped(String stepId)
     Stream<WizardProgress> getProgressStream()
   }
   ```

2. **WizardService** (Optional) - Orchestrate multi-step operations
   ```dart
   class WizardService {
     Future<void> completeProjectSetup({
       required Project project,
       required List<Asset> initialAssets,
       required List<Event> retirementEvents,
     }) async {
       // Use existing repositories in sequence or batch
       await projectRepository.createProject(...);
       for (final asset in initialAssets) {
         await assetRepository.createAsset(asset);
       }
       // etc.
     }
   }
   ```

3. **WizardProviders** - Manage wizard state
   - `wizardProgressProvider` - Current progress tracking
   - `wizardNavigationProvider` - Current step, next/previous navigation
   - `wizardDraftProvider` - Temporary data during wizard flow

### Validation of Approach

✅ **Verified**: All repositories can be used from wizard without modification
✅ **Verified**: Provider structure supports wizard (just need wizard-specific providers)
✅ **Verified**: Domain models can be created incrementally (wizard can build up data)
✅ **Verified**: No tight coupling between repositories and current UI

---

*Last Updated: 2025-10-18*
*Assessment based on comprehensive codebase review*
*Wizard compatibility analysis added: 2025-10-18*
