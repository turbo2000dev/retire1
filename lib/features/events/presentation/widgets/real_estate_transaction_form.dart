import 'package:flutter/material.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:retire1/features/events/domain/event.dart';
import 'package:retire1/features/events/domain/event_timing.dart';
import 'package:retire1/features/events/presentation/widgets/timing_selector.dart';
import 'package:retire1/features/project/domain/individual.dart';
import 'package:uuid/uuid.dart';

/// Form for creating/editing a real estate transaction event
class RealEstateTransactionForm extends StatefulWidget {
  final RealEstateTransactionEvent? initialEvent;
  final List<Individual> individuals;
  final List<Asset> assets;
  final ValueChanged<Event?> onChanged;

  const RealEstateTransactionForm({
    super.key,
    this.initialEvent,
    required this.individuals,
    required this.assets,
    required this.onChanged,
  });

  @override
  State<RealEstateTransactionForm> createState() =>
      _RealEstateTransactionFormState();
}

class _RealEstateTransactionFormState
    extends State<RealEstateTransactionForm> {
  EventTiming? _timing;
  String? _assetSoldId;
  String? _assetPurchasedId;
  String? _withdrawAccountId;
  String? _depositAccountId;

  @override
  void initState() {
    super.initState();
    if (widget.initialEvent != null) {
      _timing = widget.initialEvent!.timing;
      _assetSoldId = widget.initialEvent!.assetSoldId;
      _assetPurchasedId = widget.initialEvent!.assetPurchasedId;
      _withdrawAccountId = widget.initialEvent!.withdrawAccountId;
      _depositAccountId = widget.initialEvent!.depositAccountId;
    }
  }

  List<Asset> get _realEstateAssets {
    return widget.assets.where((asset) {
      return asset.maybeWhen(
        realEstate: (_, __, ___, ____) => true,
        orElse: () => false,
      );
    }).toList();
  }

  List<Asset> get _cashAccounts {
    return widget.assets.where((asset) {
      return asset.maybeWhen(
        cash: (_, __, ___) => true,
        orElse: () => false,
      );
    }).toList();
  }

  String _getRealEstateTypeName(RealEstateType type) {
    switch (type) {
      case RealEstateType.house:
        return 'House';
      case RealEstateType.condo:
        return 'Condo';
      case RealEstateType.cottage:
        return 'Cottage';
      case RealEstateType.land:
        return 'Land';
      case RealEstateType.commercial:
        return 'Commercial Property';
      case RealEstateType.other:
        return 'Other Property';
    }
  }

  void _notifyChange() {
    // At least one of assetSold or assetPurchased must be set
    if ((_assetSoldId != null || _assetPurchasedId != null) &&
        _withdrawAccountId != null &&
        _depositAccountId != null &&
        _timing != null) {
      final event = Event.realEstateTransaction(
        id: widget.initialEvent?.id ?? const Uuid().v4(),
        timing: _timing!,
        assetSoldId: _assetSoldId,
        assetPurchasedId: _assetPurchasedId,
        withdrawAccountId: _withdrawAccountId!,
        depositAccountId: _depositAccountId!,
      );
      widget.onChanged(event);
    } else {
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Transaction type
        Text(
          'Transaction',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_realEstateAssets.isEmpty)
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No real estate assets found. Please add real estate in Assets first.',
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          // Asset being sold
          DropdownButtonFormField<String>(
            initialValue: _assetSoldId,
            decoration: const InputDecoration(
              labelText: 'Real estate being sold (optional)',
              border: OutlineInputBorder(),
              helperText: 'Leave empty if only purchasing',
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('None'),
              ),
              ..._realEstateAssets.map((asset) {
                return asset.maybeWhen(
                  realEstate: (id, type, _, __) {
                    return DropdownMenuItem(
                      value: id,
                      child: Text(_getRealEstateTypeName(type)),
                    );
                  },
                  orElse: () => const DropdownMenuItem(
                    value: '',
                    child: Text(''),
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _assetSoldId = value;
              });
              _notifyChange();
            },
          ),
          const SizedBox(height: 16),
          // Asset being purchased
          DropdownButtonFormField<String>(
            initialValue: _assetPurchasedId,
            decoration: const InputDecoration(
              labelText: 'Real estate being purchased (optional)',
              border: OutlineInputBorder(),
              helperText: 'Leave empty if only selling',
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('None'),
              ),
              ..._realEstateAssets.map((asset) {
                return asset.maybeWhen(
                  realEstate: (id, type, _, __) {
                    return DropdownMenuItem(
                      value: id,
                      child: Text(_getRealEstateTypeName(type)),
                    );
                  },
                  orElse: () => const DropdownMenuItem(
                    value: '',
                    child: Text(''),
                  ),
                );
              }),
            ],
            onChanged: (value) {
              setState(() {
                _assetPurchasedId = value;
              });
              _notifyChange();
            },
          ),
        ],
        const SizedBox(height: 24),
        // Cash accounts
        Text(
          'Accounts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_cashAccounts.isEmpty)
          Card(
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No cash accounts found. Please add cash accounts in Assets first.',
                      style: TextStyle(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          DropdownButtonFormField<String>(
            initialValue: _withdrawAccountId,
            decoration: const InputDecoration(
              labelText: 'Withdraw/deposit account',
              border: OutlineInputBorder(),
              helperText: 'Account for purchase funds or sale proceeds',
            ),
            items: _cashAccounts.map((asset) {
              return asset.maybeWhen(
                cash: (id, _, __) {
                  return DropdownMenuItem(
                    value: id,
                    child: const Text('Cash Account'),
                  );
                },
                orElse: () => const DropdownMenuItem(
                  value: '',
                  child: Text(''),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _withdrawAccountId = value;
              });
              _notifyChange();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a withdraw account';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _depositAccountId,
            decoration: const InputDecoration(
              labelText: 'Deposit/source account',
              border: OutlineInputBorder(),
              helperText: 'Account receiving sale proceeds or funding purchase',
            ),
            items: _cashAccounts.map((asset) {
              return asset.maybeWhen(
                cash: (id, _, __) {
                  return DropdownMenuItem(
                    value: id,
                    child: const Text('Cash Account'),
                  );
                },
                orElse: () => const DropdownMenuItem(
                  value: '',
                  child: Text(''),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _depositAccountId = value;
              });
              _notifyChange();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a deposit account';
              }
              return null;
            },
          ),
        ],
        const SizedBox(height: 24),
        // Timing selector
        TimingSelector(
          initialTiming: _timing,
          individuals: widget.individuals,
          onChanged: (timing) {
            setState(() {
              _timing = timing;
            });
            _notifyChange();
          },
        ),
      ],
    );
  }
}
