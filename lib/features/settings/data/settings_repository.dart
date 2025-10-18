import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retire1/features/settings/domain/app_settings.dart';

/// Repository for managing user settings in Firestore
class SettingsRepository {
  final FirebaseFirestore _firestore;

  SettingsRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get settings for a user
  /// Returns default settings if none exist
  Future<AppSettings> getSettings(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('preferences')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = _convertTimestampsToStrings(doc.data()!);
        return AppSettings.fromJson(data);
      }

      // Return default settings if none exist
      return AppSettings.defaultSettings(userId);
    } catch (e) {
      throw SettingsException('Failed to load settings: $e');
    }
  }

  /// Save settings for a user
  Future<void> saveSettings(AppSettings settings) async {
    try {
      final updatedSettings = settings.copyWith(lastUpdated: DateTime.now());

      await _firestore
          .collection('users')
          .doc(settings.userId)
          .collection('settings')
          .doc('preferences')
          .set(updatedSettings.toJson());
    } catch (e) {
      throw SettingsException('Failed to save settings: $e');
    }
  }

  /// Stream of settings changes for a user
  Stream<AppSettings> watchSettings(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('preferences')
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            final data = _convertTimestampsToStrings(doc.data()!);
            return AppSettings.fromJson(data);
          }
          return AppSettings.defaultSettings(userId);
        });
  }

  /// Convert Firestore Timestamps to ISO8601 strings for JSON deserialization
  Map<String, dynamic> _convertTimestampsToStrings(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);

    // Convert lastUpdated Timestamp to ISO8601 string
    if (result['lastUpdated'] is Timestamp) {
      final timestamp = result['lastUpdated'] as Timestamp;
      result['lastUpdated'] = timestamp.toDate().toIso8601String();
    }

    return result;
  }

  /// Update only the language setting
  Future<void> updateLanguage(String userId, String languageCode) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('preferences')
          .set({
            'userId': userId,
            'languageCode': languageCode,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      throw SettingsException('Failed to update language: $e');
    }
  }

  /// Update only the auto-open Excel files setting
  Future<void> updateAutoOpenExcelFiles(String userId, bool autoOpen) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('preferences')
          .set({
            'userId': userId,
            'autoOpenExcelFiles': autoOpen,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      throw SettingsException('Failed to update auto-open setting: $e');
    }
  }
}

/// Custom exception for settings errors
class SettingsException implements Exception {
  final String message;

  SettingsException(this.message);

  @override
  String toString() => message;
}
