# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **retirement planning application** built with Flutter for individuals based in Quebec. The app allows users to create multiple projects for planning retirement scenarios with configurable assets, events, and projections.

A complete plan for the project has been written to @plan.md.

**Target Platforms:** iOS (15+), Android, macOS, and Web
**Target Devices:** Phones, tablets, and desktops with responsive design
**Tech Stack:** Flutter, Freezed, GoRouter, Riverpod, Firebase (Authentication, Firestore, Storage, Hosting)
**Theming:** Dark mode only, configured via MaterialApp theme (not hardcoded)
**Languages:** French and English

## Development Commands

### Running the App
```bash
flutter run                    # Run on default device
flutter run -d chrome          # Run on web
flutter run -d macos           # Run on macOS
flutter run -d ios             # Run on iOS simulator
```

### Testing
```bash
flutter test                   # Run all tests
flutter test test/widget_test.dart  # Run specific test file
```

### Code Quality
```bash
flutter analyze                # Run static analysis
flutter pub outdated           # Check for outdated dependencies
flutter pub upgrade            # Upgrade dependencies
```

### Build
```bash
flutter build ios              # Build for iOS
flutter build apk              # Build for Android
flutter build macos            # Build for macOS
flutter build web              # Build for web
```

## Architecture

The application follows a **feature-based architecture** with **Domain-Driven Design (DDD)** principles and separation of concerns.

### Directory Structure

```
lib/
├── main.dart                     # Application entry point with Firebase initialization
├── core/                         # Shared utilities and configuration
│   ├── config/
│   │   ├── theme/               # Material 3 dark/light theme configuration
│   │   └── i18n/                # French/English localization files
│   ├── data/                    # Shared data repositories (settings, etc.)
│   ├── router/                  # GoRouter configuration with auth guards
│   └── ui/
│       ├── layout/              # AppShell with responsive navigation
│       └── responsive/          # Responsive widgets library
└── features/                    # Feature modules (feature-based organization)
    ├── auth/                    # Authentication (Firebase Auth, Google Sign-In)
    │   ├── data/               # AuthRepository, UserProfileRepository
    │   ├── domain/             # User model (Freezed)
    │   └── presentation/       # Login, Register screens + providers
    ├── project/                 # Project and base parameters management
    │   ├── data/               # ProjectRepository (Firestore)
    │   ├── domain/             # Project, Individual models (Freezed)
    │   └── presentation/       # BaseParametersScreen + providers
    ├── dashboard/               # Executive dashboard with project summary
    ├── assets/                  # Asset management (4 types: Real Estate, RRSP, CELI, Cash)
    │   ├── data/               # AssetRepository (Firestore)
    │   ├── domain/             # Asset unions (Freezed)
    │   └── presentation/       # Assets & Events screen (tabbed)
    ├── events/                  # Event management (Retirement, Death, Real Estate transactions)
    │   ├── data/               # EventRepository (Firestore)
    │   ├── domain/             # Event, EventTiming unions (Freezed)
    │   └── presentation/       # Event forms and timeline
    ├── scenarios/               # Scenario management with parameter overrides
    │   ├── data/               # ScenarioRepository (Firestore)
    │   ├── domain/             # Scenario, ParameterOverride models (Freezed)
    │   └── presentation/       # Scenarios screen, editor
    ├── projection/              # Financial projection calculations and visualization
    │   ├── data/               # (Future: caching layer)
    │   ├── domain/             # Projection, YearlyProjection models (Freezed)
    │   ├── service/            # ProjectionCalculator engine
    │   └── presentation/       # Charts (fl_chart) and tables
    └── settings/                # User settings and profile management
        ├── data/               # SettingsRepository (Firestore)
        ├── domain/             # AppSettings model (Freezed)
        └── presentation/       # Settings screen with profile picture upload
```

### Layer Responsibilities

Each feature module is organized into four layers:

**domain/** - Core business logic and entities
- Immutable classes created with Freezed
- Business rules and validations in value objects
- Pure business logic, no UI or data storage concerns

**data/** - Data access and persistence
- Repositories that abstract data access
- DTOs (Data Transfer Objects) matching Firestore/API schema
- Mappers to convert between DTOs and domain models
- Riverpod providers for repositories
- Clear error handling with Result/Either patterns

**presentation/** - User interface
- "Dumb" widgets that render state and dispatch events
- Riverpod for state management
- Small, composable, focused widgets
- Widget tests for UI behavior

**service/** - Complex business operations
- External service integrations
- Email, push notifications, analytics
- No UI code, only business logic
- Robust error handling and logging

### Routing

- **GoRouter** with ShellRoute wrapping authenticated screens
- Auth routes (login/register) displayed without app shell
- Protected routes automatically redirect to login when not authenticated
- Route guards watch auth state changes for automatic navigation
- NoTransitionPage for instant screen switching in bottom nav

## Key Design Principles

### Responsive Design

The app uses responsive widgets that adapt to screen sizes:

**Breakpoints:**
- Phone: < 600px
- Tablet: 600px - 1024px
- Desktop: > 1024px

**Key Responsive Widgets:**
- `ResponsiveBuilder` - Base responsive layout component
- `ResponsiveContainer` - Content sections with width constraints
- `ResponsiveTextField` - Form inputs that scale appropriately
- `ResponsiveButton` - Consistent button sizing
- `ResponsiveCard` - Content cards with expansion
- `ResponsiveDialog` - Modal dialogs
- `ResponsiveMultiPaneLayout` - Multi-pane adaptive layouts

**Navigation Pattern:**
- Bottom navigation for phones (max 5 items)
- Navigation rail for tablet/desktop

### Coding Style

- Prefer small composable widgets over large ones
- Use flex values over hardcoded sizes in rows/columns
- Use `log` from `dart:developer` (not `print` or `debugPrint`)
- Keep widgets focused on rendering, not logic
- Use `const` constructors where possible

### State Management

- Use Riverpod providers for state and logic
- Keep widgets "dumb" - they render state and dispatch events
- Controllers/providers handle business logic

## Key Dependencies & Usage

### State Management & Code Generation
- **flutter_riverpod** (^2.6.1) - State management with providers
  - Use `AsyncNotifier` for stream-based data (Firestore)
  - Use `StateNotifier` for simple in-memory state
  - Watch auth state for conditional provider creation
- **freezed** (^2.5.7) - Immutable models with unions
  - Use for all domain models
  - Unions for discriminated types (Assets, Events, Timings)
  - Always run build_runner after model changes
- **json_serializable** (^6.8.0) - JSON serialization
  - Pair with Freezed for Firestore compatibility
  - Use `explicitToJson: true` for nested objects

### Firebase Services
- **firebase_core** (^3.8.1) - Initialize in main() before runApp()
- **firebase_auth** (^5.3.4) - Authentication with email/password and Google
- **cloud_firestore** (^5.5.2) - Real-time database
  - Use streams for live updates
  - Handle Timestamp conversion for DateTime fields
- **firebase_storage** (^12.3.7) - Profile picture uploads
- **google_sign_in** (^6.2.2) - Google OAuth
  - Requires platform-specific configuration (see Phase 7 in PLAN.md)

### Routing & Navigation
- **go_router** (^14.6.2) - Declarative routing
  - ShellRoute for app shell with bottom nav
  - Redirect logic for auth guards
  - Watch auth state provider for automatic navigation

### UI & Visualization
- **fl_chart** (^0.70.1) - Charts for financial projections
  - LineChart for net worth over time
- **image_picker** (^1.1.2) - Profile picture selection
- **intl** (^0.20.1) - Internationalization and number/date formatting
  - NumberFormat.currency for money values
  - DateFormat for date display

### Utilities
- **uuid** (^4.5.1) - Generate unique IDs for events and assets

## Development Approach

**Incremental Development:**
- Build features incrementally in small, testable steps
- Ensure each increment is functional and testable before moving forward
- Run and test the app frequently during development to catch issues early
- Use `flutter run` with hot reload to quickly verify changes
- Write tests alongside feature implementation, not after
- Commit working increments regularly

This approach allows for:
- Early detection of integration issues
- Continuous validation of functionality
- Easier debugging with smaller changesets
- Regular feedback on progress

## Application Features

The app includes:

1. **Authentication** - Username/password and social sign-in
2. **Projects** - Multiple planning projects per account
3. **Assets** - Configurable assets (real estate, RRSP, CELI, cash accounts)
4. **Events** - Retirement, death, real estate transactions with flexible timing
5. **Scenarios** - Base scenario with variations for different planning outcomes
6. **Projection** - Yearly cash flow and asset values (current or constant dollars)

### Navigation Structure

**Primary Navigation** (Bottom Nav on phone, Navigation Rail on tablet/desktop):
1. **Dashboard** - Executive summary of currently selected project
2. **Base Parameters** - Project details and individuals management
3. **Assets & Events** - Tabbed interface for managing assets and timeline events
4. **Scenarios** - Base scenario + variations with parameter overrides
5. **Projection** - Financial projections with charts and yearly breakdown table

**Secondary Navigation** (App bar):
- **Settings** - User profile, language selection, logout

## Important Implementation Details

### Firestore Data Model

**Collections Structure:**
- `users/{userId}/projects/{projectId}` - User's projects
- `users/{userId}/settings/preferences` - App settings (language)
- `users/{userId}/settings/currentProject` - Currently selected project ID
- `projects/{projectId}/assets/{assetId}` - Assets for a project
- `projects/{projectId}/events/{eventId}` - Events for a project
- `projects/{projectId}/scenarios/{scenarioId}` - Scenarios (base + variations)

**Current Project Selection:**
- Tracked via `CurrentProjectProvider` (sealed class with states)
- Persisted to Firestore at `users/{userId}/settings/currentProject`
- All screens read from this provider to show relevant data
- Dashboard shows executive summary of selected project
- Base Parameters screen allows switching between projects

### Freezed Union Types with Firestore

**Critical Pattern for Nested Unions:**
When using Freezed union types nested inside other Freezed models, manual serialization is required:

```dart
// In repository methods:
final timingJson = event.map(
  retirement: (e) => e.timing.toJson(),
  death: (e) => e.timing.toJson(),
  realEstateTransaction: (e) => e.timing.toJson(),
);

await doc.set({
  ...event.toJson(),
  'timing': timingJson,  // Manually serialize nested union
});
```

This is necessary because Freezed doesn't automatically call `toJson()` on nested union types.

### Code Generation

When modifying domain models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Use `--delete-conflicting-outputs` to avoid manual deletion of generated files.

### Authentication Flow

1. Firebase Auth state changes trigger `authStateProvider` updates
2. GoRouter watches auth state and redirects accordingly
3. On successful social sign-in, UserProfileRepository syncs profile data
4. Smart sync: only updates profile fields not manually edited by user
5. Manual edits set flags (`displayNameManuallyEdited`, `photoUrlManuallyEdited`)

### Real-time Data Synchronization

All feature providers use AsyncNotifier with Firestore streams:
- `ProjectsProvider` - Listens to projects stream
- `AssetsProvider` - Listens to assets stream
- `EventsProvider` - Listens to events stream
- `ScenariosProvider` - Listens to scenarios stream
- Auto-ensures base scenario exists
- Stream subscriptions cleaned up on dispose

### Projection Calculation

Located in `ProjectionCalculator` service:
- Takes Project, Scenario, Assets, Events as input
- Applies scenario overrides to assets and events
- Iterates through years calculating income/expenses/net worth
- Handles 3 timing types: Relative (years from start), Absolute (calendar year), Age (individual's age)
- Returns `Projection` with yearly breakdown
- Currently calculated on-demand (Phase 21 will add Firestore caching)

## Common Patterns & Gotchas

### AsyncNotifier Pattern for Firestore Streams

```dart
class MyAsyncNotifier extends AsyncNotifier<List<MyModel>> {
  StreamSubscription? _subscription;

  @override
  Future<List<MyModel>> build() async {
    _subscription = repository.getStream().listen((data) {
      if (mounted) state = AsyncValue.data(data);
    });
    ref.onDispose(() => _subscription?.cancel());
    return [];
  }
}
```

Always check `mounted` before updating state to avoid disposed state errors.

### Responsive Widget Usage

Always wrap main content in `ResponsiveContainer` for consistent max-width:
```dart
ResponsiveContainer(
  child: Column(children: [...]),
)
```

Use responsive grid columns based on screen size:
```dart
final columns = screenSize.isPhone ? 1 : (screenSize.isTablet ? 2 : 3);
```

### Timestamp Conversion

Firestore uses Timestamp, Dart uses DateTime. Repositories handle conversion:
```dart
// In repository - recursive conversion for nested objects
Map<String, dynamic> _convertDateTimesToTimestamps(Map<String, dynamic> data) {
  return data.map((key, value) {
    if (value is DateTime) return MapEntry(key, Timestamp.fromDate(value));
    if (value is Map) return MapEntry(key, _convertDateTimesToTimestamps(value));
    if (value is List) return MapEntry(key, value.map((e) =>
      e is Map ? _convertDateTimesToTimestamps(e) : e).toList());
    return MapEntry(key, value);
  });
}
```

### Error Handling in Providers

Always wrap repository calls in try-catch:
```dart
try {
  await repository.createItem(item);
  // Success feedback
} catch (e) {
  log('Error creating item: $e');
  // Show error to user via SnackBar
}
```

### Form Validation

Use `ResponsiveTextField` with built-in validation:
```dart
ResponsiveTextField(
  controller: controller,
  labelText: l10n.name,
  validator: (value) {
    if (value == null || value.isEmpty) return l10n.pleaseEnterName;
    if (value.length < 3) return l10n.nameTooShort;
    return null;
  },
)
```

## Important References

- **Implementation Plan:** See `PLAN.md` for complete phase-by-phase development plan with progress tracking
- **Requirements:** See `specs/requirements.md` for detailed feature specifications
- **Projection Requirements:** See `specs/projection_requirements.md` for projection calculation details
- **Design Patterns:** See `specs/Design Best Practices.md` for architecture details
- **UI Guidelines:** See `specs/UI Guidelines.md` for responsive design patterns

## Testing Checklist

When implementing responsive features, test on:
- iPhone SE (smallest supported size)
- iPad (both orientations)
- Desktop at various widths
- Height-constrained environments
- Orientation changes
