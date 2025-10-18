import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/responsive_builder.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_provider.dart';
import 'package:retire1/features/project/presentation/wizard/wizard_state.dart';
import 'package:uuid/uuid.dart';

/// Step 3: Configure major assets
class WizardAssetsStep extends ConsumerStatefulWidget {
  const WizardAssetsStep({super.key});

  @override
  ConsumerState<WizardAssetsStep> createState() => _WizardAssetsStepState();
}

class _WizardAssetsStepState extends ConsumerState<WizardAssetsStep> {
  // Asset type selections
  bool _hasRealEstate = false;
  bool _hasRrsp = false;
  bool _hasCeli = false;
  bool _hasCri = false;
  bool _hasCash = false;

  // Real estate (only 1 allowed)
  final _realEstateValueController = TextEditingController();

  // RRSP accounts (can have multiple)
  final List<_RrspAccount> _rrspAccounts = [];

  // CELI accounts (can have multiple)
  final List<_CeliAccount> _celiAccounts = [];

  // CRI accounts (can have multiple)
  final List<_CriAccount> _criAccounts = [];

  // Cash accounts (can have multiple)
  final List<_CashAccount> _cashAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  @override
  void dispose() {
    _realEstateValueController.dispose();
    for (var account in _rrspAccounts) {
      account.balanceController.dispose();
      account.contributionController.dispose();
    }
    for (var account in _celiAccounts) {
      account.balanceController.dispose();
      account.contributionController.dispose();
    }
    for (var account in _criAccounts) {
      account.balanceController.dispose();
    }
    for (var account in _cashAccounts) {
      account.balanceController.dispose();
    }
    super.dispose();
  }

  void _loadExistingData() {
    final wizardState = ref.read(wizardProvider);
    if (wizardState == null) return;

    final assets = wizardState.assets;

    // Load real estate
    final realEstate = assets.whereType<WizardRealEstateData>().firstOrNull;
    if (realEstate != null) {
      _hasRealEstate = true;
      _realEstateValueController.text = realEstate.value.toStringAsFixed(0);
    }

    // Load RRSP accounts
    final rrsps = assets.whereType<WizardRrspData>().toList();
    if (rrsps.isNotEmpty) {
      _hasRrsp = true;
      _rrspAccounts.clear();
      for (var rrsp in rrsps) {
        _rrspAccounts.add(
          _RrspAccount(
            id: rrsp.id,
            individualId: rrsp.individualId,
            balanceController: TextEditingController(
              text: rrsp.value.toStringAsFixed(0),
            ),
            contributionController: TextEditingController(
              text: rrsp.annualContribution?.toStringAsFixed(0) ?? '',
            ),
          ),
        );
      }
    }

    // Load CELI accounts
    final celis = assets.whereType<WizardCeliData>().toList();
    if (celis.isNotEmpty) {
      _hasCeli = true;
      _celiAccounts.clear();
      for (var celi in celis) {
        _celiAccounts.add(
          _CeliAccount(
            id: celi.id,
            individualId: celi.individualId,
            balanceController: TextEditingController(
              text: celi.value.toStringAsFixed(0),
            ),
            contributionController: TextEditingController(
              text: celi.annualContribution?.toStringAsFixed(0) ?? '',
            ),
          ),
        );
      }
    }

    // Load CRI accounts
    final cris = assets.whereType<WizardCriData>().toList();
    if (cris.isNotEmpty) {
      _hasCri = true;
      _criAccounts.clear();
      for (var cri in cris) {
        _criAccounts.add(
          _CriAccount(
            id: cri.id,
            individualId: cri.individualId,
            balanceController: TextEditingController(
              text: cri.value.toStringAsFixed(0),
            ),
          ),
        );
      }
    }

    // Load Cash accounts
    final cashes = assets.whereType<WizardCashData>().toList();
    if (cashes.isNotEmpty) {
      _hasCash = true;
      _cashAccounts.clear();
      for (var cash in cashes) {
        _cashAccounts.add(
          _CashAccount(
            id: cash.id,
            individualId: cash.individualId,
            balanceController: TextEditingController(
              text: cash.value.toStringAsFixed(0),
            ),
          ),
        );
      }
    }
  }

  void _saveData() {
    final List<WizardAssetData> assets = [];

    // Add real estate if selected
    if (_hasRealEstate) {
      final value = double.tryParse(_realEstateValueController.text) ?? 0.0;
      if (value > 0) {
        assets.add(
          WizardAssetData.realEstate(id: const Uuid().v4(), value: value),
        );
      }
    }

    // Add RRSP accounts
    if (_hasRrsp) {
      for (var account in _rrspAccounts) {
        final balance = double.tryParse(account.balanceController.text) ?? 0.0;
        if (balance > 0) {
          final contribution = double.tryParse(
            account.contributionController.text,
          );
          assets.add(
            WizardAssetData.rrsp(
              id: account.id,
              individualId: account.individualId,
              value: balance,
              annualContribution: contribution,
            ),
          );
        }
      }
    }

    // Add CELI accounts
    if (_hasCeli) {
      for (var account in _celiAccounts) {
        final balance = double.tryParse(account.balanceController.text) ?? 0.0;
        if (balance > 0) {
          final contribution = double.tryParse(
            account.contributionController.text,
          );
          assets.add(
            WizardAssetData.celi(
              id: account.id,
              individualId: account.individualId,
              value: balance,
              annualContribution: contribution,
            ),
          );
        }
      }
    }

    // Add CRI accounts
    if (_hasCri) {
      for (var account in _criAccounts) {
        final balance = double.tryParse(account.balanceController.text) ?? 0.0;
        if (balance > 0) {
          assets.add(
            WizardAssetData.cri(
              id: account.id,
              individualId: account.individualId,
              value: balance,
            ),
          );
        }
      }
    }

    // Add Cash accounts
    if (_hasCash) {
      for (var account in _cashAccounts) {
        final balance = double.tryParse(account.balanceController.text) ?? 0.0;
        if (balance > 0) {
          assets.add(
            WizardAssetData.cash(
              id: account.id,
              individualId: account.individualId,
              value: balance,
            ),
          );
        }
      }
    }

    ref.read(wizardProvider.notifier).clearAssets();
    for (var asset in assets) {
      ref.read(wizardProvider.notifier).addAsset(asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = ref.watch(wizardProvider);

    if (wizardState == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final individual1 = wizardState.individual1;
    final individual2 = wizardState.individual2;

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(screenSize.isPhone ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Brief step description
              Text(
                'Select the asset types you currently have',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'All assets are optional - you can add them later if needed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 24),

              // Asset type checkboxes and detail forms
              _buildAssetTypeSection(
                theme: theme,
                title: 'Real Estate',
                description: 'Primary residence',
                icon: Icons.home_outlined,
                value: _hasRealEstate,
                onChanged: (value) {
                  setState(() => _hasRealEstate = value ?? false);
                  _saveData();
                },
                detailsBuilder: _hasRealEstate
                    ? () => _buildRealEstateDetails(theme)
                    : null,
              ),
              const SizedBox(height: 16),

              _buildAssetTypeSection(
                theme: theme,
                title: 'RRSP/REER Accounts',
                description: 'Registered retirement savings',
                icon: Icons.account_balance_outlined,
                value: _hasRrsp,
                onChanged: (value) {
                  setState(() {
                    _hasRrsp = value ?? false;
                    if (_hasRrsp && _rrspAccounts.isEmpty) {
                      _addRrspAccount(individual1?.id ?? '');
                    }
                  });
                  _saveData();
                },
                detailsBuilder: _hasRrsp
                    ? () => _buildRrspDetails(theme, individual1, individual2)
                    : null,
              ),
              const SizedBox(height: 16),

              _buildAssetTypeSection(
                theme: theme,
                title: 'CELI/TFSA Accounts',
                description: 'Tax-free savings accounts',
                icon: Icons.savings_outlined,
                value: _hasCeli,
                onChanged: (value) {
                  setState(() {
                    _hasCeli = value ?? false;
                    if (_hasCeli && _celiAccounts.isEmpty) {
                      _addCeliAccount(individual1?.id ?? '');
                    }
                  });
                  _saveData();
                },
                detailsBuilder: _hasCeli
                    ? () => _buildCeliDetails(theme, individual1, individual2)
                    : null,
              ),
              const SizedBox(height: 16),

              _buildAssetTypeSection(
                theme: theme,
                title: 'CRI Accounts',
                description: 'Locked-in retirement accounts',
                icon: Icons.lock_outlined,
                value: _hasCri,
                onChanged: (value) {
                  setState(() {
                    _hasCri = value ?? false;
                    if (_hasCri && _criAccounts.isEmpty) {
                      _addCriAccount(individual1?.id ?? '');
                    }
                  });
                  _saveData();
                },
                detailsBuilder: _hasCri
                    ? () => _buildCriDetails(theme, individual1, individual2)
                    : null,
              ),
              const SizedBox(height: 16),

              _buildAssetTypeSection(
                theme: theme,
                title: 'Cash/Savings Accounts',
                description: 'Non-registered savings',
                icon: Icons.attach_money,
                value: _hasCash,
                onChanged: (value) {
                  setState(() {
                    _hasCash = value ?? false;
                    if (_hasCash && _cashAccounts.isEmpty) {
                      _addCashAccount(individual1?.id ?? '');
                    }
                  });
                  _saveData();
                },
                detailsBuilder: _hasCash
                    ? () => _buildCashDetails(theme, individual1, individual2)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAssetTypeSection({
    required ThemeData theme,
    required String title,
    required String description,
    required IconData icon,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Widget Function()? detailsBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: value,
          onChanged: onChanged,
          title: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (detailsBuilder != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 8),
            child: detailsBuilder(),
          ),
        ],
      ],
    );
  }

  Widget _buildRealEstateDetails(ThemeData theme) {
    return TextFormField(
      controller: _realEstateValueController,
      decoration: const InputDecoration(
        labelText: 'Estimated Current Value',
        border: OutlineInputBorder(),
        prefixText: '\$ ',
        isDense: true,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: (_) => _saveData(),
    );
  }

  void _addRrspAccount(String individualId) {
    _rrspAccounts.add(
      _RrspAccount(
        id: const Uuid().v4(),
        individualId: individualId,
        balanceController: TextEditingController(),
        contributionController: TextEditingController(),
      ),
    );
  }

  void _removeRrspAccount(int index) {
    if (index >= 0 && index < _rrspAccounts.length) {
      _rrspAccounts[index].balanceController.dispose();
      _rrspAccounts[index].contributionController.dispose();
      _rrspAccounts.removeAt(index);
    }
  }

  Widget _buildRrspDetails(ThemeData theme, individual1, individual2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._rrspAccounts.asMap().entries.map((entry) {
          final index = entry.key;
          final account = entry.value;
          return _buildAccountCard(
            theme: theme,
            title: 'RRSP Account ${index + 1}',
            balanceController: account.balanceController,
            contributionController: account.contributionController,
            individualId: account.individualId,
            individual1: individual1,
            individual2: individual2,
            onOwnerChanged: (newOwnerId) {
              setState(() => account.individualId = newOwnerId);
              _saveData();
            },
            onRemove: _rrspAccounts.length > 1
                ? () {
                    setState(() => _removeRrspAccount(index));
                    _saveData();
                  }
                : null,
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _addRrspAccount(individual1?.id ?? ''));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Another RRSP Account'),
        ),
      ],
    );
  }

  void _addCeliAccount(String individualId) {
    _celiAccounts.add(
      _CeliAccount(
        id: const Uuid().v4(),
        individualId: individualId,
        balanceController: TextEditingController(),
        contributionController: TextEditingController(),
      ),
    );
  }

  void _removeCeliAccount(int index) {
    if (index >= 0 && index < _celiAccounts.length) {
      _celiAccounts[index].balanceController.dispose();
      _celiAccounts[index].contributionController.dispose();
      _celiAccounts.removeAt(index);
    }
  }

  Widget _buildCeliDetails(ThemeData theme, individual1, individual2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._celiAccounts.asMap().entries.map((entry) {
          final index = entry.key;
          final account = entry.value;
          return _buildAccountCard(
            theme: theme,
            title: 'CELI Account ${index + 1}',
            balanceController: account.balanceController,
            contributionController: account.contributionController,
            individualId: account.individualId,
            individual1: individual1,
            individual2: individual2,
            onOwnerChanged: (newOwnerId) {
              setState(() => account.individualId = newOwnerId);
              _saveData();
            },
            onRemove: _celiAccounts.length > 1
                ? () {
                    setState(() => _removeCeliAccount(index));
                    _saveData();
                  }
                : null,
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _addCeliAccount(individual1?.id ?? ''));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Another CELI Account'),
        ),
      ],
    );
  }

  void _addCriAccount(String individualId) {
    _criAccounts.add(
      _CriAccount(
        id: const Uuid().v4(),
        individualId: individualId,
        balanceController: TextEditingController(),
      ),
    );
  }

  void _removeCriAccount(int index) {
    if (index >= 0 && index < _criAccounts.length) {
      _criAccounts[index].balanceController.dispose();
      _criAccounts.removeAt(index);
    }
  }

  Widget _buildCriDetails(ThemeData theme, individual1, individual2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._criAccounts.asMap().entries.map((entry) {
          final index = entry.key;
          final account = entry.value;
          return _buildAccountCard(
            theme: theme,
            title: 'CRI Account ${index + 1}',
            balanceController: account.balanceController,
            individualId: account.individualId,
            individual1: individual1,
            individual2: individual2,
            onOwnerChanged: (newOwnerId) {
              setState(() => account.individualId = newOwnerId);
              _saveData();
            },
            onRemove: _criAccounts.length > 1
                ? () {
                    setState(() => _removeCriAccount(index));
                    _saveData();
                  }
                : null,
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _addCriAccount(individual1?.id ?? ''));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Another CRI Account'),
        ),
      ],
    );
  }

  void _addCashAccount(String individualId) {
    _cashAccounts.add(
      _CashAccount(
        id: const Uuid().v4(),
        individualId: individualId,
        balanceController: TextEditingController(),
      ),
    );
  }

  void _removeCashAccount(int index) {
    if (index >= 0 && index < _cashAccounts.length) {
      _cashAccounts[index].balanceController.dispose();
      _cashAccounts.removeAt(index);
    }
  }

  Widget _buildCashDetails(ThemeData theme, individual1, individual2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._cashAccounts.asMap().entries.map((entry) {
          final index = entry.key;
          final account = entry.value;
          return _buildAccountCard(
            theme: theme,
            title: 'Cash Account ${index + 1}',
            balanceController: account.balanceController,
            individualId: account.individualId,
            individual1: individual1,
            individual2: individual2,
            onOwnerChanged: (newOwnerId) {
              setState(() => account.individualId = newOwnerId);
              _saveData();
            },
            onRemove: _cashAccounts.length > 1
                ? () {
                    setState(() => _removeCashAccount(index));
                    _saveData();
                  }
                : null,
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            setState(() => _addCashAccount(individual1?.id ?? ''));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add Another Cash Account'),
        ),
      ],
    );
  }

  Widget _buildAccountCard({
    required ThemeData theme,
    required String title,
    required TextEditingController balanceController,
    TextEditingController? contributionController,
    required String individualId,
    required individual1,
    required individual2,
    required ValueChanged<String> onOwnerChanged,
    VoidCallback? onRemove,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    iconSize: 20,
                    onPressed: onRemove,
                    tooltip: 'Remove account',
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Owner dropdown
            DropdownButtonFormField<String>(
              value: individualId,
              decoration: const InputDecoration(
                labelText: 'Owner',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                if (individual1 != null)
                  DropdownMenuItem(
                    value: individual1.id,
                    child: Text(individual1.name),
                  ),
                if (individual2 != null)
                  DropdownMenuItem(
                    value: individual2.id,
                    child: Text(individual2.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) onOwnerChanged(value);
              },
            ),
            const SizedBox(height: 12),

            // Current balance
            TextFormField(
              controller: balanceController,
              decoration: const InputDecoration(
                labelText: 'Current Balance',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
                isDense: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              onChanged: (_) => _saveData(),
            ),

            // Annual contribution (if provided)
            if (contributionController != null) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: contributionController,
                decoration: const InputDecoration(
                  labelText: 'Annual Contribution (optional)',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                  isDense: true,
                  helperText: 'Amount contributed each year',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                onChanged: (_) => _saveData(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Helper classes to track account state
class _RrspAccount {
  String id;
  String individualId;
  final TextEditingController balanceController;
  final TextEditingController contributionController;

  _RrspAccount({
    required this.id,
    required this.individualId,
    required this.balanceController,
    required this.contributionController,
  });
}

class _CeliAccount {
  String id;
  String individualId;
  final TextEditingController balanceController;
  final TextEditingController contributionController;

  _CeliAccount({
    required this.id,
    required this.individualId,
    required this.balanceController,
    required this.contributionController,
  });
}

class _CriAccount {
  String id;
  String individualId;
  final TextEditingController balanceController;

  _CriAccount({
    required this.id,
    required this.individualId,
    required this.balanceController,
  });
}

class _CashAccount {
  String id;
  String individualId;
  final TextEditingController balanceController;

  _CashAccount({
    required this.id,
    required this.individualId,
    required this.balanceController,
  });
}
