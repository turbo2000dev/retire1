"""
Excel generation logic for projection data.
Uses XlsxWriter to create formatted Excel files.
"""

import io
from typing import Dict, List
import xlsxwriter
from models import Projection, Asset


class ExcelGenerator:
    """Generates Excel files from projection data."""

    def __init__(self, projection: Projection, scenario_name: str, assets: List[Asset]):
        self.projection = projection
        self.scenario_name = scenario_name
        self.assets = assets

        # Build asset type map for quick lookup
        self.asset_type_map: Dict[str, str] = {
            asset.id: asset.type for asset in assets
        }

    def generate(self) -> bytes:
        """
        Generate Excel file and return as bytes.

        Returns:
            bytes: Excel file content
        """
        # Create workbook in memory
        output = io.BytesIO()
        workbook = xlsxwriter.Workbook(output, {'in_memory': True})

        # Define formats
        formats = self._create_formats(workbook)

        # Create tabs in order
        self._create_summary_sheet(workbook, formats)
        self._create_base_projection_sheet(workbook, formats)
        self._create_detailed_projection_sheet(workbook, formats)
        self._create_charts_sheet(workbook, formats)

        # Close workbook to finalize
        workbook.close()

        # Get the bytes
        output.seek(0)
        return output.read()

    def _create_formats(self, workbook: xlsxwriter.Workbook) -> Dict:
        """Create reusable cell formats."""
        return {
            'header': workbook.add_format({
                'bold': True,
                'bg_color': '#4472C4',
                'font_color': 'white',
                'align': 'center',
                'valign': 'vcenter',
                'border': 1,
            }),
            'header_group': workbook.add_format({
                'bold': True,
                'bg_color': '#2E5C8A',  # Darker blue for group headers
                'font_color': 'white',
                'align': 'center',
                'valign': 'vcenter',
                'border': 1,
            }),
            'currency': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
            }),
            'currency_alt': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'bg_color': '#F2F2F2',  # Light gray for alternating rows
            }),
            'currency_negative': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': 'red',
            }),
            'currency_negative_alt': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': 'red',
                'bg_color': '#F2F2F2',
            }),
            'currency_total': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'bg_color': '#E7E6E6',  # Slightly darker gray for total columns
                'bold': True,
            }),
            'currency_total_alt': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'bg_color': '#D9D9D9',  # Darker gray for alternating rows in total columns
                'bold': True,
            }),
            'currency_total_negative': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': 'red',
                'bg_color': '#E7E6E6',
                'bold': True,
            }),
            'currency_total_negative_alt': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': 'red',
                'bg_color': '#D9D9D9',
                'bold': True,
            }),
            'integer': workbook.add_format({
                'num_format': '0',
                'align': 'center',
            }),
            'integer_alt': workbook.add_format({
                'num_format': '0',
                'align': 'center',
                'bg_color': '#F2F2F2',
            }),
            'label': workbook.add_format({
                'bold': True,
                'align': 'left',
            }),
            'value': workbook.add_format({
                'align': 'left',
            }),
            'section_header': workbook.add_format({
                'bold': True,
                'font_size': 12,
                'bg_color': '#D9E1F2',
                'border': 1,
            }),
            'group_header': workbook.add_format({
                'bold': True,
                'bg_color': '#8FAADC',  # Lighter blue for group headers
                'font_color': 'white',
                'align': 'center',
                'valign': 'vcenter',
                'border': 1,
            }),
        }

    def _create_summary_sheet(self, workbook: xlsxwriter.Workbook, formats: Dict):
        """Create summary sheet with projection parameters and key metrics."""
        worksheet = workbook.add_worksheet('Summary')

        # Set column widths
        worksheet.set_column(0, 0, 25)  # Label column
        worksheet.set_column(1, 1, 30)  # Value column

        row = 0

        # Title
        worksheet.merge_range(row, 0, row, 1, 'Projection Summary', formats['section_header'])
        row += 2

        # Projection Parameters
        worksheet.write(row, 0, 'Scenario Name:', formats['label'])
        worksheet.write(row, 1, self.scenario_name, formats['value'])
        row += 1

        worksheet.write(row, 0, 'Start Year:', formats['label'])
        worksheet.write(row, 1, self.projection.start_year, formats['value'])
        row += 1

        worksheet.write(row, 0, 'End Year:', formats['label'])
        worksheet.write(row, 1, self.projection.end_year, formats['value'])
        row += 1

        worksheet.write(row, 0, 'Planning Period:', formats['label'])
        worksheet.write(row, 1, f"{len(self.projection.years)} years", formats['value'])
        row += 1

        worksheet.write(row, 0, 'Inflation Rate:', formats['label'])
        worksheet.write(row, 1, f"{self.projection.inflation_rate * 100:.2f}%", formats['value'])
        row += 1

        worksheet.write(row, 0, 'Dollar Type:', formats['label'])
        dollar_type = 'Constant Dollars' if self.projection.use_constant_dollars else 'Current Dollars'
        worksheet.write(row, 1, dollar_type, formats['value'])
        row += 2

        # Key Metrics section
        worksheet.merge_range(row, 0, row, 1, 'Key Metrics', formats['section_header'])
        row += 2

        # Calculate summary metrics
        first_year = self.projection.years[0] if self.projection.years else None
        last_year = self.projection.years[-1] if self.projection.years else None

        if first_year:
            worksheet.write(row, 0, 'Initial Net Worth:', formats['label'])
            worksheet.write_number(row, 1, first_year.net_worth_start_of_year, formats['currency'])
            row += 1

        if last_year:
            worksheet.write(row, 0, 'Final Net Worth:', formats['label'])
            worksheet.write_number(row, 1, last_year.net_worth_end_of_year, formats['currency'])
            row += 1

        # Calculate total income and expenses over planning period
        total_income = sum(year.total_income for year in self.projection.years)
        total_expenses = sum(year.total_expenses for year in self.projection.years)
        total_tax = sum(year.total_tax for year in self.projection.years)

        worksheet.write(row, 0, 'Total Income (All Years):', formats['label'])
        worksheet.write_number(row, 1, total_income, formats['currency'])
        row += 1

        worksheet.write(row, 0, 'Total Expenses (All Years):', formats['label'])
        worksheet.write_number(row, 1, total_expenses, formats['currency'])
        row += 1

        worksheet.write(row, 0, 'Total Taxes (All Years):', formats['label'])
        worksheet.write_number(row, 1, total_tax, formats['currency'])
        row += 1

        # Check for shortfalls
        years_with_shortfall = [year for year in self.projection.years if year.has_shortfall]
        worksheet.write(row, 0, 'Years with Shortfall:', formats['label'])
        worksheet.write(row, 1, len(years_with_shortfall), formats['value'])
        row += 1

        if years_with_shortfall:
            total_shortfall = sum(year.shortfall_amount for year in years_with_shortfall)
            worksheet.write(row, 0, 'Total Shortfall Amount:', formats['label'])
            worksheet.write_number(row, 1, total_shortfall, formats['currency_negative'])
            row += 1

        row += 1

        # Assets section
        worksheet.merge_range(row, 0, row, 1, 'Assets', formats['section_header'])
        row += 2

        # Count assets by type
        asset_counts = {}
        for asset in self.assets:
            asset_type = asset.type
            asset_counts[asset_type] = asset_counts.get(asset_type, 0) + 1

        type_names = {
            'realEstate': 'Real Estate',
            'rrsp': 'RRSP/REER',
            'celi': 'CELI/TFSA',
            'cri': 'CRI',
            'cash': 'Cash',
        }

        for asset_type, count in asset_counts.items():
            display_name = type_names.get(asset_type, asset_type)
            worksheet.write(row, 0, f'{display_name} Accounts:', formats['label'])
            worksheet.write(row, 1, count, formats['value'])
            row += 1

        worksheet.write(row, 0, 'Total Assets:', formats['label'])
        worksheet.write(row, 1, len(self.assets), formats['value'])

    def _create_base_projection_sheet(self, workbook: xlsxwriter.Workbook, formats: Dict):
        """Create simplified base projection sheet with key metrics only."""
        worksheet = workbook.add_worksheet('Base Projection')

        # Check if we have couples
        has_couples = any(year.spouse_age is not None for year in self.projection.years)

        # Define simplified headers
        headers = ['Year', 'Age 1']
        if has_couples:
            headers.append('Age 2')

        headers.extend([
            'Total Income',
            'Total Expenses',
            'Total Tax',
            'After-Tax Income',
            'Net Cash Flow',
            'Total Withdrawals',
            'Total Contributions',
            'Net Worth (Start)',
            'Net Worth (End)',
            'Shortfall Amount',
        ])

        # Write headers
        for col_idx, header in enumerate(headers):
            worksheet.write(0, col_idx, header, formats['header_group'])

        # Set column widths - consistent width for all currency columns (114 pixels = ~16.5 chars)
        worksheet.set_column(0, 0, 7)  # Year
        worksheet.set_column(1, 2 if has_couples else 1, 8)  # Ages
        # All currency columns get same width (114 pixels)
        first_currency_col = 3 if has_couples else 2
        worksheet.set_column(first_currency_col, len(headers) - 1, 16.5)

        # Freeze header row and first columns
        freeze_col = 3 if has_couples else 2
        worksheet.freeze_panes(1, freeze_col)

        # Write data rows
        for row_idx, year in enumerate(self.projection.years, start=1):
            is_alt_row = row_idx % 2 == 0
            col = 0

            # Year
            self._write_value(worksheet, row_idx, col, year.year, 'integer', is_alt_row, formats)
            col += 1

            # Ages
            self._write_value(worksheet, row_idx, col, year.primary_age or '', 'integer', is_alt_row, formats)
            col += 1
            if has_couples:
                self._write_value(worksheet, row_idx, col, year.spouse_age or '', 'integer', is_alt_row, formats)
                col += 1

            # Key financial metrics
            self._write_currency(worksheet, row_idx, col, year.total_income, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_expenses, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_tax, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.after_tax_income, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_cash_flow, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_withdrawals, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_contributions, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_worth_start_of_year, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_worth_end_of_year, is_alt_row, formats)
            col += 1

            # Shortfall
            if year.has_shortfall:
                self._write_currency(worksheet, row_idx, col, year.shortfall_amount, is_alt_row, formats)
            else:
                format_key = 'currency_alt' if is_alt_row else 'currency'
                worksheet.write(row_idx, col, '', formats[format_key])

    def _create_detailed_projection_sheet(self, workbook: xlsxwriter.Workbook, formats: Dict):
        """Create the detailed projection worksheet with advanced formatting and grouping."""
        worksheet = workbook.add_worksheet('Detailed Projection')

        # Check if we have couples
        has_couples = any(year.spouse_age is not None for year in self.projection.years)

        # Track column positions for grouping
        col = 0
        age_start_col = col

        # Define headers with groups
        headers = ['Year', 'Age 1']
        col += 2
        if has_couples:
            headers.append('Age 2')
            col += 1

        # Income sources (will be grouped)
        income_start_col = col
        headers.extend([
            'Employment Income',
            'RRQ Income',
            'PSV Income',
            'RRPE Income',
            'Other Income',
            'Total Income',
        ])
        income_end_col = col + 4  # Last detail column (Other Income), before Total Income
        col += 6

        # Expenses by category (will be grouped)
        expense_start_col = col
        headers.extend([
            'Housing Expenses',
            'Transport Expenses',
            'Daily Living Expenses',
            'Recreation Expenses',
            'Health Expenses',
            'Family Expenses',
            'Total Expenses',
        ])
        expense_end_col = col + 5  # Last detail column (Family Expenses), before Total Expenses
        col += 7

        # Taxes (will be grouped)
        tax_start_col = col
        headers.extend([
            'Federal Tax',
            'Quebec Tax',
            'Total Tax',
        ])
        tax_end_col = col + 1  # Last detail column (Quebec Tax), before Total Tax
        col += 3

        # Cash flow
        headers.extend([
            'After-Tax Income',
            'Net Cash Flow',
        ])
        col += 2

        # Withdrawals (will be grouped)
        withdrawal_start_col = col
        headers.extend([
            'CELI Withdrawals',
            'Cash Withdrawals',
            'CRI Withdrawals',
            'REER Withdrawals',
            'Total Withdrawals',
        ])
        withdrawal_end_col = col + 3  # Last detail column (REER Withdrawals), before Total Withdrawals
        col += 5

        # Contributions (will be grouped)
        contribution_start_col = col
        headers.extend([
            'CELI Contributions',
            'Cash Contributions',
            'Total Contributions',
        ])
        contribution_end_col = col + 1  # Last detail column (Cash Contributions), before Total Contributions
        col += 3

        # Asset balances (will be grouped)
        balance_start_col = col
        headers.extend([
            'Real Estate Balance',
            'REER Balance',
            'CELI Balance',
            'CRI Balance',
            'Cash Balance',
            'Total Asset Returns',
        ])
        balance_end_col = col + 4  # Last detail column (Cash Balance), before Total Asset Returns
        col += 6

        # Net worth
        headers.extend([
            'Net Worth (Start)',
            'Net Worth (End)',
        ])
        col += 2

        # Warnings
        headers.append('Shortfall Amount')

        # Write group headers in row 0 (merged cells for each group)
        # Year and Ages span both rows
        worksheet.write(0, 0, 'Year', formats['header_group'])
        worksheet.write(0, 1, 'Age 1', formats['header_group'])
        if has_couples:
            worksheet.write(0, 2, 'Age 2', formats['header_group'])

        # Income group header
        if income_end_col > income_start_col:  # Only if there are detail columns
            worksheet.merge_range(0, income_start_col, 0, income_end_col, 'Income Sources', formats['group_header'])
        worksheet.write(0, income_end_col + 1, '', formats['header_group'])  # Total Income column

        # Expenses group header
        if expense_end_col > expense_start_col:
            worksheet.merge_range(0, expense_start_col, 0, expense_end_col, 'Expenses', formats['group_header'])
        worksheet.write(0, expense_end_col + 1, '', formats['header_group'])  # Total Expenses column

        # Taxes group header
        if tax_end_col > tax_start_col:
            worksheet.merge_range(0, tax_start_col, 0, tax_end_col, 'Taxes', formats['group_header'])
        worksheet.write(0, tax_end_col + 1, '', formats['header_group'])  # Total Tax column

        # Cash flow - no group header
        after_tax_col = tax_end_col + 2
        worksheet.write(0, after_tax_col, '', formats['header_group'])
        worksheet.write(0, after_tax_col + 1, '', formats['header_group'])

        # Withdrawals group header
        if withdrawal_end_col > withdrawal_start_col:
            worksheet.merge_range(0, withdrawal_start_col, 0, withdrawal_end_col, 'Withdrawals', formats['group_header'])
        worksheet.write(0, withdrawal_end_col + 1, '', formats['header_group'])  # Total Withdrawals column

        # Contributions group header
        if contribution_end_col > contribution_start_col:
            worksheet.merge_range(0, contribution_start_col, 0, contribution_end_col, 'Contributions', formats['group_header'])
        worksheet.write(0, contribution_end_col + 1, '', formats['header_group'])  # Total Contributions column

        # Balances group header
        if balance_end_col > balance_start_col:
            worksheet.merge_range(0, balance_start_col, 0, balance_end_col, 'Asset Balances', formats['group_header'])
        worksheet.write(0, balance_end_col + 1, '', formats['header_group'])  # Total Asset Returns column

        # Net worth - no group header
        net_worth_start_col = balance_end_col + 2
        worksheet.write(0, net_worth_start_col, '', formats['header_group'])
        worksheet.write(0, net_worth_start_col + 1, '', formats['header_group'])

        # Shortfall - no group header
        worksheet.write(0, len(headers) - 1, '', formats['header_group'])

        # Write column headers in row 1
        for col_idx, header in enumerate(headers):
            # Use darker blue for total columns
            if 'Total' in header or 'Net Worth' in header or 'After-Tax' in header:
                worksheet.write(1, col_idx, header, formats['header_group'])
            else:
                worksheet.write(1, col_idx, header, formats['header'])

        # Set column widths - consistent width for all currency columns (114 pixels = ~16.5 chars)
        worksheet.set_column(0, 0, 7)  # Year
        worksheet.set_column(1, 2 if has_couples else 1, 8)  # Ages

        # All currency columns get same width (114 pixels)
        first_currency_col = 3 if has_couples else 2
        worksheet.set_column(first_currency_col, len(headers) - 1, 16.5)

        # Freeze header rows (2 rows) and first 3 columns (Year + Ages)
        freeze_col = 3 if has_couples else 2
        worksheet.freeze_panes(2, freeze_col)

        # Set up column groups (collapsible and collapsed by default)
        # Width must be specified in grouping calls to maintain 114 pixels (16.5 chars)
        # Important: Total columns between groups must have level: 0 to break the grouping

        # Income sources group (collapsible and hidden by default)
        worksheet.set_column(income_start_col, income_end_col, 16.5, None, {'level': 1, 'hidden': True})
        # Total Income column - level 0 to break grouping
        worksheet.set_column(income_end_col + 1, income_end_col + 1, 16.5, None, {'level': 0})

        # Expenses group (collapsible and hidden by default)
        worksheet.set_column(expense_start_col, expense_end_col, 16.5, None, {'level': 1, 'hidden': True})
        # Total Expenses column - level 0 to break grouping
        worksheet.set_column(expense_end_col + 1, expense_end_col + 1, 16.5, None, {'level': 0})

        # Taxes group
        worksheet.set_column(tax_start_col, tax_end_col, 16.5, None, {'level': 1, 'hidden': True})
        # Total Tax column - level 0 to break grouping
        worksheet.set_column(tax_end_col + 1, tax_end_col + 1, 16.5, None, {'level': 0})

        # After-Tax Income and Net Cash Flow - level 0 (not grouped)
        after_tax_col = tax_end_col + 2
        worksheet.set_column(after_tax_col, after_tax_col + 1, 16.5, None, {'level': 0})

        # Withdrawals group
        worksheet.set_column(withdrawal_start_col, withdrawal_end_col, 16.5, None, {'level': 1, 'hidden': True})
        # Total Withdrawals column - level 0 to break grouping
        worksheet.set_column(withdrawal_end_col + 1, withdrawal_end_col + 1, 16.5, None, {'level': 0})

        # Contributions group
        worksheet.set_column(contribution_start_col, contribution_end_col, 16.5, None, {'level': 1, 'hidden': True})
        # Total Contributions column - level 0 to break grouping
        worksheet.set_column(contribution_end_col + 1, contribution_end_col + 1, 16.5, None, {'level': 0})

        # Balances group
        worksheet.set_column(balance_start_col, balance_end_col, 16.5, None, {'level': 1, 'hidden': True})
        # Total Asset Returns column - level 0 to break grouping
        worksheet.set_column(balance_end_col + 1, balance_end_col + 1, 16.5, None, {'level': 0})

        # Net worth and shortfall columns - level 0 (not grouped)
        net_worth_start_col = balance_end_col + 2
        worksheet.set_column(net_worth_start_col, len(headers) - 1, 16.5, None, {'level': 0})

        # Write data rows with alternating colors (starting at row 2 after 2 header rows)
        for row_idx, year in enumerate(self.projection.years, start=2):
            # Determine if this is an alternating row (even row number)
            is_alt_row = row_idx % 2 == 0

            col = 0

            # Year
            self._write_value(worksheet, row_idx, col, year.year, 'integer', is_alt_row, formats)
            col += 1

            # Ages
            self._write_value(worksheet, row_idx, col, year.primary_age or '', 'integer', is_alt_row, formats)
            col += 1
            if has_couples:
                self._write_value(worksheet, row_idx, col, year.spouse_age or '', 'integer', is_alt_row, formats)
                col += 1

            # Calculate income totals from all individuals
            total_employment = sum(income.employment for income in year.income_by_individual.values())
            total_rrq = sum(income.rrq for income in year.income_by_individual.values())
            total_psv = sum(income.psv for income in year.income_by_individual.values())
            total_rrpe = sum(income.rrpe for income in year.income_by_individual.values())
            total_other = sum(income.other for income in year.income_by_individual.values())

            # Income sources
            self._write_currency(worksheet, row_idx, col, total_employment, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_rrq, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_psv, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_rrpe, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_other, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_income, is_alt_row, formats, is_total=True)
            col += 1

            # Expenses by category
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('housing', 0.0), is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('transport', 0.0), is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('dailyLiving', 0.0), is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('recreation', 0.0), is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('health', 0.0), is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('family', 0.0), is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_expenses, is_alt_row, formats, is_total=True)
            col += 1

            # Taxes
            self._write_currency(worksheet, row_idx, col, year.federal_tax, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.quebec_tax, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_tax, is_alt_row, formats, is_total=True)
            col += 1

            # Cash flow
            self._write_currency(worksheet, row_idx, col, year.after_tax_income, is_alt_row, formats, is_total=True)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_cash_flow, is_alt_row, formats, is_total=True)
            col += 1

            # Calculate withdrawals by account type
            celi_withdrawals = sum(
                amount for asset_id, amount in year.withdrawals_by_account.items()
                if self.asset_type_map.get(asset_id) == 'celi'
            )
            cash_withdrawals = sum(
                amount for asset_id, amount in year.withdrawals_by_account.items()
                if self.asset_type_map.get(asset_id) == 'cash'
            )
            cri_withdrawals = sum(
                amount for asset_id, amount in year.withdrawals_by_account.items()
                if self.asset_type_map.get(asset_id) == 'cri'
            )
            reer_withdrawals = sum(
                amount for asset_id, amount in year.withdrawals_by_account.items()
                if self.asset_type_map.get(asset_id) == 'rrsp'
            )

            # Withdrawals
            self._write_currency(worksheet, row_idx, col, celi_withdrawals, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cash_withdrawals, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cri_withdrawals, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, reer_withdrawals, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_withdrawals, is_alt_row, formats, is_total=True)
            col += 1

            # Calculate contributions by account type
            celi_contributions = sum(
                amount for asset_id, amount in year.contributions_by_account.items()
                if self.asset_type_map.get(asset_id) == 'celi'
            )
            cash_contributions = sum(
                amount for asset_id, amount in year.contributions_by_account.items()
                if self.asset_type_map.get(asset_id) == 'cash'
            )

            # Contributions
            self._write_currency(worksheet, row_idx, col, celi_contributions, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cash_contributions, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_contributions, is_alt_row, formats, is_total=True)
            col += 1

            # Calculate asset balances by type
            real_estate_balance = sum(
                amount for asset_id, amount in year.assets_end_of_year.items()
                if self.asset_type_map.get(asset_id) == 'realEstate'
            )
            reer_balance = sum(
                amount for asset_id, amount in year.assets_end_of_year.items()
                if self.asset_type_map.get(asset_id) == 'rrsp'
            )
            celi_balance = sum(
                amount for asset_id, amount in year.assets_end_of_year.items()
                if self.asset_type_map.get(asset_id) == 'celi'
            )
            cri_balance = sum(
                amount for asset_id, amount in year.assets_end_of_year.items()
                if self.asset_type_map.get(asset_id) == 'cri'
            )
            cash_balance = sum(
                amount for asset_id, amount in year.assets_end_of_year.items()
                if self.asset_type_map.get(asset_id) == 'cash'
            )
            total_returns = sum(year.asset_returns.values())

            # Asset balances
            self._write_currency(worksheet, row_idx, col, real_estate_balance, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, reer_balance, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, celi_balance, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cri_balance, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cash_balance, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_returns, is_alt_row, formats, is_total=True)
            col += 1

            # Net worth
            self._write_currency(worksheet, row_idx, col, year.net_worth_start_of_year, is_alt_row, formats, is_total=True)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_worth_end_of_year, is_alt_row, formats, is_total=True)
            col += 1

            # Shortfall
            if year.has_shortfall:
                self._write_currency(worksheet, row_idx, col, year.shortfall_amount, is_alt_row, formats, is_total=True)
            else:
                format_key = 'currency_alt' if is_alt_row else 'currency'
                worksheet.write(row_idx, col, '', formats[format_key])
            col += 1

    def _write_value(self, worksheet, row: int, col: int, value, value_type: str, is_alt_row: bool, formats: Dict):
        """Write a value with appropriate formatting based on type and row."""
        format_key = f'{value_type}_alt' if is_alt_row else value_type
        if value == '':
            worksheet.write(row, col, '', formats[format_key])
        else:
            worksheet.write(row, col, value, formats[format_key])

    def _write_currency(self, worksheet, row: int, col: int, value: float, is_alt_row: bool, formats: Dict, is_total: bool = False):
        """Write a currency value with appropriate formatting based on sign, row, and whether it's a total column."""
        if is_total:
            if value < 0:
                format_key = 'currency_total_negative_alt' if is_alt_row else 'currency_total_negative'
            else:
                format_key = 'currency_total_alt' if is_alt_row else 'currency_total'
        else:
            if value < 0:
                format_key = 'currency_negative_alt' if is_alt_row else 'currency_negative'
            else:
                format_key = 'currency_alt' if is_alt_row else 'currency'
        worksheet.write_number(row, col, value, formats[format_key])

    def _create_charts_sheet(self, workbook: xlsxwriter.Workbook, formats: Dict):
        """Create charts worksheet with visual representations of projection data."""
        worksheet = workbook.add_worksheet('Charts')

        # Reference sheets and calculate positions
        has_couples = any(year.spouse_age is not None for year in self.projection.years)
        num_years = len(self.projection.years)

        # For Detailed Projection sheet, we need to know column positions
        # Year is always column A (0), ages start at column B (1)
        # If couples: Age1=B(1), Age2=C(2), first data column = D(3)
        # If single: Age1=B(1), first data column = C(2)
        first_data_col_num = 3 if has_couples else 2

        # Calculate all column positions exactly as in _create_detailed_projection_sheet
        col = 0
        col += 2  # Year, Age 1
        if has_couples:
            col += 1  # Age 2

        # Income sources: Employment, RRQ, PSV, RRPE, Other, Total Income (6 columns)
        employment_col = col
        rrq_col = col + 1
        psv_col = col + 2
        rrpe_col = col + 3
        other_col = col + 4
        total_income_col = col + 5
        col += 6

        # Expenses: Housing, Transport, Daily Living, Recreation, Health, Family, Total Expenses (7 columns)
        housing_col = col
        transport_col = col + 1
        daily_col = col + 2
        recreation_col = col + 3
        health_col = col + 4
        family_col = col + 5
        total_expenses_col = col + 6
        col += 7

        # Taxes: Federal Tax, Quebec Tax, Total Tax (3 columns)
        col += 3

        # Cash flow: After-Tax Income, Net Cash Flow (2 columns)
        after_tax_income_col = col
        net_cashflow_col = col + 1
        col += 2

        # Withdrawals: CELI, Cash, CRI, REER, Total (5 columns)
        col += 5

        # Contributions: CELI, Cash, Total (3 columns)
        col += 3

        # Balances: Real Estate, REER, CELI, CRI, Cash, Total Asset Returns (6 columns)
        col += 6

        # Net worth: Start, End (2 columns)
        net_worth_start_col = col
        net_worth_end_col = col + 1
        col += 2

        # Shortfall (1 column)
        col += 1

        # Convert column numbers to Excel letters
        def col_letter(col_num):
            """Convert 0-based column number to Excel letter (A, B, C...)."""
            result = ''
            while col_num >= 0:
                result = chr(65 + (col_num % 26)) + result
                col_num = col_num // 26 - 1
            return result

        # Chart 1: Net Worth Over Time (Line Chart)
        chart_net_worth = workbook.add_chart({'type': 'line'})
        chart_net_worth.add_series({
            'name': 'Net Worth',
            'categories': f"='Detailed Projection'!$A$3:$A${num_years + 2}",  # Years (starts row 3)
            'values': f"='Detailed Projection'!${col_letter(net_worth_end_col)}$3:${col_letter(net_worth_end_col)}${num_years + 2}",  # Net Worth End
            'line': {'color': '#4472C4', 'width': 2.5},
        })
        chart_net_worth.set_title({'name': 'Net Worth Over Time'})
        chart_net_worth.set_x_axis({'name': 'Year'})
        chart_net_worth.set_y_axis({'name': 'Net Worth ($)', 'num_format': '#,##0'})
        chart_net_worth.set_size({'width': 720, 'height': 400})
        chart_net_worth.set_legend({'position': 'bottom'})
        chart_net_worth.show_hidden_data()  # Show data in hidden/collapsed columns
        worksheet.insert_chart('B2', chart_net_worth)

        # Chart 2: Income Breakdown by Source (Stacked Area Chart)
        chart_income = workbook.add_chart({'type': 'area', 'subtype': 'stacked'})

        # Add each income source as a series
        income_sources = [
            ('Employment', employment_col, '#70AD47'),
            ('RRQ', rrq_col, '#5B9BD5'),
            ('PSV', psv_col, '#FFC000'),
            ('RRPE', rrpe_col, '#C55A11'),
            ('Other', other_col, '#A5A5A5'),
        ]

        # Use same formula approach as working charts
        for name, col_num, color in income_sources:
            chart_income.add_series({
                'name': name,
                'categories': f"='Detailed Projection'!$A$3:$A${num_years + 2}",
                'values': f"='Detailed Projection'!${col_letter(col_num)}$3:${col_letter(col_num)}${num_years + 2}",
                'fill': {'color': color},
                'line': {'none': True},
            })

        chart_income.set_title({'name': 'Income Breakdown by Source'})
        chart_income.set_x_axis({'name': 'Year'})
        chart_income.set_y_axis({'name': 'Income ($)', 'num_format': '#,##0'})
        chart_income.set_size({'width': 720, 'height': 400})
        chart_income.set_legend({'position': 'bottom'})
        chart_income.show_hidden_data()  # Show data in hidden/collapsed columns
        worksheet.insert_chart('B23', chart_income)

        # Chart 3: Expense Breakdown (Pie Chart - final year)
        chart_expenses = workbook.add_chart({'type': 'pie'})

        expense_categories = [
            ('Housing', housing_col, '#4472C4'),
            ('Transport', transport_col, '#ED7D31'),
            ('Daily Living', daily_col, '#A5A5A5'),
            ('Recreation', recreation_col, '#FFC000'),
            ('Health', health_col, '#5B9BD5'),
            ('Family', family_col, '#70AD47'),
        ]

        # Use last year's expenses for pie chart
        if num_years > 0:
            last_row = num_years + 2  # Excel row number (1-indexed)
            colors = [cat[2] for cat in expense_categories]

            # Use same formula approach as working charts
            chart_expenses.add_series({
                'name': 'Expenses',
                'categories': f"='Detailed Projection'!${col_letter(housing_col)}$2:${col_letter(family_col)}$2",  # Headers row 2
                'values': f"='Detailed Projection'!${col_letter(housing_col)}${last_row}:${col_letter(family_col)}${last_row}",  # Last year data
                'points': [{'fill': {'color': color}} for color in colors],
            })

        chart_expenses.set_title({'name': f'Expense Distribution (Final Year)'})
        chart_expenses.set_size({'width': 720, 'height': 400})
        chart_expenses.set_legend({'position': 'right'})
        chart_expenses.show_hidden_data()  # Show data in hidden/collapsed columns
        worksheet.insert_chart('N2', chart_expenses)

        # Chart 4: Cash Flow Over Time (Column Chart)
        chart_cashflow = workbook.add_chart({'type': 'column'})

        chart_cashflow.add_series({
            'name': 'Net Cash Flow',
            'categories': f"='Detailed Projection'!$A$3:$A${num_years + 2}",
            'values': f"='Detailed Projection'!${col_letter(net_cashflow_col)}$3:${col_letter(net_cashflow_col)}${num_years + 2}",
            'fill': {'color': '#70AD47'},
        })

        chart_cashflow.set_title({'name': 'Net Cash Flow Over Time'})
        chart_cashflow.set_x_axis({'name': 'Year'})
        chart_cashflow.set_y_axis({'name': 'Cash Flow ($)', 'num_format': '#,##0'})
        chart_cashflow.set_size({'width': 720, 'height': 400})
        chart_cashflow.set_legend({'position': 'bottom'})
        chart_cashflow.show_hidden_data()  # Show data in hidden/collapsed columns
        worksheet.insert_chart('N23', chart_cashflow)


class MultiScenarioExcelGenerator:
    """Generates Excel files comparing multiple scenarios."""

    def __init__(self, scenarios: List[Dict]):
        """
        Initialize with list of scenarios.
        
        Each scenario dict contains:
        - 'projection': Projection object
        - 'scenario_name': str
        - 'assets': List[Asset]
        """
        self.scenarios = scenarios

    def generate(self) -> bytes:
        """
        Generate multi-scenario comparison Excel file.
        
        Returns:
            bytes: Excel file content
        """
        # Create workbook in memory
        output = io.BytesIO()
        workbook = xlsxwriter.Workbook(output, {'in_memory': True})

        # Create formats
        formats = self._create_formats(workbook)

        # Create comparison summary tab (first tab)
        self._create_comparison_summary(workbook, formats)

        # Create individual scenario tabs
        for idx, scenario in enumerate(self.scenarios):
            prefix = f"{idx + 1}. {scenario['scenario_name']}"
            generator = ExcelGenerator(
                scenario['projection'],
                scenario['scenario_name'],
                scenario['assets']
            )
            
            # Create tabs with scenario prefix
            self._create_scenario_tabs(workbook, generator, prefix, formats)

        # Close workbook
        workbook.close()

        # Return bytes
        output.seek(0)
        return output.read()

    def _create_formats(self, workbook: xlsxwriter.Workbook) -> Dict:
        """Create reusable cell formats."""
        return {
            'header': workbook.add_format({
                'bold': True,
                'bg_color': '#4472C4',
                'font_color': 'white',
                'align': 'center',
                'valign': 'vcenter',
                'border': 1,
            }),
            'currency': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
            }),
            'currency_positive': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': '#008000',  # Green
            }),
            'currency_negative': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': 'red',
            }),
            'label': workbook.add_format({
                'bold': True,
                'align': 'left',
            }),
            'value': workbook.add_format({
                'align': 'left',
            }),
            'section_header': workbook.add_format({
                'bold': True,
                'font_size': 12,
                'bg_color': '#D9E1F2',
                'border': 1,
            }),
        }

    def _create_comparison_summary(self, workbook: xlsxwriter.Workbook, formats: Dict):
        """Create comparison summary tab with side-by-side KPIs."""
        worksheet = workbook.add_worksheet('Comparison Summary')

        # Set column widths
        worksheet.set_column(0, 0, 25)  # Metric name column
        for i in range(len(self.scenarios)):
            worksheet.set_column(i + 1, i + 1, 18)  # Scenario columns

        row = 0

        # Title
        worksheet.merge_range(row, 0, row, len(self.scenarios), 
                            'Scenario Comparison', formats['section_header'])
        row += 2

        # Write scenario headers
        worksheet.write(row, 0, 'Metric', formats['header'])
        for idx, scenario in enumerate(self.scenarios):
            worksheet.write(row, idx + 1, scenario['scenario_name'], formats['header'])
        row += 1

        # Calculate KPIs for each scenario
        kpis_list = []
        for scenario in self.scenarios:
            projection = scenario['projection']
            first_year = projection.years[0] if projection.years else None
            last_year = projection.years[-1] if projection.years else None
            
            kpis = {
                'Initial Net Worth': first_year.net_worth_start_of_year if first_year else 0,
                'Final Net Worth': last_year.net_worth_end_of_year if last_year else 0,
                'Total Income': sum(y.total_income for y in projection.years),
                'Total Expenses': sum(y.total_expenses for y in projection.years),
                'Total Tax': sum(y.total_tax for y in projection.years),
                'Years with Shortfall': len([y for y in projection.years if y.has_shortfall]),
                'Total Shortfall': sum(y.shortfall_amount for y in projection.years if y.has_shortfall),
            }
            kpis_list.append(kpis)

        # Write KPI rows
        metric_names = [
            'Initial Net Worth',
            'Final Net Worth',
            'Total Income',
            'Total Expenses',
            'Total Tax',
            'Years with Shortfall',
            'Total Shortfall',
        ]

        for metric in metric_names:
            worksheet.write(row, 0, metric, formats['label'])
            
            # Write values for each scenario
            for idx, kpis in enumerate(kpis_list):
                value = kpis[metric]
                
                # Special handling for Years with Shortfall (integer)
                if metric == 'Years with Shortfall':
                    worksheet.write(row, idx + 1, value, formats['value'])
                else:
                    # Currency values
                    if idx == 0:
                        # First scenario (baseline) - no color
                        worksheet.write_number(row, idx + 1, value, formats['currency'])
                    else:
                        # Compare to first scenario
                        baseline_value = kpis_list[0][metric]
                        diff = value - baseline_value
                        
                        if diff > 0:
                            worksheet.write_number(row, idx + 1, value, formats['currency_positive'])
                        elif diff < 0:
                            worksheet.write_number(row, idx + 1, value, formats['currency_negative'])
                        else:
                            worksheet.write_number(row, idx + 1, value, formats['currency'])
            
            row += 1

        # Add difference row for Final Net Worth
        row += 1
        worksheet.merge_range(row, 0, row, len(self.scenarios), 
                            'Differences vs First Scenario', formats['section_header'])
        row += 1

        worksheet.write(row, 0, 'Final Net Worth Diff', formats['label'])
        baseline_final = kpis_list[0]['Final Net Worth']
        
        for idx, kpis in enumerate(kpis_list):
            if idx == 0:
                worksheet.write(row, idx + 1, 'Baseline', formats['value'])
            else:
                diff = kpis['Final Net Worth'] - baseline_final
                if diff > 0:
                    worksheet.write_number(row, idx + 1, diff, formats['currency_positive'])
                elif diff < 0:
                    worksheet.write_number(row, idx + 1, diff, formats['currency_negative'])
                else:
                    worksheet.write_number(row, idx + 1, diff, formats['currency'])

    def _create_scenario_tabs(self, workbook: xlsxwriter.Workbook,
                             generator: ExcelGenerator, prefix: str, formats: Dict):
        """Create tabs for a single scenario - simplified for Phase 9."""
        # For Phase 9, we'll just create the base projection tab for each scenario
        # Users can export individual scenarios for full details (Summary, Detailed, Charts)

        # Reuse the ExcelGenerator's base projection logic
        # This creates a simple tab with key metrics for comparison
        worksheet = workbook.add_worksheet(f"{prefix}")

        # Use the generator's methods directly
        # We'll create a simplified version - just the projection data
        formats_full = generator._create_formats(workbook)

        # Set column widths
        worksheet.set_column(0, 0, 7)  # Year
        worksheet.set_column(1, 1, 8)  # Age
        worksheet.set_column(2, 10, 16.5)  # Data columns

        # Write headers
        headers = ['Year', 'Age', 'Total Income', 'Total Expenses', 'Total Tax',
                  'Net Cash Flow', 'Net Worth', 'Shortfall']
        for col_idx, header in enumerate(headers):
            worksheet.write(0, col_idx, header, formats['header'])

        # Write data rows (simplified)
        for row_idx, year in enumerate(generator.projection.years, start=1):
            worksheet.write(row_idx, 0, year.year, formats['value'])
            worksheet.write(row_idx, 1, year.primary_age or '', formats['value'])
            worksheet.write_number(row_idx, 2, year.total_income, formats['currency'])
            worksheet.write_number(row_idx, 3, year.total_expenses, formats['currency'])
            worksheet.write_number(row_idx, 4, year.total_tax, formats['currency'])
            worksheet.write_number(row_idx, 5, year.net_cash_flow, formats['currency'])
            worksheet.write_number(row_idx, 6, year.net_worth_end_of_year, formats['currency'])
            if year.has_shortfall:
                worksheet.write_number(row_idx, 7, year.shortfall_amount, formats['currency_negative'])
            else:
                worksheet.write(row_idx, 7, '', formats['value'])

        # Freeze panes
        worksheet.freeze_panes(1, 2)
