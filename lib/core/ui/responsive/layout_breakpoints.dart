/// Layout breakpoints for responsive design
///
/// These breakpoints define the screen size ranges for different device types:
/// - Phone: < 600px
/// - Tablet: 600px - 1024px
/// - Desktop: > 1024px
class LayoutBreakpoints {
  LayoutBreakpoints._();

  /// Maximum width for phone layouts (exclusive)
  static const double phoneMax = 600.0;

  /// Maximum width for tablet layouts (exclusive)
  static const double tabletMax = 1024.0;

  /// Minimum width for desktop layouts (inclusive)
  static const double desktopMin = 1024.0;

  /// Compact spacing for dense layouts
  static const double spacingCompact = 8.0;

  /// Standard spacing for most layouts
  static const double spacingStandard = 16.0;

  /// Comfortable spacing for larger screens
  static const double spacingComfortable = 24.0;

  /// Maximum content width for readability on large screens
  static const double maxContentWidth = 1200.0;
}
