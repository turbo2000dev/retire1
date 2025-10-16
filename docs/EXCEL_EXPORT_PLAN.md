# Server-Side Excel Generation Implementation Plan

## Overview
Migrate from client-side CSV export to server-side Excel (.xlsx) generation using Python XlsxWriter on Firebase Cloud Functions.

## Status: Phase 3 Complete ✅ | Ready for Testing

---

## Phase 1: Firebase Cloud Functions Setup (Python) ✅
**Objective**: Set up Python Cloud Functions infrastructure

### Step 1.1: Initialize Firebase Functions ✅
- [x] Install Firebase CLI tools
- [x] Initialize Cloud Functions in project (`firebase init functions`)
- [x] Choose Python as runtime
- [x] Create functions directory structure

### Step 1.2: Create Basic Excel Generation Function ✅
- [x] Create `generate_projection_excel` HTTP function
- [x] Add XlsxWriter to `requirements.txt`
- [x] Implement basic function that accepts JSON and returns "Hello World"
- [x] Test deployment and invocation

**Design Decisions Made**:
- **Authentication**: Using CORS headers for web access, will add Firebase Auth validation in Phase 3
- **Request payload**: JSON with `projection`, `scenarioName`, and `assets` fields
- **Response format**: Will return Excel file directly as binary response (decided in Phase 2)
- **Runtime**: Python 3.11 chosen for latest features and stability

**Testing**: ✅ Successfully deployed and tested with curl - function returns expected JSON response

**Function URL**: https://us-central1-retire1-1a558.cloudfunctions.net/generate_projection_excel

---

## Phase 2: Simple Excel Generation (Single Tab) ✅
**Objective**: Generate basic Excel file with projection data

### Step 2.1: Create Data Models ✅
- [x] Define Python dataclasses for Projection, YearlyProjection, etc.
- [x] Create JSON-to-model deserialization logic
- [x] Validate incoming data structure

### Step 2.2: Implement Basic Excel Generator ✅
- [x] Create single "Projection" worksheet
- [x] Add headers (Year, Ages, Income, Expenses, etc.)
- [x] Populate data rows
- [x] Apply basic number formatting (currency, percentages)
- [x] Return Excel file as HTTP response

**Design Decisions Made**:
- **Column order**: Matches CSV export exactly (Year, Ages, Income sources, Expenses, Taxes, Cash flow, Withdrawals, Contributions, Balances, Net worth, Shortfall)
- **Number format**: `#,##0` for currency (no decimals), `0` for years/ages
- **Negative numbers**: Red font color for negative cash flow values
- **Headers**: Blue background (#4472C4), white text, bold, centered
- **Column widths**: Year=6, Ages=8, all others=16 characters
- **Freeze panes**: Top row (headers) frozen for scrolling

**Testing**: Deployed successfully - ready to test from Flutter (Phase 3)

---

## Phase 3: Flutter Integration (Download Only) ✅
**Objective**: Connect Flutter app to Cloud Function

### Step 3.1: Create Excel Export Service ✅
- [x] Create `ExcelExportService` in Flutter
- [x] Add `cloud_functions` package dependency
- [x] Implement `exportToExcel()` method that calls Cloud Function
- [x] Serialize Projection + Assets + Project data to JSON

### Step 3.2: Update UI ✅
- [x] Add Excel export button to projection screen (kept CSV as fallback)
- [x] Add loading indicator during generation
- [x] Handle errors gracefully
- [x] Download file using platform-specific approach (dart:html for web)

**Design Decisions Made**:
- **Keep CSV export**: Yes, as OutlinedButton (secondary style), Excel as FilledButton (primary)
- **Loading UX**: SnackBar with CircularProgressIndicator and "Generating Excel file..." message (30s duration)
- **Error handling**: Try-catch with SnackBar showing error message
- **Download approach**: Direct HTTP POST to Cloud Function URL, receive blob response, trigger download via anchor element
- **Button placement**: Both buttons in Detailed tab action bar

**Testing**: Ready to test from Flutter web app - click "Export Excel" button in Detailed view

---

## Phase 4: Advanced Formatting & Grouping 🎨
**Objective**: Add collapsible columns, colors, and formatting

### Step 4.1: Implement Column Grouping
- [ ] Group Income columns (Employment, RRQ, PSV, RRPE, Other → Total)
- [ ] Group Expense columns by category
- [ ] Group Withdrawal columns by account type
- [ ] Group Balance columns by account type
- [ ] Make sub-columns collapsible (level=1, hidden=False)

### Step 4.2: Apply Professional Formatting
- [ ] Header row: Bold, colored background, frozen pane
- [ ] Alternating row colors for readability
- [ ] Currency formatting with thousand separators
- [ ] Conditional formatting (negative cash flow = red)
- [ ] Border styling for sections

**Design Decision Point**:
- Color scheme (professional, accessible)
- Which columns should be initially collapsed
- Conditional formatting rules

**Testing**: Open file, verify grouping works, check formatting

---

## Phase 5: Multiple Tabs & Freeze Panes 📑
**Objective**: Create multi-tab workbook with easy navigation

### Step 5.1: Create Tab Structure
- [ ] **Tab 1**: Summary/Parameters (Project info, individuals, key assumptions)
- [ ] **Tab 2**: Detailed Projection (current detailed view)
- [ ] **Tab 3**: Base Projection (simplified view, key metrics only)
- [ ] **Tab 4**: Charts (optional - net worth over time, income breakdown)

### Step 5.2: Implement Freeze Panes
- [ ] Freeze top row (headers) on all tabs
- [ ] Freeze first 3 columns (Year, Age 1, Age 2) on projection tabs
- [ ] Add split panes on Summary tab if needed

**Design Decision Point**:
- Tab naming convention (English/French bilingual?)
- Summary tab layout
- Which metrics for Base projection
- Chart types and data ranges

**Testing**: Navigate between tabs, verify freeze panes work correctly

---

## Phase 6: Auto-Open Functionality 🚀
**Objective**: Automatically open Excel file after download

### Step 6.1: Implement Platform-Specific Opening
- [ ] **Web**: Set proper MIME type, use `target="_blank"` approach
- [ ] **Mobile**: Add `open_file` package, call `OpenFile.open(filePath)`
- [ ] **Desktop**: Use `url_launcher` or `open_file` for system default app

### Step 6.2: Add User Preference
- [ ] Add setting: "Auto-open Excel files" (default: true)
- [ ] Store in user preferences
- [ ] Show one-time explanation dialog

**Design Decision Point**:
- Should auto-open be default behavior?
- Fallback if auto-open fails (show manual open button)
- User education/onboarding

**Testing**: Test on all platforms (Web, iOS, Android, macOS, Windows)

---

## Phase 7: Performance Optimization ⚡
**Objective**: Ensure fast generation for large datasets

### Step 7.1: Optimize Data Transfer
- [ ] Send only necessary data to Cloud Function
- [ ] Use gzip compression for request/response
- [ ] Implement caching strategy for repeated exports

### Step 7.2: Optimize Excel Generation
- [ ] Use `workbook.constant_memory` mode for large files
- [ ] Optimize formatting (reuse format objects)
- [ ] Add generation time logging/monitoring

**Design Decision Point**:
- Cache duration for generated files
- When to regenerate vs serve cached version
- File size limits and compression

**Testing**: Load test with 40-year projections, measure generation time

---

## Phase 8: Charts & Graphs Tab 📊
**Objective**: Add visual charts to workbook

### Step 8.1: Implement Charts
- [ ] Net Worth over time (line chart)
- [ ] Income breakdown by source (stacked area chart)
- [ ] Expense breakdown by category (pie chart)
- [ ] Asset allocation over time (stacked area chart)

### Step 8.2: Chart Formatting
- [ ] Professional styling (colors, legends, titles)
- [ ] Proper axis labels with currency formatting
- [ ] Chart positioning and sizing

**Design Decision Point**:
- Which charts are most valuable
- Chart styles and colors
- Static vs dynamic ranges

**Testing**: Open Charts tab, verify data accuracy and visual appeal

---

## Phase 9: Scenario Comparison Support 🔄
**Objective**: Export multiple scenarios in one workbook

### Step 9.1: Multi-Scenario Export
- [ ] Add "Export All Scenarios" option
- [ ] Create separate tab for each scenario
- [ ] Add comparison summary tab

### Step 9.2: Comparison Features
- [ ] Side-by-side KPI comparison table
- [ ] Difference highlighting (conditional formatting)
- [ ] Cross-scenario charts

**Design Decision Point**:
- Tab naming for multiple scenarios
- Layout of comparison summary
- Maximum number of scenarios to include

**Testing**: Export 2-3 scenarios, verify comparison accuracy

---

## Phase 10: Polish & Documentation 📝
**Objective**: Finalize implementation and document

### Step 10.1: Error Handling & Validation
- [ ] Comprehensive input validation
- [ ] User-friendly error messages
- [ ] Retry logic for network failures
- [ ] Timeout handling

### Step 10.2: Documentation
- [ ] Update user documentation
- [ ] Add inline help/tooltips
- [ ] Create sample exported files
- [ ] Document Cloud Functions deployment

**Testing**: Final end-to-end testing on all platforms

---

## Implementation Notes

### Firebase Setup Commands
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize functions
firebase init functions
# Select: Python
# Select: Use existing project (retire1-1a558)

# Deploy
firebase deploy --only functions
```

### Project Structure
```
functions/
├── requirements.txt          # XlsxWriter, firebase-admin, etc.
├── main.py                   # Function definitions
├── excel_generator.py        # Excel generation logic
├── models.py                 # Data models
└── formatters.py             # Formatting utilities
```

### Key Dependencies
- **Python**: XlsxWriter, firebase-admin, flask (for HTTP functions)
- **Flutter**: cloud_functions, open_file, url_launcher

### Estimated Timeline
- Phases 1-3: 2-3 days (basic functionality)
- Phases 4-5: 2-3 days (formatting & tabs)
- Phases 6-7: 1-2 days (auto-open & performance)
- Phases 8-9: 2-3 days (charts & scenarios)
- Phase 10: 1 day (polish)

**Total: ~10-12 days of development**

---

## Decision Log

### Phase 1 Decisions ✅
- **Runtime**: Python 3.11 selected for Cloud Functions
- **Directory structure**: Created `functions/` directory with `main.py`, `requirements.txt`, `.gitignore`
- **Dependencies**: firebase-functions>=0.4.0, firebase-admin>=6.0.0, XlsxWriter>=3.1.0
- **CORS**: Enabled for all origins (`*`) to support Flutter web client
- **Deployment region**: us-central1 (Firebase default)
- **Function name**: `generate_projection_excel`

### Phase 2 Decisions ✅
- **Data models**: Created Python dataclasses mirroring Dart/Freezed models
- **Deserialization**: `from_dict()` class methods for JSON parsing
- **Excel library**: XlsxWriter with in-memory BytesIO buffer
- **Response format**: Direct binary response with proper MIME type (`application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`)
- **Filename**: `projection_{scenario-name}_{date}.xlsx` with Content-Disposition header
- **Asset categorization**: Build asset type map from assets array for withdrawal/balance categorization
- **Error handling**: Comprehensive try-catch with detailed logging

### Phase 3 Decisions ✅
- **Package**: cloud_functions v5.6.2 added to dependencies
- **Service location**: Created `lib/features/projection/service/projection_excel_export.dart`
- **HTTP approach**: Direct HTTP call using dart:html HttpRequest (not httpsCallable) for blob response
- **Function URL**: Hardcoded Cloud Run URL (https://generate-projection-excel-zljvaxltlq-uc.a.run.app)
- **Response handling**: Blob response type, create object URL, trigger anchor download, revoke URL
- **Button styling**: Excel = primary (FilledButton), CSV = secondary (OutlinedButton)

---

## Progress Tracking

| Phase | Status | Started | Completed | Notes |
|-------|--------|---------|-----------|-------|
| Phase 1 | ✅ Complete | 2025-10-16 | 2025-10-16 | Firebase setup complete, function deployed |
| Phase 2 | ✅ Complete | 2025-10-16 | 2025-10-16 | Excel generator working, ready to integrate with Flutter |
| Phase 3 | ✅ Complete | 2025-10-16 | 2025-10-16 | Flutter integration complete, ready to test |
| Phase 4 | 📋 Pending | - | - | - |
| Phase 5 | 📋 Pending | - | - | - |
| Phase 6 | 📋 Pending | - | - | - |
| Phase 7 | 📋 Pending | - | - | - |
| Phase 8 | 📋 Pending | - | - | - |
| Phase 9 | 📋 Pending | - | - | - |
| Phase 10 | 📋 Pending | - | - | - |
