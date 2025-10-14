/// Exception thrown during project import operations
///
/// Provides detailed error context including field paths, line numbers,
/// and the problematic data to help debug import failures.
class ImportException implements Exception {
  /// Human-readable error message
  final String message;

  /// Path to the field that caused the error (e.g., "assets[0].type")
  final String? fieldPath;

  /// The JSON data that failed to parse (truncated if too large)
  final dynamic problemData;

  /// Original exception that was caught
  final Object? originalException;

  /// Stack trace from the original exception
  final StackTrace? stackTrace;

  /// Approximate line number in the JSON file (if available)
  final int? lineNumber;

  ImportException(
    this.message, {
    this.fieldPath,
    this.problemData,
    this.originalException,
    this.stackTrace,
    this.lineNumber,
  });

  /// Create exception for a missing required field
  factory ImportException.missingField(String fieldPath, {int? lineNumber}) {
    return ImportException(
      'Missing required field',
      fieldPath: fieldPath,
      lineNumber: lineNumber,
    );
  }

  /// Create exception for an invalid field type
  factory ImportException.invalidType(
    String fieldPath,
    String expectedType,
    dynamic actualValue, {
    int? lineNumber,
  }) {
    return ImportException(
      'Invalid type: expected $expectedType',
      fieldPath: fieldPath,
      problemData: actualValue,
      lineNumber: lineNumber,
    );
  }

  /// Create exception for a parsing failure
  factory ImportException.parsingFailed(
    String fieldPath,
    dynamic data,
    Object error,
    StackTrace stackTrace, {
    int? lineNumber,
  }) {
    return ImportException(
      'Failed to parse field',
      fieldPath: fieldPath,
      problemData: data,
      originalException: error,
      stackTrace: stackTrace,
      lineNumber: lineNumber,
    );
  }

  /// Create exception for schema validation failure
  factory ImportException.schemaViolation(
    String message, {
    String? fieldPath,
    int? lineNumber,
  }) {
    return ImportException(
      message,
      fieldPath: fieldPath,
      lineNumber: lineNumber,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('ImportException: $message');

    if (lineNumber != null) {
      buffer.write(' (near line $lineNumber)');
    }

    if (fieldPath != null) {
      buffer.write('\n  Field: $fieldPath');
    }

    if (problemData != null) {
      final dataStr = _truncateData(problemData);
      buffer.write('\n  Data: $dataStr');
    }

    if (originalException != null) {
      buffer.write('\n  Caused by: $originalException');
    }

    return buffer.toString();
  }

  /// Truncate data for display (max 200 characters)
  String _truncateData(dynamic data) {
    final str = data.toString();
    if (str.length <= 200) return str;
    return '${str.substring(0, 197)}...';
  }

  /// Get a user-friendly error message for display in UI
  String get userMessage {
    final buffer = StringBuffer();
    buffer.write(message);

    if (lineNumber != null) {
      buffer.write(' (near line $lineNumber)');
    }

    if (fieldPath != null) {
      buffer.write(' at $fieldPath');
    }

    return buffer.toString();
  }
}
