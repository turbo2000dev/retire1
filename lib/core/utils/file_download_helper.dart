import 'package:flutter/foundation.dart' show kIsWeb;
import 'file_download_helper_stub.dart'
    if (dart.library.html) 'file_download_helper_web.dart' as impl;

/// Helper class for downloading files across platforms
class FileDownloadHelper {
  /// Download a text file
  ///
  /// On web: Triggers browser download
  /// On mobile/desktop: Platform-specific implementation
  static void downloadTextFile(String content, String filename) {
    if (kIsWeb) {
      impl.downloadTextFile(content, filename);
    } else {
      // For mobile/desktop, will be implemented in later phase
      // For now, caller should handle by showing content in dialog
      throw UnsupportedError('File download not yet supported on this platform');
    }
  }
}
