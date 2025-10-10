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
├── main.dart              # Application entry point
├── app.dart               # Root widget with routing and app-wide state
├── core/                  # Shared utilities and configuration
│   ├── config/           # Application configuration
│   ├── error/            # Error handling
│   ├── logger/           # Logging services
│   └── router/           # Navigation and routing (GoRouter)
└── features/             # Feature modules (feature-based organization)
    ├── auth/             # Authentication feature
    └── home/             # Home screen feature
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

- **GoRouter** for deep linking and route transitions
- Feature routes stored in feature directories, integrated in main router
- Route guards for authentication protection

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
- Dashboard
- Base Parameters
- Assets & Events
- Scenarios
- Projection
- Settings (includes logout)

## Important References

- **Requirements:** See `specs/requirements.md` for detailed feature specifications
- **Design Patterns:** See `specs/Design Best Practices.md` for architecture details
- **UI Guidelines:** See `specs/UI Guidelines.md` for responsive design patterns

## Testing Checklist

When implementing responsive features, test on:
- iPhone SE (smallest supported size)
- iPad (both orientations)
- Desktop at various widths
- Height-constrained environments
- Orientation changes
