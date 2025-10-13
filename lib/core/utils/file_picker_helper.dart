/// Cross-platform file picker helper
/// Uses conditional imports to provide web-specific or stub implementation
export 'file_picker_helper_stub.dart'
    if (dart.library.html) 'file_picker_helper_web.dart';
