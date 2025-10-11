import 'package:flutter/material.dart';
import 'screen_size.dart';

/// A widget that builds different layouts based on screen size
///
/// Provides callbacks for phone, tablet, and desktop layouts.
/// Falls back to a general builder if specific size builder is not provided.
class ResponsiveBuilder extends StatelessWidget {
  /// Optional builder for all screen sizes (fallback)
  final Widget Function(BuildContext, ScreenSize)? builder;

  /// Optional builder specifically for phone layouts
  final Widget Function(BuildContext, ScreenSize)? phone;

  /// Optional builder specifically for tablet layouts
  final Widget Function(BuildContext, ScreenSize)? tablet;

  /// Optional builder specifically for desktop layouts
  final Widget Function(BuildContext, ScreenSize)? desktop;

  const ResponsiveBuilder({
    super.key,
    this.builder,
    this.phone,
    this.tablet,
    this.desktop,
  }) : assert(
          builder != null || phone != null || tablet != null || desktop != null,
          'At least one builder must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    // Determine which builder to use
    Widget Function(BuildContext, ScreenSize)? selectedBuilder;

    if (screenSize.isPhone && phone != null) {
      selectedBuilder = phone;
    } else if (screenSize.isTablet && tablet != null) {
      selectedBuilder = tablet;
    } else if (screenSize.isDesktop && desktop != null) {
      selectedBuilder = desktop;
    } else if (builder != null) {
      selectedBuilder = builder;
    } else {
      // Fallback to the most appropriate builder
      if (screenSize.isPhone && (tablet != null || desktop != null)) {
        selectedBuilder = tablet ?? desktop;
      } else if (screenSize.isTablet && desktop != null) {
        selectedBuilder = desktop;
      } else {
        selectedBuilder = phone ?? tablet ?? desktop;
      }
    }

    return selectedBuilder!(context, screenSize);
  }
}
