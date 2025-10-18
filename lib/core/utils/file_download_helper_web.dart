import 'dart:html' as html;
import 'dart:convert';

/// File download helper for web platform
class FileDownloadHelper {
  /// Download text content as a file
  ///
  /// Creates a Blob with the content, generates a download link,
  /// and triggers the download with the specified filename.
  ///
  /// [content] - The text content to download
  /// [filename] - The name of the file to be downloaded
  /// [mimeType] - The MIME type of the file (default: text/plain)
  static void downloadTextFile(
    String content,
    String filename, {
    String mimeType = 'text/plain',
  }) {
    // Create a Blob from the content
    final bytes = utf8.encode(content);
    final blob = html.Blob([bytes], mimeType);

    // Create a URL for the blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..style.display = 'none';

    // Add to document, click, and remove
    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();

    // Revoke the blob URL to free memory
    html.Url.revokeObjectUrl(url);
  }

  /// Download JSON content as a .json file
  static void downloadJson(String jsonContent, String filename) {
    downloadTextFile(jsonContent, filename, mimeType: 'application/json');
  }

  /// Download CSV content as a .csv file
  static void downloadCsv(String csvContent, String filename) {
    downloadTextFile(csvContent, filename, mimeType: 'text/csv');
  }
}
