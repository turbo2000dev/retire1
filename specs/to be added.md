## Taxes
- Add individual breakdown (claculation and display)
- Flag if real estate sales is main property and therefore no capital gain taxes
- Split revenues for couples
- Surplus will go in CELI. Currently 7k per year is allowed. Make it more sophisticated (available per individuals configurable and 7k up to limit if not used)

## Engine Logic
 Proposed new flow:
  1. Get events for year
  2. Calculate income per individual (IncomeCalculator)
  3. Calculate taxes per individual (TaxCalculator)
  4. Sum to household totals
  5. Calculate expenses (from Expense entities)
  6. Apply events (real estate transactions)
  7. netCashFlow = totalIncome - totalExpenses - totalTax

Projection Loop Flow:
  For each year:
  1. Calculate CRI minimums (add to income, update balances)
  2. Calculate income (employment, RRQ, PSV, RRPE including CRI minimums)
  3. Calculate expenses
  4. Check if all individuals retired
  5. Use iterative calculation:
     - Calculate taxes
     - Calculate shortfall = (expenses + taxes) - income
     - If shortfall > 0: determine withdrawals (may trigger tax recalculation if REER)
     - If surplus > 0 AND all retired: determine contributions
  6. Update asset balances
  7. Update CELI room for next year
  8. Store all data in YearlyProjection