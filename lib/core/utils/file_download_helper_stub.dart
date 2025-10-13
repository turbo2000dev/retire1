/// Stub implementation for non-web platforms
class FileDownloadHelper {
  static void downloadTextFile(
    String content,
    String filename, {
    String mimeType = 'text/plain',
  }) {
    throw UnsupportedError(
      'File download is not supported on this platform. '
      'Please use the web version to download files.',
    );
  }

  static void downloadJson(String jsonContent, String filename) {
    throw UnsupportedError(
      'File download is not supported on this platform. '
      'Please use the web version to download files.',
    );
  }

  static void downloadCsv(String csvContent, String filename) {
    throw UnsupportedError(
      'File download is not supported on this platform. '
      'Please use the web version to download files.',
    );
  }
}
