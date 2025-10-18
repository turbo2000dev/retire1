import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/settings/data/settings_repository.dart';
import 'package:retire1/features/settings/domain/app_settings.dart';

/// Provider for settings repository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// Settings state notifier
class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final SettingsRepository _repository;
  final String? _userId;

  SettingsNotifier(this._repository, this._userId)
    : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  /// Load settings from Firestore
  Future<void> _loadSettings() async {
    if (_userId == null) {
      // User not logged in, use default English settings
      if (mounted) {
        state = AsyncValue.data(
          AppSettings(
            userId: '',
            languageCode: 'en',
            lastUpdated: DateTime.now(),
          ),
        );
      }
      return;
    }

    try {
      final settings = await _repository.getSettings(_userId);
      if (mounted) {
        state = AsyncValue.data(settings);
      }
    } catch (e, stack) {
      log('Failed to load settings', error: e, stackTrace: stack);
      if (mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Update language setting
  Future<void> updateLanguage(String languageCode) async {
    if (!mounted || _userId == null) {
      log('Cannot update language: user not logged in or notifier disposed');
      return;
    }

    final currentSettings = state.value;
    if (currentSettings == null) return;

    // Optimistically update the state
    if (mounted) {
      state = AsyncValue.data(
        currentSettings.copyWith(
          languageCode: languageCode,
          lastUpdated: DateTime.now(),
        ),
      );
    }

    try {
      await _repository.updateLanguage(_userId, languageCode);
    } catch (e, stack) {
      log('Failed to update language', error: e, stackTrace: stack);
      // Revert to previous settings on error
      if (mounted) {
        state = AsyncValue.data(currentSettings);
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Update auto-open Excel files setting
  Future<void> updateAutoOpenExcelFiles(bool autoOpen) async {
    if (!mounted || _userId == null) {
      log(
        'Cannot update auto-open setting: user not logged in or notifier disposed',
      );
      return;
    }

    final currentSettings = state.value;
    if (currentSettings == null) return;

    // Optimistically update the state
    if (mounted) {
      state = AsyncValue.data(
        currentSettings.copyWith(
          autoOpenExcelFiles: autoOpen,
          lastUpdated: DateTime.now(),
        ),
      );
    }

    try {
      await _repository.updateAutoOpenExcelFiles(_userId, autoOpen);
    } catch (e, stack) {
      log('Failed to update auto-open setting', error: e, stackTrace: stack);
      // Revert to previous settings on error
      if (mounted) {
        state = AsyncValue.data(currentSettings);
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Reload settings from Firestore
  Future<void> reload() async {
    await _loadSettings();
  }
}

/// Provider for settings state
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      final authState = ref.watch(authNotifierProvider);

      // Get user ID from auth state
      final userId = authState is Authenticated ? authState.user.id : null;

      return SettingsNotifier(repository, userId);
    });

/// Provider for current language code
final currentLanguageProvider = Provider<String>((ref) {
  final settingsAsync = ref.watch(settingsProvider);
  return settingsAsync.when(
    data: (settings) => settings.languageCode,
    loading: () => 'en', // Default to English while loading
    error: (_, __) => 'en', // Default to English on error
  );
});
