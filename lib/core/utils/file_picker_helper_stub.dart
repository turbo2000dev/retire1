/// Stub implementation for file picker on unsupported platforms
class FilePickerHelper {
  /// Pick a JSON file - not supported on this platform
  static Future<String> pickJsonFile() async {
    throw UnsupportedError(
      'File picker is not supported on this platform. '
      'Please use the web version or manually paste JSON content.',
    );
  }
}
