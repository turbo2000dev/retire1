# Project Creation Wizard - Implementation Plan

## Overview
Create an optional guided wizard to help users quickly set up retirement planning projects with intuitive steps, smart defaults, and educational tooltips. The wizard complements (not replaces) existing data entry screens.

## Architecture Approach
- **Feature location**: `lib/features/project/presentation/wizard/`
- **Wizard flow**: Multi-step stepper with forward/backward navigation
- **Data storage**: Wizard state held in memory, only committed to Firestore at final confirmation
- **Responsive design**: Works across iOS, Android, Web, macOS with phone/tablet/desktop layouts
- **Reusable components**: Leverage existing responsive widgets and domain models

---

## Phase 1: Foundation & Entry Point
**Goal**: Create wizard infrastructure and integrate entry point after project creation

### Step 1.1: Wizard State Management
**Tasks**:
- Create `wizard_state.dart` with Freezed model to hold all wizard data
- Create `wizard_provider.dart` with Riverpod StateNotifier for managing wizard flow
- Include fields for: individuals (1-2), revenue sources, assets, expenses, scenarios

**Design Decisions**:
- ✅ Use Freezed for immutable wizard state
- ✅ Store all data in memory until final commit
- ✅ Wizard state is temporary (no persistence until completion)
- ✅ Support exactly 1-2 individuals (typical for single/couple plans)

**Testing**: Verify wizard state can be created, updated, and reset

### Step 1.2: Wizard Entry Dialog
**Tasks**:
- Create `wizard_launch_dialog.dart` - shown after project creation
- Two options: "Go to Project" (skip wizard) or "Use Setup Wizard" (start wizard)
- Modify `BaseParametersScreen._createNewProject()` to show launch dialog
- Add appealing icons and brief explanation of wizard benefits

**Design Decisions**:
- ✅ Non-blocking: users can always skip wizard
- ✅ Show wizard option immediately after project is created
- ✅ Clear messaging: "Quick setup wizard" vs "Manual configuration"

**Testing**: Create project, verify dialog appears, test both paths (skip/start wizard)

### Step 1.3: Wizard Shell & Navigation
**Tasks**:
- Create `project_wizard_screen.dart` - main wizard container
- Implement stepper UI with progress indicator (6 steps total)
- Add Previous/Next/Cancel buttons with responsive positioning
- Handle navigation between steps (maintain state)

**Design Decisions**:
- ✅ Use Flutter Stepper widget for desktop/tablet, custom mobile-optimized layout for phones
- ✅ Progress indicator shows current step (e.g., "Step 2 of 6")
- ✅ Cancel button confirms before discarding wizard data
- ✅ All steps are optional - can proceed with defaults

**Testing**: Navigate forward/backward between empty steps, verify cancel confirmation

---

## Phase 2: Individuals Step (REVISED - Single Screen for Both)
**Goal**: Collect basic information about 1-2 people in the retirement plan on ONE screen

### Step 2.1: Dual Individual Collection Screen
**Tasks**:
- Create `wizard_individuals_step.dart`
- **Individual 1 Section** (required, always visible):
  - Name, Birthdate, Current Annual Income, Expected Retirement Age, Life Expectancy
  - Clear heading: "Individual 1" or "You"
- **Individual 2 Section** (optional):
  - Initially collapsed with "Add Partner/Spouse" button
  - When expanded: same 5 fields as Individual 1
  - "Remove Second Individual" option (with confirmation)
  - Clear heading: "Individual 2" or "Partner/Spouse (Optional)"
- Responsive layout:
  - Mobile: Stacked vertically with divider between individuals
  - Tablet/Desktop: Two-column side-by-side layout
- Use card widgets for visual separation

**Design Decisions**:
- ✅ Individual 1 is always required (minimum for any plan)
- ✅ Individual 2 is optional - common for couples, skipped for singles
- ✅ Default life expectancy: 85 years (user adjustable)
- ✅ Default retirement age: 65 years (user adjustable)
- ✅ Simplified compared to full Individual dialog (no RRQ/PSV/RRPE details yet)
- ✅ Visual distinction: slightly different card colors or icons
- ✅ Reduces total wizard steps from 7 to 6

**Benefits**:
- Eliminates one navigation step
- Natural for couples (see both at once, compare ages)
- Still simple for singles (just fill one side)
- Less clicking overall

**Testing**:
- Add only Individual 1, proceed to next step
- Add both individuals, verify state holds both
- Add Individual 2 then remove, verify cleanup
- Visual review on phone (stacked), tablet (2-col), desktop (2-col)

### Step 2.2: Visual Design & Education
**Tasks**:
- Add friendly icons (person_outline for Ind 1, people_outline for Ind 2)
- Add tooltip for "Life Expectancy" explaining projection end date
- Helper text: "You can refine these details later in Base Parameters"
- Responsive adjustments for small screens

**Design Decisions**:
- ✅ Labels: "You/Individual 1" and "Partner/Spouse (Optional)"
- ✅ Tooltips use info icon next to field labels
- ✅ Warm, friendly tone in all help text
- ✅ Mobile: clear visual divider between individuals

**Testing**: Verify tooltips, test responsive layouts, check accessibility

---

## Phase 3: Revenue Sources Step
**Goal**: Identify potential retirement income sources

### Step 3.1: Revenue Source Selection
**Tasks**:
- Create `wizard_revenue_sources_step.dart`
- Checkbox list of common revenue sources (per individual):
  - RRQ (Quebec Pension Plan) - default checked
  - PSV (Old Age Security) - default checked
  - RRPE (Management pension) - unchecked
  - Employment Income (after retirement) - unchecked
  - Other Income - unchecked
- If 2 individuals: group by individual with clear sections
- Brief description for each source

**Design Decisions**:
- ✅ Pre-check RRQ and PSV (universal programs in Quebec)
- ✅ Show brief 1-sentence description per source
- ✅ Selection determines which detail fields show in next substep
- ✅ All sources optional (user might want to add manually later)

**Testing**: Check/uncheck sources, verify state per individual

### Step 3.2: Revenue Source Details
**Tasks**:
- For checked revenue sources, show detail fields:
  - **RRQ**: Start age (60-70, default 65), Projected annual amount at 60/65
  - **PSV**: Start age (65-70, default 65)
  - **RRPE**: Participation start date
  - **Employment/Other**: Annual amount, duration
- Provide sensible defaults based on Quebec averages
- Use collapsible sections per individual (if 2 individuals)

**Design Decisions**:
- ✅ Only show fields for selected revenue sources (conditional rendering)
- ✅ Default RRQ amounts: $12,000 at 60, $16,000 at 65 (Quebec averages)
- ✅ Default PSV age: 65
- ✅ Educational tooltips explaining each program
- ✅ Helper text: "Estimates - you can refine later"

**Testing**: Verify conditional display, test defaults, validate age ranges

---

## Phase 4: Assets Step
**Goal**: Identify and configure major assets

### Step 4.1: Asset Type Selection
**Tasks**:
- Create `wizard_assets_step.dart`
- Checkbox list of asset types:
  - Real Estate (primary residence)
  - RRSP/REER accounts
  - CELI/TFSA accounts
  - CRI accounts
  - Cash/Savings accounts
- Show friendly icons and brief descriptions
- Note: All optional (starting from scratch is valid)

**Design Decisions**:
- ✅ No assets required (user might be just starting)
- ✅ Simplified asset types (no real estate transactions in wizard)
- ✅ Focus on current balances, not complex configurations

**Testing**: Select different asset combinations, test "skip all" scenario

### Step 4.2: Asset Details Collection
**Tasks**:
- For each selected asset type, collect:
  - **Real Estate**: Estimated current value
  - **RRSP**: Owner (dropdown: Ind 1/Ind 2), Current balance, Annual contribution (optional)
  - **CELI**: Owner, Current balance, Annual contribution (optional)
  - **CRI**: Owner, Current balance
  - **Cash**: Owner, Current balance
- Use simple number inputs with currency formatting
- Support multiple accounts per type (except real estate - only one)
- "Add Another [Account Type]" button for RRSP/CELI/CRI/Cash

**Design Decisions**:
- ✅ All fields optional - can skip and add later
- ✅ Auto-generate UUIDs for assets
- ✅ Use project's default return rates (no custom rates in wizard)
- ✅ Group by asset type with visual cards
- ✅ Real estate limited to 1 (primary residence only in wizard)

**Testing**: Add multiple accounts, verify owner assignment, test without any assets

---

## Phase 5: Expenses Step
**Goal**: Estimate annual expenses with smart defaults

### Step 5.1: Expense Categories & Defaults
**Tasks**:
- Create `wizard_expenses_step.dart`
- Show 6 expense categories with pre-filled estimates:
  - Housing (30% of combined income)
  - Transport (15% of combined income)
  - Daily Living (20% of combined income)
  - Recreation (10% of combined income)
  - Health (10% of combined income)
  - Family (15% of combined income)
- Allow users to adjust any amount
- Show total annual expenses and visual breakdown
- Helper text: "Based on your income from Step 1"

**Design Decisions**:
- ✅ Defaults calculated from Individual 1 + Individual 2 income (Step 2)
- ✅ Percentages based on typical Quebec household spending patterns
- ✅ Users can modify any category or accept all defaults
- ✅ Expenses assumed: start at projection start, end at last life expectancy
- ✅ Optional: Visual pie chart showing expense distribution

**Testing**: Verify calculations correct, test manual adjustments, test with 0 income

### Step 5.2: Expense Timing
**Tasks**:
- Simple question: "When do these expenses start?"
  - Now (projection start) - default
  - At retirement (earliest retirement of both individuals)
  - Custom year
- Radio buttons for selection
- Note: Detailed per-category timing can be adjusted later in Expenses screen

**Design Decisions**:
- ✅ Default: "Now" (projection start)
- ✅ Simplified timing: single timing applies to all categories
- ✅ End timing: automatically set to last individual's life expectancy
- ✅ Helper text: "You can set different timing per category later"

**Testing**: Verify each timing option, check end date calculation

---

## Phase 6: Scenarios Step
**Goal**: Offer pre-configured scenario variations

### Step 6.1: Scenario Template Selection
**Tasks**:
- Create `wizard_scenarios_step.dart`
- Show 5 pre-defined scenario templates with checkboxes:
  1. **Base Scenario** (required, auto-checked, disabled)
  2. **Optimistic** (higher returns, longer life)
  3. **Pessimistic** (lower returns, higher expenses)
  4. **Early Retirement** (retire 5 years earlier)
  5. **Late Retirement** (retire 5 years later)
- Show brief 2-3 sentence description for each
- Users select which scenarios to create (besides base)

**Design Decisions**:
- ✅ Base scenario always created (required by system)
- ✅ Templates are sensible variations (±1-2% returns, ±5 years retirement/life)
- ✅ No detailed override configuration in wizard (too complex)
- ✅ Scenarios can be edited/customized later in Scenarios screen
- ✅ All optional except Base (user can select 0-4 additional scenarios)

**Testing**: Select different combinations, test "base only" scenario

### Step 6.2: Scenario Creation Logic
**Tasks**:
- Define override templates for each scenario type in code
- Logic to create Scenario entities with appropriate ParameterOverrides
- Use descriptive names and consistent override patterns

**Design Decisions**:
- ✅ **Optimistic**: +1% all returns, +3 years life expectancy
- ✅ **Pessimistic**: -1% all returns, +10% all expenses
- ✅ **Early Retirement**: -5 years to retirement age (both individuals)
- ✅ **Late Retirement**: +5 years to retirement age (both individuals)
- ✅ Overrides stored as ParameterOverride objects with proper types

**Testing**: Create scenarios, verify overrides correct in Firestore

---

## Phase 7: Summary & Confirmation
**Goal**: Review all wizard data before committing to Firestore

### Step 7.1: Summary Screen
**Tasks**:
- Create `wizard_summary_step.dart`
- Display comprehensive summary in collapsible sections:
  - **Individuals**: Names, ages, retirement ages, life expectancies
  - **Revenue Sources**: Which sources enabled per individual, key values
  - **Assets**: Types, counts, total estimated value
  - **Expenses**: Categories, amounts, total annual, timing
  - **Scenarios**: List of scenarios to be created
- Add "Edit" button for each section to jump back to that step
- Use visual cards with icons

**Design Decisions**:
- ✅ Read-only summary with edit navigation links
- ✅ Clear section headings with expand/collapse
- ✅ Highlight what will be created vs what user should add later
- ✅ Responsive: stacked cards on mobile, 2-column grid on desktop
- ✅ Show totals and key metrics prominently

**Testing**: Review summary accuracy, verify edit navigation, test on all devices

### Step 7.2: Data Commitment & Creation
**Tasks**:
- "Complete Setup" prominent button at bottom
- Show loading indicator with status updates during creation
- Create entities in order:
  1. Update Project with individuals (Individual 1, optionally Individual 2)
  2. Create Assets (Real Estate, RRSP, CELI, CRI, Cash - if any)
  3. Create retirement Events for each individual
  4. Create Expenses (6 categories with entered amounts)
  5. Create Scenarios (Base + selected variations)
- Handle errors gracefully with user-friendly messages
- On success: dismiss wizard, show success SnackBar, navigate to Dashboard
- Clear wizard state after completion

**Design Decisions**:
- ✅ Best effort: try to create all, log errors but don't fail completely
- ✅ Progress indicator: "Creating individuals...", "Creating assets...", etc.
- ✅ Success message: "🎉 Your project is ready! You can refine details anytime."
- ✅ Error handling: Show specific error, offer retry or "Finish Anyway"
- ✅ Wizard state cleared on success or explicit abandon

**Testing**: Complete full wizard, verify all Firestore data, test error scenarios

---

## Phase 8: Polish & Refinement
**Goal**: Enhance UX with visual appeal, animations, and responsive design

### Step 8.1: Visual Enhancements
**Tasks**:
- Add illustrations/icons for each step header
- Add smooth transitions between steps (fade/slide)
- Improve loading states with skeleton screens
- Add congratulations screen/animation on completion

**Design Decisions**:
- ✅ Use Material icons with theme colors for each step
- ✅ Consider confetti animation on completion (package: confetti)
- ✅ Subtle fade transitions between steps (200ms duration)
- ✅ Skeleton loaders during Firestore operations

**Testing**: Visual review across devices, verify animations smooth

### Step 8.2: Responsive Design Validation
**Tasks**:
- Test on: iPhone SE (375px), iPad (768px), Desktop (1920px), macOS
- Verify scrolling on small screens (content doesn't overflow)
- Ensure touch targets meet 48x48 minimum
- Test landscape and portrait orientations

**Design Decisions**:
- ✅ Phone: Full-screen wizard, back/next in bottom app bar
- ✅ Tablet/Desktop: Centered dialog or container (max-width 1200px)
- ✅ Minimum supported height: 600px with scrollable content
- ✅ Progress stepper horizontal on desktop, vertical on mobile

**Testing**: Complete wizard on each target device, verify usability

### Step 8.3: Accessibility & Internationalization
**Tasks**:
- Add semantic labels for screen readers
- Ensure keyboard navigation works (Tab, Enter, Escape)
- Extract all strings to l10n files (English + French)
- Test with screen reader (TalkBack on Android, VoiceOver on iOS)

**Design Decisions**:
- ✅ All text in l10n files: `lib/core/config/i18n/`
- ✅ Tab order follows visual/logical flow
- ✅ Focus indicators clearly visible
- ✅ ARIA labels for icon buttons

**Testing**: Navigate with keyboard only, test with screen reader

---

## Phase 9: Error Handling & Edge Cases
**Goal**: Ensure wizard handles errors and edge cases gracefully

### Step 9.1: Validation & Error Messages
**Tasks**:
- Add validation for all input fields
- Show inline error messages (red text below field)
- Prevent "Next" if current step has validation errors
- Handle network/Firestore errors during data creation

**Design Decisions**:
- ✅ Lenient validation: most fields optional with sensible defaults
- ✅ Only block on critical errors (e.g., Individual 1 name missing)
- ✅ Network errors: show retry button with exponential backoff
- ✅ Validation errors shown in real-time (onChanged) and on submit

**Testing**: Test invalid inputs, offline mode, slow network

### Step 9.2: Cancellation & Data Loss Prevention
**Tasks**:
- Confirm before exiting wizard if user entered data
- "Are you sure?" dialog with clear warning
- Clear wizard state on explicit cancel or successful completion

**Design Decisions**:
- ✅ Warning: "You'll lose your progress. Are you sure?"
- ✅ No draft persistence in v1 (keep scope manageable)
- ✅ Cancel available at any step via "X" button or back navigation

**Testing**: Verify confirmation dialog, test state cleanup

---

## Phase 10: Documentation & Testing
**Goal**: Document wizard and ensure quality

### Step 10.1: Developer Documentation
**Tasks**:
- Update `docs/WIZARD_PLAN.md` with final implementation notes
- Update `CLAUDE.md` with wizard architecture and usage
- Document default values and calculation formulas
- Add code comments for complex logic

**Design Decisions**:
- ✅ Document in both CLAUDE.md and dedicated WIZARD_PLAN.md
- ✅ Include architectural decisions and trade-offs
- ✅ Note wizard as optional, complementary to regular screens

**Testing**: N/A (documentation review)

### Step 10.2: Integration Testing
**Tasks**:
- Write widget tests for each wizard step
- Test full wizard flow end-to-end
- Verify data appears correctly in regular screens after wizard
- Test wizard → manual editing workflow

**Design Decisions**:
- ✅ Focus on integration tests (full flow) over isolated unit tests
- ✅ Verify Firestore data structure matches expectations
- ✅ Test with 1 individual and 2 individuals paths

**Testing**: Run flutter test, verify coverage >80% for wizard code

---

## Progress Tracking

| Phase | Status | Start Date | End Date | Notes |
|-------|--------|------------|----------|-------|
| Phase 1 | ✅ Complete | 2025-10-17 | 2025-10-17 | Foundation & Entry Point (3 steps) |
| Phase 2 | ✅ Complete | 2025-10-17 | 2025-10-17 | Individuals Step - DUAL ENTRY (2 steps) |
| Phase 3 | ⏳ Pending | - | - | Revenue Sources Step (2 steps) |
| Phase 4 | ⏳ Pending | - | - | Assets Step (2 steps) |
| Phase 5 | ⏳ Pending | - | - | Expenses Step (2 steps) |
| Phase 6 | ⏳ Pending | - | - | Scenarios Step (2 steps) |
| Phase 7 | ⏳ Pending | - | - | Summary & Confirmation (2 steps) |
| Phase 8 | ⏳ Pending | - | - | Polish & Refinement (3 steps) |
| Phase 9 | ⏳ Pending | - | - | Error Handling (2 steps) |
| Phase 10 | ⏳ Pending | - | - | Documentation & Testing (2 steps) |

**Status Legend**: ⏳ Pending | 🚧 In Progress | ✅ Complete | ❌ Blocked

---

## Key Design Decisions Summary

1. **Wizard as Optional Flow**: Users can skip wizard entirely or use partially
2. **Dual Individual Entry**: Both individuals (1-2) collected on single screen
3. **Smart Defaults**: Pre-filled values based on Quebec retirement norms
4. **Non-Blocking Steps**: Can proceed without filling everything
5. **Simplified Data Model**: Less detail than full screens (quick setup focus)
6. **Educational**: Tooltips and help text without overwhelming
7. **Responsive First**: All platforms from the start
8. **Atomic Commitment**: All data created at end (no partial saves)
9. **Complementary Tool**: Complements existing screens, doesn't replace

---

## Estimated Timeline
- **Phase 1**: 1-2 days (foundation critical)
- **Phase 2**: 1 day (dual individual entry)
- **Phase 3-6**: 1 day each (4 days for content steps)
- **Phase 7**: 1-2 days (complex data creation)
- **Phase 8-9**: 1-2 days (polish and edge cases)
- **Phase 10**: 1 day (docs and tests)

**Total**: 10-14 days with review pauses between phases

---

## Next Steps
1. ✅ Plan approved and saved to docs/WIZARD_PLAN.md
2. Begin Phase 1 implementation
3. Update progress table after each phase completion
4. Commit after each phase with visible changes
