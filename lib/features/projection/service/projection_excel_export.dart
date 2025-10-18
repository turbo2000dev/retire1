import 'dart:convert';
import 'dart:developer' show log;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for exporting projection data to Excel via Firebase Cloud Functions
class ProjectionExcelExport {
  /// Export projection to Excel and trigger download
  /// If [autoOpen] is true, attempts to open the file after download (web only)
  static Future<void> exportToExcel(
    Projection projection,
    String scenarioName,
    List<Asset> assets, {
    bool autoOpen = false,
  }) async {
    try {
      // Serialize data to JSON
      final requestData = {
        'projection': projection.toJson(),
        'scenarioName': scenarioName,
        'assets': assets.map((asset) => asset.toJson()).toList(),
      };

      // Use direct HTTP call to Cloud Function
      await _downloadExcelViaHttp(
        requestData,
        scenarioName,
        autoOpen: autoOpen,
      );
    } catch (e) {
      log('Error exporting to Excel: $e');
      rethrow;
    }
  }

  /// Download Excel file via direct HTTP call to Cloud Function
  static Future<void> _downloadExcelViaHttp(
    Map<String, dynamic> requestData,
    String scenarioName, {
    required bool autoOpen,
  }) async {
    const functionUrl =
        'https://generate-projection-excel-zljvaxltlq-uc.a.run.app';

    try {
      // Make HTTP POST request to Cloud Function
      final response = await html.HttpRequest.request(
        functionUrl,
        method: 'POST',
        requestHeaders: {'Content-Type': 'application/json'},
        sendData: jsonEncode(requestData),
        responseType: 'blob',
      );

      if (response.status == 200) {
        // Create a download link for the blob
        final blob = response.response as html.Blob;
        final url = html.Url.createObjectUrlFromBlob(blob);

        // Generate filename
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final filename =
            'projection_${scenarioName.replaceAll(' ', '-')}_$today.xlsx';

        if (autoOpen) {
          // Open file in new tab (web only)
          try {
            final uri = Uri.parse(url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              // Fallback to download if can't open
              _triggerDownload(url, filename);
            }
          } catch (e) {
            log('Error auto-opening file: $e. Falling back to download.');
            _triggerDownload(url, filename);
          }
        } else {
          // Just download without opening
          _triggerDownload(url, filename);
        }

        // Clean up after a delay to allow the file to be accessed
        Future.delayed(const Duration(seconds: 2), () {
          html.Url.revokeObjectUrl(url);
        });
      } else {
        throw Exception(
          'Failed to generate Excel: HTTP ${response.status} - ${response.statusText}',
        );
      }
    } catch (e) {
      log('Error downloading Excel via HTTP: $e');
      rethrow;
    }
  }

  /// Trigger download using anchor element
  static void _triggerDownload(String url, String filename) {
    html.AnchorElement(href: url)
      ..setAttribute('download', filename)
      ..click();
  }
}
