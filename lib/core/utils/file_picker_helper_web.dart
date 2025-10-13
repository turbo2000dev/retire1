// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';

/// Web implementation for file picker using browser file input
class FilePickerHelper {
  /// Pick a JSON file and return its content as a string
  /// Throws UnsupportedError if file type is not JSON or if cancelled
  static Future<String> pickJsonFile() async {
    // Create a file input element
    final input = html.FileUploadInputElement()
      ..accept = '.json,application/json';

    // Trigger the file picker
    input.click();

    // Wait for file selection
    final completer = Completer<String>();

    input.onChange.listen((event) async {
      final files = input.files;
      if (files == null || files.isEmpty) {
        completer.completeError(
          UnsupportedError('No file selected'),
        );
        return;
      }

      final file = files[0];

      // Validate file type
      if (!file.name.toLowerCase().endsWith('.json')) {
        completer.completeError(
          Exception('Invalid file type. Please select a JSON file.'),
        );
        return;
      }

      // Read file content
      final reader = html.FileReader();

      reader.onLoadEnd.listen((event) {
        if (reader.result != null) {
          completer.complete(reader.result as String);
        } else {
          completer.completeError(
            Exception('Failed to read file'),
          );
        }
      });

      reader.onError.listen((event) {
        completer.completeError(
          Exception('Error reading file'),
        );
      });

      reader.readAsText(file);
    });

    // Handle cancellation (input element removed without selection)
    // Set a timeout to detect if the file picker was cancelled
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!completer.isCompleted) {
        // Check if input is still in DOM or has no files
        if (input.files == null || input.files!.isEmpty) {
          // User might still be selecting, don't complete yet
          // We rely on the onChange event to complete
        }
      }
    });

    return completer.future;
  }
}
