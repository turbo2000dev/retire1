import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing dollar display mode (current vs constant dollars)
///
/// Persists user preference to SharedPreferences so it survives app restarts.
/// Default: false (current dollars)
final dollarModeProvider = StateNotifierProvider<DollarModeNotifier, bool>((
  ref,
) {
  return DollarModeNotifier();
});

/// Notifier for dollar display mode preference
class DollarModeNotifier extends StateNotifier<bool> {
  static const String _prefsKey = 'projection_use_constant_dollars';

  DollarModeNotifier() : super(false) {
    _loadPreference();
  }

  /// Load preference from SharedPreferences
  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final useConstantDollars = prefs.getBool(_prefsKey) ?? false;
    state = useConstantDollars;
  }

  /// Toggle between current and constant dollars
  Future<void> toggle() async {
    final newValue = !state;
    state = newValue;
    await _savePreference(newValue);
  }

  /// Set specific mode
  Future<void> setMode(bool useConstantDollars) async {
    state = useConstantDollars;
    await _savePreference(useConstantDollars);
  }

  /// Save preference to SharedPreferences
  Future<void> _savePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }
}
