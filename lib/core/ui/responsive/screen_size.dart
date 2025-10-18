import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/layout_breakpoints.dart';

/// Utility class for determining screen size categories
class ScreenSize {
  final BuildContext context;

  ScreenSize(this.context);

  /// Get the current screen width
  double get width => MediaQuery.of(context).size.width;

  /// Get the current screen height
  double get height => MediaQuery.of(context).size.height;

  /// Check if the current screen is a phone (width < 600)
  bool get isPhone => width < LayoutBreakpoints.phoneMax;

  /// Check if the current screen is a tablet (600 <= width < 1024)
  bool get isTablet =>
      width >= LayoutBreakpoints.phoneMax &&
      width < LayoutBreakpoints.tabletMax;

  /// Check if the current screen is a desktop (width >= 1024)
  bool get isDesktop => width >= LayoutBreakpoints.desktopMin;

  /// Get the device type as a string
  String get deviceType {
    if (isPhone) return 'Phone';
    if (isTablet) return 'Tablet';
    return 'Desktop';
  }

  /// Get the appropriate spacing for the current screen size
  double get spacing {
    if (isPhone) return LayoutBreakpoints.spacingCompact;
    if (isTablet) return LayoutBreakpoints.spacingStandard;
    return LayoutBreakpoints.spacingComfortable;
  }

  /// Get the orientation of the device
  Orientation get orientation => MediaQuery.of(context).orientation;

  /// Check if the device is in portrait orientation
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if the device is in landscape orientation
  bool get isLandscape => orientation == Orientation.landscape;
}
