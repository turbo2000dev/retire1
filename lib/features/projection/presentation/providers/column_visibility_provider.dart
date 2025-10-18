import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// State class for column visibility preferences
class ColumnVisibilityState {
  final Set<String> visibleColumnGroups;

  const ColumnVisibilityState({required this.visibleColumnGroups});

  /// Default state with all column groups visible
  factory ColumnVisibilityState.defaultState() {
    return const ColumnVisibilityState(
      visibleColumnGroups: {
        'basic',
        'income',
        'expenses',
        'taxes',
        'cashFlow',
        'withdrawals',
        'contributions',
        'assets',
        'netWorth',
        'warnings',
      },
    );
  }

  ColumnVisibilityState copyWith({Set<String>? visibleColumnGroups}) {
    return ColumnVisibilityState(
      visibleColumnGroups: visibleColumnGroups ?? this.visibleColumnGroups,
    );
  }
}

/// Notifier for managing column visibility state
class ColumnVisibilityNotifier extends StateNotifier<ColumnVisibilityState> {
  ColumnVisibilityNotifier() : super(ColumnVisibilityState.defaultState()) {
    _loadFromLocalStorage();
  }

  static const String _storageKey = 'projection_column_visibility';

  /// Load column visibility preferences from local storage
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedGroups = prefs.getStringList(_storageKey);

      if (savedGroups != null) {
        state = ColumnVisibilityState(visibleColumnGroups: savedGroups.toSet());
      }
    } catch (e) {
      // If loading fails, keep default state
      // log error silently
    }
  }

  /// Save column visibility preferences to local storage
  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        _storageKey,
        state.visibleColumnGroups.toList(),
      );
    } catch (e) {
      // If saving fails, continue without persisting
      // log error silently
    }
  }

  /// Toggle visibility of a column group
  void toggleColumnGroup(String group) {
    final newGroups = Set<String>.from(state.visibleColumnGroups);

    if (newGroups.contains(group)) {
      newGroups.remove(group);
    } else {
      newGroups.add(group);
    }

    state = state.copyWith(visibleColumnGroups: newGroups);
    _saveToLocalStorage();
  }

  /// Show all column groups
  void showAll() {
    state = ColumnVisibilityState.defaultState();
    _saveToLocalStorage();
  }

  /// Hide all column groups except basic
  void hideAll() {
    state = const ColumnVisibilityState(visibleColumnGroups: {'basic'});
    _saveToLocalStorage();
  }

  /// Reset to default state
  void reset() {
    state = ColumnVisibilityState.defaultState();
    _saveToLocalStorage();
  }
}

/// Provider for column visibility state
final columnVisibilityProvider =
    StateNotifierProvider<ColumnVisibilityNotifier, ColumnVisibilityState>(
      (ref) => ColumnVisibilityNotifier(),
    );
