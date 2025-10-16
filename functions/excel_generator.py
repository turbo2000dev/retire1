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

        # Set column widths - consistent width for all currency columns
        worksheet.set_column(0, 0, 7)  # Year
        worksheet.set_column(1, 2 if has_couples else 1, 8)  # Ages
        # All currency columns get same width (based on longest header "Daily Living Expenses")
        first_currency_col = 3 if has_couples else 2
        worksheet.set_column(first_currency_col, len(headers) - 1, 22)

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
        income_end_col = col + 5  # Before Total Income
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
        expense_end_col = col + 5  # Before Total Expenses
        col += 7

        # Taxes (will be grouped)
        tax_start_col = col
        headers.extend([
            'Federal Tax',
            'Quebec Tax',
            'Total Tax',
        ])
        tax_end_col = col + 1  # Before Total Tax
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
        withdrawal_end_col = col + 3  # Before Total Withdrawals
        col += 5

        # Contributions (will be grouped)
        contribution_start_col = col
        headers.extend([
            'CELI Contributions',
            'Cash Contributions',
            'Total Contributions',
        ])
        contribution_end_col = col + 1  # Before Total Contributions
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
        balance_end_col = col + 4  # Before Total Asset Returns
        col += 6

        # Net worth
        headers.extend([
            'Net Worth (Start)',
            'Net Worth (End)',
        ])
        col += 2

        # Warnings
        headers.append('Shortfall Amount')

        # Write headers
        for col_idx, header in enumerate(headers):
            # Use darker blue for total columns
            if 'Total' in header or 'Net Worth' in header or 'After-Tax' in header:
                worksheet.write(0, col_idx, header, formats['header_group'])
            else:
                worksheet.write(0, col_idx, header, formats['header'])

        # Set column widths - consistent width for all currency columns
        worksheet.set_column(0, 0, 7)  # Year
        worksheet.set_column(1, 2 if has_couples else 1, 8)  # Ages

        # All currency columns get same width (based on longest header "Daily Living Expenses" = 21 chars)
        first_currency_col = 3 if has_couples else 2
        worksheet.set_column(first_currency_col, len(headers) - 1, 22)

        # Freeze header row and first 3 columns (Year + Ages)
        freeze_col = 3 if has_couples else 2
        worksheet.freeze_panes(1, freeze_col)

        # Set up column groups (collapsible and collapsed by default)
        # Income sources group
        worksheet.set_column(income_start_col, income_end_col, None, None, {'level': 1, 'hidden': True})

        # Expenses group
        worksheet.set_column(expense_start_col, expense_end_col, None, None, {'level': 1, 'hidden': True})

        # Taxes group
        worksheet.set_column(tax_start_col, tax_end_col, None, None, {'level': 1, 'hidden': True})

        # Withdrawals group
        worksheet.set_column(withdrawal_start_col, withdrawal_end_col, None, None, {'level': 1, 'hidden': True})

        # Contributions group
        worksheet.set_column(contribution_start_col, contribution_end_col, None, None, {'level': 1, 'hidden': True})

        # Balances group
        worksheet.set_column(balance_start_col, balance_end_col, None, None, {'level': 1, 'hidden': True})

        # Write data rows with alternating colors
        for row_idx, year in enumerate(self.projection.years, start=1):
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
            self._write_currency(worksheet, row_idx, col, year.total_income, is_alt_row, formats)
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
            self._write_currency(worksheet, row_idx, col, year.total_expenses, is_alt_row, formats)
            col += 1

            # Taxes
            self._write_currency(worksheet, row_idx, col, year.federal_tax, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.quebec_tax, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_tax, is_alt_row, formats)
            col += 1

            # Cash flow
            self._write_currency(worksheet, row_idx, col, year.after_tax_income, is_alt_row, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_cash_flow, is_alt_row, formats)
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
            self._write_currency(worksheet, row_idx, col, year.total_withdrawals, is_alt_row, formats)
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
            self._write_currency(worksheet, row_idx, col, year.total_contributions, is_alt_row, formats)
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
            self._write_currency(worksheet, row_idx, col, total_returns, is_alt_row, formats)
            col += 1

            # Net worth
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
            col += 1

    def _write_value(self, worksheet, row: int, col: int, value, value_type: str, is_alt_row: bool, formats: Dict):
        """Write a value with appropriate formatting based on type and row."""
        format_key = f'{value_type}_alt' if is_alt_row else value_type
        if value == '':
            worksheet.write(row, col, '', formats[format_key])
        else:
            worksheet.write(row, col, value, formats[format_key])

    def _write_currency(self, worksheet, row: int, col: int, value: float, is_alt_row: bool, formats: Dict):
        """Write a currency value with appropriate formatting based on sign and row."""
        if value < 0:
            format_key = 'currency_negative_alt' if is_alt_row else 'currency_negative'
        else:
            format_key = 'currency_alt' if is_alt_row else 'currency'
        worksheet.write_number(row, col, value, formats[format_key])
