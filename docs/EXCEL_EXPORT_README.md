# Excel Export Feature

## Overview

The Excel Export feature allows users to export their retirement projection data to professional, formatted Excel (.xlsx) files. The export is handled by a Firebase Cloud Function that generates comprehensive workbooks with multiple tabs, charts, and advanced formatting.

## Features

### Single Scenario Export

Export a single projection scenario with:
- **Summary Tab**: Key metrics and projection parameters
- **Base Projection Tab**: Simplified 10-column view of essential metrics
- **Detailed Projection Tab**: Full 40+ column breakdown with collapsible column groups
- **Charts Tab**: Visual charts including:
  - Net Worth Over Time (Line Chart)
  - Income Breakdown by Source (Stacked Area Chart)
  - Expense Distribution (Pie Chart)
  - Net Cash Flow Over Time (Column Chart)

### Multi-Scenario Comparison

Compare 2-5 scenarios side-by-side with:
- **Comparison Summary Tab**: Side-by-side KPI comparison with color-coded differences
- **Individual Scenario Tabs**: Simplified 8-column view for each scenario

### Professional Formatting

- **Collapsible Column Groups**: Income, Expenses, Taxes, Withdrawals, Contributions, and Balances all collapse for a cleaner view
- **Alternating Row Colors**: Light gray on even rows for readability
- **Conditional Formatting**: Red text for negative values, green for positive differences
- **Freeze Panes**: Headers and key columns frozen for easy navigation
- **Currency Formatting**: Consistent thousand separators, no decimals
- **Charts Reference Hidden Data**: Charts display correctly even when columns are collapsed

## Usage

### From the Flutter App

1. Navigate to the **Projection** screen
2. Click the **Export Excel** button (primary blue button)
3. The file will be generated and either:
   - Auto-opened in Excel (if enabled in Settings)
   - Downloaded to your Downloads folder

### Settings

**Auto-Open Excel Files** (Settings > Excel Export)
- Default: Enabled
- When enabled, Excel files open automatically after download
- When disabled, files are downloaded without opening

## Architecture

### Cloud Function

- **Function Name**: `generate_projection_excel`
- **Runtime**: Python 3.11
- **Region**: us-central1
- **Timeout**: 60 seconds
- **Memory**: 256 MB

### Request Format

**Single Scenario:**
```json
{
  "projection": { /* Projection object */ },
  "scenarioName": "Base Scenario",
  "assets": [ /* Array of Asset objects */ ]
}
```

**Multi-Scenario:**
```json
{
  "scenarios": [
    {
      "projection": { /* Projection object */ },
      "scenarioName": "Base Scenario",
      "assets": [ /* Array of Asset objects */ ]
    },
    {
      "projection": { /* Projection object */ },
      "scenarioName": "Optimistic",
      "assets": [ /* Array of Asset objects */ ]
    }
  ]
}
```

### Response

- **Content-Type**: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- **Content-Disposition**: `attachment; filename="projection_{name}_{date}.xlsx"`
- **Body**: Binary Excel file data

## File Structure

### Single Scenario Workbook

```
projection_base-scenario_2025-10-17.xlsx
├── Summary                # Key metrics and parameters
├── Base Projection        # 10-column simplified view
├── Detailed Projection    # 40+ columns with groups
└── Charts                 # 4 visual charts
```

### Multi-Scenario Workbook

```
projection_comparison_3_scenarios_2025-10-17.xlsx
├── Comparison Summary     # Side-by-side KPI comparison
├── 1. Base Scenario       # 8-column simplified view
├── 2. Optimistic          # 8-column simplified view
└── 3. Pessimistic         # 8-column simplified view
```

## Performance

- **Typical Generation Time**: < 2 seconds for 40-year projections
- **File Size**: 15-50 KB depending on data volume
- **In-Memory Processing**: Uses XlsxWriter's in-memory mode for optimal performance
- **Format Reuse**: All format objects created once and reused

## Error Handling

### Cloud Function Errors

- **400 Bad Request**: Invalid JSON, missing fields, invalid scenario count
- **405 Method Not Allowed**: Non-POST requests
- **500 Internal Server Error**: Unexpected errors (logged with stack trace)

### Flutter Error Handling

- Try-catch wrapper around export calls
- User-friendly error messages displayed in SnackBar
- Graceful fallback to download if auto-open fails

## Development

### Deploying Changes

```bash
# From project root
firebase deploy --only functions

# Or deploy specific function
firebase deploy --only functions:generate_projection_excel
```

### Testing Locally

```bash
# Install Firebase emulator
firebase emulators:start --only functions

# Test with curl
curl -X POST http://localhost:5001/retire1-1a558/us-central1/generate_projection_excel \
  -H "Content-Type: application/json" \
  -d @test-payload.json \
  --output test.xlsx
```

### Project Structure

```
functions/
├── main.py                   # Cloud Function entry point
├── excel_generator.py        # Excel generation logic
│   ├── ExcelGenerator        # Single scenario
│   └── MultiScenarioExcelGenerator  # Multi-scenario comparison
├── models.py                 # Data models (Projection, Asset, etc.)
├── requirements.txt          # Python dependencies
└── .gitignore
```

### Dependencies

**Python:**
- firebase-functions >= 0.4.0
- firebase-admin >= 6.0.0
- XlsxWriter >= 3.1.0

**Flutter:**
- url_launcher: ^6.3.2 (for auto-open)

## Limitations

- **Maximum Scenarios**: 5 scenarios for multi-scenario comparison
- **Minimum Scenarios**: 2 scenarios for comparison (otherwise use single scenario export)
- **Platform Support**: Web only for auto-open (download works on all platforms)
- **File Format**: Excel 2007+ (.xlsx) only

## Future Enhancements

Potential improvements for future releases:

1. **Additional Charts**: Asset allocation over time, tax breakdown charts
2. **Mobile/Desktop Auto-Open**: Extend auto-open to mobile and desktop platforms
3. **Custom Templates**: Allow users to customize Excel templates
4. **PDF Export**: Generate PDF versions of projections
5. **Email Integration**: Email Excel files directly from the app
6. **Scheduled Exports**: Automatically generate and email reports on a schedule

## Related Documentation

- [EXCEL_EXPORT_PLAN.md](./EXCEL_EXPORT_PLAN.md) - Complete implementation plan with all phases
- [Firebase Cloud Functions Docs](https://firebase.google.com/docs/functions)
- [XlsxWriter Documentation](https://xlsxwriter.readthedocs.io/)

## Support

For issues or questions:
1. Check Firebase Console → Functions → Logs for Cloud Function errors
2. Review error messages in the Flutter app
3. Consult the implementation plan for design decisions
4. Check performance metrics in Cloud Function logs

## Version History

- **v1.0** (2025-10-17): Initial release with all 10 phases complete
  - Single scenario export with 4 tabs
  - Multi-scenario comparison
  - Charts with hidden data support
  - Auto-open functionality
  - Performance monitoring
