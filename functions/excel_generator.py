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

        # Create projection worksheet
        self._create_projection_sheet(workbook, formats)

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
            'currency': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
            }),
            'currency_negative': workbook.add_format({
                'num_format': '#,##0',
                'align': 'right',
                'font_color': 'red',
            }),
            'integer': workbook.add_format({
                'num_format': '0',
                'align': 'center',
            }),
        }

    def _create_projection_sheet(self, workbook: xlsxwriter.Workbook, formats: Dict):
        """Create the main projection worksheet."""
        worksheet = workbook.add_worksheet('Projection')

        # Check if we have couples
        has_couples = any(year.spouse_age is not None for year in self.projection.years)

        # Define headers
        headers = [
            'Year',
            'Age 1',
        ]
        if has_couples:
            headers.append('Age 2')

        # Income sources
        headers.extend([
            'Employment Income',
            'RRQ Income',
            'PSV Income',
            'RRPE Income',
            'Other Income',
            'Total Income',
        ])

        # Expenses by category
        headers.extend([
            'Housing Expenses',
            'Transport Expenses',
            'Daily Living Expenses',
            'Recreation Expenses',
            'Health Expenses',
            'Family Expenses',
            'Total Expenses',
        ])

        # Taxes
        headers.extend([
            'Federal Tax',
            'Quebec Tax',
            'Total Tax',
        ])

        # Cash flow
        headers.extend([
            'After-Tax Income',
            'Net Cash Flow',
        ])

        # Withdrawals
        headers.extend([
            'CELI Withdrawals',
            'Cash Withdrawals',
            'CRI Withdrawals',
            'REER Withdrawals',
            'Total Withdrawals',
        ])

        # Contributions
        headers.extend([
            'CELI Contributions',
            'Cash Contributions',
            'Total Contributions',
        ])

        # Asset balances
        headers.extend([
            'Real Estate Balance',
            'REER Balance',
            'CELI Balance',
            'CRI Balance',
            'Cash Balance',
            'Total Asset Returns',
        ])

        # Net worth
        headers.extend([
            'Net Worth (Start)',
            'Net Worth (End)',
        ])

        # Warnings
        headers.append('Shortfall Amount')

        # Write headers
        for col, header in enumerate(headers):
            worksheet.write(0, col, header, formats['header'])

        # Set column widths
        worksheet.set_column(0, 0, 6)  # Year
        worksheet.set_column(1, 2 if has_couples else 1, 8)  # Ages
        worksheet.set_column(2 if has_couples else 1, len(headers) - 1, 16)  # All other columns

        # Freeze header row
        worksheet.freeze_panes(1, 0)

        # Write data rows
        for row_idx, year in enumerate(self.projection.years, start=1):
            col = 0

            # Year
            worksheet.write(row_idx, col, year.year, formats['integer'])
            col += 1

            # Ages
            worksheet.write(row_idx, col, year.primary_age or '', formats['integer'])
            col += 1
            if has_couples:
                worksheet.write(row_idx, col, year.spouse_age or '', formats['integer'])
                col += 1

            # Calculate income totals from all individuals
            total_employment = sum(income.employment for income in year.income_by_individual.values())
            total_rrq = sum(income.rrq for income in year.income_by_individual.values())
            total_psv = sum(income.psv for income in year.income_by_individual.values())
            total_rrpe = sum(income.rrpe for income in year.income_by_individual.values())
            total_other = sum(income.other for income in year.income_by_individual.values())

            # Income sources
            self._write_currency(worksheet, row_idx, col, total_employment, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_rrq, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_psv, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_rrpe, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_other, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_income, formats)
            col += 1

            # Expenses by category
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('housing', 0.0), formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('transport', 0.0), formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('dailyLiving', 0.0), formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('recreation', 0.0), formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('health', 0.0), formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.expenses_by_category.get('family', 0.0), formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_expenses, formats)
            col += 1

            # Taxes
            self._write_currency(worksheet, row_idx, col, year.federal_tax, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.quebec_tax, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_tax, formats)
            col += 1

            # Cash flow
            self._write_currency(worksheet, row_idx, col, year.after_tax_income, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_cash_flow, formats)
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
            self._write_currency(worksheet, row_idx, col, celi_withdrawals, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cash_withdrawals, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cri_withdrawals, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, reer_withdrawals, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_withdrawals, formats)
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
            self._write_currency(worksheet, row_idx, col, celi_contributions, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cash_contributions, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.total_contributions, formats)
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
            self._write_currency(worksheet, row_idx, col, real_estate_balance, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, reer_balance, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, celi_balance, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cri_balance, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, cash_balance, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, total_returns, formats)
            col += 1

            # Net worth
            self._write_currency(worksheet, row_idx, col, year.net_worth_start_of_year, formats)
            col += 1
            self._write_currency(worksheet, row_idx, col, year.net_worth_end_of_year, formats)
            col += 1

            # Shortfall
            if year.has_shortfall:
                self._write_currency(worksheet, row_idx, col, year.shortfall_amount, formats)
            else:
                worksheet.write(row_idx, col, '', formats['currency'])
            col += 1

    def _write_currency(self, worksheet, row: int, col: int, value: float, formats: Dict):
        """Write a currency value with appropriate formatting."""
        if value < 0:
            worksheet.write_number(row, col, value, formats['currency_negative'])
        else:
            worksheet.write_number(row, col, value, formats['currency'])
