# Retirement Planning App - Implementation Plan

**Key Principle:** Every phase produces a runnable, testable app increment that can be manually verified with `flutter run`.

---

## PHASE 1: Dependencies & iOS/CocoaPods Setup

**Goal:** Get all dependencies working, especially on iOS to avoid late-stage CocoaPods issues

### Tasks:
1. **Add required packages to `pubspec.yaml`:**
   - `flutter_riverpod` - State management
   - `freezed` + `freezed_annotation` - Immutable models
   - `build_runner` - Code generation
   - `json_annotation` + `json_serializable` - JSON serialization
   - `go_router` - Routing and navigation
   - `firebase_core` - Firebase foundation
   - `firebase_auth` - Authentication
   - `cloud_firestore` - Database
   - `firebase_storage` - File storage
   - `google_sign_in` - Google authentication
   - `sign_in_with_apple` - Apple authentication
   - `intl` - Internationalization

2. **Configure iOS project:**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Set minimum deployment target to iOS 15.0 in project settings
   - Update `ios/Podfile`: set `platform :ios, '15.0'`
   - Add required iOS permissions to `ios/Runner/Info.plist`

3. **Test CocoaPods installation:**
   - Run `cd ios && pod install`
   - Verify all pods install without errors
   - Check for version conflicts
   - Document any specific pod versions if needed

4. **Verify iOS build:**
   - Run `flutter build ios --debug`
   - Fix any build errors
   - Ensure no linker errors

5. **Test on iOS simulator:**
   - Run `flutter run -d "iPhone 15 Pro"` (or available simulator)
   - Verify app launches without crashes
   - Test hot reload functionality
   - Check console for any runtime warnings

6. **Configure Firebase using FlutterFire CLI:**
   - Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - Run FlutterFire configure with project ID: `flutterfire configure --project=retire1-1a558`
   - Select platforms: iOS, Android, macOS, Web
   - FlutterFire will automatically:
     - Download platform config files (GoogleService-Info.plist for iOS, google-services.json for Android)
     - Generate `lib/firebase_options.dart` with configuration
     - Add files to appropriate locations

7. **Initialize Firebase in main.dart:**
   - Import `firebase_core` and generated `firebase_options.dart`
   - Add `WidgetsFlutterBinding.ensureInitialized()`
   - Call `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`
   - Wrap main() with async
   - Test app launch with Firebase initialized
   - Verify no Firebase-related crashes

8. **Test on physical iOS device (if available):**
   - Connect physical device
   - Run on device
   - Verify no device-specific issues

**Manual Test Checklist:**
- ✓ App runs on iOS simulator without errors
- ✓ Hot reload works on iOS
- ✓ No CocoaPods warnings in build output
- ✓ Firebase initializes without crashes
- ✓ App runs on physical iOS device (if available)

**Deliverable:** Working Flutter app with all dependencies, confirmed working on iOS

---

## ✅ PHASE 1 COMPLETED

**What was accomplished:**
- All required packages added to pubspec.yaml
- iOS project configured with Podfile (iOS 15.0 minimum)
- CocoaPods successfully installed (32 pods)
- iOS build verified (initial: ~17min, subsequent: ~26sec)
- Firebase configured using FlutterFire CLI
  - Project: retire1-1a558
  - Platforms: iOS, Android, macOS, Web
  - Bundle ID: dev.turbo2000.retire1
- Firebase initialized in main.dart
- App running successfully on iOS simulator (iPad Air 13-inch M3)
- No crashes or errors

**Key files modified:**
- pubspec.yaml - dependencies added
- lib/main.dart - Firebase initialization
- iOS/Android/macOS - platform configurations
- .gitignore - Firebase files excluded

---

## PHASE 2: Dark Theme & Localization

**Goal:** App has proper dark theme and supports French/English languages

### Tasks:
1. **Create theme configuration:**
   - Create `lib/core/config/theme/app_theme.dart`
   - Define Material 3 dark color scheme
   - Configure typography (readable font sizes)
   - Set component themes (buttons, cards, text fields, etc.)
   - Ensure no hardcoded colors (all via theme)

2. **Set up internationalization:**
   - Create `lib/core/config/i18n/app_localizations.dart`
   - Create `lib/core/config/i18n/app_localizations_en.dart` (English strings)
   - Create `lib/core/config/i18n/app_localizations_fr.dart` (French strings)
   - Add common strings: app title, navigation items, buttons, etc.

3. **Update MaterialApp:**
   - Apply theme in `main.dart`
   - Add localization delegates
   - Set supported locales (en, fr)
   - Set default locale based on device settings

4. **Create temporary language switcher:**
   - Add a simple button to toggle language (for testing)
   - Can be removed later when settings screen is built

5. **Test theme:**
   - Verify dark theme throughout app
   - Check contrast ratios for accessibility
   - Test on different screen sizes

**Manual Test Checklist:**
- ✓ App displays with dark theme
- ✓ Can switch between English and French
- ✓ All text uses theme colors (no bright white on dark background issues)
- ✓ Theme looks good on phone, tablet, desktop sizes

**Deliverable:** App with polished dark theme and working bilingual support

---

## PHASE 3: Responsive Foundation

**Goal:** Breakpoints and responsive utilities are working and testable

### Tasks:
1. **Create responsive utilities:**
   - Create `lib/core/ui/responsive/layout_breakpoints.dart`
   - Define constants: `phoneMax = 600`, `tabletMax = 1024`, `desktopMin = 1024`
   - Define spacing constants
   - Define max content widths

2. **Create ScreenSize utility:**
   - Create `lib/core/ui/responsive/screen_size.dart`
   - Add `isPhone`, `isTablet`, `isDesktop` getters
   - Add helper methods for width/height

3. **Create demo screen:**
   - Create `lib/demo/responsive_demo_screen.dart`
   - Display current screen size category
   - Display current width/height
   - Show breakpoint values
   - Update in real-time when resizing

4. **Add navigation to demo:**
   - Update main.dart to show demo screen
   - Test window resizing (web/desktop)
   - Test device rotation (mobile)

**Manual Test Checklist:**
- ✓ Resize browser window, see breakpoint change
- ✓ Rotate device, see size update
- ✓ Correct categories on phone/tablet/desktop
- ✓ Values update in real-time

**Deliverable:** Working responsive foundation with visual confirmation

---

## PHASE 4: Responsive Component Library

**Goal:** All reusable responsive widgets built, documented, and demonstrated

### Tasks:
1. **Create base responsive widgets:**
   - Create `lib/core/ui/responsive/responsive_builder.dart`
     - Accept `builder`, `phone`, `tablet`, `desktop` callbacks
     - Return appropriate widget based on screen size
   - Create `lib/core/ui/responsive/responsive_container.dart`
     - Max width constraints
     - Responsive padding
     - Alignment options

2. **Create form components:**
   - Create `lib/core/ui/responsive/responsive_text_field.dart`
     - Adaptive sizing
     - Validation support
     - Error message display
   - Create `lib/core/ui/responsive/responsive_button.dart`
     - Size variants (small, medium, large)
     - Loading state
     - Fill width option
     - Disabled state

3. **Create content components:**
   - Create `lib/core/ui/responsive/responsive_card.dart`
     - Title, subtitle, description
     - Expansion support
     - Badge support
     - Tap handler
   - Create `lib/core/ui/responsive/responsive_collapsible_section.dart`
     - Expandable/collapsible
     - Icon rotation animation
     - Initially expanded option

4. **Create dialog components:**
   - Create `lib/core/ui/responsive/responsive_dialog.dart`
     - Adaptive width (narrow on phone, constrained on desktop)
     - Title, content, actions
   - Create `lib/core/ui/responsive/responsive_bottom_sheet.dart`
     - Full screen on phone, modal on tablet/desktop
     - Scrollable content support
     - Drag handle

5. **Create layout components:**
   - Create `lib/core/ui/responsive/responsive_multi_pane_layout.dart`
     - Start, center, end panes
     - Collapsible panes
     - Responsive pane visibility

6. **Create components demo screen:**
   - Create `lib/demo/components_demo_screen.dart`
   - Section for each component type
   - Working examples with interactions
   - Show responsive behavior

7. **Add navigation to demo:**
   - Create simple navigation to demo screen
   - Allow easy access for testing

**Manual Test Checklist:**
- ✓ All components render correctly
- ✓ Resize window, components adapt appropriately
- ✓ Test all interactive states (hover, pressed, disabled)
- ✓ Forms validate correctly
- ✓ Dialogs and bottom sheets work on all sizes
- ✓ Text fields accept input and show errors
- ✓ Buttons show loading states

**Deliverable:** Complete responsive component library with working demos

---

## PHASE 5: Navigation Shell

**Goal:** Full app navigation structure working with responsive navigation

### Tasks:
1. **Set up GoRouter:**
   - Create `lib/core/router/app_router.dart`
   - Define route names as constants
   - Define routes for all main screens (placeholders)
   - Set up initial route

2. **Create placeholder screens:**
   - Create `lib/features/dashboard/presentation/dashboard_screen.dart` (empty)
   - Create `lib/features/project/presentation/base_parameters_screen.dart` (empty)
   - Create `lib/features/assets/presentation/assets_events_screen.dart` (empty)
   - Create `lib/features/scenarios/presentation/scenarios_screen.dart` (empty)
   - Create `lib/features/projection/presentation/projection_screen.dart` (empty)
   - Create `lib/features/settings/presentation/settings_screen.dart` (empty)
   - Each screen shows its title and description

3. **Create app shell with navigation:**
   - Create `lib/core/ui/layout/app_shell.dart`
   - Implement responsive navigation:
     - Phone: Bottom navigation bar (5 items max)
     - Tablet/Desktop: Navigation rail (collapsible)
   - Define navigation items: Dashboard, Base Parameters, Assets & Events, Scenarios, Projection
   - Add settings button/icon in app bar

4. **Integrate router with app:**
   - Update `main.dart` to use GoRouter
   - Set up MaterialApp.router
   - Test deep linking structure

5. **Test navigation:**
   - Navigate between all screens
   - Verify navigation persists on hot reload
   - Test back button behavior
   - Resize window, verify navigation adapts

**Manual Test Checklist:**
- ✓ Can navigate to all 6 main screens
- ✓ Bottom nav shows on phone size
- ✓ Navigation rail shows on tablet/desktop size
- ✓ Settings accessible from all screens
- ✓ Current screen highlighted in navigation
- ✓ Smooth transitions between screens

**Deliverable:** Complete navigation structure, all screens accessible

---

## PHASE 6: Authentication UI (Mock)

**Goal:** Login and registration screens working with mock authentication

### Tasks:
1. **Create domain models:**
   - Create `lib/features/auth/domain/user.dart`
   - Define User class with Freezed (id, email, displayName, photoUrl)
   - Run build_runner: `flutter pub run build_runner build`

2. **Create login screen:**
   - Create `lib/features/auth/presentation/login_screen.dart`
   - Email text field (with validation)
   - Password text field (obscured)
   - Login button with loading state
   - "Don't have an account? Register" link
   - Social sign-in buttons (Google, Apple) - disabled for now
   - Responsive layout (centered form on desktop, full width on phone)

3. **Create registration screen:**
   - Create `lib/features/auth/presentation/register_screen.dart`
   - Display name field
   - Email field (with validation)
   - Password field (with strength indicator)
   - Confirm password field (must match)
   - Register button
   - "Already have an account? Login" link
   - Form validation

4. **Create mock authentication provider:**
   - Create `lib/features/auth/data/auth_repository_mock.dart`
   - Implement mock login (accept any email/password)
   - Implement mock registration (store in memory)
   - Return mock User object
   - Simulate network delay (500ms)

5. **Create auth state provider:**
   - Create `lib/features/auth/presentation/providers/auth_provider.dart`
   - Use Riverpod StateNotifier
   - Track auth state (loading, authenticated, unauthenticated, error)
   - Expose login/logout/register methods

6. **Add route guards:**
   - Update GoRouter with redirect logic
   - Redirect to login if not authenticated
   - Redirect to dashboard if authenticated trying to access login

7. **Update navigation:**
   - Show login screen initially
   - Show app shell after login
   - Add logout functionality (temporary button)

**Manual Test Checklist:**
- ✓ App shows login screen on launch
- ✓ Can enter email/password
- ✓ Form validation works (empty fields, invalid email)
- ✓ Login button shows loading state
- ✓ After login, redirected to dashboard
- ✓ Can navigate to register screen
- ✓ Registration form validation works
- ✓ Can logout and return to login
- ✓ Responsive layout on all screen sizes

**Deliverable:** Working login/registration flow with mock auth

---

## PHASE 7: Firebase Authentication

**Goal:** Real authentication with Firebase Auth

### Tasks:
1. **Create Firebase auth repository:**
   - Create `lib/features/auth/data/auth_repository.dart`
   - Implement email/password sign in
   - Implement email/password registration
   - Implement sign out
   - Convert Firebase User to domain User model
   - Handle Firebase exceptions (weak password, email in use, etc.)

2. **Create auth state listener:**
   - Listen to Firebase auth state changes
   - Update Riverpod provider automatically
   - Persist auth state across app restarts

3. **Update auth provider:**
   - Replace mock repository with Firebase repository
   - Keep mock as alternate for testing

4. **Add error handling:**
   - Display user-friendly error messages
   - Handle common errors: invalid email, wrong password, email already in use
   - Show errors in UI (SnackBar or below fields)

5. **Test on iOS:**
   - Run on iOS simulator
   - Test registration
   - Test login
   - Verify no crashes
   - Check Firebase console for created users

6. **Test on Android:**
   - Run on Android emulator
   - Test authentication flow
   - Verify Firebase integration

7. **Implement social sign-in (optional for this phase):**
   - Configure Google Sign-In (iOS and Android)
   - Configure Sign in with Apple (iOS)
   - Add sign-in buttons to login screen
   - Test on physical devices

**Manual Test Checklist:**
- ✓ Can create new account with Firebase
- ✓ User appears in Firebase console
- ✓ Can login with created account
- ✓ Invalid credentials show error message
- ✓ Email already in use shows error
- ✓ Weak password shows error
- ✓ Can logout
- ✓ Auth state persists after app restart
- ✓ Works on iOS without crashes
- ✓ Works on Android

**Deliverable:** Production-ready authentication with Firebase

---

## PHASE 8: Settings Screen

**Goal:** Functional settings screen with language selection and logout

### Tasks:
1. **Create settings domain models:**
   - Create `lib/features/settings/domain/app_settings.dart`
   - Define settings: language, userId
   - Use Freezed for immutability

2. **Create settings screen UI:**
   - Create `lib/features/settings/presentation/settings_screen.dart`
   - User account information section (email, display name)
   - Language selector (dropdown or segmented control)
   - Logout button (with confirmation dialog)
   - Responsive layout

3. **Create settings repository:**
   - Create `lib/features/settings/data/settings_repository.dart`
   - Store settings in Firestore (per user)
   - Load settings on login
   - Update settings in real-time

4. **Create settings provider:**
   - Create Riverpod provider for settings
   - Load settings on app start
   - Apply language changes immediately
   - Persist to Firestore

5. **Integrate language switching:**
   - Update MaterialApp locale based on settings
   - Rebuild app when language changes
   - Test all strings in both languages

6. **Add logout confirmation:**
   - Show dialog before logout
   - "Are you sure?" message
   - Cancel/Logout buttons

**Manual Test Checklist:**
- ✓ Can access settings from any screen
- ✓ Current user email displayed
- ✓ Can switch language, UI updates immediately
- ✓ Language preference saved to Firestore
- ✓ Language persists after logout/login
- ✓ Logout shows confirmation
- ✓ Logout returns to login screen
- ✓ Settings UI responsive on all sizes

**Deliverable:** Working settings screen with persistence

---

## PHASE 9: Dashboard & Projects (UI Only)

**Goal:** Dashboard showing project list with create/edit/delete (mock data)

### Tasks:
1. **Create project domain models:**
   - Create `lib/features/project/domain/project.dart`
   - Define Project: id, name, description, ownerId, createdAt, updatedAt
   - Use Freezed

2. **Create dashboard screen:**
   - Create `lib/features/dashboard/presentation/dashboard_screen.dart`
   - App bar with title and settings button
   - Project grid/list (responsive: grid on tablet/desktop, list on phone)
   - "Create New Project" FAB or button
   - Empty state (when no projects)

3. **Create project card component:**
   - Create `lib/features/dashboard/presentation/widgets/project_card.dart`
   - Show project name, description, last modified
   - Tap to open project (navigate to base parameters)
   - Edit button (opens edit dialog)
   - Delete button (shows confirmation)

4. **Create project dialogs:**
   - Create `lib/features/dashboard/presentation/widgets/create_project_dialog.dart`
   - Name field (required)
   - Description field (optional)
   - Create/Cancel buttons
   - Form validation
   - Create `lib/features/dashboard/presentation/widgets/edit_project_dialog.dart` (similar)

5. **Create mock projects provider:**
   - Create Riverpod provider with mock project data
   - Support add/edit/delete (in memory only)
   - Show 2-3 mock projects initially

6. **Implement interactions:**
   - Create project → shows in list
   - Edit project → updates card
   - Delete project → shows confirmation, then removes
   - Tap project → navigates to base parameters screen (which is still placeholder)

**Manual Test Checklist:**
- ✓ Dashboard shows mock projects
- ✓ Can create new project, appears in list
- ✓ Can edit project name/description
- ✓ Can delete project with confirmation
- ✓ Empty state shows when no projects
- ✓ Project cards responsive (grid/list)
- ✓ Tapping project navigates (to placeholder screen)
- ✓ All interactions smooth on phone/tablet/desktop

**Deliverable:** Functional dashboard UI with mock data

---

## PHASE 10: Projects - Firebase Integration

**Goal:** Projects saved to and loaded from Firestore

### Tasks:
1. **Create project DTO:**
   - Create `lib/features/project/data/project_dto.dart`
   - Map to/from Firestore document
   - Handle serialization with json_serializable
   - Include createdAt/updatedAt timestamps

2. **Create project repository:**
   - Create `lib/features/project/data/project_repository.dart`
   - Implement CRUD operations:
     - `createProject(Project)` → Firestore
     - `getProjects(userId)` → Stream of projects
     - `updateProject(Project)` → Firestore
     - `deleteProject(projectId)` → Firestore
   - Use Firestore collection: `users/{userId}/projects`

3. **Update projects provider:**
   - Replace mock data with Firestore stream
   - Listen to real-time updates
   - Handle loading and error states

4. **Test Firestore integration:**
   - Create project, verify in Firebase console
   - Edit project, see update in console
   - Delete project, verify deletion
   - Open app on different device, see same projects

5. **Handle errors:**
   - Network errors (offline mode)
   - Permission errors
   - Show error messages in UI

**Manual Test Checklist:**
- ✓ Create project, appears in Firestore console
- ✓ Projects load on app start
- ✓ Edit project, update reflected in Firestore
- ✓ Delete project, removed from Firestore
- ✓ Real-time updates (change in console, app updates)
- ✓ Loading state shown while fetching
- ✓ Works on iOS, Android, Web

**Deliverable:** Project management fully integrated with Firestore

---

## PHASE 11: Base Parameters Screen (UI Only)

**Goal:** Manage project-wide parameters and individuals (mock data)

### Tasks:
1. **Create individual domain model:**
   - Create `lib/features/project/domain/individual.dart`
   - Fields: id, name, birthdate
   - Use Freezed
   - Add helper: `int get age` (calculate from birthdate)

2. **Update project model:**
   - Add `List<Individual> individuals` to Project
   - Add other base parameters as needed

3. **Create base parameters screen:**
   - Create `lib/features/project/presentation/base_parameters_screen.dart`
   - App bar with project name
   - Form for project-wide parameters
   - "Individuals" section
   - List of individuals with add/edit/delete
   - Responsive layout (form constrained on desktop)

4. **Create individual card:**
   - Show name, birthdate, calculated age
   - Edit and delete buttons
   - Compact on phone, detailed on desktop

5. **Create individual dialogs:**
   - Create `lib/features/project/presentation/widgets/individual_dialog.dart`
   - Name field (required)
   - Birthdate picker
   - Save/Cancel buttons
   - Validation
   - Use for both add and edit

6. **Create parameters provider:**
   - Riverpod provider for current project parameters
   - Mock data for testing
   - Support add/edit/delete individuals
   - Calculate ages automatically

7. **Test interactions:**
   - Add individual, appears in list with calculated age
   - Edit individual, updates in list
   - Delete individual, removed with confirmation
   - Age updates correctly

**Manual Test Checklist:**
- ✓ Can add individuals with names and birthdates
- ✓ Age calculated and displayed correctly
- ✓ Can edit individual information
- ✓ Can delete individuals with confirmation
- ✓ Form validation works (required fields)
- ✓ Date picker works on all platforms
- ✓ Responsive layout on all sizes
- ✓ All data in mock state (not persisted yet)

**Deliverable:** Working base parameters screen with mock data

---

## PHASE 12: Base Parameters - Firebase Integration

**Goal:** Parameters and individuals saved to Firestore

### Tasks:
1. **Update project DTO:**
   - Add individuals to DTO
   - Add other base parameters
   - Handle date serialization (Firestore Timestamp)

2. **Update project repository:**
   - Save individuals with project
   - Load individuals when loading project

3. **Update parameters provider:**
   - Load from Firestore when opening project
   - Save changes to Firestore immediately (or on save button)
   - Handle real-time updates

4. **Test persistence:**
   - Add individuals, close app, reopen, verify data persists
   - Edit on one device, see update on another
   - Check Firestore console for data structure

**Manual Test Checklist:**
- ✓ Add individuals, data saved to Firestore
- ✓ Close and reopen app, individuals still there
- ✓ Edit individual, changes persist
- ✓ Delete individual, removed from Firestore
- ✓ Correct data structure in Firestore console

**Deliverable:** Base parameters fully integrated with Firestore

---

## PHASE 13: Assets Screen (UI Only)

**Goal:** Full asset management UI with all 4 asset types (mock data)

### Tasks:
1. **Create asset domain models:**
   - Create `lib/features/assets/domain/asset.dart`
   - Use Freezed unions for 4 asset types:
     - `RealEstateAsset(id, type, value, setAtStart)`
     - `RRSPAccount(id, individualId, value)`
     - `CELIAccount(id, individualId, value)`
     - `CashAccount(id, individualId, value)`
   - Add helper methods as needed

2. **Create assets screen:**
   - Create `lib/features/assets/presentation/assets_screen.dart`
   - App bar with project name
   - Assets grouped by type
   - "Add Asset" FAB with type selector
   - Empty state for each type
   - Responsive card layout

3. **Create asset cards:**
   - Create `lib/features/assets/presentation/widgets/asset_card.dart`
   - Display differently based on asset type
   - Show key information (value, type, individual)
   - Edit and delete buttons

4. **Create add asset dialog:**
   - Create `lib/features/assets/presentation/widgets/add_asset_dialog.dart`
   - First step: Select asset type (4 buttons/tiles)
   - Second step: Type-specific form
   - Cancel/Save buttons

5. **Create asset type forms:**
   - Create `lib/features/assets/presentation/widgets/real_estate_form.dart`
     - Type dropdown (house, condo, cottage, etc.)
     - Value field (currency)
     - "Set at start" checkbox
   - Create `lib/features/assets/presentation/widgets/account_form.dart` (reusable)
     - Individual selector (dropdown)
     - Value field (currency)
     - Account type shown as title

6. **Create mock assets provider:**
   - Riverpod provider with mock assets
   - Support CRUD operations (in memory)
   - Link to individuals from base parameters

7. **Test interactions:**
   - Add each asset type
   - Edit assets
   - Delete with confirmation
   - Verify correct forms shown for each type

**Manual Test Checklist:**
- ✓ Can add all 4 asset types
- ✓ Each type shows appropriate form fields
- ✓ Individual selector shows individuals from base parameters
- ✓ Can edit any asset
- ✓ Can delete assets with confirmation
- ✓ Assets grouped by type
- ✓ Responsive layout on all sizes
- ✓ Currency formatting works
- ✓ All data in mock state

**Deliverable:** Complete asset management UI with mock data

---

## PHASE 14: Assets - Firebase Integration

**Goal:** Assets saved to Firestore with proper type handling

### Tasks:
1. **Create asset DTOs:**
   - Create `lib/features/assets/data/asset_dto.dart`
   - Handle union type serialization (type field + type-specific data)
   - Map to/from Firestore documents

2. **Create asset repository:**
   - Create `lib/features/assets/data/asset_repository.dart`
   - Implement CRUD for assets
   - Store in `projects/{projectId}/assets` collection
   - Handle different asset types

3. **Update assets provider:**
   - Load assets from Firestore
   - Real-time updates
   - Save changes to Firestore

4. **Test persistence:**
   - Add assets, verify in Firestore console
   - Check correct type discrimination
   - Test real-time updates

**Manual Test Checklist:**
- ✓ Add assets, saved to Firestore
- ✓ All 4 asset types persist correctly
- ✓ Edit asset, changes saved
- ✓ Delete asset, removed from Firestore
- ✓ Assets load on app start
- ✓ Correct data structure in Firestore

**Deliverable:** Assets fully integrated with Firestore

---

## PHASE 15: Events Screen (UI Only)

**Goal:** Event management UI with timeline view (mock data)

### Tasks:
1. **Create event domain models:**
   - Create `lib/features/events/domain/event_timing.dart`
   - Use Freezed unions:
     - `RelativeTiming(yearsFromStart)`
     - `AbsoluteTiming(calendarYear)`
     - `AgeTiming(individualId, age)`
   - Create `lib/features/events/domain/event.dart`
   - Use Freezed unions:
     - `RetirementEvent(id, individualId, timing)`
     - `DeathEvent(id, individualId, timing)`
     - `RealEstateTransactionEvent(id, timing, assetSoldId, assetPurchasedId, withdrawAccountId, depositAccountId)`

2. **Create events screen:**
   - Create `lib/features/events/presentation/events_screen.dart`
   - App bar with project name
   - Timeline view (vertical on phone, could be horizontal on desktop)
   - Events sorted by timing
   - "Add Event" FAB with type selector
   - Empty state

3. **Create event cards:**
   - Create `lib/features/events/presentation/widgets/event_card.dart`
   - Different display for each event type
   - Show timing in human-readable format
   - Edit and delete buttons
   - Position on timeline

4. **Create timing selector component:**
   - Create `lib/features/events/presentation/widgets/timing_selector.dart`
   - Radio buttons for timing type (Relative/Absolute/Age)
   - Conditional fields based on selection
   - Individual selector for Age timing
   - Validation

5. **Create event type forms:**
   - Create `lib/features/events/presentation/widgets/retirement_event_form.dart`
     - Individual selector
     - Timing selector
   - Create `lib/features/events/presentation/widgets/death_event_form.dart`
     - Individual selector
     - Timing selector
   - Create `lib/features/events/presentation/widgets/real_estate_transaction_form.dart`
     - Timing selector
     - Asset sold selector (optional, can be null)
     - Asset purchased selector (optional, can be null)
     - Withdraw from account selector
     - Deposit to account selector

6. **Create add event dialog:**
   - First: Select event type
   - Second: Show appropriate form
   - Validation
   - Cancel/Save buttons

7. **Create mock events provider:**
   - Riverpod provider with mock events
   - Support CRUD operations
   - Sort events by calculated timing

8. **Implement event sorting logic:**
   - Convert all timing types to comparable values
   - Sort events chronologically
   - Handle edge cases (same timing)

**Manual Test Checklist:**
- ✓ Can add all 3 event types
- ✓ All timing types work (relative, absolute, age)
- ✓ Events appear on timeline in correct order
- ✓ Can edit events
- ✓ Can delete events with confirmation
- ✓ Individual and asset selectors populated correctly
- ✓ Timing displays in human-readable format
- ✓ Form validation works
- ✓ Responsive timeline layout
- ✓ All data in mock state

**Deliverable:** Complete event management UI with timeline

---

## PHASE 16: Events - Firebase Integration

**Goal:** Events saved to Firestore with complex type handling

### Tasks:
1. **Create event DTOs:**
   - Create `lib/features/events/data/event_dto.dart`
   - Handle nested union types (event type + timing type)
   - Map to/from Firestore documents

2. **Create event repository:**
   - Create `lib/features/events/data/event_repository.dart`
   - Implement CRUD for events
   - Store in `projects/{projectId}/events` collection
   - Handle complex type serialization

3. **Update events provider:**
   - Load events from Firestore
   - Real-time updates
   - Save changes to Firestore
   - Keep sorting logic

4. **Test persistence:**
   - Add events with different timing types
   - Verify correct serialization in Firestore
   - Test updates and deletes

**Manual Test Checklist:**
- ✓ Add events, saved to Firestore correctly
- ✓ All timing types persist correctly
- ✓ Event type discrimination works
- ✓ Edit event, changes saved
- ✓ Delete event, removed from Firestore
- ✓ Events load and sort correctly on app start
- ✓ Correct data structure in Firestore

**Deliverable:** Events fully integrated with Firestore

---

## PHASE 17: Scenarios Screen (UI Only)

**Goal:** Scenario management with variation highlighting (mock data)

### Tasks:
1. **Create scenario domain models:**
   - Create `lib/features/scenarios/domain/scenario.dart`
   - Fields: id, name, isBase, variationOverrides
   - Create `lib/features/scenarios/domain/parameter_override.dart`
   - Support overriding asset values, event parameters, etc.
   - Use Freezed

2. **Create scenarios screen:**
   - Create `lib/features/scenarios/presentation/scenarios_screen.dart`
   - App bar with project name
   - Base scenario card (always visible, not deletable)
   - List of variation scenarios
   - "Add Scenario" button
   - Responsive layout

3. **Create scenario card:**
   - Show scenario name
   - Show number of variations
   - Tap to open/edit
   - Delete button (not for base scenario)
   - Expandable to show quick summary

4. **Create scenario editor:**
   - Create `lib/features/scenarios/presentation/scenario_editor_screen.dart`
   - Scenario name field
   - Collapsible sections for parameter groups:
     - Asset value overrides
     - Event parameter overrides
   - Each parameter shows base value vs override value
   - Highlight overridden parameters (different color/icon)
   - Can clear override to use base value

5. **Create parameter override widgets:**
   - Create `lib/features/scenarios/presentation/widgets/asset_override_section.dart`
   - List all assets, show base values
   - Allow editing value for this scenario
   - Highlight if different from base
   - Create similar for event overrides

6. **Create mock scenarios provider:**
   - Base scenario (always present)
   - Support adding variation scenarios
   - Track overrides
   - Apply overrides when viewing scenario

7. **Test interactions:**
   - Create variation scenario
   - Override some asset values
   - See highlighting of changed values
   - Edit scenario name
   - Delete variation scenario

**Manual Test Checklist:**
- ✓ Base scenario always visible
- ✓ Can create variation scenarios
- ✓ Can override asset values
- ✓ Overridden values highlighted
- ✓ Can clear override to use base value
- ✓ Can edit scenario name
- ✓ Can delete variation scenarios (not base)
- ✓ Responsive layout
- ✓ All data in mock state

**Deliverable:** Scenario management UI with variation highlighting

---

## PHASE 18: Scenarios - Firebase Integration

**Goal:** Scenarios with overrides saved to Firestore

### Tasks:
1. **Create scenario DTOs:**
   - Create `lib/features/scenarios/data/scenario_dto.dart`
   - Handle parameter overrides
   - Map to/from Firestore

2. **Create scenario repository:**
   - Create `lib/features/scenarios/data/scenario_repository.dart`
   - CRUD for scenarios
   - Store in `projects/{projectId}/scenarios` collection
   - Ensure base scenario always exists

3. **Update scenarios provider:**
   - Load scenarios from Firestore
   - Create base scenario if doesn't exist
   - Real-time updates
   - Save overrides

4. **Test persistence:**
   - Create scenarios with overrides
   - Verify in Firestore
   - Test updates and deletes

**Manual Test Checklist:**
- ✓ Scenarios saved to Firestore
- ✓ Overrides persist correctly
- ✓ Base scenario created automatically
- ✓ Changes sync across devices
- ✓ Can edit and delete scenarios

**Deliverable:** Scenarios fully integrated with Firestore

---

## PHASE 19: Projection Calculation Engine

**Goal:** Calculate yearly projections based on project data

### Tasks:
1. **Create projection domain models:**
   - Create `lib/features/projection/domain/projection.dart`
   - Fields: scenarioId, years (list of yearly data)
   - Create `lib/features/projection/domain/yearly_projection.dart`
   - Fields: year, assetValues (map), cashFlows, totalNetWorth
   - Use Freezed

2. **Create calculation service:**
   - Create `lib/features/projection/service/projection_calculator.dart`
   - Input: Project, Scenario, parameters (inflation rate, etc.)
   - Output: Projection (yearly breakdown)

3. **Implement calculation logic:**
   - Start with initial asset values (from base or scenario overrides)
   - For each year:
     - Apply events that occur in this year
     - Calculate asset appreciation
     - Calculate cash flows (income, expenses)
     - Update account values
     - Track net worth
   - Handle event timing calculations
   - Handle asset transactions
   - Handle account withdrawals/deposits

4. **Add inflation adjustments:**
   - Calculate both current dollars and constant dollars
   - Apply inflation to asset values
   - Adjust cash flows for inflation

5. **Write unit tests:**
   - Test calculation logic
   - Test edge cases (negative balances, etc.)
   - Test event application
   - Verify calculations manually

6. **Create calculation provider:**
   - Riverpod provider to calculate projection
   - Recalculate when project/scenario changes
   - Cache results

7. **Test calculations:**
   - Create simple project with known values
   - Run calculation
   - Verify results manually
   - Log yearly breakdown to console

**Manual Test Checklist:**
- ✓ Calculation completes without errors
- ✓ Yearly values make sense
- ✓ Events applied in correct years
- ✓ Asset values change over time
- ✓ Net worth calculated correctly
- ✓ Inflation adjustments work
- ✓ Unit tests pass

**Deliverable:** Working projection calculation engine

---

## PHASE 20: Projection Screen (UI)

**Goal:** Display projections with charts and tables

### Tasks:
1. **Add charting package:**
   - Add `fl_chart` or similar to pubspec.yaml
   - Test basic chart rendering

2. **Create projection screen:**
   - Create `lib/features/projection/presentation/projection_screen.dart`
   - App bar with project name
   - Scenario selector dropdown
   - Current/constant dollars toggle
   - Tabs or sections:
     - Chart view
     - Table view
   - Responsive layout

3. **Create chart view:**
   - Create `lib/features/projection/presentation/widgets/projection_chart.dart`
   - Line chart showing net worth over time
   - Multiple lines for different asset types
   - X-axis: years, Y-axis: value
   - Interactive tooltips
   - Responsive sizing

4. **Create table view:**
   - Create `lib/features/projection/presentation/widgets/projection_table.dart`
   - Columns: Year, Assets (by type), Total Net Worth, Cash Flow
   - Scrollable horizontally and vertically
   - Responsive (fewer columns on phone)
   - Currency formatting

5. **Connect to calculation engine:**
   - Load projection from provider
   - Show loading state while calculating
   - Display results
   - Update when scenario changes

6. **Add dollar type toggle:**
   - Switch between current and constant dollars
   - Recalculate/reformat when toggled

7. **Test visualization:**
   - Switch scenarios, see chart update
   - Toggle dollar type, see values change
   - Scroll table, verify all data visible
   - Resize window, verify responsive behavior

**Manual Test Checklist:**
- ✓ Projection screen loads
- ✓ Can select different scenarios
- ✓ Chart displays correctly
- ✓ Chart shows all asset types
- ✓ Table displays all years and values
- ✓ Can toggle current/constant dollars
- ✓ Values update when toggling
- ✓ Responsive on all screen sizes
- ✓ Chart tooltips work
- ✓ Table scrolls smoothly

**Deliverable:** Working projection visualization

---

## PHASE 21: Projection - Firebase Integration

**Goal:** Cache calculated projections in Firestore for performance

### Tasks:
1. **Create projection DTO:**
   - Create `lib/features/projection/data/projection_dto.dart`
   - Map to/from Firestore

2. **Create projection repository:**
   - Create `lib/features/projection/data/projection_repository.dart`
   - Save calculated projections
   - Store in `projects/{projectId}/projections` collection
   - Load cached projections

3. **Implement caching logic:**
   - Calculate projection if not in cache
   - Save to Firestore after calculation
   - Invalidate cache when project/scenario changes
   - Load from cache when available

4. **Update projection provider:**
   - Check cache first
   - Calculate if needed
   - Save to cache

5. **Test caching:**
   - Calculate projection, verify saved to Firestore
   - Reload app, projection loads from cache
   - Modify asset, projection recalculates

**Manual Test Checklist:**
- ✓ Projection calculated and cached
- ✓ Subsequent loads faster (from cache)
- ✓ Cache invalidated when data changes
- ✓ Projections visible in Firestore console

**Deliverable:** Optimized projection with caching

---

## PHASE 22: Polish, Testing & Production Readiness

**Goal:** Production-ready app with comprehensive testing

### Tasks:
1. **Add loading states everywhere:**
   - Review all screens
   - Add loading indicators where data is fetched
   - Skeleton loaders for lists
   - Shimmer effects (optional)

2. **Error handling and user feedback:**
   - Wrap all Firestore operations in try-catch
   - Show user-friendly error messages
   - Network error handling (offline mode)
   - Validation errors displayed clearly
   - Success messages for important actions

3. **Widget tests:**
   - Write tests for responsive components
   - Test form validation
   - Test navigation flows
   - Test state changes
   - Run `flutter test`

4. **Integration tests:**
   - Create end-to-end test scenarios
   - Test full user flows (create project → add assets → view projection)
   - Test authentication flows
   - Run on simulators/emulators

5. **Test on physical iOS device:**
   - Connect iPhone
   - Run app
   - Test all features
   - Verify performance
   - Check for any device-specific issues
   - Test touch interactions

6. **Test on physical Android device:**
   - Connect Android phone
   - Run app
   - Test all features
   - Verify performance

7. **Test on Web:**
   - Run `flutter run -d chrome`
   - Test all features
   - Check responsive design
   - Verify Firebase works on web

8. **Test on macOS:**
   - Run on macOS desktop
   - Test all features
   - Verify native feel

9. **Accessibility improvements:**
   - Add semantic labels to all interactive widgets
   - Test with screen reader (VoiceOver on iOS, TalkBack on Android)
   - Verify keyboard navigation
   - Check minimum touch target sizes (48x48)
   - Test text scaling (large fonts)

10. **Performance optimization:**
    - Profile app performance
    - Optimize list rendering (use ListView.builder)
    - Optimize image loading (if any)
    - Reduce bundle size
    - Check for memory leaks

11. **Internationalization completion:**
    - Review all hardcoded strings
    - Add missing translations
    - Test all screens in French
    - Test all screens in English
    - Verify date/number formatting for locale

12. **Security review:**
    - Review Firestore security rules
    - Verify user can only access their own data
    - Test with multiple users
    - Check for data leaks

13. **Final polish:**
    - Consistent spacing and alignment
    - Smooth animations
    - Proper keyboard handling (dismiss, next field)
    - Empty states for all lists
    - Confirmation dialogs for destructive actions
    - App icon and splash screen

14. **Documentation:**
    - Update README with setup instructions
    - Document Firebase setup steps
    - Document environment setup
    - Add screenshots to README

**Manual Test Checklist:**
- ✓ All features work on iOS
- ✓ All features work on Android
- ✓ All features work on Web
- ✓ All features work on macOS
- ✓ No crashes or errors
- ✓ Loading states shown appropriately
- ✓ Error messages clear and helpful
- ✓ All strings translated
- ✓ Responsive on all screen sizes
- ✓ Accessible to screen reader users
- ✓ Good performance on target devices
- ✓ Multiple users can use app simultaneously
- ✓ Data properly isolated per user

**Deliverable:** Production-ready retirement planning app

---

## Testing Workflow (Apply to Every Phase)

After completing each phase:

1. **Run the app:**
   ```bash
   flutter run
   # or specify device:
   flutter run -d "iPhone 15 Pro"
   flutter run -d chrome
   ```

2. **Manual testing:**
   - Test all new functionality
   - Try to break it (edge cases, invalid input)
   - Test on multiple screen sizes (resize window or rotate device)

3. **Verify hot reload:**
   - Make a small change
   - Press `r` to hot reload
   - Verify change appears

4. **Test on iOS specifically:**
   - Run on iOS simulator regularly
   - Check console for warnings
   - Verify no crashes

5. **Check code quality:**
   ```bash
   flutter analyze
   ```

6. **Run tests:**
   ```bash
   flutter test
   ```

7. **Commit working increment:**
   ```bash
   git add .
   git commit -m "Phase X: [description]"
   ```

8. **Document any issues or technical debt**

---

## Notes

- **Incremental development** is key - each phase builds on the previous
- **Test frequently** - catch issues early when they're easier to fix
- **Use hot reload** - fastest way to see changes
- **Check iOS regularly** - CocoaPods issues should be caught early
- **Keep commits small** - easier to debug if something breaks
- **Don't skip phases** - the order is designed to minimize risk

