"""
Data models for projection data.
These mirror the Dart/Flutter models to deserialize JSON from the client.
"""

from dataclasses import dataclass, field
from typing import Dict, List, Optional
from datetime import datetime


@dataclass
class AnnualIncome:
    """Annual income breakdown for an individual."""
    employment: float = 0.0
    rrq: float = 0.0
    psv: float = 0.0
    rrif: float = 0.0
    rrpe: float = 0.0
    other: float = 0.0

    @property
    def total(self) -> float:
        """Calculate total income from all sources."""
        return self.employment + self.rrq + self.psv + self.rrif + self.rrpe + self.other

    @classmethod
    def from_dict(cls, data: Dict) -> 'AnnualIncome':
        """Create AnnualIncome from dictionary."""
        return cls(
            employment=data.get('employment', 0.0),
            rrq=data.get('rrq', 0.0),
            psv=data.get('psv', 0.0),
            rrif=data.get('rrif', 0.0),
            rrpe=data.get('rrpe', 0.0),
            other=data.get('other', 0.0),
        )


@dataclass
class YearlyProjection:
    """Projection data for a single year."""
    year: int
    years_from_start: int
    primary_age: Optional[int]
    spouse_age: Optional[int]
    income_by_individual: Dict[str, AnnualIncome] = field(default_factory=dict)
    total_income: float = 0.0
    taxable_income: float = 0.0
    federal_tax: float = 0.0
    quebec_tax: float = 0.0
    total_tax: float = 0.0
    after_tax_income: float = 0.0
    total_expenses: float = 0.0
    expenses_by_category: Dict[str, float] = field(default_factory=dict)
    withdrawals_by_account: Dict[str, float] = field(default_factory=dict)
    contributions_by_account: Dict[str, float] = field(default_factory=dict)
    total_withdrawals: float = 0.0
    total_contributions: float = 0.0
    celi_contribution_room: float = 0.0
    net_cash_flow: float = 0.0
    assets_start_of_year: Dict[str, float] = field(default_factory=dict)
    assets_end_of_year: Dict[str, float] = field(default_factory=dict)
    asset_returns: Dict[str, float] = field(default_factory=dict)
    net_worth_start_of_year: float = 0.0
    net_worth_end_of_year: float = 0.0
    events_occurred: List[str] = field(default_factory=list)
    has_shortfall: bool = False
    shortfall_amount: float = 0.0

    @classmethod
    def from_dict(cls, data: Dict) -> 'YearlyProjection':
        """Create YearlyProjection from dictionary."""
        # Parse income by individual
        income_by_individual = {}
        for individual_id, income_data in data.get('incomeByIndividual', {}).items():
            income_by_individual[individual_id] = AnnualIncome.from_dict(income_data)

        return cls(
            year=data['year'],
            years_from_start=data['yearsFromStart'],
            primary_age=data.get('primaryAge'),
            spouse_age=data.get('spouseAge'),
            income_by_individual=income_by_individual,
            total_income=data['totalIncome'],
            taxable_income=data.get('taxableIncome', 0.0),
            federal_tax=data.get('federalTax', 0.0),
            quebec_tax=data.get('quebecTax', 0.0),
            total_tax=data.get('totalTax', 0.0),
            after_tax_income=data.get('afterTaxIncome', 0.0),
            total_expenses=data['totalExpenses'],
            expenses_by_category=data.get('expensesByCategory', {}),
            withdrawals_by_account=data.get('withdrawalsByAccount', {}),
            contributions_by_account=data.get('contributionsByAccount', {}),
            total_withdrawals=data.get('totalWithdrawals', 0.0),
            total_contributions=data.get('totalContributions', 0.0),
            celi_contribution_room=data.get('celiContributionRoom', 0.0),
            net_cash_flow=data['netCashFlow'],
            assets_start_of_year=data['assetsStartOfYear'],
            assets_end_of_year=data['assetsEndOfYear'],
            asset_returns=data.get('assetReturns', {}),
            net_worth_start_of_year=data['netWorthStartOfYear'],
            net_worth_end_of_year=data['netWorthEndOfYear'],
            events_occurred=data.get('eventsOccurred', []),
            has_shortfall=data.get('hasShortfall', False),
            shortfall_amount=data.get('shortfallAmount', 0.0),
        )


@dataclass
class Projection:
    """Complete projection for a scenario over the planning period."""
    scenario_id: str
    project_id: str
    start_year: int
    end_year: int
    use_constant_dollars: bool
    inflation_rate: float
    years: List[YearlyProjection]
    calculated_at: datetime

    @classmethod
    def from_dict(cls, data: Dict) -> 'Projection':
        """Create Projection from dictionary."""
        # Parse yearly projections
        years = [YearlyProjection.from_dict(year_data) for year_data in data['years']]

        # Parse datetime
        calculated_at_str = data['calculatedAt']
        if isinstance(calculated_at_str, str):
            calculated_at = datetime.fromisoformat(calculated_at_str.replace('Z', '+00:00'))
        else:
            calculated_at = datetime.now()

        return cls(
            scenario_id=data['scenarioId'],
            project_id=data['projectId'],
            start_year=data['startYear'],
            end_year=data['endYear'],
            use_constant_dollars=data['useConstantDollars'],
            inflation_rate=data['inflationRate'],
            years=years,
            calculated_at=calculated_at,
        )


@dataclass
class Asset:
    """Asset information for categorization."""
    id: str
    type: str  # 'realEstate', 'rrsp', 'celi', 'cri', 'cash'

    @classmethod
    def from_dict(cls, data: Dict) -> 'Asset':
        """Create Asset from dictionary."""
        # The asset type is stored in the 'runtimeType' field from Freezed unions
        asset_type = data.get('runtimeType', '').lower()

        # Map runtimeType to our internal type names
        type_mapping = {
            'realestate': 'realEstate',
            'rrsp': 'rrsp',
            'celi': 'celi',
            'cri': 'cri',
            'cash': 'cash',
        }

        return cls(
            id=data['id'],
            type=type_mapping.get(asset_type, asset_type),
        )
