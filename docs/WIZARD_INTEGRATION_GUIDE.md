# Wizard Integration Guide

**Quick Reference for Implementing the Retirement Planning Wizard**

---

## TL;DR - Good News! 🎉

**The data layer is wizard-ready with ZERO modifications needed.**

Your existing repositories can be used **exactly as-is** from the wizard. This means:
- ✅ No code duplication
- ✅ Guaranteed consistency between wizard and direct UI
- ✅ ~70% of existing codebase can be reused
- ✅ Estimated 2-3 days for wizard infrastructure, then normal UI development

---

## Existing Components You Can Reuse

### Repositories (100% Reusable)

All these work out-of-the-box from wizard:

```dart
// ProjectRepository
projectRepository.createProject(name: 'My Retirement Plan')
projectRepository.updateProjectData(project)
projectRepository.getProjectStream(projectId)

// AssetRepository
assetRepository.createAsset(Asset.rrsp(...))
assetRepository.updateAsset(asset)
assetRepository.getAssetsStream()

// EventRepository
eventRepository.createEvent(Event.retirement(...))
eventRepository.updateEvent(event)
eventRepository.getEventsStream()

// ExpenseRepository
expenseRepository.createExpense(Expense.housing(...))
expenseRepository.updateExpense(expense)
expenseRepository.getExpensesStream()

// ScenarioRepository
scenarioRepository.createScenario(scenario)
scenarioRepository.updateScenario(scenario)
scenarioRepository.getScenariosStream()
```

**How to use in wizard**:
```dart
class WizardStep extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get repository (same as direct UI)
    final repository = ref.watch(assetRepositoryProvider);

    return WizardStepWidget(
      onSave: () async {
        // Use repository directly
        await repository.createAsset(newAsset);

        // Update wizard progress
        wizardProgress.markStepComplete('assets');
        wizardNav.nextStep();
      },
    );
  }
}
```

### Domain Models (100% Reusable)

All Freezed models work in wizard:
- `Project` - Create with required fields, optionally add individuals
- `Individual` - Person with birthdate, employment info
- `Asset` - Union type: RealEstate, RRSP, CELI, CRI, Cash
- `Event` - Union type: Retirement, Death, RealEstateTransaction
- `EventTiming` - Union type: Relative, Absolute, Age, EventRelative, ProjectionEnd
- `Expense` - Union type: Housing, Transport, DailyLiving, Recreation, Health, Family
- `Scenario` - Base scenario + parameter overrides

### Responsive Widgets (Partial Reuse)

Can use in wizard UI:
- `ResponsiveContainer` - Max-width content constraint
- `ResponsiveCard` - Consistent card styling
- `ResponsiveTextField` - Form inputs with validation
- `ResponsiveButton` - Consistent button styling
- `ResponsiveDialog` - Modal dialogs
- `ResponsiveBuilder` - Phone/tablet/desktop layouts
- `ScreenSize` - Device type detection

---

## New Components You Need to Build

### 1. WizardProgressRepository

Tracks which steps user has completed:

```dart
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

**Firestore Location**: `users/{userId}/wizardProgress/{projectId}`

**Estimated Effort**: 1 day

### 2. WizardProgress Domain Model

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

**Estimated Effort**: 2 hours (includes code generation)

### 3. WizardNotifier Provider

Manages wizard navigation and current state:

```dart
@freezed
class WizardState with _$WizardState {
  const factory WizardState({
    required String currentStepId,
    required List<String> completedSteps,
    required List<String> skippedSteps,
    Map<String, dynamic>? draftData,
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
    // Navigate to next step based on wizard flow
  }

  void previousStep() {
    // Navigate to previous step
  }

  void jumpToStep(String stepId) {
    // Allow direct navigation (for todo list)
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

**Estimated Effort**: 1 day

### 4. WizardService (Optional)

If you need to orchestrate multiple repository calls:

```dart
class WizardService {
  final ProjectRepository _projectRepository;
  final AssetRepository _assetRepository;
  final EventRepository _eventRepository;

  Future<void> completeInitialSetup({
    required Project project,
    required List<Asset> assets,
    required List<Event> events,
  }) async {
    // Create project
    await _projectRepository.createProject(
      name: project.name,
      description: project.description,
    );

    // Create assets
    for (final asset in assets) {
      await _assetRepository.createAsset(asset);
    }

    // Create events
    for (final event in events) {
      await _eventRepository.createEvent(event);
    }
  }
}
```

**Estimated Effort**: 1 day

---

## Data Persistence Strategy

### Recommendation: Immediate Persistence

**Each wizard step saves to Firestore immediately** when user clicks "Next" or "Save".

**Why?**
1. ✅ Wizard requirement: "Users can stop/resume the lengthy process"
2. ✅ No risk of data loss if user closes app
3. ✅ Simpler implementation (use existing repositories as-is)
4. ✅ Real-time updates visible across app
5. ✅ No complex state management needed

**How?**
```dart
onNext: () async {
  // Save to Firestore immediately
  await assetRepository.createAsset(newAsset);

  // Update wizard progress
  await wizardProgressRepo.markStepComplete(projectId, 'add-assets');

  // Navigate to next step
  wizardNav.nextStep();
}
```

**What about incomplete data?**
- Option 1: Mark project as "in wizard" with a flag
- Option 2: Don't show incomplete projects in direct UI
- Option 3: Allow incomplete data (user can complete later in direct UI)

**Recommendation**: Option 1 or 3 depending on business requirements.

---

## Wizard Step Template

Use this pattern for each wizard step:

```dart
class WizardAssetStep extends ConsumerWidget {
  const WizardAssetStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Get repositories (same as direct UI)
    final assetRepository = ref.watch(assetRepositoryProvider);
    if (assetRepository == null) {
      return const Center(child: Text('Please select a project first'));
    }

    // 2. Get wizard state
    final wizardState = ref.watch(wizardNotifierProvider);

    // 3. Watch existing data (for edit mode)
    final assetsAsync = ref.watch(assetsProvider);

    return assetsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error: error),
      data: (assets) => WizardStepScaffold(
        title: 'Add Your Assets',
        subtitle: 'Tell us about your savings and investments',
        currentStep: wizardState.currentStepId,
        totalSteps: 10,
        onNext: () async {
          try {
            // 4. Create domain model
            final newAsset = Asset.rrsp(
              id: const Uuid().v4(),
              individualId: primaryIndividualId,
              value: _valueController.value,
              customReturnRate: _returnRateController.value,
            );

            // 5. Save using repository (same as direct UI)
            await assetRepository.createAsset(newAsset);

            // 6. Update wizard progress
            ref.read(wizardNotifierProvider.notifier).markCurrentStepComplete();

          } catch (e) {
            // 7. Show error (same as direct UI)
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
        onSkip: () {
          ref.read(wizardNotifierProvider.notifier).skipCurrentStep();
        },
        onBack: () {
          ref.read(wizardNotifierProvider.notifier).previousStep();
        },
        child: Column(
          children: [
            // Your wizard step content here
            // Can use responsive widgets, forms, etc.
          ],
        ),
      ),
    );
  }
}
```

---

## Wizard UI Structure

### Recommended Layout

```
WizardScreen (Shell)
├─ Desktop/Tablet: Row
│  ├─ Left Panel (30%): WizardTodoList
│  │  ├─ Step 1: Welcome ✅
│  │  ├─ Step 2: Create Project ✅
│  │  ├─ Step 3: Add Individuals 🔄
│  │  ├─ Step 4: Add Assets ⏹️
│  │  └─ ...
│  └─ Right Panel (70%): Current WizardStep
│     └─ Step content + Next/Back/Skip buttons
│
└─ Mobile: Column
   ├─ Top: Progress indicator
   ├─ Middle: Current step content
   └─ Bottom Sheet (collapsible): Todo list
```

### Responsive Considerations

```dart
ResponsiveBuilder(
  phone: (context, screenSize) => Column(
    children: [
      WizardProgressBar(),
      Expanded(child: currentStepWidget),
      WizardBottomSheet(todoList: wizardTodoList),
    ],
  ),
  tablet: (context, screenSize) => Row(
    children: [
      SizedBox(width: 300, child: WizardTodoList()),
      Expanded(child: currentStepWidget),
    ],
  ),
  desktop: (context, screenSize) => Row(
    children: [
      SizedBox(width: 400, child: WizardTodoList()),
      Expanded(child: currentStepWidget),
    ],
  ),
)
```

---

## Implementation Checklist

### Phase 1: Infrastructure (2-3 days)
- [ ] Create `WizardProgress` domain model (Freezed)
- [ ] Create `WizardProgressRepository`
- [ ] Create `WizardState` domain model (Freezed)
- [ ] Create `WizardNotifier` provider
- [ ] Run `build_runner` for code generation
- [ ] Test wizard progress persistence

### Phase 2: Wizard Shell (2-3 days)
- [ ] Create `WizardScreen` shell with responsive layout
- [ ] Create `WizardTodoList` component
- [ ] Create `WizardStepScaffold` reusable widget
- [ ] Add wizard navigation logic
- [ ] Test responsive layout on phone/tablet/desktop

### Phase 3: First Wizard Step (2-3 days)
- [ ] Implement "Create Project" step
- [ ] Use `ProjectRepository` to save project
- [ ] Test repository integration
- [ ] Test stop/resume functionality
- [ ] Verify data appears in direct UI

### Phase 4: Remaining Steps (1-2 weeks)
- [ ] Implement "Add Individuals" step → uses `ProjectRepository.updateProjectData()`
- [ ] Implement "Add Assets" step → uses `AssetRepository`
- [ ] Implement "Add Events" step → uses `EventRepository`
- [ ] Implement "Add Expenses" step → uses `ExpenseRepository`
- [ ] Add educational content between steps
- [ ] Test complete wizard flow

### Phase 5: Polish (3-5 days)
- [ ] Add step validation
- [ ] Add progress indicators
- [ ] Add completion celebration
- [ ] Add ability to jump to specific step
- [ ] Test edge cases (incomplete data, errors, etc.)
- [ ] Add i18n for French translations

---

## Testing Strategy

### Unit Tests
```dart
test('WizardNotifier navigates to next step', () {
  final notifier = WizardNotifier();
  notifier.nextStep();
  expect(notifier.state.currentStepId, 'step-2');
});

test('WizardProgressRepository tracks completed steps', () async {
  final repo = WizardProgressRepository(userId: 'test-user');
  await repo.markStepComplete('project-1', 'add-assets');

  final progress = await repo.getProgressStream('project-1').first;
  expect(progress.completedSteps, contains('add-assets'));
});
```

### Integration Tests
```dart
testWidgets('Wizard saves asset and navigates to next step', (tester) async {
  // 1. Render wizard step
  await tester.pumpWidget(WizardAssetStep());

  // 2. Fill in asset form
  await tester.enterText(find.byKey('value-field'), '50000');

  // 3. Tap next
  await tester.tap(find.text('Next'));
  await tester.pumpAndSettle();

  // 4. Verify asset saved
  final assets = await assetRepository.getAssetsStream().first;
  expect(assets, hasLength(1));

  // 5. Verify navigation
  verify(wizardNav.nextStep()).called(1);
});
```

---

## FAQs

### Q: Do I need to modify existing repositories?
**A: No.** All existing repositories work as-is from wizard.

### Q: Can wizard and direct UI both modify the same project?
**A: Yes.** They use the same Firestore collections and repositories. Changes sync automatically via Firestore streams.

### Q: What if user abandons wizard mid-way?
**A: Incomplete data is already saved** (immediate persistence). User can:
1. Resume wizard later (wizard progress tracked)
2. Complete setup in direct UI
3. Delete project if they want to start over

### Q: Can I reuse responsive widgets from direct UI?
**A: Yes, partially.** ResponsiveContainer, ResponsiveCard, ResponsiveTextField, etc. can all be used in wizard.

### Q: How do I handle validation?
**A: Same as direct UI.** Use form validators, Freezed models enforce type safety, repositories throw exceptions on error.

### Q: Should I use batch writes for multiple entities?
**A: Optional.** For simple flows, sequential saves are fine. For complex flows (e.g., create project + 5 assets + 3 events), consider WizardService with Firestore batch writes.

### Q: How do I show wizard progress in the todo list?
**A: Watch wizardProgressProvider:**
```dart
final progress = ref.watch(wizardProgressProvider);
progress.maybeWhen(
  data: (wizardProgress) => TodoList(
    steps: allSteps.map((step) => TodoItem(
      title: step.title,
      status: wizardProgress.completedSteps.contains(step.id)
        ? StepStatus.complete
        : wizardProgress.skippedSteps.contains(step.id)
          ? StepStatus.skipped
          : StepStatus.notStarted,
    )),
  ),
);
```

---

## Summary

**You're in great shape!** 🎉

The architecture is wizard-ready. You just need to:
1. Build wizard UI components (2-3 weeks)
2. Add wizard progress tracking (2-3 days)
3. Reuse existing repositories (0 days - already done)

Total estimated effort: **3-4 weeks** for complete wizard implementation.

**Key takeaway**: Your clean architecture with UI-agnostic repositories means the wizard will reuse ~70% of existing code, ensuring consistency and saving significant development time.

---

*For detailed technical information, see:*
- `docs/ARCHITECTURE.md` - Full architecture documentation
- `docs/CODE_QUALITY_ASSESSMENT.md` - Wizard compatibility analysis
- `specs/Design Best Practices.md` - Implementation patterns
