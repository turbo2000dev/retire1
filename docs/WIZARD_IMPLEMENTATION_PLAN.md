# Quebec Retirement Planning Wizard - Implementation Plan

## Executive Summary

This document outlines the implementation plan for a hybrid wizard/todo-list interface for Quebec retirement planning. The wizard serves inexperienced users who need guidance while allowing them to stop, resume, skip sections, and jump freely between steps.

---

## 1. User Experience Goals & Key Requirements

### Primary Goals
- ✅ Serve inexperienced users who need guidance
- ✅ Allow users to stop/resume the lengthy process multiple times
- ✅ Enable skipping sections to return to later
- ✅ Mix educational content with data collection
- ✅ Provide a persistent todo-list view with wizard-style guidance

### Critical Constraints
- Must support French/English from the start
- Must work on desktop and mobile (responsive)
- Data persistence is critical (users will stop/resume)
- Must reuse existing data layer (repositories)
- Production-ready architecture

---

## 2. Proposed Wizard Flow (User Standpoint)

### Section Structure

```
📋 WIZARD SECTIONS (12 total)

🎯 GETTING STARTED (2 sections)
├─ 1. Welcome & Overview (Educational - Optional)
│   └─ Explains the planning process, what to expect, why each step matters
└─ 2. Project Basics (Required)
    └─ Project name, description, start year, projection length

👥 INDIVIDUALS (2 sections)
├─ 3. Primary Individual (Required)
│   └─ Name, birthdate, gender (for life expectancy)
└─ 4. Partner/Spouse (Optional)
    └─ Add second individual if planning for couple

💰 CURRENT FINANCIAL SITUATION (3 sections)
├─ 5. Assets Inventory (Optional but Important)
│   ├─ Real estate (primary residence, rental properties)
│   ├─ Registered accounts (RRSP, CELI, CRI/FRV)
│   └─ Cash and other savings
├─ 6. Current Employment & Income (Optional)
│   ├─ Employment income for each individual
│   └─ RRPE participation details
└─ 7. Understanding Quebec Retirement Benefits (Educational - Optional)
    └─ Explains RRQ (Quebec Pension Plan) and PSV (Old Age Security)

📊 RETIREMENT INCOME PLANNING (2 sections)
├─ 8. Government Benefits Setup (Required)
│   ├─ RRQ start age and estimated amounts (per individual)
│   └─ PSV start age
└─ 9. Living Expenses (Required)
    ├─ Housing, transport, daily living, recreation, health, family
    └─ When expenses start (now, at retirement, custom)

🎯 KEY EVENTS (2 sections)
├─ 10. Retirement Timing (Required)
│   └─ When does each individual plan to retire?
└─ 11. Major Life Events (Optional)
    ├─ Real estate transactions (selling home, downsizing)
    ├─ Large purchases
    └─ Estate planning considerations

📈 SCENARIOS & REVIEW (1 section)
└─ 12. Summary & Next Steps (Required)
    ├─ Review all entered data
    ├─ Choose scenario templates (optimistic, pessimistic, etc.)
    └─ Complete wizard and view projections
```

### Section Status System

Each section can have one of these statuses:

| Icon | Status | Description |
|------|--------|-------------|
| ⏹️ | Not Started | User hasn't entered this section yet |
| 🔄 | In Progress | User started but didn't complete |
| ⏸️ | Skipped | User explicitly skipped for now |
| ✅ | Complete | All required data entered |
| 📚 | Educational | Optional learning content (no data entry) |
| ⚠️ | Needs Attention | Validation warning or missing required data |

### Navigation Philosophy

**Guided Flow (Default)**:
- "Next" button guides through logical sequence
- Skips educational sections automatically (can be accessed from todo list)
- Validates required data before allowing "Complete"

**Free Navigation (Advanced)**:
- Left panel shows all sections with status
- Click any section to jump directly
- Can revisit completed sections to edit
- Can skip ahead even if previous sections incomplete

---

## 3. Technical Architecture

### 3.1 Feature Module Organization

```
lib/features/wizard/
├─ domain/
│   ├─ wizard_section.dart              # Section definition (id, title, status, etc.)
│   ├─ wizard_progress.dart             # User's progress through wizard
│   └─ wizard_section_status.dart       # Status enum and helpers
├─ data/
│   └─ wizard_progress_repository.dart  # Firestore persistence
├─ service/
│   └─ wizard_completion_service.dart   # Orchestrates final setup
└─ presentation/
    ├─ providers/
    │   ├─ wizard_progress_provider.dart     # Progress state management
    │   ├─ wizard_navigation_provider.dart   # Current section tracking
    │   └─ wizard_sections_config.dart       # Section definitions
    ├─ screens/
    │   └─ wizard_screen.dart                # Main wizard container
    ├─ widgets/
    │   ├─ wizard_layout/
    │   │   ├─ wizard_desktop_layout.dart    # Dual-panel for desktop
    │   │   ├─ wizard_mobile_layout.dart     # Bottom sheet for mobile
    │   │   └─ wizard_section_list.dart      # Todo list component
    │   ├─ wizard_navigation/
    │   │   ├─ wizard_nav_buttons.dart       # Next/Previous/Skip buttons
    │   │   └─ wizard_progress_bar.dart      # Progress indicator
    │   └─ section_cards/
    │       └─ wizard_section_card.dart      # Individual section in list
    └─ sections/
        ├─ welcome_section.dart              # Section 1
        ├─ project_basics_section.dart       # Section 2
        ├─ primary_individual_section.dart   # Section 3
        ├─ partner_section.dart              # Section 4
        ├─ assets_section.dart               # Section 5
        ├─ employment_section.dart           # Section 6
        ├─ benefits_education_section.dart   # Section 7
        ├─ government_benefits_section.dart  # Section 8
        ├─ expenses_section.dart             # Section 9
        ├─ retirement_timing_section.dart    # Section 10
        ├─ life_events_section.dart          # Section 11
        └─ summary_section.dart              # Section 12
```

### 3.2 Domain Models

#### WizardSection
```dart
@freezed
class WizardSection with _$WizardSection {
  const factory WizardSection({
    required String id,                    // Unique identifier (e.g., 'primary-individual')
    required String titleKey,              // i18n key for section title
    required String descriptionKey,        // i18n key for description
    required WizardSectionCategory category, // Getting Started, Individuals, etc.
    required bool isRequired,              // Must complete before finishing wizard
    required bool isEducational,           // Is this educational content?
    @Default(0) int orderIndex,           // Display order
    String? dependsOnSectionId,           // Optional dependency (e.g., partner depends on having 2 individuals)
  }) = _WizardSection;
}

enum WizardSectionCategory {
  gettingStarted,
  individuals,
  financialSituation,
  retirementIncome,
  keyEvents,
  scenariosReview,
}
```

#### WizardProgress
```dart
@freezed
class WizardProgress with _$WizardProgress {
  const factory WizardProgress({
    required String projectId,
    required String userId,
    @Default('welcome') String currentSectionId,
    @Default({}) Map<String, WizardSectionStatus> sectionStatuses,
    required DateTime lastUpdated,
    required DateTime createdAt,
    bool? wizardCompleted,
    DateTime? completedAt,
  }) = _WizardProgress;

  factory WizardProgress.fromJson(Map<String, dynamic> json) =>
    _$WizardProgressFromJson(json);
}
```

#### WizardSectionStatus
```dart
@freezed
class WizardSectionStatus with _$WizardSectionStatus {
  const factory WizardSectionStatus({
    required WizardSectionState state,
    DateTime? lastVisited,
    DateTime? completedAt,
    @Default([]) List<String> validationWarnings,
  }) = _WizardSectionStatus;

  factory WizardSectionStatus.fromJson(Map<String, dynamic> json) =>
    _$WizardSectionStatusFromJson(json);
}

enum WizardSectionState {
  notStarted,   // ⏹️
  inProgress,   // 🔄
  skipped,      // ⏸️
  complete,     // ✅
  needsAttention, // ⚠️
}
```

### 3.3 Data Persistence Strategy

#### Firestore Structure
```
users/{userId}/
  wizardProgress/{projectId}  # One document per project
    - currentSectionId: string
    - sectionStatuses: map<sectionId, status>
    - lastUpdated: timestamp
    - createdAt: timestamp
    - wizardCompleted: boolean
    - completedAt: timestamp?
```

#### Data Flow Strategy: **Immediate Persistence**

✅ **Recommended Approach**: Save data immediately to existing repositories

**Why This Works**:
1. **Aligns with Requirements**: "Users can stop/resume the lengthy process"
2. **Reuses Data Layer**: Leverages existing tested repositories
3. **Real-Time Updates**: Changes visible immediately across app
4. **No Data Loss**: Everything persisted immediately
5. **Simpler Architecture**: No complex draft state management

**How Sections Work**:
- Each section uses existing repositories (AssetRepository, EventRepository, etc.)
- Section calls repository methods directly (e.g., `createAsset()`)
- Wizard progress tracks section completion status
- User can exit anytime - data already saved

**Example Flow**:
```dart
// In assets_section.dart
onSaveAsset() async {
  final repository = ref.read(assetRepositoryProvider);

  // 1. Save asset using existing repository
  await repository.createAsset(newAsset);

  // 2. Update wizard progress
  await ref.read(wizardProgressProvider.notifier)
    .markSectionProgress('assets', WizardSectionState.inProgress);

  // Done! No draft state needed.
}
```

### 3.4 Section Dependencies & Validation

#### Dependency Chain
```
Project Basics (2) [Required First]
  ↓
Primary Individual (3) [Required]
  ↓
  ├─ Partner (4) [Optional]
  ├─ Government Benefits (8) [Requires at least one individual]
  └─ Retirement Timing (10) [Requires at least one individual]
       ↓
       └─ Expenses (9) [Can reference retirement timing]
```

#### Validation Rules

**Before Completing Wizard**:
- ✅ Project basics filled
- ✅ At least one individual defined
- ✅ Government benefits configured for each individual
- ✅ At least one expense category filled
- ✅ Retirement timing set for each individual

**Soft Warnings (Don't Block Completion)**:
- ⚠️ No assets entered
- ⚠️ No employment income
- ⚠️ Educational sections not viewed

---

## 4. UI/UX Design

### 4.1 Dual-Panel Desktop Layout

```
┌─────────────────────────────────────────────────────────────┐
│ Retirement Planning Setup                         [X] Close │
├────────────────┬────────────────────────────────────────────┤
│                │                                            │
│ 🎯 GETTING     │  📝 Section 3: Primary Individual         │
│    STARTED     │                                            │
│ ✅ 1. Welcome  │  Tell us about yourself to personalize    │
│ ✅ 2. Basics   │  your retirement plan.                     │
│                │                                            │
│ 👥 INDIVIDUALS │  ┌────────────────────────────────────┐   │
│ 🔄 3. Primary  │  │ Full Name *                        │   │
│ ⏹️ 4. Partner  │  │ [Jean Tremblay            ]       │   │
│                │  │                                    │   │
│ 💰 FINANCIAL   │  │ Date of Birth *                   │   │
│ ⏸️ 5. Assets   │  │ [Jan 15, 1965             ] 📅   │   │
│ ⏹️ 6. Employment│  │                                    │   │
│ 📚 7. Benefits  │  │ Gender (for life expectancy)      │   │
│                │  │ ○ Male  ● Female  ○ Other         │   │
│ 📊 RETIREMENT  │  └────────────────────────────────────┘   │
│ ⏹️ 8. Govt Bene│                                            │
│ ⏹️ 9. Expenses │  ℹ️ This information helps us estimate    │
│                │     life expectancy and government         │
│ 🎯 KEY EVENTS  │     benefits eligibility.                  │
│ ⏹️ 10. Retirem │                                            │
│ ⏹️ 11. Events  │                                            │
│                │                                            │
│ 📈 REVIEW      │                                            │
│ ⏹️ 12. Summary │  [Skip for Now]  [← Previous]  [Save →]  │
│                │                                            │
│ Progress: 25%  │                                            │
│ 3 of 12 done   │                                            │
└────────────────┴────────────────────────────────────────────┘
        280px                    Remaining space
```

**Key Features**:
- Left panel: 280px fixed width, scrollable section list
- Right panel: Flexible width, contains current section content
- Section list shows icons, status, and click to jump
- Progress indicator at bottom of section list
- Persistent across all sections

### 4.2 Mobile Layout

```
┌─────────────────────────────────┐
│ Retirement Setup      ≡  [X]    │
├─────────────────────────────────┤
│                                 │
│  📝 Primary Individual          │
│                                 │
│  Tell us about yourself to      │
│  personalize your retirement    │
│  plan.                          │
│                                 │
│  ┌───────────────────────────┐ │
│  │ Full Name *               │ │
│  │ [Jean Tremblay      ]    │ │
│  │                           │ │
│  │ Date of Birth *           │ │
│  │ [Jan 15, 1965       ] 📅 │ │
│  │                           │ │
│  │ Gender                    │ │
│  │ ○ Male ● Female ○ Other  │ │
│  └───────────────────────────┘ │
│                                 │
│  ℹ️ This helps estimate life    │
│     expectancy and benefits.    │
│                                 │
│                                 │
│ [Skip]  [← Back]  [Save →]     │
│                                 │
│ ═══════════════════════════     │
│ Section 3 of 12 │ Progress: 25% │
│ [Tap to see all sections]      │
└─────────────────────────────────┘
         Swipe up ↑
┌─────────────────────────────────┐
│ ═ All Sections                  │
│                                 │
│ 🎯 GETTING STARTED              │
│ ✅ 1. Welcome                   │
│ ✅ 2. Project Basics            │
│                                 │
│ 👥 INDIVIDUALS                  │
│ 🔄 3. Primary Individual   ←    │
│ ⏹️ 4. Partner/Spouse            │
│                                 │
│ 💰 CURRENT FINANCES             │
│ ⏸️ 5. Assets Inventory          │
│ ⏹️ 6. Employment & Income       │
│ ...                             │
└─────────────────────────────────┘
```

**Key Features**:
- Full-screen section content
- Bottom sheet for section navigation (swipe up or tap)
- Progress bar at bottom
- Collapsible section list

### 4.3 Section Card Design

```
┌─────────────────────────────────────────┐
│ ✅  2. Project Basics            →      │
│     Set up your project details         │
│     Completed 2 hours ago               │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ 🔄  5. Assets Inventory          →      │
│     Add your current assets             │
│     ⚠️ 2 items need review              │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ ⏸️  11. Major Life Events        →      │
│     Add important future events         │
│     Skipped - Return later              │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ 📚  7. Understanding Benefits    →      │
│     Learn about RRQ and PSV             │
│     Optional educational content        │
└─────────────────────────────────────────┘
```

---

## 5. Development Phases

### Phase 1: Foundation (Days 1-2)
**Goal**: Set up core wizard infrastructure

**Tasks**:
1. Create domain models (WizardSection, WizardProgress, WizardSectionStatus)
2. Implement WizardProgressRepository with Firestore persistence
3. Create wizard providers (progress, navigation)
4. Define section configuration (all 12 sections with metadata)
5. Run build_runner for Freezed code generation

**Testing**:
- Unit tests for domain models
- Repository tests with fake Firestore
- Provider tests for state management

**Deliverable**: Core wizard data layer working

---

### Phase 2: Layout & Navigation (Days 3-4)
**Goal**: Build responsive layouts and navigation

**Tasks**:
1. Create WizardScreen (main container)
2. Implement WizardDesktopLayout (dual-panel)
3. Implement WizardMobileLayout (bottom sheet)
4. Build WizardSectionList (todo list component)
5. Create WizardSectionCard (individual section in list)
6. Implement WizardNavButtons (Next/Previous/Skip)
7. Add WizardProgressBar

**Testing**:
- Widget tests for layout components
- Responsive tests (phone/tablet/desktop)
- Navigation flow tests

**Deliverable**: Empty wizard shell with working navigation

---

### Phase 3: Core Sections Implementation (Days 5-9)
**Goal**: Implement required data collection sections

**Priority Order**:
1. **Day 5**: Section 2 (Project Basics) + Section 3 (Primary Individual)
2. **Day 6**: Section 4 (Partner) + Section 8 (Government Benefits)
3. **Day 7**: Section 9 (Expenses) + Section 10 (Retirement Timing)
4. **Day 8**: Section 5 (Assets Inventory)
5. **Day 9**: Section 12 (Summary & Completion)

**Each Section Includes**:
- Section widget with form fields
- Validation logic
- Integration with existing repositories
- Progress tracking
- i18n strings (French + English)

**Testing**:
- Widget tests for each section
- Integration tests with repositories
- Validation tests
- i18n string completeness

**Deliverable**: All required sections working end-to-end

---

### Phase 4: Optional Sections (Days 10-11)
**Goal**: Implement optional and educational sections

**Tasks**:
1. Section 1 (Welcome & Overview) - Educational
2. Section 6 (Employment & Income) - Optional data
3. Section 7 (Benefits Education) - Educational
4. Section 11 (Major Life Events) - Optional data

**Testing**:
- Widget tests
- Skip functionality tests
- Educational content rendering

**Deliverable**: Complete wizard with all 12 sections

---

### Phase 5: Completion & Polish (Days 12-13)
**Goal**: Finalize wizard and handle edge cases

**Tasks**:
1. Implement WizardCompletionService (orchestrates final setup)
2. Add scenario template creation
3. Handle wizard resume/restore
4. Add comprehensive validation
5. Polish animations and transitions
6. Add loading states and error handling
7. Test stop/resume flow thoroughly

**Testing**:
- End-to-end wizard completion tests
- Stop/resume tests
- Error handling tests
- Cross-browser testing

**Deliverable**: Production-ready wizard

---

### Phase 6: Documentation & Entry Points (Day 14)
**Goal**: Integrate wizard into app

**Tasks**:
1. Add wizard route to router
2. Add "Start Wizard" button to relevant screens
3. Handle wizard state (in progress vs. complete)
4. Add re-run wizard capability
5. Write user documentation
6. Write developer documentation

**Testing**:
- Integration tests with app navigation
- User acceptance testing

**Deliverable**: Fully integrated wizard

---

## 6. Key Architectural Decisions

### Decision 1: Immediate Persistence vs. Draft Mode
**Choice**: ✅ Immediate Persistence
**Rationale**:
- Requirements explicitly state "stop/resume" capability
- Reuses tested data layer without duplication
- Simpler architecture
- No risk of data loss

### Decision 2: Section Independence
**Choice**: ✅ Sections work with existing repositories independently
**Rationale**:
- Assets section uses AssetRepository directly
- No wizard-specific data models
- Easy to test sections in isolation
- Data immediately visible in main app

### Decision 3: Progress Tracking Scope
**Choice**: ✅ Per-project progress tracking
**Rationale**:
- Users may have multiple projects
- Each project can have different wizard state
- Can re-run wizard for existing projects
- Progress survives project deletion (for analytics)

### Decision 4: Validation Strategy
**Choice**: ✅ Soft validation with clear warnings
**Rationale**:
- Don't block users unnecessarily
- Clearly show what's required vs. recommended
- Allow skipping optional sections
- Validate before final completion

### Decision 5: Educational Content Approach
**Choice**: ✅ Separate educational sections (optional)
**Rationale**:
- Doesn't interrupt data collection flow
- Advanced users can skip
- Available for reference anytime
- Doesn't affect progress calculation

---

## 7. Internationalization (i18n) Strategy

### String Organization
```
AppLocalizations (both En and Fr):
  // Wizard general
  - wizardTitle
  - wizardSubtitle
  - wizardProgress
  - wizardCompleteButton
  - wizardSkipButton
  - wizardNextButton
  - wizardPreviousButton

  // Section titles (12)
  - section1Title / section1Description
  - section2Title / section2Description
  ... (etc)

  // Status labels
  - statusNotStarted
  - statusInProgress
  - statusSkipped
  - statusComplete
  - statusNeedsAttention

  // Validation messages
  - validationRequired
  - validationInvalidFormat
  ...
```

### Testing i18n
- Every section tested in both languages
- String completeness check in tests
- Manual review of French translations

---

## 8. Testing Strategy

### Unit Tests
- Domain model creation/serialization
- Repository CRUD operations
- Status calculations
- Validation logic

### Widget Tests
- Each section renders correctly
- Forms submit properly
- Navigation works
- Status updates correctly

### Integration Tests
- Complete wizard flow (start to finish)
- Stop and resume
- Skip and return
- Section jumping
- Data persistence

### Manual Testing Checklist
- [ ] Desktop layout (Chrome, Safari, Firefox)
- [ ] Tablet layout (iPad portrait/landscape)
- [ ] Mobile layout (iPhone SE, iPhone 14 Pro)
- [ ] French language completeness
- [ ] Stop/resume multiple times
- [ ] Skip various sections
- [ ] Complete with minimal data
- [ ] Complete with full data
- [ ] Re-run wizard on existing project

---

## 9. Success Criteria

### Functionality
- ✅ Users can complete wizard and create working retirement plan
- ✅ Users can stop and resume without data loss
- ✅ Users can skip sections and return later
- ✅ Users can jump between any sections
- ✅ All required data validated before completion
- ✅ Works on desktop and mobile

### Quality
- ✅ Zero data loss scenarios
- ✅ 90%+ test coverage on wizard code
- ✅ All strings translated (En + Fr)
- ✅ Responsive on all target devices
- ✅ No console errors or warnings

### User Experience
- ✅ Clear visual feedback on progress
- ✅ Educational content available but not intrusive
- ✅ Minimal clicks to complete (efficient flow)
- ✅ Forgiving (allows skipping, easy to correct mistakes)

---

## 10. Risks & Mitigation

### Risk 1: Incomplete Data in Main App
**Issue**: User skips sections, sees incomplete projections
**Mitigation**:
- Clear warnings when skipped sections affect projections
- "Return to Wizard" button if critical data missing
- Soft blocks on projection view if minimum data not met

### Risk 2: Complex State Management
**Issue**: Tracking progress across 12 sections gets complex
**Mitigation**:
- Simple state model (just section statuses)
- Leverage Riverpod for reactive updates
- Comprehensive unit tests
- Clear documentation

### Risk 3: Translation Quality
**Issue**: Poor French translations frustrate Quebec users
**Mitigation**:
- Professional translation review
- Native French speaker testing
- Financial terminology validation

### Risk 4: Performance on Mobile
**Issue**: Complex forms slow on older devices
**Mitigation**:
- Lazy load sections
- Optimize form validation
- Test on older devices
- Monitor performance metrics

---

## 11. Future Enhancements (Post-MVP)

### Enhanced Features
- Wizard templates (common scenarios)
- Smart suggestions based on demographics
- Integration with financial institution data
- AI-powered expense estimation
- Video tutorials for educational sections
- Guided tours for first-time users

### Analytics & Insights
- Track wizard completion rates
- Identify where users get stuck
- A/B test different section orders
- Measure time-to-completion

---

## Appendix A: Section Details

### Section 1: Welcome & Overview (Educational)
**Goal**: Orient users to the planning process
**Content**:
- What is retirement planning?
- Why early planning matters
- What information you'll need
- How long this takes (15-30 minutes)
- Can stop and resume anytime

**Status**: Always marked as "Educational" (not counted in required progress)

---

### Section 2: Project Basics (Required)
**Goal**: Initialize project with basic parameters
**Data Collected**:
- Project name (e.g., "Jean & Marie's Retirement Plan")
- Description (optional)
- Projection start year (default: current year)
- Projection length in years (default: 40 years)
- Stored in: Project (existing model)

**Validation**:
- ✅ Project name required (min 3 characters)
- ✅ Start year must be valid (1900-2100)
- ✅ Projection length must be 1-100 years

---

### Section 3: Primary Individual (Required)
**Goal**: Collect primary person's demographic info
**Data Collected**:
- Full name
- Date of birth
- Gender (for life expectancy calculations)
- Stored in: Individual (existing model)

**Validation**:
- ✅ Name required (min 2 characters)
- ✅ Birthdate required (age must be 18-100)
- ⚠️ Warning if approaching retirement age without plans

---

### Section 4: Partner/Spouse (Optional)
**Goal**: Add second individual if planning for couple
**Data Collected**:
- Same as Section 3 (name, birthdate, gender)
- Stored in: Individual (existing model)

**Special Handling**:
- Can be skipped (planning for single person)
- If added, enables couple-specific features
- Can be removed (with confirmation)

---

### Section 5: Assets Inventory (Optional but Important)
**Goal**: Collect current assets
**Data Collected**:
- Real estate (primary residence, rental properties)
- RRSP accounts (per individual)
- CELI accounts (per individual)
- CRI/FRV accounts (locked-in)
- Cash and savings
- Stored in: Asset (existing models - RealEstate, RRSP, CELI, CRI, Cash)

**UI Approach**:
- Grid of asset type cards
- Click card to add asset of that type
- Show running total
- "Add Another" for multiple assets of same type

**Validation**:
- ⚠️ Warning if no assets (can projection still be meaningful?)
- Values must be positive

---

### Section 6: Current Employment & Income (Optional)
**Goal**: Capture current employment situation
**Data Collected**:
- Employment income (per individual)
- RRPE participation (per individual)
- RRPE start date
- Stored in: Individual (employmentIncome, hasRrpe, rrpeParticipationStartDate)

**Special Handling**:
- Can skip if both individuals are already retired
- RRPE affects RRQ calculations

---

### Section 7: Understanding Quebec Retirement Benefits (Educational)
**Goal**: Explain RRQ and PSV for informed decisions
**Content**:
- What is RRQ (Régie des rentes du Québec)?
- How RRQ amounts are calculated
- When to start RRQ (60, 65, or 70)
- What is PSV (Pension de la Sécurité de la vieillesse)?
- PSV eligibility and amounts
- Tax implications

**Format**:
- Accordion sections
- Visual diagrams
- Examples with numbers
- Links to official resources

---

### Section 8: Government Benefits Setup (Required)
**Goal**: Configure RRQ and PSV for each individual
**Data Collected** (per individual):
- RRQ start age (60-70, default 65)
- Estimated RRQ amount at age 60
- Estimated RRQ amount at age 65
- PSV start age (65-70, default 65)
- Stored in: Individual (rrqStartAge, psvStartAge)

**Helpers**:
- Calculator/estimator based on employment income
- Links to official RRQ calculator
- Visual timeline showing benefit start dates

**Validation**:
- ✅ RRQ start age required for each individual
- ✅ PSV start age required for each individual
- ⚠️ Warning if starting benefits very early/late

---

### Section 9: Living Expenses (Required)
**Goal**: Estimate annual living expenses
**Data Collected**:
- Housing (mortgage/rent, utilities, maintenance, insurance)
- Transport (vehicle, public transit, gas, maintenance)
- Daily Living (food, clothing, personal care)
- Recreation (entertainment, hobbies, travel)
- Health (insurance, medications, dental, vision)
- Family (gifts, support for family members)
- Expense start timing (now, at retirement, custom year)
- Stored in: Expense (existing model - one per category)

**UI Approach**:
- Card per category with amount input
- Show total monthly and annual
- Slider or quick presets (minimal, comfortable, generous)
- Tips for estimation

**Validation**:
- ✅ At least one expense category must have a value > 0
- ⚠️ Warning if total seems very low/high compared to typical
- ⚠️ Timing must be valid

---

### Section 10: Retirement Timing (Required)
**Goal**: When does each individual plan to retire?
**Data Collected** (per individual):
- Retirement age or specific year
- Stored in: Event (retirement event with EventTiming.age)

**Validation**:
- ✅ Retirement age required for each individual
- ⚠️ Warning if retiring very early (< 55)
- ⚠️ Warning if working past PSV age

---

### Section 11: Major Life Events (Optional)
**Goal**: Capture significant future events
**Data Collected**:
- Real estate transactions (sell home, downsize, purchase rental)
- Large purchases (vehicle, vacation home)
- Estate considerations (gifts to children)
- Stored in: Event (existing models - RealEstateTransaction)

**UI Approach**:
- Timeline visualization
- Add event cards
- Each event has timing and financial impact

**Can Skip**: Many people won't have major events planned

---

### Section 12: Summary & Next Steps (Required)
**Goal**: Review data and complete wizard
**Content**:
- Summary cards for each section
- Edit buttons to jump back to sections
- Validation warnings (if any)
- Scenario template selection:
  - Base Scenario (always created)
  - Optimistic (+20% better returns)
  - Pessimistic (-20% lower returns)
  - Early Retirement (-5 years)
  - Late Retirement (+5 years)

**Actions**:
- "Complete Setup" button (primary)
- Creates base scenario
- Marks wizard as complete
- Navigates to Dashboard to view projections

**Validation Before Completion**:
- ✅ Project basics filled
- ✅ At least one individual
- ✅ Government benefits configured
- ✅ At least one expense
- ✅ Retirement timing set

---

## Appendix B: Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Wizard progress documents
    match /users/{userId}/wizardProgress/{projectId} {
      // Users can only access their own wizard progress
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Existing rules for projects, assets, events, etc. remain unchanged
  }
}
```

---

## Appendix C: Performance Considerations

### Optimization Strategies
1. **Lazy Loading**: Load section content only when navigated to
2. **Debounced Saves**: Batch rapid changes (e.g., typing) before saving
3. **Optimistic UI**: Update UI immediately, sync to Firestore in background
4. **Caching**: Cache section configuration to avoid recalculation
5. **Image Optimization**: Use appropriate sizes for icons/illustrations

### Monitoring
- Track wizard completion time
- Monitor Firestore read/write counts
- Measure section load times
- Watch for memory leaks on mobile

---

## Plan Review Decisions (2025-10-18)

1. **Section Order**: ✅ Approved for now - expect to restructure during implementation based on user testing

2. **Required vs. Optional**: ✅ Approved - Project Basics, Primary Individual, Government Benefits, Expenses, Retirement Timing, and Summary are required

3. **Educational Content**: ✅ Approved to start with Section 7 - plan to add more educational content throughout in future iterations

4. **Scenario Templates**: ✅ Approved - Base, Optimistic, Pessimistic, Early Retirement, Late Retirement templates sound good

5. **Validation Approach**: ✅ Approved - soft validation (warnings but not blocking) is appropriate

6. **Mobile Experience**: ✅ Approved - same functionality on mobile, use responsive design

7. **Re-run Wizard**: ✅ Approved - users should be able to re-run wizard on existing projects

8. **Time Estimates**: ✅ Approved - 14 days across 6 phases is realistic

9. **Visual Design**: 🎨 Add graphics/pictures on some screens to make the wizard more friendly and welcoming

---

## Next Steps

**Upon Plan Approval**:
1. Review and incorporate feedback
2. Finalize section definitions
3. Create initial i18n string list
4. Begin Phase 1 implementation
5. Set up daily progress tracking

**During Implementation**:
- Daily standups on progress
- Demo each phase upon completion
- Adjust timeline based on actual velocity
- Document learnings and architecture decisions

---

*This plan is a living document and will be updated as implementation progresses.*
