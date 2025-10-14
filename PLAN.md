# Retirement Planning App - Active Implementation Plan

**Note:** Completed phases 1-27 have been archived to plan_archive1.md

**Key Principle:** Every phase produces a runnable, testable app increment that can be manually verified with `flutter run`.

---

## PHASE 28: Redesign Events - Add 6 Expense Categories

**Goal:** Replace simple events with comprehensive expense categories and lifecycle events

### Tasks:
1. **Create new expense domain models:**
   - [x] Create `lib/features/expenses/domain/expense_category.dart`
   - [x] Use Freezed unions for 6 expense types:
     - `HousingExpense(id, startTiming, endTiming, annualAmount)`
     - `TransportExpense(id, startTiming, endTiming, annualAmount)`
     - `DailyLivingExpense(id, startTiming, endTiming, annualAmount)`
     - `RecreationExpense(id, startTiming, endTiming, annualAmount)`
     - `HealthExpense(id, startTiming, endTiming, annualAmount)`
     - `FamilyExpense(id, startTiming, endTiming, annualAmount)`
   - [x] Each expense has start and end timing (both use EventTiming)
   - [x] Run build_runner

2. **Keep lifecycle events:**
   - [x] Retirement, Death, Real Estate Transaction remain unchanged
   - [x] These are kept in the existing Event model

3. **Create expenses screen/tab:**
   - [x] Add new tab or section to Assets & Events screen
   - [x] Or create dedicated Expenses screen with navigation
   - [x] List all 6 expense categories
   - [x] Show start/end timing for each
   - [x] Show annual amount with currency formatting

4. **Create expense forms:**
   - [x] Create `expense_form.dart` - reusable for all categories
   - [x] Category name (read-only/title)
   - [x] Start timing selector (reuse TimingSelector)
   - [x] End timing selector (reuse TimingSelector)
   - [x] Annual amount field (currency format)
   - [x] Form validation

5. **Create expense card component:**
   - [x] Category-specific icons and colors
   - [x] Display start and end timing
   - [x] Display annual amount
   - [x] Edit and delete buttons

6. **Create expenses provider:**
   - [x] ExpensesNotifier with CRUD operations
   - [x] Load from Firestore
   - [x] Real-time updates

7. **Create expense repository:**
   - [x] Store in `projects/{projectId}/expenses` collection
   - [x] Handle nested union serialization (timing within expense)
   - [x] CRUD operations

8. **Update projection calculator:**
   - [x] Calculate total expenses for each year
   - [x] Check if expense is active based on start/end timing
   - [x] Sum all active expenses
   - [x] Apply inflation to expense amounts

9. **Add import/export functionality:**
   - [x] Update ProjectExportService to export expenses (version 1.2)
   - [x] Update ProjectImportService to import expenses with ID remapping
   - [x] Update ImportPreviewDialog to show expense counts by category
   - [x] Update BaseParametersScreen to load/save expenses during import/export
   - [x] Handle timing reference remapping (individual and event IDs)

**Manual Test Checklist:**
- [x] Can add/edit all 6 expense categories
- [x] Start and end timing work correctly
- [x] Timing types (relative, absolute, age, eventRelative, projectionEnd) all work
- [x] Annual amounts save and load correctly
- [x] Expenses persist to Firestore
- [x] Nested timing serialization works
- [x] Projection calculator uses expenses
- [x] Expenses export to JSON correctly
- [x] Expenses import from JSON with ID remapping
- [x] Inflation adjustment applies correctly in projections

**Deliverable:** 6 expense categories with start/end timing, fully integrated with projection calculator, import/export functionality, and inflation-adjusted projections

**Completion Notes:**
- Export version bumped to 1.2 to include expenses
- Import handles ID remapping for individual and event references in timing
- Projection engine validated with comprehensive test data
- All 5 timing types working correctly: relative, absolute, age, eventRelative, projectionEnd
- Inflation formula validated: `adjustedAmount = baseAmount × (1 + inflationRate)^yearsFromStart`

---

## PHASE 24: Update Scenarios - Add Event Timing & Expense Overrides

**Goal:** Allow scenarios to override event timing, expense amounts, and expense timing

### Tasks:
1. **Update ParameterOverride domain model:**
   - [x] Add `EventTimingOverride(eventId, yearsFromStart)` union case
   - [x] Add `ExpenseAmountOverride(expenseId, overrideAmount, amountMultiplier)` union case
   - [x] Add `ExpenseTimingOverride(expenseId, overrideStartTiming, overrideEndTiming)` union case
   - [x] Run build_runner

2. **Create EventOverrideSection widget:**
   - [x] Lists all lifecycle events
   - [x] Shows base timing for each
   - [x] Allows overriding timing for scenario
   - [x] Highlight overridden events
   - [x] Can clear override to use base

3. **Create ExpenseAmountOverrideSection widget:**
   - [x] Lists all 6 expense categories (two separate sections: absolute and multiplier)
   - [x] Shows base annual amount for each
   - [x] Allows overriding amount (absolute) or applying multiplier (including 0.0 to eliminate)
   - [x] Highlight overridden expenses
   - [x] Can clear override to use base

4. **Create ExpenseTimingOverrideSection widget:**
   - [x] Lists all 6 expense categories
   - [x] Shows base start and end timing for each
   - [x] Allows overriding start timing, end timing, or both independently
   - [x] Uses full TimingSelector with all 5 timing types
   - [x] Highlight overridden timing
   - [x] Can clear override to use base

5. **Update scenario editor screen:**
   - [x] Add "Event Overrides" section
   - [x] Add "Expense Amount Overrides" section (with two subsections)
   - [x] Add "Expense Timing Overrides" section
   - [x] Place all after asset overrides section
   - [x] Responsive layout

6. **Update ScenariosNotifier:**
   - [x] Handle new override types
   - [x] Add/remove event timing overrides
   - [x] Add/remove expense amount overrides
   - [x] Add/remove expense timing overrides

7. **Update projection calculator:**
   - [x] Apply event timing overrides from scenario
   - [x] Apply expense amount overrides from scenario (both absolute and multiplier)
   - [x] Apply expense timing overrides from scenario (start and/or end)
   - [x] Fall back to base values if no override

8. **Update Firestore integration:**
   - [x] Nested unions serialize correctly (timing within overrides)
   - [x] All override types persist correctly

**Manual Test Checklist:**
- [ ] Can override event timing in scenarios
- [ ] Can override expense amounts (absolute and multiplier) in scenarios
- [ ] Can override expense timing (start, end, or both) in scenarios
- [ ] Overrides highlighted in scenario editor
- [ ] Can clear overrides
- [ ] Projection reflects scenario overrides
- [ ] All changes persist to Firestore
- [ ] Multiplier of 0.0 eliminates expense
- [ ] Both amount and timing overrides can be applied to same expense

**Deliverable:** Scenarios can override event timing, expense amounts (absolute/multiplier), and expense timing (start/end)

**Completion Notes:**
- Implemented comprehensive override system with three types: event timing, expense amount, and expense timing
- Expense amount overrides support both absolute values and multipliers (including 0.0 to eliminate)
- Expense timing overrides support independent start and end timing changes using full TimingSelector
- UI organized into separate sections for clarity: Event Overrides, Expense Amount Overrides (with Absolute and Multiplier subsections), and Expense Timing Overrides
- All override types integrated into projection calculator with proper precedence
- Ready for manual testing phase

---

## PHASE 25: Tax Calculator Service - 2025 Constants & Calculation Logic

**Goal:** Create tax calculation service with built-in 2025 tax brackets and credits (not user-configurable)

### Tasks:
1. **Create tax constants:**
   - [x] Create `lib/features/projection/service/tax_constants.dart`
   - [x] Define 2025 Federal tax brackets:
     - 0 - $55,867: 15%
     - $55,867 - $111,733: 20.5%
     - $111,733 - $173,205: 26%
     - $173,205 - $246,752: 29%
     - $246,752+: 33%
   - [x] Define 2025 Quebec tax brackets:
     - 0 - $51,780: 14%
     - $51,780 - $103,545: 19%
     - $103,545 - $126,000: 24%
     - $126,000+: 25.75%
   - [x] Define personal tax credits:
     - Federal basic: $15,705
     - Quebec basic: $18,056
     - Age credit (65+): federal $8,790, Quebec $3,458
   - [x] Define RRSP/REER deduction limits (for reference only - not used until Phase 28)
   - [x] Pension income splitting rules (deferred to Phase 28)

2. **Create TaxCalculator service:**
   - [x] Create `lib/features/projection/service/tax_calculator.dart`
   - [x] Method: `calculateFederalTax(taxableIncome, age)`
   - [x] Method: `calculateQuebecTax(taxableIncome, age)`
   - [x] Method: `calculateTotalTax(taxableIncome, age)` - combines both
   - [x] Apply progressive tax brackets correctly
   - [x] Apply tax credits (basic + age if applicable) using exact calculation
   - [x] Return TaxCalculation object with breakdown

3. **Create TaxCalculation model:**
   - [x] Create `lib/features/projection/domain/tax_calculation.dart`
   - [x] Fields: grossIncome, taxableIncome, federalTax, quebecTax, totalTax, effectiveRate
   - [x] Use Freezed
   - [x] Run build_runner

4. **Add unit tests:**
   - [x] Test federal tax calculation with various incomes
   - [x] Test Quebec tax calculation
   - [x] Test combined calculation
   - [x] Test age credit application
   - [x] Test edge cases (zero income, very high income)

5. **Create TaxCalculator provider:**
   - [x] Riverpod provider for TaxCalculator instance
   - [x] Make available to projection calculator

**Manual Test Checklist:**
- [x] Tax calculator computes correct federal tax
- [x] Tax calculator computes correct Quebec tax
- [x] Tax brackets applied progressively
- [x] Tax credits reduce tax correctly
- [x] Age credit (65+) applied when applicable
- [x] Unit tests pass (18 tests, all passing)

**Deliverable:** Tax calculation service with 2025 constants, ready for integration

**Completion Notes:**
- Implemented with hardcoded 2025 tax brackets and credits (no year parameter)
- Tax credits applied using exact calculation: credit_amount × lowest_marginal_rate (15% federal, 14% Quebec)
- Simple TaxCalculation model with 6 essential fields
- RRSP deductions and pension income splitting deferred to Phase 28
- Comprehensive test suite with 18 tests covering all scenarios including edge cases
- Progressive tax brackets implemented correctly with marginal rates
- Tax owing clamped to zero (non-refundable credits)

---

## PHASE 26: Income Calculation - Employment, RRQ, PSV, RRPE

**Goal:** Calculate all income sources for each year in projection

### Tasks:
1. **Create income calculation models:**
   - [x] Create `lib/features/projection/domain/annual_income.dart`
   - [x] Fields: employment, rrq, psv, rrpe, other, total
   - [x] Use Freezed
   - [x] Run build_runner

2. **Create income constants:**
   - [x] Create `lib/features/projection/service/income_constants.dart`
   - [x] Define 2025 RRQ constants (max benefit, early penalty, late bonus)
   - [x] Define 2025 PSV constants (base amount, clawback threshold, clawback rate)
   - [x] Define RRIF minimum withdrawal rates (ages 65-95+)

3. **Update Individual model:**
   - [x] Add `rrqAnnualBenefit` field (user-specified RRQ benefit amount)
   - [x] Run build_runner

4. **Create IncomeCalculator service:**
   - [x] Create `lib/features/projection/service/income_calculator.dart`
   - [x] Method: `calculateIncome()` - calculates all income sources
   - [x] Method: `_calculateEmploymentIncome()` - continues until retirement event
   - [x] Method: `_calculateRRQ()` - applies age-based adjustments
     - Early penalty: -0.6% per month before 65
     - Late bonus: +0.7% per month after 65
     - Uses user-specified rrqAnnualBenefit as base
   - [x] Method: `_calculatePSV()` - applies income-based clawback
     - Base amount: $8,500/year
     - Clawback: 15% on income over $90,000
   - [x] Method: `_calculateRRPE()` - calculates RRIF minimum withdrawal
     - Age-based percentages from 4% (age 65) to 20% (age 95+)

5. **Update YearlyProjection model:**
   - [x] Add `Map<String, AnnualIncome> incomeByIndividual`
   - [x] Supports per-individual income tracking for couples
   - [x] Run build_runner

6. **Create IncomeCalculator provider:**
   - [x] Add incomeCalculatorProvider to projection_provider.dart
   - [x] Make available for dependency injection

7. **Add unit tests:**
   - [x] Test RRQ with early/on-time/late start (5 tests)
   - [x] Test PSV with various income levels and clawback (5 tests)
   - [x] Test RRPE minimum withdrawal at different ages (6 tests)
   - [x] Test income constants verification (2 tests)
   - [x] Test combined income calculation (2 tests)
   - [x] All 20 tests passing

**Manual Test Checklist:**
- [ ] Employment income stops at retirement
- [ ] RRQ starts at specified age
- [ ] RRQ early penalty applied correctly
- [ ] RRQ late bonus applied correctly
- [ ] PSV starts at specified age
- [ ] PSV clawback applied when income high
- [ ] RRPE calculated from CRI/FRV balance
- [ ] All income sources sum correctly

**Deliverable:** Complete income calculation for all sources

**Completion Notes:**
- Implemented with hardcoded 2025 constants (consistent with Phase 25 tax brackets)
- RRQ benefit uses user-specified rrqAnnualBenefit field (default $16,000) instead of earnings history
- Income tracking supports both individuals and couples via Map<String, AnnualIncome>
- Employment income uses binary model (full or zero) with placeholder for retirement event integration
- PSV clawback calculated based on total other income (employment + RRQ)
- RRIF withdrawal rates include full table from age 65 to 95+ (20% cap)
- Comprehensive test suite with 20 unit tests covering all income sources and edge cases
- All calculations use dart:developer log() for debugging (not print)
- Ready for integration with ProjectionCalculator in Phase 27

---

## PHASE 27: Expense Calculation - 6 Categories Integration

**Goal:** Calculate total expenses for each year based on 6 expense categories

### Tasks:
1. **Extend ProjectionCalculator:**
   - [x] Method `_calculateExpensesForYear` already implemented (Phase 28)
     - For each of 6 expense categories
     - Check if expense is active (year within start/end timing)
     - Apply scenario overrides if present
     - Apply inflation to amounts
     - Sum all active expenses
   - [x] Modified to return both total and category breakdown
   - [x] Store expense breakdown in YearlyProjection

2. **Update YearlyProjection model:**
   - [x] Add `Map<String, double> expensesByCategory`
   - [x] Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
   - [x] Run build_runner

3. **Apply inflation correctly:**
   - [x] Compound inflation from start year (already implemented)
   - [x] Formula: baseAmount * (1 + inflationRate)^yearsFromStart
   - [x] Use inflationRate from base parameters

4. **Handle expense timing edge cases:**
   - [x] Expense starts mid-projection (handled by timing resolution)
   - [x] Expense ends mid-projection (handled by timing resolution)
   - [x] Expense spans entire projection (supported)
   - [x] Multiple expenses of same category (supported)

**Manual Test Checklist:**
- [ ] Expenses calculated for each category
- [ ] Only active expenses included each year
- [ ] Inflation applied correctly
- [ ] Scenario overrides change expense amounts
- [ ] Total expenses sum correctly
- [ ] Timing edge cases handled

**Deliverable:** Expense calculation integrated into projection

**Completion Notes:**
- Most functionality was already implemented in Phase 28 (expense categories phase)
- Added expense category breakdown tracking to YearlyProjection
- Modified `_calculateExpensesForYear` to return Map with 'total' and 'byCategory'
- Updated projection loop to extract and store category breakdown
- All 38 existing unit tests still passing
- Expense breakdown enables future detailed charts (Phases 32-33)
- Import/export automatically compatible via Freezed serialization

---

## PHASE 28: Integrate Tax Calculation into Projection

**Goal:** Calculate taxes on income and integrate into cash flow

### Tasks:
1. **Extend ProjectionCalculator:**
   - [x] Add helper method: `_calculateIncomeForYear()` - calculates income for all individuals
   - [x] Add helper method: `_calculateTaxesForYear()` - calculates taxes for all individuals
   - [x] Integrate into yearly loop:
     - Calculate income for each individual (employment, RRQ, PSV, RRPE)
     - Calculate taxes per individual using TaxCalculator
     - Sum household taxes
     - Update net cash flow formula to include taxes
     - Store all tax fields in YearlyProjection

2. **Update YearlyProjection model:**
   - [x] Add `double taxableIncome` (household total)
   - [x] Add `double federalTax` (household total)
   - [x] Add `double quebecTax` (household total)
   - [x] Add `double totalTax` (household total)
   - [x] Add `double afterTaxIncome` (household total)
   - [x] Run build_runner

3. **Handle multiple individuals:**
   - [x] Calculate taxes separately for each individual
   - [x] Sum household taxes
   - [x] Log calculations to console for debugging
   - [x] Note: Pension income splitting deferred to future phase

4. **Update projection UI:**
   - [x] Add "Taxes" column to projection table
   - [x] Add "After-Tax Income" column to projection table
   - [x] Display with currency formatting
   - [x] Color-code taxes (red) and income (green/tertiary)

5. **Enhance import/export error handling:**
   - [x] Create ImportException class with field paths and line numbers
   - [x] Create ImportSchemaValidator for comprehensive validation
   - [x] Enhance ProjectImportService with detailed error logging
   - [x] All errors logged to Flutter console using dart:developer log()

**Manual Test Checklist:**
- [x] Taxable income calculated correctly
- [x] Taxes calculated and applied per individual
- [x] Federal and Quebec taxes properly separated
- [x] After-tax income computed (total income - total tax)
- [x] Net cash flow includes taxes (after-tax income - expenses)
- [x] Taxes shown in projection table UI
- [x] Tax columns display in yearly breakdown
- [x] Import validation catches schema errors with line numbers
- [x] Exported projection includes all tax fields

**Deliverable:** Tax calculation fully integrated into cash flow projection with UI display and enhanced error handling

**Completion Notes:**
- Implemented two helper methods in ProjectionCalculator: `_calculateIncomeForYear()` and `_calculateTaxesForYear()`
- Tax calculation uses existing IncomeCalculator and TaxCalculator services from Phases 25-26
- Taxes calculated per individual, then aggregated at household level (no per-individual breakdown in YearlyProjection)
- Phase 28 design decision: For now, taxable income = total income (RRPE, employment, RRQ, PSV all taxable)
- Real estate transaction income handled separately (not part of taxable income in this phase)
- Net cash flow formula: `totalIncome - totalExpenses - totalTax`
- Added "Taxes" and "After-Tax Income" columns to projection_table.dart
- Created comprehensive import validation system with schema checking and detailed error messages
- All validation errors include field paths and approximate line numbers for easy debugging
- Tested with Phase 28 test data: couple with employment, RRQ, PSV, and RRPE income
- Effective tax rates progress correctly (35.7% at $321k income to 46.1% at $649k income)
- All 38 existing unit tests still passing
- Ready for Phase 29 (Withdrawal Strategy)

---

## PHASE 29: Withdrawal Strategy - Optimized Asset Drawdown

**Goal:** Implement withdrawal strategy: CELI → Cash → CRI → REER, with tax optimization

### Tasks:
1. **Create withdrawal strategy service:**
   - [x] Create `lib/features/projection/service/withdrawal_strategy.dart`
   - [x] Method: `calculateCriMinimums()` - calculate age-based RRIF minimums
   - [x] Method: `determineWithdrawals()` - withdrawal priority: CELI → Cash → CRI → REER
   - [x] Method: `determineContributions()` - contribution priority: CELI → Cash
   - [x] Uses Freezed pattern matching for asset type detection

2. **Update Individual model:**
   - [x] Add `initialCeliRoom` field (default 0.0)
   - [x] Run build_runner

3. **Update YearlyProjection model:**
   - [x] Add `Map<String, double> withdrawalsByAccount`
   - [x] Add `Map<String, double> contributionsByAccount`
   - [x] Add `double totalWithdrawals`
   - [x] Add `double totalContributions`
   - [x] Add `double celiContributionRoom`
   - [x] Run build_runner

4. **Extend ProjectionCalculator:**
   - [x] Add 9 new helper methods for withdrawal/contribution logic
   - [x] Refactor main projection loop with CRI minimums
   - [x] Implement iterative tax/withdrawal calculation (up to 5 iterations, $1 threshold)
   - [x] Handle retirement gate for surplus contributions (only after ALL retired)
   - [x] Track CELI room with $7,000 annual increase
   - [x] Store all withdrawal/contribution data in YearlyProjection

5. **Handle CRI/FRV minimum withdrawal:**
   - [x] Calculate minimum based on age and RRIF withdrawal rates
   - [x] Force withdrawal at start of year (before other calculations)
   - [x] Add to RRPE income (taxable)

6. **Track CELI contribution room:**
   - [x] Initialize from individual's `initialCeliRoom`
   - [x] Reduce room when contributions made
   - [x] Increase room by $7,000 each year
   - [x] Track room at end of each year in YearlyProjection

**Manual Test Checklist:**
- [x] CELI withdrawn first (tax-free)
- [x] Cash withdrawn second
- [x] CRI withdrawn third (after minimums)
- [x] REER withdrawn last (taxed)
- [x] Surplus contributed correctly (CELI → Cash)
- [x] CELI contribution room tracked
- [x] CRI minimums calculated and applied
- [x] Retirement gate prevents surplus contributions before retirement
- [x] Iterative tax calculation converges for REER withdrawals

**Deliverable:** Optimized withdrawal strategy with tax considerations

**Completion Notes:**
- Implemented comprehensive withdrawal strategy with priority ordering: CELI → Cash → CRI → REER
- CRI minimum withdrawals calculated at start of year using age-based RRIF rates
- Iterative tax/withdrawal calculation handles circular dependency (REER withdrawals affect taxes)
- Contribution logic: CELI (up to room) → Cash (unlimited)
- Surplus only invested after ALL individuals retired (retirement gate)
- CELI room tracking: initial room + $7,000/year - contributions made
- Design decision: No REER contributions from surplus (only CELI and Cash)
- All withdrawal/contribution data tracked in YearlyProjection for future UI display
- Tested with two scenarios: surplus (base) and shortfall (high-expenses test)
- Validation confirmed: withdrawal priority works correctly, shortfalls covered precisely
- Ready for Phase 30 (Asset Balance Updates)

---

## PHASE 30: Asset Balance Updates - Year-over-Year Tracking

**Goal:** Update asset balances each year based on returns, contributions, withdrawals

### Tasks:
1. **Extend ProjectionCalculator:**
   - [x] Refactored `_applyAssetGrowth()` to return asset returns map
     - For each asset:
       - Start balance = end balance from previous year (already implemented)
       - Apply return rate (use custom or project default)
       - Subtract withdrawals (already implemented in Phase 29)
       - Add contributions (already implemented in Phase 29)
       - End balance = start + returns - withdrawals + contributions
     - Store balances in YearlyProjection (already implemented)
   - [x] Track and return asset returns for each asset type
     - Formula: balance * returnRate
     - Use custom rate if set, otherwise project default
   - [x] Track asset balances throughout projection (already implemented)

2. **Handle real estate:**
   - [x] Real estate appreciates at custom rate or inflation rate (added customReturnRate field)
   - [x] Real estate can be sold (RealEstateTransaction event - already implemented)
   - [x] Sale proceeds go to specified deposit account (already implemented)
   - [x] Purchase cost comes from specified withdrawal account (already implemented)

3. **Handle account depletion:**
   - [x] When balance reaches $0, mark as depleted with warning log
   - [x] Clamp negative balances to $0 (prevent overdrafts)
   - [x] Log warning when account depleted (level 900)

4. **Update YearlyProjection model:**
   - [x] Already has `assetsStartOfYear` and `assetsEndOfYear` (maps)
   - [x] Add `assetReturns` map
   - [x] Run build_runner

5. **Update Asset model:**
   - [x] Add `customReturnRate` parameter to RealEstateAsset (optional, defaults to inflation)
   - [x] Run build_runner
   - [x] Fix all pattern matching callsites

**Manual Test Checklist:**
- [ ] Asset balances track correctly year-over-year
- [ ] Returns applied based on rates
- [ ] Withdrawals reduce balances
- [ ] Contributions increase balances
- [ ] Real estate appreciation works with custom rate
- [ ] Real estate sales/purchases work
- [ ] Account depletion handled gracefully with warnings

**Deliverable:** Complete asset balance tracking throughout projection

**Completion Notes:**
- Most functionality was already implemented in Phases 28-29 (balances, withdrawals, contributions)
- Added `assetReturns` field to YearlyProjection to track individual asset performance
- Refactored `_applyAssetGrowth()` from void to return Map<String, double> with returns
- Added `customReturnRate` to RealEstateAsset for flexibility (defaults to inflationRate)
- Account depletion detection: logs warning at level 900, clamps balances to $0
- Returns calculation formula: `returnAmount = currentBalance * rate`
- Asset growth order: CRI withdrawals → income calculation → shortfall withdrawals → surplus contributions → **asset growth** → annual contributions
- Real estate can now have custom appreciation rates independent of inflation
- All pattern matching updated to include new customReturnRate parameter (8 files fixed)
- **UI Enhancements:**
  - Added "Custom appreciation rate" field to real estate asset form (optional percentage field)
  - Added "Asset Returns" column to projection table showing total returns per year
  - Asset returns automatically included in JSON export via Freezed serialization
- Validated with test data: house at 4.5% custom rate, condo at 2% inflation rate, CRI at 6% custom rate
- All calculations mathematically verified against exported projection data
- Ready for Phase 31 (Edge Cases - Death, Survivor Benefits)

---

## PHASE 31: Edge Cases - Death, Survivor Benefits, Account Depletion

**Goal:** Handle edge cases: death events, survivor benefits, running out of money

### Tasks:
1. **Handle death events:**
   - [x] When individual dies:
     - [x] Stop their employment income
     - [x] Stop their RRQ and PSV
     - [x] Survivor benefits calculated separately (60% rule)
     - [ ] Transfer REER/RRSP to survivor (deferred - assets remain in projection)
     - [ ] Transfer CELI to survivor (deferred - assets remain in projection)
     - [ ] CRI/FRV to survivor (deferred - assets remain in projection)
   - [x] Individual income calculation checks death status
   - [x] Death detection uses event timeline (not YearlyProjection field)

2. **Calculate survivor benefits:**
   - [x] RRQ survivor benefit:
     - [x] Spouse receives 60% of deceased's RRQ benefit
     - [x] Spouse receives 60% of deceased's PSV benefit
     - [x] Simplified rule (no combined maximum)
   - [x] Add survivor benefit to income calculation (stored in `AnnualIncome.other`)

3. **Handle account depletion:**
   - [x] When all accounts reach $0:
     - [x] Mark projection year as "shortfall"
     - [x] Calculate shortfall amount
     - [x] Flag in YearlyProjection
   - [x] Add `hasShortfall` boolean to YearlyProjection
   - [x] Add `shortfallAmount` double to YearlyProjection

4. **Handle real estate as last resort:**
   - [x] If all accounts depleted and still need money:
     - [x] For Phase 31: just flag as shortfall
     - [ ] Auto-sell real estate (deferred to future phase)
     - [ ] Reverse mortgage modeling (deferred to future phase)

5. **Update projection table to show warnings:**
   - [x] Highlight years with shortfalls (light red background)
   - [x] Show shortfall amounts in dedicated column with warning icon
   - [x] Show survivor benefits with heart icon (♥) in Income column
   - [x] Deceased indicator removed due to bug (detecting by zero income was faulty)

**Manual Test Checklist:**
- [x] Death event stops individual's income
- [ ] Assets transfer to survivor (deferred)
- [x] Survivor benefits calculated correctly (60% rule)
- [x] Account depletion flagged
- [x] Shortfall years highlighted
- [x] Shortfall amounts shown

**Deliverable:** Edge cases handled, warnings displayed

**Completion Notes:**
- Implemented simplified 60% survivor benefit rule (60% of deceased's RRQ + PSV)
- Death event detection in `IncomeCalculator` checks event list (not income levels)
- Modified `calculateIncome()` to accept `allIndividuals` parameter for survivor benefit calculation
- Survivor benefits stored in `AnnualIncome.other` field and displayed with heart icon
- Enhanced shortfall tracking with boolean flag and dollar amount in YearlyProjection
- Modified `_calculateCashFlowWithWithdrawals()` to return shortfall data in all return paths
- UI enhancements: light red row background for shortfall years, dedicated Shortfall column with warning icon
- Bug fix: Removed faulty deceased detection from Age column (was incorrectly flagging retired individuals with no income yet)
- Design decisions:
  - Simplified survivor benefits (no complex "higher of own or survivor" logic, no combined maximum)
  - Shortfall flagging only (no automatic real estate liquidation)
  - Asset transfers deferred to future phase (assets remain in projection after death)
- Modified files:
  - `lib/features/projection/service/income_calculator.dart` (death detection, survivor benefits)
  - `lib/features/projection/service/projection_calculator.dart` (pass events to income calculator)
  - `lib/features/projection/domain/yearly_projection.dart` (hasShortfall, shortfallAmount fields)
  - `lib/features/projection/presentation/widgets/projection_table.dart` (UI warnings)
- Ready for Phase 32 (Enhanced Projection Table)

---

## PHASE 32: Enhanced Projection Table - 40+ Columns ✅

**Goal:** Expand projection table to show detailed breakdown with 40+ columns

### Tasks:
1. **Design expanded table structure:**
   - [x] Year
   - [x] Age (Primary / Spouse)
   - [x] **Income sources:** Employment, RRQ, PSV, RRPE, Other, Total
   - [x] **Expenses:** Housing, Transport, Daily Living, Recreation, Health, Family, Total
   - [x] **Taxes:** Federal, Quebec, Total
   - [x] **Withdrawals:** CELI, Cash, CRI, REER, Total
   - [x] **Contributions:** CELI, REER, Total
   - [x] **Asset Balances (End of Year):** Real Estate, REER, CELI, CRI, Cash, Total
   - [x] **Net Worth:** Start, End
   - [x] **Cash Flow:** Net (income - expenses - taxes)

2. **Create ExpandedProjectionTable widget:**
   - [x] Create `lib/features/projection/presentation/widgets/expanded_projection_table.dart`
   - [x] Use DataTable with horizontal scrolling
   - [x] Sticky header row
   - [x] Sticky first column (Year)
   - [x] Group columns with dividers
   - [x] Color-code positive/negative values
   - [x] Currency formatting for all monetary columns
   - [x] Percentage formatting for rates

3. **Add column visibility toggles:**
   - [x] Checkbox list to show/hide column groups
   - [x] Income columns (show/hide all)
   - [x] Expense columns (show/hide all)
   - [x] Tax columns (show/hide all)
   - [x] Withdrawal columns (show/hide all)
   - [x] Asset balance columns (show/hide all)
   - [x] Save preferences to user settings

4. **Add export functionality:**
   - [x] "Export to CSV" button
   - [x] Generate CSV with all columns
   - [x] Download file (web) or share (mobile)

5. **Update projection screen:**
   - [x] Add tab or toggle to switch between:
     - Simple table (existing, 7 columns)
     - Expanded table (new, 40+ columns)
   - [x] Default to simple table

**Manual Test Checklist:**
- [x] Expanded table shows all columns
- [x] Horizontal scrolling works
- [x] Column groups visually separated
- [x] Can toggle column visibility
- [x] Export to CSV works
- [x] Data matches simple table
- [x] Responsive on desktop/tablet (not phone)

**Deliverable:** Detailed projection table with 40+ columns and export capability

**Completion Notes:**
- Implemented expanded projection table with ~40 columns organized into 10 column groups:
  1. Basic (Year, Age 1, Age 2)
  2. Income Sources (Employment, RRQ, PSV, RRPE, Other, Total - 6 columns)
  3. Expenses by Category (Housing, Transport, Daily Living, Recreation, Health, Family, Total - 7 columns)
  4. Taxes (Federal, Quebec, Total - 3 columns)
  5. Cash Flow (After-Tax Income, Net Cash Flow - 2 columns)
  6. Withdrawals by Account (CELI, Cash, CRI, REER, Total - 5 columns)
  7. Contributions by Account (CELI, Cash, Total - 3 columns)
  8. Asset Balances End of Year (Real Estate, REER, CELI, CRI, Cash, Total Returns - 6 columns)
  9. Net Worth (Start, End - 2 columns)
  10. Warnings (Shortfall Amount - 1 column)
- Created column visibility system with local storage persistence via ColumnVisibilityProvider
- Added TabBar UI with two tabs: "Simple" (11 columns) and "Detailed" (40+ columns)
- Implemented CSV export functionality with ProjectionCsvExport service
- Added dual age columns (Age 1, Age 2) to both simple and detailed tables
- Fixed critical bug: Strikethrough for deceased individuals now shows in ALL subsequent years (not just year of death)
  - Modified `_isPrimaryDeceased` and `_isSpouseDeceased` to check cumulative death events from year 0 to current year
- Fixed critical bug: Horizontal scrolling now works correctly in both tables
  - Restructured Card layout to remove padding constraints on horizontal scroll view
  - Moved header into separate Padding with only top/side padding
  - Added `horizontalMargin: 24` to DataTable for consistent spacing
  - SingleChildScrollView placed directly under Card's Column without horizontal padding

**Files Created:**
- `lib/features/projection/presentation/widgets/expanded_projection_table.dart` (808 lines)
- `lib/features/projection/presentation/widgets/column_visibility_dialog.dart` (109 lines)
- `lib/features/projection/presentation/providers/column_visibility_provider.dart` (provider for visibility state)
- `lib/features/projection/service/projection_csv_export.dart` (222 lines)

**Files Modified:**
- `lib/features/projection/presentation/widgets/projection_table.dart` (added events/individuals parameters, fixed strikethrough, restructured Card layout)
- `lib/features/projection/presentation/projection_screen.dart` (added TabBar, providers, passed events/individuals to tables)
- `lib/features/projection/presentation/widgets/expanded_projection_table.dart` (fixed strikethrough detection)

**Design Decisions:**
- Used TabBar instead of toggle button for better visual separation between views
- Column visibility stored in local storage (not Firestore) as UI preference
- CSV export uses simplified column headers for Excel compatibility
- Strikethrough detection uses event timeline traversal (not null age checking)
- Horizontal scrolling achieved by careful layout restructuring (no padding on scroll container)

**Ready for Phase 33:** Multiple charts for income sources, expense categories, cash flow, and asset allocation

---

## PHASE 33: Multiple Charts - Income, Expenses, Cash Flow, Asset Allocation ✅

**Goal:** Add 4 comprehensive charts to visualize projection data

### Tasks:
1. **Create IncomeSourcesChart:**
   - [x] Create `lib/features/projection/presentation/widgets/income_sources_chart.dart`
   - [x] Stacked area chart showing:
     - Employment income (bottom)
     - RRQ income
     - PSV income
     - RRPE income
     - Other income (top)
   - [x] X-axis: years (every 5 years)
   - [x] Y-axis: currency
   - [x] Legend for each income source
   - [x] Color-coded areas

2. **Create ExpenseCategoriesChart:**
   - [x] Create `lib/features/projection/presentation/widgets/expense_categories_chart.dart`
   - [x] Stacked bar chart showing 6 categories per year
   - [x] X-axis: years (show every 5 years for readability)
   - [x] Y-axis: currency
   - [x] Legend for 6 categories
   - [x] Color-coded bars

3. **Create CashFlowChart:**
   - [x] Create `lib/features/projection/presentation/widgets/cash_flow_chart.dart`
   - [x] Bar chart with color coding:
     - Positive bars (green)
     - Negative bars (red)
     - Shortfall bars (amber)
   - [x] X-axis: years (every 5 years)
   - [x] Y-axis: currency (allow negative)
   - [x] Highlight zero line (dashed)
   - [x] Show years with shortfalls in tooltip

4. **Create AssetAllocationChart:**
   - [x] Create `lib/features/projection/presentation/widgets/asset_allocation_chart.dart`
   - [x] Stacked area chart showing asset balances over time:
     - Real Estate
     - REER accounts
     - CELI accounts
     - CRI accounts
     - Cash accounts
   - [x] X-axis: years (every 5 years)
   - [x] Y-axis: currency
   - [x] Total net worth line overlaid (bold line)
   - [x] Legend for each asset type
   - [x] Proper asset type detection using Asset model

5. **Update projection screen:**
   - [x] Add charts section in Simple tab view
   - [x] Show all 4 charts in vertical stack (1x4 layout)
   - [x] Each chart in a card with title
   - [x] Charts update when scenario changes

6. **Add chart interactivity:**
   - [x] Tooltips on hover
   - [x] Click legend to show/hide series
   - [x] Zoom/pan deferred to Phase 34

**Manual Test Checklist:**
- [x] All 4 charts render correctly
- [x] Data matches projection table
- [x] Charts responsive on all sizes
- [x] Tooltips show accurate values
- [x] Legend toggles series visibility
- [x] Charts update when scenario changes
- [x] Colors consistent with theme

**Deliverable:** 4 comprehensive charts visualizing projection data

**Completion Notes:**
- Implemented 4 charts using existing fl_chart library (0.70.1):
  1. **IncomeSourcesChart** (367 lines) - Stacked area chart with 5 income sources
  2. **ExpenseCategoriesChart** (249 lines) - Stacked bar chart with 6 expense categories
  3. **CashFlowChart** (226 lines) - Bar chart with green/red/amber color coding
  4. **AssetAllocationChart** (446 lines) - Stacked area chart with net worth overlay
- All charts filter years to every 5 years for readability (as specified)
- All charts in 1x4 vertical stack layout for all devices (user preference)
- Interactive features implemented:
  - Hover tooltips showing detailed breakdowns
  - Clickable legend to show/hide individual series
  - Proper empty data handling
- Charts integrated into Simple tab view of projection_screen.dart
- Positioned after existing Net Worth chart, before Simple table
- Asset allocation chart uses proper Asset model for type detection (not ID naming)
- Design decisions:
  - Used consistent theme colors across all charts
  - Cash flow chart uses amber for shortfall warnings (distinct from regular deficit)
  - Asset allocation shows net worth as bold overlay line (not stacked)
  - All charts wrapped in ResponsiveContainer with consistent padding
- Charts always visible (no toggle), update automatically with scenario changes
- Zoom/pan functionality deferred to Phase 34 for simplicity

**Files Created:**
- `lib/features/projection/presentation/widgets/income_sources_chart.dart` (367 lines)
- `lib/features/projection/presentation/widgets/expense_categories_chart.dart` (249 lines)
- `lib/features/projection/presentation/widgets/cash_flow_chart.dart` (226 lines)
- `lib/features/projection/presentation/widgets/asset_allocation_chart.dart` (446 lines)

**Files Modified:**
- `lib/features/projection/presentation/projection_screen.dart` (added chart imports, assets provider, integrated 4 charts)

**Ready for Phase 34:** Current vs constant dollars toggle

---

## PHASE 34: Dollar Toggle - Current vs Constant Dollars

**Goal:** Add toggle to view projection in current or constant dollars

### Tasks:
1. **Add dollar mode to projection calculation:**
   - [ ] Update ProjectionCalculator to accept `useConstantDollars` parameter
   - [ ] If constant dollars:
     - Divide all monetary values by (1 + inflationRate)^yearsFromStart
     - Display values in today's purchasing power
   - [ ] If current dollars:
     - Show actual nominal values (existing behavior)

2. **Add toggle to projection screen:**
   - [ ] Create toggle switch in app bar or above charts
   - [ ] "Current Dollars" / "Constant Dollars"
   - [ ] Default: Current Dollars
   - [ ] Save preference to user settings

3. **Update all visualizations:**
   - [ ] Table values adjust based on toggle
   - [ ] Chart values adjust based on toggle
   - [ ] Y-axis labels reflect dollar type
   - [ ] Add indicator "(Current $)" or "(Constant $)" to chart titles

4. **Update calculation correctly:**
   - [ ] Constant dollars only affect display
   - [ ] Underlying calculation still uses nominal values
   - [ ] Adjust values only for display purposes
   - [ ] Ensure consistency across all views

5. **Show explanation:**
   - [ ] Add info icon next to toggle
   - [ ] Explain difference between current and constant dollars
   - [ ] "Current dollars show nominal values including inflation"
   - [ ] "Constant dollars show purchasing power in today's dollars"

**Manual Test Checklist:**
- [ ] Toggle switches between current and constant dollars
- [ ] Table values update correctly
- [ ] Chart values update correctly
- [ ] Y-axis labels update
- [ ] Chart titles show dollar type
- [ ] Explanation dialog helpful
- [ ] Preference persists across sessions

**Deliverable:** Toggle to view projection in current or constant dollars

---

## PHASE 35: KPIs, Warnings, and Scenario Comparison

**Goal:** Add key metrics, warning indicators, and side-by-side scenario comparison

### Tasks:
1. **Calculate KPIs:**
   - [ ] Create `lib/features/projection/domain/projection_kpis.dart`
   - [ ] Fields:
     - `yearMoneyRunsOut` (int or null if never)
     - `lowestNetWorth` (double)
     - `yearOfLowestNetWorth` (int)
     - `finalNetWorth` (double)
     - `totalTaxesPaid` (double)
     - `totalWithdrawals` (double)
     - `averageTaxRate` (double)
   - [ ] Use Freezed
   - [ ] Run build_runner

2. **Extend ProjectionCalculator:**
   - [ ] Add method: `_calculateKPIs(projection)` → ProjectionKPIs
   - [ ] Calculate each KPI from projection data
   - [ ] Return KPIs object

3. **Create KPI display widget:**
   - [ ] Create `lib/features/projection/presentation/widgets/projection_kpis_card.dart`
   - [ ] Card showing all KPIs in grid layout
   - [ ] Use icons and color coding
   - [ ] Green: good (money lasts, high net worth)
   - [ ] Red: warning (money runs out, low net worth)
   - [ ] Place at top of projection screen

4. **Create warnings system:**
   - [ ] Create `lib/features/projection/domain/projection_warning.dart`
   - [ ] Warning types:
     - MoneyRunsOut (year)
     - HighTaxRate (year, rate)
     - AccountDepleted (account type, year)
     - NoSurvivorIncome (year after death)
   - [ ] List of warnings per projection

5. **Display warnings:**
   - [ ] Create warnings section below KPIs
   - [ ] Show each warning with icon and description
   - [ ] Click warning to jump to year in table
   - [ ] Empty state if no warnings

6. **Create scenario comparison view:**
   - [ ] Create `lib/features/projection/presentation/scenario_comparison_screen.dart`
   - [ ] Select 2-3 scenarios to compare
   - [ ] Show KPIs side-by-side
   - [ ] Show overlaid charts
   - [ ] Highlight differences
   - [ ] Add navigation to comparison screen

7. **Update GoRouter:**
   - [ ] Add route for scenario comparison screen
   - [ ] `/projection/compare`

**Manual Test Checklist:**
- [ ] KPIs calculated correctly
- [ ] KPIs displayed prominently
- [ ] Warnings detected and shown
- [ ] Click warning jumps to year
- [ ] Can compare multiple scenarios
- [ ] Comparison shows differences clearly
- [ ] Navigation to comparison works

**Deliverable:** KPIs, warnings, and scenario comparison for better decision-making

---

## PHASE 36: Advanced Projection Testing & Refinement

**Goal:** End-to-end testing of advanced projection calculations and polish

### Tasks:
1. **Create comprehensive test scenarios:**
   - [ ] Scenario 1: Single individual, early retirement
   - [ ] Scenario 2: Couple, both retire at 65
   - [ ] Scenario 3: One death event mid-projection
   - [ ] Scenario 4: High income with RRQ/PSV clawbacks
   - [ ] Scenario 5: Money runs out at age 80
   - [ ] Scenario 6: Multiple real estate transactions
   - [ ] For each: manually calculate expected values, compare to app

2. **Write unit tests:**
   - [ ] Test TaxCalculator with various incomes
   - [ ] Test income calculations (employment, RRQ, PSV, RRPE)
   - [ ] Test expense calculations with timing
   - [ ] Test withdrawal strategy
   - [ ] Test asset balance updates
   - [ ] Test edge cases (death, depletion)
   - [ ] Aim for >80% coverage of projection logic

3. **Test all timing types:**
   - [ ] Relative timing (years from start)
   - [ ] Absolute timing (calendar year)
   - [ ] Age timing (when individual reaches age)
   - [ ] Event-relative timing (at start/end of another event) ✨
   - [ ] Verify all work for events and expenses

4. **Test scenario overrides:**
   - [ ] Asset value overrides
   - [ ] Event timing overrides
   - [ ] Expense amount overrides
   - [ ] Verify overrides applied in calculation

5. **Performance testing:**
   - [ ] Test projection calculation speed
   - [ ] Ensure <1 second for 40-year projection
   - [ ] Optimize if needed

6. **Verify data consistency:**
   - [ ] Asset balances always add up
   - [ ] Income - expenses - taxes = change in assets (closed loop)
   - [ ] No negative balances (except cash flow)
   - [ ] Contribution rooms never go negative

7. **Polish projection UI:**
   - [ ] Loading states during calculation
   - [ ] Error messages if calculation fails
   - [ ] Smooth scrolling in large tables
   - [ ] Chart animations on load
   - [ ] Responsive on all screen sizes

8. **Add user documentation:**
   - [ ] Help tooltip for each parameter
   - [ ] Explanation of each KPI
   - [ ] Explanation of withdrawal strategy
   - [ ] Explanation of tax calculation
   - [ ] Link to user guide (future)

9. **Test on all platforms:**
   - [ ] iOS simulator/device
   - [ ] Android emulator/device
   - [ ] Web browser (Chrome, Safari, Firefox)
   - [ ] macOS desktop

10. **Commit and document:**
    - [ ] Commit all changes
    - [ ] Update PLAN.md with completion notes
    - [ ] Update README with projection features
    - [ ] Tag release: v2.0-projection-engine

**Manual Test Checklist:**
- [ ] All 6 test scenarios calculate correctly
- [ ] Unit tests pass
- [ ] All timing types work correctly
- [ ] Scenario overrides apply correctly
- [ ] Projection calculates in <1 second
- [ ] Data consistency verified
- [ ] UI polished and responsive
- [ ] Documentation helpful
- [ ] Works on all platforms
- [ ] No console errors or warnings

**Deliverable:** Production-ready advanced projection engine with comprehensive testing

---

## Summary of Phases 21-36

**Phases 21-24:** Expand domain models and UI
- Phase 21: Economic rates & pension parameters
- Phase 22: CRI/FRV asset type
- Phase 23: 6 expense categories
- Phase 24: Event/expense overrides in scenarios

**Phases 25-31:** Build calculation engine
- Phase 25: Tax calculator with 2025 constants
- Phase 26: Income sources (employment, RRQ, PSV, RRPE)
- Phase 27: Expense calculation
- Phase 28: Tax integration
- Phase 29: Withdrawal strategy
- Phase 30: Asset balance tracking
- Phase 31: Edge cases (death, depletion)

**Phases 32-35:** Enhanced visualization
- Phase 32: 40+ column table
- Phase 33: 4 charts (income, expenses, cash flow, assets)
- Phase 34: Current vs constant dollars toggle
- Phase 35: KPIs, warnings, scenario comparison

**Phase 36:** Testing, polish, and release

**Key Principles:**
- Tax brackets are built-in constants, not user parameters
- Withdrawal priority: CELI → Cash → CRI → REER
- Progressive tax calculation with credits
- Inflation applied to expenses and asset values
- Scenario overrides allow "what-if" analysis
- Warnings guide user to potential issues

