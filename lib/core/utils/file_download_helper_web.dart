// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:convert';

/// Web implementation for file download using browser download API
/// TODO: Migrate to package:web when upgrading to Flutter 3.19+
void downloadTextFile(String content, String filename) {
  // Create a blob from the content
  final bytes = utf8.encode(content);
  final blob = html.Blob([bytes], 'application/json');

  // Create a download URL
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create a temporary anchor element and trigger download
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..style.display = 'none';

  html.document.body?.children.add(anchor);
  anchor.click();

  // Cleanup
  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
