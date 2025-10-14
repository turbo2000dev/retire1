import 'dart:developer';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/expenses/domain/expense.dart';
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
  /// [expenses] List of expenses to include in projection
  /// [startYear] First year of projection (defaults to current year)
  /// [projectionYears] Number of years to project (defaults to 40)
  /// [inflationRate] Annual inflation rate as decimal (defaults to 0.02)
  /// [useConstantDollars] Whether to use constant or current dollars
  Future<Projection> calculateProjection({
    required Project project,
    required Scenario scenario,
    required List<Asset> assets,
    required List<Event> events,
    required List<Expense> expenses,
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
    final effectiveExpenses = _applyExpenseOverrides(expenses, scenario.overrides);

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

      final eventIncome = eventResults['income'] ?? 0.0;
      final eventExpenses = eventResults['expenses'] ?? 0.0;

      // Calculate expenses from Expense entities (adjusted for inflation)
      final expenseResults = _calculateExpensesForYear(
        effectiveExpenses,
        year,
        yearsFromStart,
        project.individuals,
        calculationStartYear,
        events,
        inflationRate,
      );

      final expenseAmount = expenseResults['total'] as double;
      final expensesByCategory = expenseResults['byCategory'] as Map<String, double>;

      final totalIncome = eventIncome;
      final totalExpenses = eventExpenses + expenseAmount;
      final netCashFlow = totalIncome - totalExpenses;

      // Calculate asset growth (after events)
      _applyAssetGrowth(
        currentAssetValues,
        effectiveAssets,
        project,
      );

      // Apply annual contributions (end of year)
      _applyAnnualContributions(
        currentAssetValues,
        effectiveAssets,
      );

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
        expensesByCategory: expensesByCategory,
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
          rrsp: (id, individualId, value, customReturnRate, annualContribution) => id,
          celi: (id, individualId, value, customReturnRate, annualContribution) => id,
          cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) => id,
          cash: (id, individualId, value, customReturnRate, annualContribution) => id,
        );
      }).firstOrNull;

      if (override == null) return asset;

      // Apply override
      return asset.when(
        realEstate: (id, type, value, setAtStart) =>
            Asset.realEstate(id: id, type: type, value: override.value, setAtStart: setAtStart),
        rrsp: (id, individualId, value, customReturnRate, annualContribution) =>
            Asset.rrsp(id: id, individualId: individualId, value: override.value, customReturnRate: customReturnRate, annualContribution: annualContribution),
        celi: (id, individualId, value, customReturnRate, annualContribution) =>
            Asset.celi(id: id, individualId: individualId, value: override.value, customReturnRate: customReturnRate, annualContribution: annualContribution),
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) =>
            Asset.cri(id: id, individualId: individualId, value: override.value, contributionRoom: contributionRoom, customReturnRate: customReturnRate, annualContribution: annualContribution),
        cash: (id, individualId, value, customReturnRate, annualContribution) =>
            Asset.cash(id: id, individualId: individualId, value: override.value, customReturnRate: customReturnRate, annualContribution: annualContribution),
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

  /// Apply expense overrides from scenario (amount and/or timing)
  List<Expense> _applyExpenseOverrides(
    List<Expense> expenses,
    List<ParameterOverride> overrides,
  ) {
    return expenses.map((expense) {
      // Get expense ID
      final expenseId = expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => id,
        transport: (id, startTiming, endTiming, annualAmount) => id,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => id,
        recreation: (id, startTiming, endTiming, annualAmount) => id,
        health: (id, startTiming, endTiming, annualAmount) => id,
        family: (id, startTiming, endTiming, annualAmount) => id,
      );

      // Find amount override for this expense
      final amountOverride = overrides.where((o) => o.maybeWhen(
        expenseAmount: (id, overrideAmount, amountMultiplier) => id == expenseId,
        orElse: () => false,
      )).firstOrNull;

      // Find timing override for this expense
      final timingOverride = overrides.where((o) => o.maybeWhen(
        expenseTiming: (id, overrideStart, overrideEnd) => id == expenseId,
        orElse: () => false,
      )).firstOrNull;

      // Get current values
      final currentAmount = expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => annualAmount,
        transport: (id, startTiming, endTiming, annualAmount) => annualAmount,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => annualAmount,
        recreation: (id, startTiming, endTiming, annualAmount) => annualAmount,
        health: (id, startTiming, endTiming, annualAmount) => annualAmount,
        family: (id, startTiming, endTiming, annualAmount) => annualAmount,
      );

      final currentStartTiming = expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => startTiming,
        transport: (id, startTiming, endTiming, annualAmount) => startTiming,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => startTiming,
        recreation: (id, startTiming, endTiming, annualAmount) => startTiming,
        health: (id, startTiming, endTiming, annualAmount) => startTiming,
        family: (id, startTiming, endTiming, annualAmount) => startTiming,
      );

      final currentEndTiming = expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => endTiming,
        transport: (id, startTiming, endTiming, annualAmount) => endTiming,
        dailyLiving: (id, startTiming, endTiming, annualAmount) => endTiming,
        recreation: (id, startTiming, endTiming, annualAmount) => endTiming,
        health: (id, startTiming, endTiming, annualAmount) => endTiming,
        family: (id, startTiming, endTiming, annualAmount) => endTiming,
      );

      // Calculate effective amount (apply override if present)
      double effectiveAmount = currentAmount;
      if (amountOverride != null) {
        amountOverride.maybeWhen(
          expenseAmount: (id, overrideAmount, amountMultiplier) {
            if (overrideAmount != null) {
              // Absolute amount override
              effectiveAmount = overrideAmount;
            } else if (amountMultiplier != null) {
              // Multiplier override
              effectiveAmount = currentAmount * amountMultiplier;
            }
          },
          orElse: () {},
        );
      }

      // Calculate effective timing (apply override if present)
      EventTiming effectiveStartTiming = currentStartTiming;
      EventTiming effectiveEndTiming = currentEndTiming;
      if (timingOverride != null) {
        timingOverride.maybeWhen(
          expenseTiming: (id, overrideStart, overrideEnd) {
            if (overrideStart != null) {
              effectiveStartTiming = overrideStart;
            }
            if (overrideEnd != null) {
              effectiveEndTiming = overrideEnd;
            }
          },
          orElse: () {},
        );
      }

      // Return expense with effective values
      return expense.when(
        housing: (id, startTiming, endTiming, annualAmount) => Expense.housing(
          id: id,
          startTiming: effectiveStartTiming,
          endTiming: effectiveEndTiming,
          annualAmount: effectiveAmount,
        ),
        transport: (id, startTiming, endTiming, annualAmount) => Expense.transport(
          id: id,
          startTiming: effectiveStartTiming,
          endTiming: effectiveEndTiming,
          annualAmount: effectiveAmount,
        ),
        dailyLiving: (id, startTiming, endTiming, annualAmount) => Expense.dailyLiving(
          id: id,
          startTiming: effectiveStartTiming,
          endTiming: effectiveEndTiming,
          annualAmount: effectiveAmount,
        ),
        recreation: (id, startTiming, endTiming, annualAmount) => Expense.recreation(
          id: id,
          startTiming: effectiveStartTiming,
          endTiming: effectiveEndTiming,
          annualAmount: effectiveAmount,
        ),
        health: (id, startTiming, endTiming, annualAmount) => Expense.health(
          id: id,
          startTiming: effectiveStartTiming,
          endTiming: effectiveEndTiming,
          annualAmount: effectiveAmount,
        ),
        family: (id, startTiming, endTiming, annualAmount) => Expense.family(
          id: id,
          startTiming: effectiveStartTiming,
          endTiming: effectiveEndTiming,
          annualAmount: effectiveAmount,
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
        rrsp: (id, individualId, value, customReturnRate, annualContribution) {
          values[id] = value;
        },
        celi: (id, individualId, value, customReturnRate, annualContribution) {
          values[id] = value;
        },
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) {
          values[id] = value;
        },
        cash: (id, individualId, value, customReturnRate, annualContribution) {
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
            _isEventInYear(timing, year, yearsFromStart, individuals, startYear, events),
        death: (id, individualId, timing) =>
            _isEventInYear(timing, year, yearsFromStart, individuals, startYear, events),
        realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
                withdrawAccountId, depositAccountId) =>
            _isEventInYear(timing, year, yearsFromStart, individuals, startYear, events),
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
    List<Event> events,
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
      eventRelative: (eventId, boundary) {
        // Resolve when the referenced event occurs
        final resolvedYear = _resolveEventYear(
          eventId,
          events,
          individuals,
          startYear,
          {},
        );

        if (resolvedYear == null) {
          log('Warning: Could not resolve event-relative timing for event $eventId');
          return false;
        }

        // For now, both start and end boundaries use the same year
        // In future, events could have duration
        return resolvedYear == year;
      },
      projectionEnd: () => false, // Projection end is never "in" a specific year
    );
  }

  /// Resolve when an event occurs (returns calendar year)
  ///
  /// This method recursively resolves event timing, including event-relative timing.
  /// Returns null if the event cannot be resolved (not found, circular dependency, etc.)
  int? _resolveEventYear(
    String eventId,
    List<Event> events,
    List<Individual> individuals,
    int startYear,
    Set<String> visitedEventIds,
  ) {
    // Check for circular dependencies
    if (visitedEventIds.contains(eventId)) {
      log('Warning: Circular event reference detected for event $eventId');
      return null;
    }

    // Find the event
    final event = events.where((e) => _getEventId(e) == eventId).firstOrNull;
    if (event == null) {
      log('Warning: Referenced event $eventId not found');
      return null;
    }

    // Get the event's timing
    final timing = event.when(
      retirement: (id, individualId, timing) => timing,
      death: (id, individualId, timing) => timing,
      realEstateTransaction: (id, timing, assetSoldId, assetPurchasedId,
              withdrawAccountId, depositAccountId) =>
          timing,
    );

    // Mark this event as visited (for cycle detection)
    final newVisitedIds = {...visitedEventIds, eventId};

    // Resolve the timing to a calendar year
    return timing.when(
      relative: (years) => startYear + years,
      absolute: (calendarYear) => calendarYear,
      age: (individualId, targetAge) {
        final individual = individuals.where((i) => i.id == individualId).firstOrNull;
        if (individual == null) {
          log('Warning: Individual $individualId not found for age-based timing');
          return null;
        }
        // Calculate what year the individual reaches the target age
        return individual.birthdate.year + targetAge;
      },
      eventRelative: (referencedEventId, boundary) {
        // Recursively resolve the referenced event
        final referencedYear = _resolveEventYear(
          referencedEventId,
          events,
          individuals,
          startYear,
          newVisitedIds,
        );
        // For now, both start and end boundaries return the same year
        // In future, events could have duration and end could be different from start
        return referencedYear;
      },
      projectionEnd: () => null, // Projection end cannot be resolved to a specific year
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
                rrsp: (id, individualId, value, customReturnRate, annualContribution) => 0.0,
                celi: (id, individualId, value, customReturnRate, annualContribution) => 0.0,
                cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) => 0.0,
                cash: (id, individualId, value, customReturnRate, annualContribution) => 0.0,
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

  /// Apply asset growth based on return rates
  void _applyAssetGrowth(
    Map<String, double> assetValues,
    List<Asset> assets,
    Project project,
  ) {
    for (final asset in assets) {
      asset.when(
        realEstate: (id, type, value, setAtStart) {
          // Real estate grows at inflation rate
          final currentValue = assetValues[id] ?? 0.0;
          final newValue = currentValue * (1 + project.inflationRate);
          assetValues[id] = newValue;
        },
        rrsp: (id, individualId, value, customReturnRate, annualContribution) {
          // RRSP grows at custom rate or project REER rate
          final currentValue = assetValues[id] ?? 0.0;
          final rate = customReturnRate ?? project.reerReturnRate;
          final newValue = currentValue * (1 + rate);
          assetValues[id] = newValue;
        },
        celi: (id, individualId, value, customReturnRate, annualContribution) {
          // CELI grows at custom rate or project CELI rate
          final currentValue = assetValues[id] ?? 0.0;
          final rate = customReturnRate ?? project.celiReturnRate;
          final newValue = currentValue * (1 + rate);
          assetValues[id] = newValue;
        },
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) {
          // CRI grows at custom rate or project CRI rate
          final currentValue = assetValues[id] ?? 0.0;
          final rate = customReturnRate ?? project.criReturnRate;
          final newValue = currentValue * (1 + rate);
          assetValues[id] = newValue;
        },
        cash: (id, individualId, value, customReturnRate, annualContribution) {
          // Cash grows at custom rate or project cash rate
          final currentValue = assetValues[id] ?? 0.0;
          final rate = customReturnRate ?? project.cashReturnRate;
          final newValue = currentValue * (1 + rate);
          assetValues[id] = newValue;
        },
      );
    }
  }

  /// Apply annual contributions to accounts (end of year)
  void _applyAnnualContributions(
    Map<String, double> assetValues,
    List<Asset> assets,
  ) {
    for (final asset in assets) {
      asset.when(
        realEstate: (id, type, value, setAtStart) {
          // Real estate has no annual contributions
        },
        rrsp: (id, individualId, value, customReturnRate, annualContribution) {
          if (annualContribution != null && annualContribution > 0) {
            final currentValue = assetValues[id] ?? 0.0;
            assetValues[id] = currentValue + annualContribution;
          }
        },
        celi: (id, individualId, value, customReturnRate, annualContribution) {
          if (annualContribution != null && annualContribution > 0) {
            final currentValue = assetValues[id] ?? 0.0;
            assetValues[id] = currentValue + annualContribution;
          }
        },
        cri: (id, individualId, value, contributionRoom, customReturnRate, annualContribution) {
          if (annualContribution != null && annualContribution > 0) {
            final currentValue = assetValues[id] ?? 0.0;
            assetValues[id] = currentValue + annualContribution;
          }
        },
        cash: (id, individualId, value, customReturnRate, annualContribution) {
          if (annualContribution != null && annualContribution > 0) {
            final currentValue = assetValues[id] ?? 0.0;
            assetValues[id] = currentValue + annualContribution;
          }
        },
      );
    }
  }

  /// Calculate total expenses for a year from Expense entities
  ///
  /// Expenses are entered in "today's dollars" (constant dollars at year 0)
  /// and are adjusted for inflation each year using the formula:
  /// adjustedAmount = baseAmount * (1 + inflationRate)^yearsFromStart
  ///
  /// Returns a Map with:
  /// - 'total': total expenses for the year
  /// - 'byCategory': Map of String to double for expenses by category
  Map<String, dynamic> _calculateExpensesForYear(
    List<Expense> expenses,
    int year,
    int yearsFromStart,
    List<Individual> individuals,
    int startYear,
    List<Event> events,
    double inflationRate,
  ) {
    double totalExpenses = 0.0;
    final expensesByCategory = <String, double>{
      'housing': 0.0,
      'transport': 0.0,
      'dailyLiving': 0.0,
      'recreation': 0.0,
      'health': 0.0,
      'family': 0.0,
    };

    for (final expense in expenses) {
      // Extract timing information
      final startTiming = expense.when(
        housing: (_, startTiming, __, ___) => startTiming,
        transport: (_, startTiming, __, ___) => startTiming,
        dailyLiving: (_, startTiming, __, ___) => startTiming,
        recreation: (_, startTiming, __, ___) => startTiming,
        health: (_, startTiming, __, ___) => startTiming,
        family: (_, startTiming, __, ___) => startTiming,
      );

      final endTiming = expense.when(
        housing: (_, __, endTiming, ___) => endTiming,
        transport: (_, __, endTiming, ___) => endTiming,
        dailyLiving: (_, __, endTiming, ___) => endTiming,
        recreation: (_, __, endTiming, ___) => endTiming,
        health: (_, __, endTiming, ___) => endTiming,
        family: (_, __, endTiming, ___) => endTiming,
      );

      // Check if expense is active this year
      final hasStarted = _hasTimingOccurred(
        startTiming,
        year,
        yearsFromStart,
        individuals,
        startYear,
        events,
      );

      final hasEnded = _hasTimingOccurred(
        endTiming,
        year,
        yearsFromStart,
        individuals,
        startYear,
        events,
      );

      // Expense is active if it has started but not yet ended
      // For projectionEnd timing, hasEnded will be false (never ends)
      if (hasStarted && !hasEnded) {
        final baseAmount = expense.when(
          housing: (_, __, ___, annualAmount) => annualAmount,
          transport: (_, __, ___, annualAmount) => annualAmount,
          dailyLiving: (_, __, ___, annualAmount) => annualAmount,
          recreation: (_, __, ___, annualAmount) => annualAmount,
          health: (_, __, ___, annualAmount) => annualAmount,
          family: (_, __, ___, annualAmount) => annualAmount,
        );

        // Apply inflation adjustment
        // Base amount is in year 0 dollars, adjust for years from start
        final inflationMultiplier = _calculateInflationMultiplier(inflationRate, yearsFromStart);
        final adjustedAmount = baseAmount * inflationMultiplier;

        // Add to total
        totalExpenses += adjustedAmount;

        // Add to category breakdown
        expense.when(
          housing: (_, __, ___, ____) {
            expensesByCategory['housing'] = (expensesByCategory['housing'] ?? 0.0) + adjustedAmount;
          },
          transport: (_, __, ___, ____) {
            expensesByCategory['transport'] = (expensesByCategory['transport'] ?? 0.0) + adjustedAmount;
          },
          dailyLiving: (_, __, ___, ____) {
            expensesByCategory['dailyLiving'] = (expensesByCategory['dailyLiving'] ?? 0.0) + adjustedAmount;
          },
          recreation: (_, __, ___, ____) {
            expensesByCategory['recreation'] = (expensesByCategory['recreation'] ?? 0.0) + adjustedAmount;
          },
          health: (_, __, ___, ____) {
            expensesByCategory['health'] = (expensesByCategory['health'] ?? 0.0) + adjustedAmount;
          },
          family: (_, __, ___, ____) {
            expensesByCategory['family'] = (expensesByCategory['family'] ?? 0.0) + adjustedAmount;
          },
        );
      }
    }

    return {
      'total': totalExpenses,
      'byCategory': expensesByCategory,
    };
  }

  /// Calculate inflation multiplier for a given number of years
  ///
  /// Formula: (1 + inflationRate)^years
  /// Example: 2% inflation over 5 years = 1.02^5 = 1.10408
  double _calculateInflationMultiplier(double inflationRate, int years) {
    if (years == 0) return 1.0;

    double multiplier = 1.0;
    for (int i = 0; i < years; i++) {
      multiplier *= (1 + inflationRate);
    }

    return multiplier;
  }

  /// Check if a timing has occurred on or before a specific year
  ///
  /// For projectionEnd timing, this always returns false (event never occurs)
  bool _hasTimingOccurred(
    EventTiming timing,
    int year,
    int yearsFromStart,
    List<Individual> individuals,
    int startYear,
    List<Event> events,
  ) {
    return timing.when(
      relative: (years) => years <= yearsFromStart,
      absolute: (calendarYear) => calendarYear <= year,
      age: (individualId, targetAge) {
        final individual = individuals.where((i) => i.id == individualId).firstOrNull;
        if (individual == null) return false;
        final currentAge = _calculateAge(individual.birthdate, year);
        return currentAge >= targetAge;
      },
      eventRelative: (eventId, boundary) {
        // Resolve when the referenced event occurs
        final resolvedYear = _resolveEventYear(
          eventId,
          events,
          individuals,
          startYear,
          {},
        );

        if (resolvedYear == null) {
          log('Warning: Could not resolve event-relative timing for event $eventId');
          return false;
        }

        // Event-relative timing has occurred if the event year has passed
        return resolvedYear <= year;
      },
      projectionEnd: () => false, // Projection end never "occurs" - expenses continue until end
    );
  }
}
