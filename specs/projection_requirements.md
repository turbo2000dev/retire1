# Retirement Planning App - Projection Specifications

## 1. Overview

The projection is the core calculation engine of the retirement planning application. It generates a year-by-year financial forecast from the base year through the end of the planning horizon (typically until both individuals reach their life expectancy age).

### 1.1 Purpose
- Calculate annual income from all sources
- Track expense requirements across different life phases
- Compute tax obligations
- Monitor asset balances and growth
- Identify cash flow surpluses or shortfalls
- Determine the viability and sustainability of the retirement plan

### 1.2 Projection Horizon
- **Start Year:** Base year defined in base parameters
- **End Year:** Year when both individuals reach their life expectancy age
- **Granularity:** Annual (one row per year)

---

## 2. Input Requirements

### 2.1 Required Data
To generate a projection, the following must be defined:
1. Base parameters (individuals' information, base year, all economic rates, ...)
2. Assets and their initial values
3. Events timeline and their parameter
4. Expense definitions for all life phases
5. Selected scenario parameters, i.e., variation of base parameters, assets and events.

### 2.2 Scenario Selection
- User must select which scenario to project
- All calculations use parameters from the selected scenario
- Base scenario is the default

---

## 3. Year-by-Year Calculation Logic

Each projection year follows this calculation sequence:

### 3.1 Year Initialization
1. Determine calendar year
2. Calculate current ages of both individuals
3. Identify active events for this year
4. Check if individuals are alive (age ≤ life expectancy)

### 3.2 Income Calculation

#### 3.2.1 Employment Income
```
For each individual:
  IF age < retirement_age THEN
    employment_income = annual_salary * (1 + inflation)^(year - base_year)
  ELSE
    employment_income = 0
  END IF
```

#### 3.2.2 Government Pension Income (RRQ)
```
For each individual:
  IF age >= age_debut_rrq THEN
    base_amount = montant_rrq_100 * 12  // Convert monthly to annual
    
    // Apply early/late start adjustments
    IF age_debut_rrq < 65 THEN
      adjustment_factor = 1 - (0.006 * (65 - age_debut_rrq) * 12)  // 0.6% per month before 65
    ELSE IF age_debut_rrq > 65 THEN
      adjustment_factor = 1 + (0.007 * (age_debut_rrq - 65) * 12)  // 0.7% per month after 65
    ELSE
      adjustment_factor = 1
    END IF
    
    adjusted_amount = base_amount * adjustment_factor
    years_since_start = year - year_turned_age_debut_rrq
    rrq_income = adjusted_amount * (1 + indexation_rrqpsv)^years_since_start
  ELSE
    rrq_income = 0
  END IF
```

#### 3.2.3 Old Age Security (PSV)
```
For each individual:
  IF age >= age_debut_psv THEN
    // PSV base amount for 2025 (this should be a constant or retrieved from tax tables)
    base_psv_annual = 8,760  // Example: $730/month * 12
    
    // Apply late start bonus
    IF age_debut_psv > 65 THEN
      delay_months = (age_debut_psv - 65) * 12
      adjustment_factor = 1 + (0.006 * delay_months)  // 0.6% per month after 65
    ELSE
      adjustment_factor = 1
    END IF
    
    adjusted_psv = base_psv_annual * adjustment_factor
    years_since_start = year - year_turned_age_debut_psv
    psv_income = adjusted_psv * (1 + indexation_rrqpsv)^years_since_start
    
    // Apply income-based clawback if applicable
    IF taxable_income > psv_clawback_threshold THEN
      clawback = (taxable_income - psv_clawback_threshold) * 0.15
      psv_income = MAX(0, psv_income - clawback)
    END IF
  ELSE
    psv_income = 0
  END IF
```

#### 3.2.4 Employer Pension (RRPE)
```
For each individual:
  IF age >= retirement_age AND has_rrpe THEN
    IF age < 65 THEN
      base_amount = montant_rrpe60
    ELSE
      base_amount = montant_rrpe65
    END IF
    
    years_since_retirement = year - year_of_retirement
    rrpe_income = base_amount * (1 + indexation_rrpe)^years_since_retirement
  ELSE
    rrpe_income = 0
  END IF
```

#### 3.2.5 Investment Withdrawals
The withdrawal strategy prioritizes accounts based on tax efficiency:

**Priority Order:**
1. CELI (Tax-Free Savings Account) - withdrawn first as it's tax-free
2. Non-registered Cash Account - second priority
3. CRI/FRV (Locked-in Retirement Account) - third priority (minimum withdrawal after age 55)
4. REER/FERR (Registered Retirement Savings/Income Fund) - last resort

```
// Calculate net cash need
total_income_before_withdrawals = employment + rrq + psv + rrpe
net_expenses = total_expenses - total_income_before_withdrawals

IF net_expenses > 0 THEN
  // Need to withdraw from investments
  remaining_need = net_expenses
  
  // Step 1: Withdraw from CELI (tax-free)
  celi_withdrawal = MIN(remaining_need, celi_balance)
  remaining_need = remaining_need - celi_withdrawal
  
  // Step 2: Withdraw from Cash Account (tax-free withdrawal, but growth was taxed)
  IF remaining_need > 0 THEN
    cash_withdrawal = MIN(remaining_need, cash_balance)
    remaining_need = remaining_need - cash_withdrawal
  END IF
  
  // Step 3: Calculate required gross withdrawal from registered accounts
  // Need to account for tax on REER/CRI withdrawals
  IF remaining_need > 0 THEN
    estimated_marginal_rate = calculate_marginal_tax_rate(taxable_income_so_far)
    gross_withdrawal_needed = remaining_need / (1 - estimated_marginal_rate)
    
    // Step 3a: Withdraw from CRI/FRV (if applicable)
    IF age >= 55 AND cri_balance > 0 THEN
      // Calculate minimum required withdrawal for CRI/FRV
      cri_min_withdrawal = calculate_cri_minimum(age, cri_balance)
      cri_withdrawal = MAX(cri_min_withdrawal, MIN(gross_withdrawal_needed, cri_balance))
      remaining_need = remaining_need - (cri_withdrawal * (1 - estimated_marginal_rate))
      gross_withdrawal_needed = gross_withdrawal_needed - cri_withdrawal
    END IF
    
    // Step 3b: Withdraw from REER/FERR
    IF remaining_need > 0 THEN
      // Split between both individuals' REER accounts to optimize tax
      total_reer_balance = reer1_balance + reer2_balance
      
      IF total_reer_balance > 0 THEN
        // Calculate optimal split to minimize taxes
        reer1_withdrawal = calculate_optimal_reer_split(
          gross_withdrawal_needed, 
          reer1_balance, 
          reer2_balance,
          individual1_taxable_income,
          individual2_taxable_income
        )
        reer2_withdrawal = MIN(gross_withdrawal_needed - reer1_withdrawal, reer2_balance)
      END IF
    END IF
  END IF
ELSE
  // Surplus - deposit to cash account
  cash_deposit = -net_expenses
END IF
```

### 3.3 Expense Calculation

Expenses are calculated based on active events for the current year and indexed for inflation.

```
// Initialize all expense categories
expenses = {
  logement: 0,
  transport: 0,
  vie_courante: 0,
  loisirs: 0,
  sante: 0,
  famille: 0
}

// Process all events active in this year
FOR EACH event IN active_events_for_year:
  IF event.parameter_impacte IN expense_categories THEN
    // Get base value in today's dollars
    base_value = event.value
    
    // Index for inflation from base year to current year
    years_elapsed = current_year - base_year
    indexed_value = base_value * (1 + inflation)^years_elapsed
    
    // Add to appropriate category
    expenses[event.parameter_impacte] = indexed_value
  END IF
END FOR

total_annual_expenses = SUM(all expense categories)
```

### 3.4 Tax Calculation

#### 3.4.1 Taxable Income Determination
```
For each individual:
  taxable_income = 
    employment_income +
    rrq_income +
    psv_income +
    rrpe_income * pension_income_splitting_factor +  // Can split up to 50% with spouse
    reer_withdrawal +
    cri_withdrawal

  // Note: CELI withdrawals are NOT taxable
```

#### 3.4.2 Federal Tax Calculation
```
federal_tax = 0

FOR EACH tax_bracket IN federal_tax_brackets:
  IF taxable_income > bracket.threshold_low THEN
    taxable_in_bracket = MIN(
      bracket.threshold_high - bracket.threshold_low,
      taxable_income - bracket.threshold_low
    )
    federal_tax += taxable_in_bracket * bracket.rate
  END IF
END FOR
```

#### 3.4.3 Provincial Tax Calculation (Quebec)
```
quebec_tax = 0

FOR EACH tax_bracket IN quebec_tax_brackets:
  IF taxable_income > bracket.threshold_low THEN
    taxable_in_bracket = MIN(
      bracket.threshold_high - bracket.threshold_low,
      taxable_income - bracket.threshold_low
    )
    quebec_tax += taxable_in_bracket * bracket.rate
  END IF
END FOR
```

#### 3.4.4 Tax Credits
```
// Basic personal amount (federal)
federal_credits = basic_personal_amount * lowest_federal_rate

// Quebec personal amount
quebec_credits = basic_personal_amount_qc * lowest_quebec_rate

// Age credit (if 65+)
IF age >= 65 THEN
  federal_credits += age_credit_amount * lowest_federal_rate
  quebec_credits += age_credit_amount_qc * lowest_quebec_rate
END IF

// Pension income credit
IF rrpe_income > 0 OR (age >= 65 AND reer_withdrawal > 0) THEN
  federal_credits += MIN(2000, rrpe_income + reer_withdrawal) * lowest_federal_rate
  quebec_credits += MIN(2000, rrpe_income + reer_withdrawal) * lowest_quebec_rate
END IF

total_federal_tax = MAX(0, federal_tax - federal_credits)
total_quebec_tax = MAX(0, quebec_tax - quebec_credits)
```

#### 3.4.5 Total Tax
```
total_tax = total_federal_tax + total_quebec_tax
```

### 3.5 Asset Balance Updates

#### 3.5.1 REER/FERR Accounts
```
For each individual:
  // Starting balance
  beginning_balance = previous_year_ending_balance
  
  // Contributions (only if not retired)
  IF age < retirement_age THEN
    annual_contribution = monthly_contribution * 12
  ELSE
    annual_contribution = 0
  END IF
  
  // Investment growth
  investment_return = beginning_balance * rendement_reer
  
  // Withdrawals
  withdrawal = reer_withdrawal_for_individual
  
  // Ending balance
  ending_balance = beginning_balance + annual_contribution + investment_return - withdrawal
  
  // Cannot go negative
  ending_balance = MAX(0, ending_balance)
```

#### 3.5.2 CELI Account
```
// Starting balance
beginning_balance = previous_year_ending_balance

// Contributions (only if not retired)
IF both_individuals_not_retired THEN
  annual_contribution = monthly_contribution * 12
ELSE
  annual_contribution = 0
END IF

// Investment growth
investment_return = beginning_balance * rendement_investissement

// Withdrawals
withdrawal = celi_withdrawal

// Ending balance
ending_balance = beginning_balance + annual_contribution + investment_return - withdrawal

// Cannot go negative
ending_balance = MAX(0, ending_balance)
```

#### 3.5.3 CRI/FRV Account
```
// Starting balance
beginning_balance = previous_year_ending_balance

// Investment growth
investment_return = beginning_balance * rendement_investissement

// Withdrawals (mandatory minimum after certain age)
IF age >= 55 THEN
  minimum_withdrawal = calculate_cri_minimum_withdrawal(age, beginning_balance)
  actual_withdrawal = MAX(minimum_withdrawal, cri_withdrawal)
ELSE
  actual_withdrawal = 0
END IF

// Ending balance
ending_balance = beginning_balance + investment_return - actual_withdrawal

// Cannot go negative
ending_balance = MAX(0, ending_balance)
```

#### 3.5.4 Cash Account
```
// Starting balance
beginning_balance = previous_year_ending_balance

// Investment growth on existing balance
investment_return = beginning_balance * rendement_investissement

// Net cash flow (after all income, expenses, taxes, and other account transactions)
net_cash_flow = 
  (employment_income + government_pensions + rrpe_income) +
  celi_withdrawal +
  (reer_withdrawal + cri_withdrawal) * (1 - marginal_tax_rate) -
  total_expenses -
  total_tax -
  reer_contributions -
  celi_contributions

// Ending balance
ending_balance = beginning_balance + investment_return + net_cash_flow

// Cash account can go negative (represents debt/line of credit)
```

#### 3.5.5 Real Estate Value
```
// Determine current real estate holdings based on events
IF event_active("MAISON") THEN
  house_value = event_value("MAISON") * (1 + inflation)^years_elapsed
  condo_value = 0
ELSE IF event_active("CONDO") THEN
  house_value = 0
  condo_value = event_value("CONDO") * (1 + inflation)^years_elapsed
ELSE
  // In RPA - no real estate owned
  house_value = 0
  condo_value = 0
END IF

total_real_estate_value = house_value + condo_value
```

#### 3.5.6 Real Estate Transactions
```
// Check for real estate sale events in current year
IF event_type("VENTE_IMMO") active in current year THEN
  // Net proceeds from sale
  net_proceeds = event_value("VENTE_IMMO") * (1 + inflation)^years_elapsed
  
  // Add to cash account
  cash_account += net_proceeds
  
  // Reset appropriate real estate value to 0
END IF

// Check for real estate purchase events
IF event_type("ACHAT_IMMO") active in current year THEN
  purchase_price = event_value("ACHAT_IMMO") * (1 + inflation)^years_elapsed
  
  // Deduct from cash account
  cash_account -= purchase_price
END IF
```

### 3.6 Net Worth Calculation
```
total_net_worth = 
  reer1_balance +
  reer2_balance +
  celi_balance +
  cri_balance +
  cash_balance +  // Can be negative
  real_estate_value
```

---

## 4. Event Processing

### 4.1 Event Activation Logic
```
FOR EACH event IN project_events:
  is_active = false
  
  // Determine reference year based on time type
  IF event.time_type == "relative" THEN
    reference_year = base_year + event.start_time
    end_year = IF event.end_time IS NULL THEN 9999 ELSE base_year + event.end_time
  ELSE IF event.time_type == "age1" THEN
    reference_year = individual1_birth_year + event.start_time
    end_year = IF event.end_time IS NULL THEN 9999 ELSE individual1_birth_year + event.end_time
  ELSE IF event.time_type == "age2" THEN
    reference_year = individual2_birth_year + event.start_time
    end_year = IF event.end_time IS NULL THEN 9999 ELSE individual2_birth_year + event.end_time
  END IF
  
  // Check if current year falls within event window
  IF current_year >= reference_year AND current_year <= end_year THEN
    is_active = true
  END IF
END FOR
```

### 4.2 Event Priority
When multiple events affect the same parameter in the same year:
1. **Last-defined event takes precedence** (events defined later override earlier ones)
2. Events with more specific time ranges override broader ones
3. Document this behavior clearly for users

---

## 5. Output Specification

### 5.1 Projection Table Columns

The projection output should include the following columns for each year:

#### General Information
- **Year:** Calendar year (e.g., 2025, 2026, ...)
- **Age Individual 1:** Current age of individual 1
- **Age Individual 2:** Current age of individual 2

#### Income Sources
- **Employment Income - Individual 1:** Annual salary for individual 1
- **Employment Income - Individual 2:** Annual salary for individual 2
- **RRPE - Individual 1:** Employer pension for individual 1
- **RRPE - Individual 2:** Employer pension for individual 2
- **RRQ - Individual 1:** Quebec Pension Plan for individual 1
- **RRQ - Individual 2:** Quebec Pension Plan for individual 2
- **PSV - Individual 1:** Old Age Security for individual 1
- **PSV - Individual 2:** Old Age Security for individual 2
- **REER Withdrawal - Individual 1**
- **REER Withdrawal - Individual 2**
- **CELI Withdrawal**
- **CRI Withdrawal**
- **Cash Withdrawal**
- **Total Income:** Sum of all income sources

#### Expenses
- **Housing Expenses**
- **Transportation Expenses**
- **Daily Living Expenses**
- **Recreation Expenses**
- **Health Expenses**
- **Family & Gifts Expenses**
- **Total Expenses:** Sum of all expense categories

#### Taxes
- **Taxable Income:** Total taxable income for the household
- **Federal Tax**
- **Provincial Tax (Quebec)**
- **Tax Credits**
- **Total Tax:** Net tax payable

#### Cash Flow
- **Net Annual Cash Flow:** Total income - total expenses - total tax

#### Asset Balances (End of Year)
- **REER Balance - Individual 1**
- **REER Balance - Individual 2**
- **CELI Balance**
- **CRI Balance**
- **Cash Account Balance**
- **Real Estate Value:** Current value of house or condo
- **Total Net Worth:** Sum of all asset balances

### 5.2 Display Options

#### 5.2.1 Current Dollars vs. Constant Dollars

Users can toggle between two display modes:

**Current Dollars (Nominal)**
- All values shown as they will actually be in that year
- Includes the effect of inflation
- Shows actual dollar amounts for each year
- Default display mode

**Constant Dollars (Real)**
- All values adjusted back to base year purchasing power
- Removes the effect of inflation
- Makes it easier to compare across years
- Calculation: `constant_value = current_value / (1 + inflation)^(year - base_year)`

#### 5.2.2 Visualization Options

The projection data should support multiple visualization formats:
1. **Data Table:** Full year-by-year table with all columns
2. **Summary Charts:**
   - Income sources over time (stacked area chart)
   - Expense categories over time (stacked area chart)
   - Net worth evolution (line chart)
   - Cash flow by year (bar chart - showing positive/negative)
   - Asset allocation over time (stacked area chart)

### 5.3 Key Performance Indicators (KPIs)

Calculate and display these summary metrics:

#### 5.3.1 Plan Viability
```
// Years until cash depletion
years_covered = COUNT(years WHERE total_net_worth > 0)
plan_viable = (years_covered >= years_to_life_expectancy)
```

#### 5.3.2 Financial Metrics
- **Current Net Worth:** Total assets minus liabilities today
- **Projected Net Worth at Retirement:** Net worth when both individuals retire
- **Final Net Worth:** Net worth at end of projection
- **Average Annual Surplus/Deficit:** Average net cash flow across projection
- **Maximum Required Withdrawal:** Largest single-year withdrawal needed

#### 5.3.3 Tax Efficiency
- **Average Effective Tax Rate:** Total taxes / total income over entire projection
- **Total Taxes Paid:** Sum of all taxes over projection period

---

## 6. Validation Rules

### 6.1 Input Validation

Before running a projection, validate:

1. **Base Year:** Must be current year or future year
2. **Life Expectancy:** Must be greater than current age for both individuals
3. **Retirement Age:** Must be between 55 and 75
4. **Initial Asset Balances:** Must be non-negative
5. **Economic Rates:**
   - Inflation: 0% to 10%
   - Investment returns: -5% to 20%
   - Indexation rates: 0% to 5%

### 6.2 Calculation Warnings

Alert users when:

1. **Cash Account Goes Negative:** Indicates need for debt/line of credit
2. **Early Asset Depletion:** Assets run out before life expectancy
3. **High Tax Burden:** Effective tax rate > 40%
4. **PSV Clawback:** Income high enough to trigger PSV reduction
5. **Insufficient REER Balance:** Cannot meet withdrawal requirements

### 6.3 Edge Cases

#### 6.3.1 Death of One Individual
```
IF individual1_age > individual1_life_expectancy THEN
  // Stop individual 1's income sources
  individual1_employment = 0
  individual1_rrq = 0  // May have survivor benefits
  individual1_psv = 0
  individual1_rrpe = 0  // May have survivor benefits
  
  // Individual 2 may receive survivor benefits (typically 60% of deceased's pension)
  individual2_survivor_rrq = individual1_rrq * 0.6
  individual2_survivor_rrpe = individual1_rrpe * 0.6
  
  // Expenses may change (typically decrease)
  // This should be modeled via events
END IF
```

#### 6.3.2 Asset Depletion
```
IF any_account_balance < 0 (except cash) THEN
  // Force balance to 0
  // Increase cash account deficit
  cash_deficit += ABS(account_balance)
  account_balance = 0
END IF
```

#### 6.3.3 Event Conflicts
```
// If multiple events set the same parameter for the same year
// Use the last-defined event value
// Log a warning to the user
```

---


---

## 8. Special Calculations

### 8.1 CRI/FRV Minimum Withdrawal Calculation

Locked-in accounts have mandatory minimum withdrawals based on age:

```
// FRV/CRI minimum withdrawal percentages by age (Quebec rules)
minimum_percentages = {
  55: 0.0000,
  65: 0.0400,
  70: 0.0528,
  75: 0.0678,
  80: 0.0882,
  85: 0.1082,
  90: 0.1399,
  95: 0.2000
}

// Linear interpolation for ages between defined values
minimum_percentage = interpolate(age, minimum_percentages)
minimum_withdrawal = cri_balance * minimum_percentage
```

### 8.2 Pension Income Splitting

Canadian tax law allows splitting up to 50% of eligible pension income with a spouse:

```
// Eligible pension income includes RRPE and REER/FERR withdrawals (if age 65+)
individual1_eligible = individual1_rrpe + (individual1_age >= 65 ? individual1_reer_withdrawal : 0)
individual2_eligible = individual2_rrpe + (individual2_age >= 65 ? individual2_reer_withdrawal : 0)

// Calculate optimal split to minimize total household tax
optimal_split = calculate_optimal_pension_split(
  individual1_eligible,
  individual2_eligible,
  individual1_other_income,
  individual2_other_income,
  tax_brackets
)

// Apply split
individual1_taxable_pension = individual1_eligible * (1 - optimal_split)
individual2_taxable_pension = individual2_eligible * (1 + optimal_split)
```

### 8.3 Inflation Indexing

All monetary values must be indexed appropriately:

```
// For expenses and assets stored in "today's dollars"
indexed_value = base_value * (1 + inflation_rate)^(current_year - base_year)

// For government pensions (have their own indexation rate)
indexed_pension = base_pension * (1 + indexation_rrqpsv)^(years_since_start)

// For RRPE (has its own indexation rate)
indexed_rrpe = base_rrpe * (1 + indexation_rrpe)^(years_since_retirement)
```

---

## 9. User Interface Considerations

### 9.1 Projection Display
- Default view shows summary columns (year, ages, total income, total expenses, tax, net worth)
- Expandable sections for detailed breakdown of income sources and expense categories
- Highlight years with warnings or important events
- Allow hiding of zero-value columns

### 9.2 Interactivity
- Click on any year to see detailed breakdown
- Hover tooltips showing calculation details
- Ability to export projection to CSV/Excel
- Print-friendly formatting option

### 9.3 Scenario Comparison
- Side-by-side comparison of multiple scenarios
- Difference highlighting (show what changed and by how much)
- Charts overlaying multiple scenarios

---

---

