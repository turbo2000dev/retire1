import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Application settings for a user
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    /// User ID that these settings belong to
    required String userId,

    /// Selected language code (e.g., 'en', 'fr')
    required String languageCode,

    /// Timestamp of last update
    DateTime? lastUpdated,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Create default settings for a user
  factory AppSettings.defaultSettings(String userId) {
    return AppSettings(
      userId: userId,
      languageCode: 'en', // Default to English
      lastUpdated: DateTime.now(),
    );
  }
}

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English'),
  french('fr', 'Français');

  const AppLanguage(this.code, this.displayName);

  final String code;
  final String displayName;

  /// Get AppLanguage from language code
  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}
