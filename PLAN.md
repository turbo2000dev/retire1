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
   - [ ] Add method: `_calculateExpenses(year, individuals, expenses, scenario)`
     - For each of 6 expense categories
     - Check if expense is active (year within start/end timing)
     - Apply scenario overrides if present
     - Apply inflation to amounts
     - Sum all active expenses
   - [ ] Add method: `_isExpenseActive(year, expense)`
     - Convert start timing to year number
     - Convert end timing to year number
     - Return true if current year is within range
   - [ ] Store expense breakdown in YearlyProjection

2. **Update YearlyProjection model:**
   - [ ] Add `Map<String, double> expensesByCategory`
   - [ ] Keys: 'housing', 'transport', 'dailyLiving', 'recreation', 'health', 'family'
   - [ ] Run build_runner

3. **Apply inflation correctly:**
   - [ ] Compound inflation from start year
   - [ ] Formula: baseAmount * (1 + inflationRate)^yearsFromStart
   - [ ] Use inflationRate from base parameters

4. **Handle expense timing edge cases:**
   - [ ] Expense starts mid-projection
   - [ ] Expense ends mid-projection
   - [ ] Expense spans entire projection
   - [ ] Multiple expenses of same category

**Manual Test Checklist:**
- [ ] Expenses calculated for each category
- [ ] Only active expenses included each year
- [ ] Inflation applied correctly
- [ ] Scenario overrides change expense amounts
- [ ] Total expenses sum correctly
- [ ] Timing edge cases handled

**Deliverable:** Expense calculation integrated into projection

---

## PHASE 28: Integrate Tax Calculation into Projection

**Goal:** Calculate taxes on income and integrate into cash flow

### Tasks:
1. **Extend ProjectionCalculator:**
   - [ ] Add method: `_calculateTaxableIncome(yearIncome, reerWithdrawals, celiWithdrawals)`
     - Taxable: employment + RRQ + PSV + RRPE + REER withdrawals
     - Non-taxable: CELI withdrawals, return of capital
   - [ ] Add method: `_calculateTaxes(taxableIncome, age, individual)`
     - Use TaxCalculator service
     - Pass taxable income and age
     - Return total tax amount
   - [ ] Integrate into yearly loop:
     - Calculate income (Phase 26)
     - Calculate taxable income
     - Calculate taxes
     - Subtract taxes from available cash
     - Store in YearlyProjection

2. **Update YearlyProjection model:**
   - [ ] Add `double taxableIncome`
   - [ ] Add `double federalTax`
   - [ ] Add `double quebecTax`
   - [ ] Add `double totalTax`
   - [ ] Add `double afterTaxIncome`
   - [ ] Run build_runner

3. **Handle multiple individuals:**
   - [ ] If couple: calculate taxes separately for each
   - [ ] Consider pension income splitting optimization
   - [ ] Sum total household taxes

4. **Test tax integration:**
   - [ ] Verify REER withdrawals increase taxable income
   - [ ] Verify CELI withdrawals don't increase taxable income
   - [ ] Verify taxes reduce net cash flow
   - [ ] Verify age credit applied when applicable

**Manual Test Checklist:**
- [ ] Taxable income calculated correctly
- [ ] Taxes calculated and applied
- [ ] REER withdrawals taxed
- [ ] CELI withdrawals not taxed
- [ ] After-tax income computed
- [ ] Taxes shown in projection table

**Deliverable:** Tax calculation fully integrated into cash flow projection

---

## PHASE 29: Withdrawal Strategy - Optimized Asset Drawdown

**Goal:** Implement withdrawal strategy: CELI → Cash → CRI → REER, with tax optimization

### Tasks:
1. **Create withdrawal strategy service:**
   - [ ] Create `lib/features/projection/service/withdrawal_strategy.dart`
   - [ ] Method: `determineWithdrawals(shortfall, assetBalances, age, taxRate)`
     - Input: amount needed, current balances, age, marginal tax rate
     - Output: map of withdrawals by account type
     - Priority: CELI first, then Cash, then CRI, then REER
     - Respect CRI minimum withdrawal requirements
     - Optimize to minimize taxes

2. **Extend ProjectionCalculator:**
   - [ ] Add method: `_calculateCashShortfall(year, income, expenses, taxes)`
     - Formula: expenses + taxes - income
     - If positive: need to withdraw
     - If negative: have surplus to invest
   - [ ] Add method: `_executeWithdrawals(shortfall, assetBalances, age, taxRate)`
     - Use WithdrawalStrategy service
     - Update asset balances
     - Return withdrawal amounts by account
     - Handle case when all accounts depleted
   - [ ] Add method: `_depositSurplus(surplus, assetBalances, individual)`
     - Priority: CELI (up to contribution room), then REER (up to room), then Cash
     - Update asset balances

3. **Handle CRI/FRV minimum withdrawal:**
   - [ ] Calculate minimum based on age and balance
   - [ ] Force withdrawal even if no shortfall
   - [ ] Add to income (taxable)

4. **Track contribution room:**
   - [ ] CELI: annual limit ~$7,000 + unused from previous years
   - [ ] REER: 18% of previous year income, max ~$32,000
   - [ ] Reduce room when contributions made
   - [ ] Increase room each year

5. **Update YearlyProjection model:**
   - [ ] Add `Map<String, double> withdrawalsByAccount`
   - [ ] Add `Map<String, double> contributionsByAccount`
   - [ ] Add `double celiContributionRoom`
   - [ ] Add `double reerContributionRoom`
   - [ ] Run build_runner

**Manual Test Checklist:**
- [ ] CELI withdrawn first (tax-free)
- [ ] Cash withdrawn second
- [ ] CRI withdrawn third (min required)
- [ ] REER withdrawn last (taxed)
- [ ] Surplus deposited correctly
- [ ] Contribution rooms tracked
- [ ] Withdrawals stop when accounts depleted

**Deliverable:** Optimized withdrawal strategy with tax considerations

---

## PHASE 30: Asset Balance Updates - Year-over-Year Tracking

**Goal:** Update asset balances each year based on returns, contributions, withdrawals

### Tasks:
1. **Extend ProjectionCalculator:**
   - [ ] Add method: `_updateAssetBalances(year, assets, income, expenses, taxes, withdrawals, contributions)`
     - For each asset:
       - Start balance = end balance from previous year
       - Apply return rate (use custom or project default)
       - Subtract withdrawals
       - Add contributions
       - End balance = start + returns - withdrawals + contributions
     - Store balances in YearlyProjection
   - [ ] Add method: `_calculateAssetReturns(asset, balance, returnRate)`
     - Formula: balance * returnRate
     - Use custom rate if set, otherwise project default
   - [ ] Track asset balances throughout projection

2. **Handle real estate:**
   - [ ] Real estate appreciates at inflation rate (or custom rate)
   - [ ] Real estate can be sold (RealEstateTransaction event)
   - [ ] Sale proceeds go to specified deposit account
   - [ ] Purchase cost comes from specified withdrawal account

3. **Handle account depletion:**
   - [ ] When balance reaches $0, mark as depleted
   - [ ] Cannot withdraw from depleted account
   - [ ] Log warning when account depleted

4. **Update YearlyProjection model:**
   - [ ] Already has `assetsStartOfYear` and `assetsEndOfYear` (maps)
   - [ ] Add `assetReturns` map
   - [ ] Run build_runner if needed

5. **Test asset tracking:**
   - [ ] Balances increase with returns
   - [ ] Balances decrease with withdrawals
   - [ ] Balances increase with contributions
   - [ ] Real estate transactions handled correctly
   - [ ] Account depletion detected

**Manual Test Checklist:**
- [ ] Asset balances track correctly year-over-year
- [ ] Returns applied based on rates
- [ ] Withdrawals reduce balances
- [ ] Contributions increase balances
- [ ] Real estate appreciation works
- [ ] Real estate sales/purchases work
- [ ] Account depletion handled gracefully

**Deliverable:** Complete asset balance tracking throughout projection

---

## PHASE 31: Edge Cases - Death, Survivor Benefits, Account Depletion

**Goal:** Handle edge cases: death events, survivor benefits, running out of money

### Tasks:
1. **Handle death events:**
   - [ ] When individual dies:
     - Stop their employment income
     - Stop their RRQ (or reduce to survivor benefit)
     - Stop their PSV
     - Transfer REER/RRSP to survivor (tax-deferred if spouse)
     - Transfer CELI to survivor (tax-free)
     - CRI/FRV to survivor
   - [ ] Mark individual as deceased in projection
   - [ ] Update YearlyProjection to track deceased status

2. **Calculate survivor benefits:**
   - [ ] RRQ survivor benefit:
     - Spouse receives ~60% of deceased's benefit
     - Or their own benefit, whichever is higher
     - Combined maximum applies
   - [ ] Add survivor benefit to income calculation

3. **Handle account depletion:**
   - [ ] When all accounts reach $0:
     - Mark projection year as "shortfall"
     - Calculate negative cash flow
     - Flag as warning in UI
   - [ ] Add `hasShortfall` boolean to YearlyProjection
   - [ ] Add `shortfallAmount` double to YearlyProjection

4. **Handle real estate as last resort:**
   - [ ] If all accounts depleted and still need money:
     - Can user sell primary residence?
     - Optional: model reverse mortgage
     - For Phase 31: just flag as shortfall

5. **Update projection table to show warnings:**
   - [ ] Highlight years with shortfalls
   - [ ] Show deceased individuals
   - [ ] Show survivor benefits

**Manual Test Checklist:**
- [ ] Death event stops individual's income
- [ ] Assets transfer to survivor
- [ ] Survivor benefits calculated correctly
- [ ] Account depletion flagged
- [ ] Shortfall years highlighted
- [ ] Negative cash flow shown

**Deliverable:** Edge cases handled, warnings displayed

---

## PHASE 32: Enhanced Projection Table - 40+ Columns

**Goal:** Expand projection table to show detailed breakdown with 40+ columns

### Tasks:
1. **Design expanded table structure:**
   - [ ] Year
   - [ ] Age (Primary / Spouse)
   - [ ] **Income sources:** Employment, RRQ, PSV, RRPE, Other, Total
   - [ ] **Expenses:** Housing, Transport, Daily Living, Recreation, Health, Family, Total
   - [ ] **Taxes:** Federal, Quebec, Total
   - [ ] **Withdrawals:** CELI, Cash, CRI, REER, Total
   - [ ] **Contributions:** CELI, REER, Total
   - [ ] **Asset Balances (End of Year):** Real Estate, REER, CELI, CRI, Cash, Total
   - [ ] **Net Worth:** Start, End
   - [ ] **Cash Flow:** Net (income - expenses - taxes)

2. **Create ExpandedProjectionTable widget:**
   - [ ] Create `lib/features/projection/presentation/widgets/expanded_projection_table.dart`
   - [ ] Use DataTable with horizontal scrolling
   - [ ] Sticky header row
   - [ ] Sticky first column (Year)
   - [ ] Group columns with dividers
   - [ ] Color-code positive/negative values
   - [ ] Currency formatting for all monetary columns
   - [ ] Percentage formatting for rates

3. **Add column visibility toggles:**
   - [ ] Checkbox list to show/hide column groups
   - [ ] Income columns (show/hide all)
   - [ ] Expense columns (show/hide all)
   - [ ] Tax columns (show/hide all)
   - [ ] Withdrawal columns (show/hide all)
   - [ ] Asset balance columns (show/hide all)
   - [ ] Save preferences to user settings

4. **Add export functionality:**
   - [ ] "Export to CSV" button
   - [ ] Generate CSV with all columns
   - [ ] Download file (web) or share (mobile)

5. **Update projection screen:**
   - [ ] Add tab or toggle to switch between:
     - Simple table (existing, 7 columns)
     - Expanded table (new, 40+ columns)
   - [ ] Default to simple table

**Manual Test Checklist:**
- [ ] Expanded table shows all columns
- [ ] Horizontal scrolling works
- [ ] Column groups visually separated
- [ ] Can toggle column visibility
- [ ] Export to CSV works
- [ ] Data matches simple table
- [ ] Responsive on desktop/tablet (not phone)

**Deliverable:** Detailed projection table with 40+ columns and export capability

---

## PHASE 33: Multiple Charts - Income, Expenses, Cash Flow, Asset Allocation

**Goal:** Add 4 comprehensive charts to visualize projection data

### Tasks:
1. **Create IncomeSourcesChart:**
   - [ ] Create `lib/features/projection/presentation/widgets/income_sources_chart.dart`
   - [ ] Stacked area chart showing:
     - Employment income (bottom)
     - RRQ income
     - PSV income
     - RRPE income
     - Other income (top)
   - [ ] X-axis: years
   - [ ] Y-axis: currency
   - [ ] Legend for each income source
   - [ ] Color-coded areas

2. **Create ExpenseCategoriesChart:**
   - [ ] Create `lib/features/projection/presentation/widgets/expense_categories_chart.dart`
   - [ ] Stacked bar chart showing 6 categories per year
   - [ ] X-axis: years (show every 5 years for readability)
   - [ ] Y-axis: currency
   - [ ] Legend for 6 categories
   - [ ] Color-coded bars

3. **Create CashFlowChart:**
   - [ ] Create `lib/features/projection/presentation/widgets/cash_flow_chart.dart`
   - [ ] Combination chart:
     - Line: Net cash flow (income - expenses - taxes)
     - Bars: Positive (green) / Negative (red)
   - [ ] X-axis: years
   - [ ] Y-axis: currency (allow negative)
   - [ ] Highlight zero line
   - [ ] Show years with shortfalls

4. **Create AssetAllocationChart:**
   - [ ] Create `lib/features/projection/presentation/widgets/asset_allocation_chart.dart`
   - [ ] Stacked area chart showing asset balances over time:
     - Real Estate
     - REER accounts
     - CELI accounts
     - CRI accounts
     - Cash accounts
   - [ ] X-axis: years
   - [ ] Y-axis: currency
   - [ ] Total net worth line overlaid
   - [ ] Legend for each asset type

5. **Update projection screen:**
   - [ ] Add "Charts" section below table
   - [ ] Show all 4 charts in responsive grid (2x2 on desktop, 1x4 on mobile)
   - [ ] Each chart in a card with title
   - [ ] Charts update when scenario changes

6. **Add chart interactivity:**
   - [ ] Tooltips on hover
   - [ ] Zoom/pan capabilities
   - [ ] Click legend to show/hide series

**Manual Test Checklist:**
- [ ] All 4 charts render correctly
- [ ] Data matches projection table
- [ ] Charts responsive on all sizes
- [ ] Tooltips show accurate values
- [ ] Legend toggles series visibility
- [ ] Charts update when scenario changes
- [ ] Colors consistent with theme

**Deliverable:** 4 comprehensive charts visualizing projection data

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

