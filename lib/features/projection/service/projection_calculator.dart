import 'dart:developer';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:retire1/features/project/domain/project.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/projection/domain/yearly_projection.dart';
import 'package:retire1/features/scenarios/domain/parameter_override.dart';
import 'package:retire1/features/scenarios/domain/scenario.dart';

/// Service for calculating retirement projections
class ProjectionCalculator {
  /// Calculate projection for a scenario
  ///
  /// [project] The project containing individuals
  /// [scenario] The scenario with potential overrides
  /// [assets] List of assets to project
  /// [events] List of events to apply during projection
  /// [startYear] First year of projection (defaults to current year)
  /// [projectionYears] Number of years to project (defaults to 40)
  /// [inflationRate] Annual inflation rate as decimal (defaults to 0.02)
  /// [useConstantDollars] Whether to use constant or current dollars
  Future<Projection> calculateProjection({
    required Project project,
    required Scenario scenario,
    required List<Asset> assets,
    required List<Event> events,
    int? startYear,
    int projectionYears = 40,
    double inflationRate = 0.02,
    bool useConstantDollars = false,
  }) async {
    final calculationStartYear = startYear ?? DateTime.now().year;
    final endYear = calculationStartYear + projectionYears - 1;

    log('Calculating projection for scenario ${scenario.name} from $calculationStartYear to $endYear');

    // Apply scenario overrides
    final effectiveAssets = _applyAssetOverrides(assets, scenario.overrides);
    final effectiveEvents = _applyEventOverrides(events, scenario.overrides);

    // Calculate yearly projections
    final years = <YearlyProjection>[];
    Map<String, double> currentAssetValues = _initializeAssetValues(effectiveAssets);

    for (int year = calculationStartYear; year <= endYear; year++) {
      final yearsFromStart = year - calculationStartYear;

      // Get ages for individuals
      final primaryIndividual = project.individuals.isNotEmpty ? project.individuals[0] : null;
      final spouseIndividual = project.individuals.length > 1 ? project.individuals[1] : null;

      final primaryAge = primaryIndividual != null
          ? _calculateAge(primaryIndividual.birthdate, year)
          : null;
      final spouseAge = spouseIndividual != null
          ? _calculateAge(spouseIndividual.birthdate, year)
          : null;

      // Get events that occur this year
      final yearEvents = _getEventsForYear(
        effectiveEvents,
        year,
        yearsFromStart,
        project.individuals,
        calculationStartYear,
      );

      // Calculate assets at start of year
      final assetsStartOfYear = Map<String, double>.from(currentAssetValues);
      final netWorthStartOfYear = assetsStartOfYear.values.fold(0.0, (sum, value) => sum + value);

      // Apply events and calculate income/expenses
      final eventResults = _applyYearEvents(
        yearEvents,
        currentAssetValues,
        effectiveAssets,
      );

      final totalIncome = eventResults['income'] ?? 0.0;
      final totalExpenses = eventResults['expenses'] ?? 0.0;
      final netCashFlow = totalIncome - totalExpenses;

      // Update asset values for end of year
      final assetsEndOfYear = Map<String, double>.from(currentAssetValues);
      final netWorthEndOfYear = assetsEndOfYear.values.fold(0.0, (sum, value) => sum + value);

      // Create yearly projection
      years.add(YearlyProjection(
        year: year,
        yearsFromStart: yearsFromStart,
        primaryAge: primaryAge,
        spouseAge: spouseAge,
        totalIncome: totalIncome,
        totalExpenses: totalExpenses,
        netCashFlow: netCashFlow,
        assetsStartOfYear: assetsStartOfYear,
        assetsEndOfYear: assetsEndOfYear,
        netWorthStartOfYear: netWorthStartOfYear,
        netWorthEndOfYear: netWorthEndOfYear,
        eventsOccurred: yearEvents.map((e) => _getEventId(e)).toList(),
      ));

      // Update current asset values for next year
      currentAssetValues = Map<String, double>.from(assetsEndOfYear);
    }

    return Projection(
      scenarioId: scenario.id,
      projectId: project.id,
      startYear: calculationStartYear,
      endYear: endYear,
      useConstantDollars: useConstantDollars,
      inflationRate: inflationRate,
      years: years,
      calculatedAt: DateTime.now(),
    );
  }

  /// Apply asset value overrides from scenario
  List<Asset> _applyAssetOverrides(
    List<Asset> assets,
    List<ParameterOverride> overrides,
  ) {
    return assets.map((asset) {
      // Find override for this asset
      final override = overrides.whereType<AssetValueOverride>().where((o) {
        return o.assetId == asset.when(
          realEstate: (id, type, value, setAtStart) => id,
          rrsp: (id, individualId, value) => id,
          celi: (id, individualId, value) => id,
          cash: (id, individualId, value) => id,
        );
      }).firstOrNull;

      if (override == null) return asset;

      // Apply override
      return asset.when(
        realEstate: (id, type, value, setAtStart) =>
            Asset.realEstate(id: id, type: type, value: override.value, setAtStart: setAtStart),
        rrsp: (id, individualId, value) =>
            Asset.rrsp(id: id, individualId: individualId, value: override.value),
        celi: (id, individualId, value) =>
            Asset.celi(id: id, individualId: individualId, value: override.value),
        cash: (id, individualId, value) =>
            Asset.cash(id: id, individualId: individualId, value: override.value),
      );
    }).toList();
  }

  /// Apply event timing overrides from scenario
  List<Event> _applyEventOverrides(
    List<Event> events,
    List<ParameterOverride> overrides,
  ) {
    return events.map((event) {
      final eventId = _getEventId(event);

      // Find override for this event
      final override = overrides.whereType<EventTimingOverride>().where((o) {
        return o.eventId == eventId;
      }).firstOrNull;

      if (override == null) return event;

      // Apply override - convert to relative timing
      final newTiming = EventTiming.relative(yearsFromStart: override.yearsFromStart);

      return event.when(
        retirement: (id, individualId, timing) =>
            Event.retirement(id: id, individualId: individualId, timing: newTiming),
        death: (id, individualId, timing) =>
            Event.death(id: id, individualId: individualId, timing: newTiming),
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            Event.realEstateTransaction(
              id: id,
              timing: newTiming,
              assetSoldId: assetSoldId,
              assetPurchasedId: assetPurchasedId,
              withdrawAccountId: withdrawAccountId,
              depositAccountId: depositAccountId,
            ),
      );
    }).toList();
  }

  /// Initialize asset values at start of projection
  Map<String, double> _initializeAssetValues(List<Asset> assets) {
    final values = <String, double>{};
    for (final asset in assets) {
      asset.when(
        realEstate: (id, type, value, setAtStart) {
          values[id] = value;
        },
        rrsp: (id, individualId, value) {
          values[id] = value;
        },
        celi: (id, individualId, value) {
          values[id] = value;
        },
        cash: (id, individualId, value) {
          values[id] = value;
        },
      );
    }
    return values;
  }

  /// Calculate age at a specific year
  int _calculateAge(DateTime birthdate, int year) {
    int age = year - birthdate.year;
    // Simplified - assumes birthday has passed in the year
    return age;
  }

  /// Get events that occur in a specific year
  List<Event> _getEventsForYear(
    List<Event> events,
    int year,
    int yearsFromStart,
    List<Individual> individuals,
    int startYear,
  ) {
    return events.where((event) {
      return event.when(
        retirement: (id, individualId, timing) =>
            _isEventInYear(timing, year, yearsFromStart, individuals, startYear),
        death: (id, individualId, timing) =>
            _isEventInYear(timing, year, yearsFromStart, individuals, startYear),
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            _isEventInYear(timing, year, yearsFromStart, individuals, startYear),
      );
    }).toList();
  }

  /// Check if an event occurs in a specific year
  bool _isEventInYear(
    EventTiming timing,
    int year,
    int yearsFromStart,
    List<Individual> individuals,
    int startYear,
  ) {
    return timing.when(
      relative: (years) => years == yearsFromStart,
      absolute: (calendarYear) => calendarYear == year,
      age: (individualId, targetAge) {
        final individual = individuals.where((i) => i.id == individualId).firstOrNull;
        if (individual == null) return false;
        final currentAge = _calculateAge(individual.birthdate, year);
        return currentAge == targetAge;
      },
    );
  }

  /// Apply events that occur in a year and calculate income/expenses
  Map<String, double> _applyYearEvents(
    List<Event> events,
    Map<String, double> currentAssetValues,
    List<Asset> assets,
  ) {
    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    for (final event in events) {
      event.when(
        retirement: (id, individualId, timing) {
          // Retirement event - in future phases, this would trigger pension income
          log('Retirement event occurred');
        },
        death: (id, individualId, timing) {
          // Death event - in future phases, this would trigger estate changes
          log('Death event occurred');
        },
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
            withdrawAccountId, depositAccountId) {
          // Real estate transaction
          double transactionAmount = 0.0;

          if (assetSoldId != null) {
            // Selling property - add to cash
            final saleValue = currentAssetValues[assetSoldId] ?? 0.0;
            currentAssetValues[depositAccountId] =
                (currentAssetValues[depositAccountId] ?? 0.0) + saleValue;
            currentAssetValues.remove(assetSoldId);
            totalIncome += saleValue;
            transactionAmount += saleValue;
          }

          if (assetPurchasedId != null) {
            // Buying property - deduct from cash
            final asset = assets.where((a) => a.maybeWhen(
              realEstate: (id, type, value, setAtStart) => id == assetPurchasedId,
              orElse: () => false,
            )).firstOrNull;

            if (asset != null) {
              final purchaseValue = asset.when(
                realEstate: (id, type, value, setAtStart) => value,
                rrsp: (id, individualId, value) => 0.0,
                celi: (id, individualId, value) => 0.0,
                cash: (id, individualId, value) => 0.0,
              );

              currentAssetValues[withdrawAccountId] =
                  (currentAssetValues[withdrawAccountId] ?? 0.0) - purchaseValue;
              currentAssetValues[assetPurchasedId] = purchaseValue;
              totalExpenses += purchaseValue;
              transactionAmount -= purchaseValue;
            }
          }

          log('Real estate transaction: amount = $transactionAmount');
        },
      );
    }

    return {
      'income': totalIncome,
      'expenses': totalExpenses,
    };
  }

  /// Get event ID from event
  String _getEventId(Event event) {
    return event.when(
      retirement: (id, individualId, timing) => id,
      death: (id, individualId, timing) => id,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          id,
    );
  }
}
