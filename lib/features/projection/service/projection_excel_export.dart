import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:retire1/features/projection/domain/projection.dart';
import 'package:retire1/features/assets/domain/asset.dart';
import 'package:intl/intl.dart';

/// Service for exporting projection data to Excel via Firebase Cloud Functions
class ProjectionExcelExport {
  static final _functions = FirebaseFunctions.instance;

  /// Export projection to Excel and trigger download
  static Future<void> exportToExcel(
    Projection projection,
    String scenarioName,
    List<Asset> assets,
  ) async {
    try {
      // Serialize data to JSON
      final requestData = {
        'projection': projection.toJson(),
        'scenarioName': scenarioName,
        'assets': assets.map((asset) => asset.toJson()).toList(),
      };

      // Call Cloud Function
      final callable = _functions.httpsCallable('generate_projection_excel');
      final response = await callable.call(requestData);

      // The Cloud Function returns the file as base64 encoded data
      // But since we're using HTTP callable, we need to use the HTTP endpoint directly
      // Let's use a direct HTTP call instead
      await _downloadExcelViaHttp(requestData, scenarioName);
    } catch (e) {
      print('Error exporting to Excel: $e');
      rethrow;
    }
  }

  /// Download Excel file via direct HTTP call to Cloud Function
  static Future<void> _downloadExcelViaHttp(
    Map<String, dynamic> requestData,
    String scenarioName,
  ) async {
    const functionUrl =
        'https://generate-projection-excel-zljvaxltlq-uc.a.run.app';

    try {
      // Make HTTP POST request to Cloud Function
      final response = await html.HttpRequest.request(
        functionUrl,
        method: 'POST',
        requestHeaders: {
          'Content-Type': 'application/json',
        },
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

        // Trigger download
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', filename)
          ..click();

        // Clean up
        html.Url.revokeObjectUrl(url);
      } else {
        throw Exception(
            'Failed to generate Excel: HTTP ${response.status} - ${response.statusText}');
      }
    } catch (e) {
      print('Error downloading Excel via HTTP: $e');
      rethrow;
    }
  }
}
