import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/projection_kpis.dart';

/// Extension to calculate KPIs from a Projection
extension ProjectionKpisCalculator on Projection {
  /// Calculate KPIs for this projection
  ProjectionKpis calculateKpis() {
    if (years.isEmpty) {
      return const ProjectionKpis(
        yearMoneyRunsOut: null,
        lowestNetWorth: 0,
        yearOfLowestNetWorth: 0,
        finalNetWorth: 0,
        totalTaxesPaid: 0,
        totalWithdrawals: 0,
        averageTaxRate: 0,
      );
    }

    // Find year money runs out (first year with shortfall)
    int? yearMoneyRunsOut;
    for (final year in years) {
      if (year.hasShortfall) {
        yearMoneyRunsOut = year.year;
        break;
      }
    }

    // Find lowest net worth and its year
    double lowestNetWorth = years.first.netWorthEndOfYear;
    int yearOfLowestNetWorth = years.first.year;

    for (final year in years) {
      if (year.netWorthEndOfYear < lowestNetWorth) {
        lowestNetWorth = year.netWorthEndOfYear;
        yearOfLowestNetWorth = year.year;
      }
    }

    // Final net worth
    final finalNetWorth = years.last.netWorthEndOfYear;

    // Total taxes paid
    double totalTaxesPaid = 0;
    for (final year in years) {
      totalTaxesPaid += year.totalTax;
    }

    // Total withdrawals
    double totalWithdrawals = 0;
    for (final year in years) {
      totalWithdrawals += year.totalWithdrawals;
    }

    // Average tax rate (total tax / total income)
    double totalIncome = 0;
    for (final year in years) {
      totalIncome += year.totalIncome;
    }
    final averageTaxRate = totalIncome > 0
        ? (totalTaxesPaid / totalIncome).toDouble()
        : 0.0;

    return ProjectionKpis(
      yearMoneyRunsOut: yearMoneyRunsOut,
      lowestNetWorth: lowestNetWorth,
      yearOfLowestNetWorth: yearOfLowestNetWorth,
      finalNetWorth: finalNetWorth,
      totalTaxesPaid: totalTaxesPaid,
      totalWithdrawals: totalWithdrawals,
      averageTaxRate: averageTaxRate,
    );
  }
}
