# Project JSON Import Reference Guide

This document provides a complete reference for creating valid project JSON files for import into the retirement planning application.

## Table of Contents
1. [File Structure Overview](#file-structure-overview)
2. [Project Section](#project-section)
3. [Assets Section](#assets-section)
4. [Events Section](#events-section)
5. [Expenses Section](#expenses-section)
6. [Scenarios Section](#scenarios-section)
7. [Common Patterns](#common-patterns)
8. [Complete Example](#complete-example)

---

## File Structure Overview

```json
{
  "exportVersion": "1.2",
  "exportedAt": "2025-10-14T16:30:00.000Z",
  "project": { ... },
  "assets": [ ... ],
  "events": [ ... ],
  "expenses": [ ... ],
  "scenarios": [ ... ]
}
```

### Top-Level Fields
- `exportVersion`: String - Always "1.2" (current version)
- `exportedAt`: ISO 8601 timestamp string
- `project`: Object - Project metadata and parameters
- `assets`: Array - List of financial assets
- `events`: Array - List of lifecycle events
- `expenses`: Array - List of expense categories
- `scenarios`: Array - List of planning scenarios

---

## Project Section

### Structure
```json
{
  "id": "unique-project-id",
  "name": "Project Name",
  "description": "Project description text",
  "createdAt": "2025-10-14T16:30:00.000Z",
  "updatedAt": "2025-10-14T16:30:00.000Z",
  "individuals": [ ... ],
  "projectionStartYear": 2025,
  "projectionEndYear": 2091,
  "inflationRate": 0.025,
  "defaultReturnRate": 0.055
}
```

### Field Details

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `id` | String | Yes | Unique project identifier | "my-project-2025" |
| `name` | String | Yes | Project display name | "André & Anne - Retirement Plan" |
| `description` | String | Yes | Detailed description | "Couple's retirement plan..." |
| `createdAt` | String | Yes | ISO 8601 timestamp | "2025-10-14T16:30:00.000Z" |
| `updatedAt` | String | Yes | ISO 8601 timestamp | "2025-10-14T16:30:00.000Z" |
| `individuals` | Array | Yes | List of individuals (1-2) | See below |
| `projectionStartYear` | Number | Yes | Starting year (e.g., 2025) | 2025 |
| `projectionEndYear` | Number | Yes | Ending year | 2091 |
| `inflationRate` | Number | Yes | Annual inflation rate (decimal) | 0.025 (2.5%) |
| `defaultReturnRate` | Number | Yes | Default investment return (decimal) | 0.055 (5.5%) |

### Individual Structure
```json
{
  "id": "unique-individual-id",
  "name": "Person Name",
  "birthdate": "1967-01-30",
  "currentAnnualIncome": 312000.0,
  "rrqAnnualBenefit": 16140.0,
  "psvEligibilityAge": 65,
  "initialCeliRoom": 95000.0
}
```

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `id` | String | Yes | Unique individual identifier | "andre" |
| `name` | String | Yes | Full name | "André Boisvert" |
| `birthdate` | String | Yes | Date in YYYY-MM-DD format | "1967-01-30" |
| `currentAnnualIncome` | Number | Yes | Annual employment income | 312000.0 |
| `rrqAnnualBenefit` | Number | Yes | RRQ monthly benefit × 12 | 16140.0 |
| `psvEligibilityAge` | Number | Yes | PSV eligibility age (usually 65) | 65 |
| `initialCeliRoom` | Number | Yes | CELI contribution room | 95000.0 |

---

## Assets Section

### Asset Types
The app supports 5 asset types, each with different required fields:
1. **realEstate** - Real estate properties
2. **rrsp** - REER/RRSP accounts
3. **celi** - CELI/TFSA accounts
4. **cri** - CRI/LIRA accounts
5. **cash** - Cash accounts

### 1. Real Estate Asset
```json
{
  "runtimeType": "realEstate",
  "id": "house-vmr",
  "type": "house",
  "value": 1500000.0,
  "setAtStart": true,
  "customReturnRate": 0.025
}
```

| Field | Type | Required | Description | Valid Values |
|-------|------|----------|-------------|--------------|
| `runtimeType` | String | Yes | Must be "realEstate" | "realEstate" |
| `id` | String | Yes | Unique asset identifier | "house-vmr" |
| `type` | String | Yes | Property type | "house", "condo", "cottage", "land", "commercial", "other" |
| `value` | Number | Yes | Current market value | 1500000.0 |
| `setAtStart` | Boolean | No | Exists at projection start (default: true) | true, false |
| `customReturnRate` | Number | No | Annual appreciation rate (default: inflation) | 0.025 |

### 2. RRSP/REER Account
```json
{
  "runtimeType": "rrsp",
  "id": "rrsp-andre",
  "individualId": "andre",
  "value": 592099.68,
  "customReturnRate": 0.0609,
  "annualContribution": 10512.0
}
```

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `runtimeType` | String | Yes | Must be "rrsp" | "rrsp" |
| `id` | String | Yes | Unique asset identifier | "rrsp-andre" |
| `individualId` | String | Yes | Owner's individual ID | "andre" |
| `value` | Number | Yes | Current account balance | 592099.68 |
| `customReturnRate` | Number | No | Annual return rate | 0.0609 (6.09%) |
| `annualContribution` | Number | No | Annual contribution amount | 10512.0 |

### 3. CELI/TFSA Account
```json
{
  "runtimeType": "celi",
  "id": "celi-joint",
  "individualId": "andre",
  "value": 34005.68,
  "customReturnRate": 0.0609,
  "annualContribution": 12600.0
}
```

**Note**: Use `"celi"` (French), NOT `"tfsa"` (English)

Fields are identical to RRSP accounts.

### 4. CRI/LIRA Account
```json
{
  "runtimeType": "cri",
  "id": "cri-andre",
  "individualId": "andre",
  "value": 53494.30,
  "customReturnRate": 0.0609,
  "contributionRoom": 0.0,
  "annualContribution": 0.0
}
```

**Note**: Use `"cri"` (French), NOT `"lira"` (English)

| Field | Type | Required | Description | Example |
|-------|------|----------|-------------|---------|
| `runtimeType` | String | Yes | Must be "cri" | "cri" |
| `id` | String | Yes | Unique asset identifier | "cri-andre" |
| `individualId` | String | Yes | Owner's individual ID | "andre" |
| `value` | Number | Yes | Current account balance | 53494.30 |
| `contributionRoom` | Number | No | Available contribution room | 0.0 |
| `customReturnRate` | Number | No | Annual return rate | 0.0609 |
| `annualContribution` | Number | No | Annual contribution amount | 0.0 |

### 5. Cash Account
```json
{
  "runtimeType": "cash",
  "id": "cash-main",
  "individualId": "andre",
  "value": 50000.0,
  "customReturnRate": 0.02,
  "annualContribution": 0.0
}
```

Fields are identical to RRSP accounts.

### Important Notes
- ⚠️ Use `value` NOT `currentValue`
- ⚠️ Use `individualId` NOT `owner`
- ⚠️ Contributions are ANNUAL amounts (not monthly)
- ⚠️ Rates are decimals (0.025 = 2.5%, not 2.5)
- ⚠️ Use French type names: `celi`, `cri` (not `tfsa`, `lira`)

---

## Events Section

### Event Types
The app supports 3 event types:
1. **retirement** - Individual retires
2. **death** - Individual passes away
3. **realEstateTransaction** - Buy/sell property

### Event Timing Types
All events use an `EventTiming` structure with 5 possible types:

#### 1. Relative Timing
Years from projection start:
```json
{
  "runtimeType": "relative",
  "yearsFromStart": 5
}
```

#### 2. Absolute Timing
Specific calendar year:
```json
{
  "runtimeType": "absolute",
  "calendarYear": 2027
}
```

#### 3. Age-Based Timing
When individual reaches specific age:
```json
{
  "runtimeType": "age",
  "individualId": "andre",
  "age": 62
}
```

#### 4. Event-Relative Timing
Tied to another event:
```json
{
  "runtimeType": "eventRelative",
  "eventId": "retirement-anne",
  "boundary": "start"
}
```

**Important**: Use `boundary` (NOT `offsetYears`)
- Valid values: `"start"` or `"end"`

#### 5. Projection End Timing
Continues to end of projection:
```json
{
  "runtimeType": "projectionEnd"
}
```

### 1. Retirement Event
```json
{
  "runtimeType": "retirement",
  "id": "retirement-andre",
  "individualId": "andre",
  "timing": {
    "runtimeType": "age",
    "individualId": "andre",
    "age": 62
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `runtimeType` | String | Yes | Must be "retirement" |
| `id` | String | Yes | Unique event identifier |
| `individualId` | String | Yes | Who is retiring |
| `timing` | Object | Yes | EventTiming structure |

### 2. Death Event
```json
{
  "runtimeType": "death",
  "id": "death-andre",
  "individualId": "andre",
  "timing": {
    "runtimeType": "age",
    "individualId": "andre",
    "age": 91
  }
}
```

Fields are identical to retirement events.

### 3. Real Estate Transaction Event
```json
{
  "runtimeType": "realEstateTransaction",
  "id": "sell-house-buy-condo",
  "timing": {
    "runtimeType": "age",
    "individualId": "andre",
    "age": 70
  },
  "assetSoldId": "house-vmr",
  "assetPurchasedId": "condo-montreal",
  "withdrawAccountId": "cash-main",
  "depositAccountId": "cash-main"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `runtimeType` | String | Yes | Must be "realEstateTransaction" |
| `id` | String | Yes | Unique event identifier |
| `timing` | Object | Yes | EventTiming structure |
| `assetSoldId` | String | No | Asset being sold (can be null) |
| `assetPurchasedId` | String | No | Asset being purchased (can be null) |
| `withdrawAccountId` | String | Yes | Cash account for transaction |
| `depositAccountId` | String | Yes | Cash account for proceeds/costs |

**Important Notes**:
- At least one of `assetSoldId` or `assetPurchasedId` must be provided
- Both accounts typically reference the same cash account
- Assets must already exist in the assets array
- If purchasing, the asset must have `"setAtStart": false`

---

## Expenses Section

### Expense Categories
The app has 6 expense categories (French names):

1. **housing** - Housing costs
2. **transport** - Transportation
3. **dailyLiving** - Daily living expenses
4. **recreation** - Recreation and travel
5. **health** - Health expenses
6. **family** - Family expenses

### Expense Structure
```json
{
  "runtimeType": "housing",
  "id": "housing-house",
  "name": "Logement - Maison",
  "annualAmount": 23100.0,
  "startTiming": {
    "runtimeType": "relative",
    "yearsFromStart": 0
  },
  "endTiming": {
    "runtimeType": "eventRelative",
    "eventId": "sell-house",
    "boundary": "start"
  }
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `runtimeType` | String | Yes | Expense category (see list above) |
| `id` | String | Yes | Unique expense identifier |
| `name` | String | Yes | Display name |
| `annualAmount` | Number | Yes | Annual expense amount |
| `startTiming` | Object | Yes | EventTiming structure |
| `endTiming` | Object | Yes | EventTiming structure |

### Expense Timing Examples

**Continuous expense (entire projection):**
```json
{
  "runtimeType": "dailyLiving",
  "id": "daily-base",
  "name": "Daily living expenses",
  "annualAmount": 72000.0,
  "startTiming": {
    "runtimeType": "relative",
    "yearsFromStart": 0
  },
  "endTiming": {
    "runtimeType": "projectionEnd"
  }
}
```

**Expense tied to events:**
```json
{
  "runtimeType": "recreation",
  "id": "travel-active",
  "name": "Travel - Active years",
  "annualAmount": 40000.0,
  "startTiming": {
    "runtimeType": "eventRelative",
    "eventId": "retirement-anne",
    "boundary": "start"
  },
  "endTiming": {
    "runtimeType": "age",
    "individualId": "andre",
    "age": 75
  }
}
```

**Fixed duration expense:**
```json
{
  "runtimeType": "family",
  "id": "grandchild-1",
  "name": "Grandchild 1 education",
  "annualAmount": 3000.0,
  "startTiming": {
    "runtimeType": "relative",
    "yearsFromStart": 5
  },
  "endTiming": {
    "runtimeType": "relative",
    "yearsFromStart": 23
  }
}
```

---

## Scenarios Section

### Scenario Structure
```json
{
  "id": "base-scenario",
  "name": "Base Scenario",
  "isBase": true,
  "overrides": [],
  "createdAt": "2025-10-14T16:30:00.000Z",
  "updatedAt": "2025-10-14T16:30:00.000Z"
}
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | String | Yes | Unique scenario identifier |
| `name` | String | Yes | Display name |
| `isBase` | Boolean | Yes | Is this the base scenario? |
| `overrides` | Array | Yes | List of parameter overrides (can be empty) |
| `createdAt` | String | Yes | ISO 8601 timestamp |
| `updatedAt` | String | Yes | ISO 8601 timestamp |

**Important Notes**:
- There should be exactly ONE scenario with `"isBase": true`
- For basic imports, use an empty `overrides` array: `[]`
- Timestamps must be in ISO 8601 format: `"YYYY-MM-DDTHH:mm:ss.sssZ"`

### Parameter Overrides (Advanced)

Overrides allow scenarios to modify base parameters. Types:

#### 1. Asset Value Override
```json
{
  "runtimeType": "assetValue",
  "assetId": "house-vmr",
  "overrideValue": 1800000.0
}
```

#### 2. Event Timing Override
```json
{
  "runtimeType": "eventTiming",
  "eventId": "retirement-andre",
  "overrideTiming": {
    "runtimeType": "age",
    "individualId": "andre",
    "age": 65
  }
}
```

#### 3. Expense Amount Override
```json
{
  "runtimeType": "expenseAmount",
  "expenseId": "travel-active",
  "overrideAmount": 60000.0,
  "amountMultiplier": null
}
```

#### 4. Expense Timing Override
```json
{
  "runtimeType": "expenseTiming",
  "expenseId": "travel-active",
  "overrideStartTiming": {
    "runtimeType": "age",
    "individualId": "andre",
    "age": 60
  },
  "overrideEndTiming": null
}
```

---

## Common Patterns

### Pattern 1: Couple with Two Retirements
```json
{
  "individuals": [
    {
      "id": "person1",
      "name": "Person 1",
      "birthdate": "1967-01-30",
      ...
    },
    {
      "id": "person2",
      "name": "Person 2",
      "birthdate": "1967-01-19",
      ...
    }
  ],
  "events": [
    {
      "runtimeType": "retirement",
      "id": "retirement-person1",
      "individualId": "person1",
      "timing": { "runtimeType": "age", "individualId": "person1", "age": 62 }
    },
    {
      "runtimeType": "retirement",
      "id": "retirement-person2",
      "individualId": "person2",
      "timing": { "runtimeType": "age", "individualId": "person2", "age": 60 }
    }
  ]
}
```

### Pattern 2: Housing Transition (House → Condo → RPA)
```json
{
  "assets": [
    {
      "runtimeType": "realEstate",
      "id": "house",
      "type": "house",
      "value": 1500000.0,
      "setAtStart": true
    },
    {
      "runtimeType": "realEstate",
      "id": "condo",
      "type": "condo",
      "value": 800000.0,
      "setAtStart": false
    }
  ],
  "events": [
    {
      "runtimeType": "realEstateTransaction",
      "id": "sell-house-buy-condo",
      "timing": { "runtimeType": "age", "individualId": "person1", "age": 70 },
      "assetSoldId": "house",
      "assetPurchasedId": "condo",
      "withdrawAccountId": "cash",
      "depositAccountId": "cash"
    },
    {
      "runtimeType": "realEstateTransaction",
      "id": "sell-condo",
      "timing": { "runtimeType": "age", "individualId": "person1", "age": 78 },
      "assetSoldId": "condo",
      "withdrawAccountId": "cash",
      "depositAccountId": "cash"
    }
  ],
  "expenses": [
    {
      "runtimeType": "housing",
      "id": "housing-house",
      "name": "House costs",
      "annualAmount": 23100.0,
      "startTiming": { "runtimeType": "relative", "yearsFromStart": 0 },
      "endTiming": { "runtimeType": "eventRelative", "eventId": "sell-house-buy-condo", "boundary": "start" }
    },
    {
      "runtimeType": "housing",
      "id": "housing-condo",
      "name": "Condo costs",
      "annualAmount": 13248.0,
      "startTiming": { "runtimeType": "eventRelative", "eventId": "sell-house-buy-condo", "boundary": "start" },
      "endTiming": { "runtimeType": "eventRelative", "eventId": "sell-condo", "boundary": "start" }
    },
    {
      "runtimeType": "housing",
      "id": "housing-rpa",
      "name": "RPA rent",
      "annualAmount": 75648.0,
      "startTiming": { "runtimeType": "eventRelative", "eventId": "sell-condo", "boundary": "start" },
      "endTiming": { "runtimeType": "projectionEnd" }
    }
  ]
}
```

### Pattern 3: Age-Based Expense Transitions
```json
{
  "expenses": [
    {
      "runtimeType": "health",
      "id": "health-65-75",
      "name": "Health 65-75",
      "annualAmount": 4000.0,
      "startTiming": { "runtimeType": "age", "individualId": "person1", "age": 65 },
      "endTiming": { "runtimeType": "age", "individualId": "person1", "age": 75 }
    },
    {
      "runtimeType": "health",
      "id": "health-75plus",
      "name": "Health 75+",
      "annualAmount": 8500.0,
      "startTiming": { "runtimeType": "age", "individualId": "person1", "age": 75 },
      "endTiming": { "runtimeType": "projectionEnd" }
    }
  ]
}
```

### Pattern 4: Converting Monthly to Annual Contributions
If you have monthly contribution amounts, convert to annual:

```javascript
// Monthly amounts from source data
const monthlyRRSP = 876;
const monthlyCELI = 1050;

// Convert to annual (multiply by 12)
const annualRRSP = monthlyRRSP * 12;  // 10512
const annualCELI = monthlyCELI * 12;  // 12600
```

```json
{
  "runtimeType": "rrsp",
  "annualContribution": 10512.0
}
```

---

## Common Mistakes to Avoid

### ❌ Wrong Field Names
```json
// WRONG
{
  "currentValue": 100000,
  "owner": "andre",
  "monthlyContribution": 500
}

// CORRECT
{
  "value": 100000,
  "individualId": "andre",
  "annualContribution": 6000
}
```

### ❌ Wrong Asset Type Names
```json
// WRONG
{ "runtimeType": "tfsa" }
{ "runtimeType": "lira" }

// CORRECT
{ "runtimeType": "celi" }
{ "runtimeType": "cri" }
```

### ❌ Missing Required Fields
```json
// WRONG - Real estate missing 'type'
{
  "runtimeType": "realEstate",
  "id": "house",
  "value": 1500000
}

// CORRECT
{
  "runtimeType": "realEstate",
  "id": "house",
  "type": "house",
  "value": 1500000
}
```

### ❌ Wrong Event Timing Structure
```json
// WRONG - Using offsetYears
{
  "runtimeType": "eventRelative",
  "eventId": "retirement",
  "offsetYears": 0
}

// CORRECT - Using boundary
{
  "runtimeType": "eventRelative",
  "eventId": "retirement",
  "boundary": "start"
}
```

### ❌ Missing Scenario Timestamps
```json
// WRONG
{
  "id": "base",
  "name": "Base",
  "isBase": true,
  "overrides": []
}

// CORRECT
{
  "id": "base",
  "name": "Base",
  "isBase": true,
  "overrides": [],
  "createdAt": "2025-10-14T16:30:00.000Z",
  "updatedAt": "2025-10-14T16:30:00.000Z"
}
```

### ❌ Rates as Percentages Instead of Decimals
```json
// WRONG
{
  "inflationRate": 2.5,
  "customReturnRate": 6.09
}

// CORRECT
{
  "inflationRate": 0.025,
  "customReturnRate": 0.0609
}
```

---

## Validation Checklist

Before importing, verify:

### Project Section
- [ ] All required fields present
- [ ] Individuals have unique IDs
- [ ] Birthdates in YYYY-MM-DD format
- [ ] Rates are decimals (0.025, not 2.5)
- [ ] Start year < End year

### Assets Section
- [ ] All assets have unique IDs
- [ ] Using correct type names: `celi`, `cri` (not `tfsa`, `lira`)
- [ ] Using `value` (not `currentValue`)
- [ ] Using `individualId` (not `owner`)
- [ ] Real estate has `type` field
- [ ] Contributions are annual (not monthly)
- [ ] Assets purchased later have `"setAtStart": false`

### Events Section
- [ ] All events have unique IDs
- [ ] Event timing structures are valid
- [ ] Using `boundary` (not `offsetYears`) for eventRelative
- [ ] Referenced individualIds exist
- [ ] Referenced eventIds exist
- [ ] Real estate transactions reference existing assets

### Expenses Section
- [ ] All expenses have unique IDs
- [ ] Using correct category names
- [ ] Start and end timing are valid
- [ ] Amounts are annual
- [ ] Referenced eventIds and individualIds exist

### Scenarios Section
- [ ] Exactly one scenario has `"isBase": true`
- [ ] All scenarios have timestamps
- [ ] Timestamps in ISO 8601 format
- [ ] Override references point to existing IDs

---

## Complete Example

See `andre_anne_retirement_plan.json` in the project root for a complete, validated example covering:
- Couple with different retirement ages
- Multiple asset types (house, condo, RRSP, CELI, CRI, cash)
- Real estate transitions
- 12 expense categories with various timing patterns
- Event-relative and age-based timing
- Base scenario with no overrides

---

## Troubleshooting

### Import Fails with "Unknown asset type"
- Check that you're using French type names: `celi`, `cri`
- Verify `runtimeType` field matches exactly (case-sensitive)

### Import Fails with "Type 'Null' is not a subtype"
- A required field is missing
- Check error message for field name and line number
- Compare against this reference guide

### Import Fails with "Invalid argument"
- An enum value is incorrect
- Check valid values for fields like `type`, `boundary`
- Ensure exact case match ("start" not "Start")

### Real Estate Transaction Fails
- Verify both `assetSoldId` and `assetPurchasedId` exist in assets array
- Check that purchased assets have `"setAtStart": false`
- Ensure both account IDs reference cash accounts

### Timing Validation Fails
- Verify all referenced IDs exist
- Check timing type structure matches exactly
- For eventRelative, use `boundary` not `offsetYears`

---

## Version History

- **1.2** (Current) - Added expense support
- **1.1** - Added scenario overrides
- **1.0** - Initial format

---

**Last Updated**: 2025-10-14
**Based on**: Retire1 App v2.0 (Phase 32 complete)
