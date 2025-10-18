import 'package:flutter/material.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';

/// A multi-pane layout that adapts based on screen size
///
/// On phone: Shows only center pane (others accessible via drawer/sheet)
/// On tablet: Shows center + one optional side pane
/// On desktop: Shows all panes that are provided
class ResponsiveMultiPaneLayout extends StatelessWidget {
  /// Start pane (left side on desktop/tablet)
  final Widget? startPane;

  /// Center pane (always visible)
  final Widget centerPane;

  /// End pane (right side on desktop)
  final Widget? endPane;

  /// Width of the start pane (desktop/tablet)
  final double startPaneWidth;

  /// Width of the end pane (desktop)
  final double endPaneWidth;

  /// Whether the start pane can be collapsed
  final bool startPaneCollapsible;

  /// Whether the start pane is initially collapsed
  final bool startPaneInitiallyCollapsed;

  const ResponsiveMultiPaneLayout({
    super.key,
    this.startPane,
    required this.centerPane,
    this.endPane,
    this.startPaneWidth = 280,
    this.endPaneWidth = 320,
    this.startPaneCollapsible = false,
    this.startPaneInitiallyCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    if (screenSize.isPhone) {
      // Phone: Only show center pane
      // TODO: Add drawer for start pane if provided
      return centerPane;
    } else if (screenSize.isTablet) {
      // Tablet: Show center + start pane (if provided)
      if (startPane != null) {
        return Row(
          children: [
            SizedBox(width: startPaneWidth, child: startPane),
            const VerticalDivider(width: 1),
            Expanded(child: centerPane),
          ],
        );
      }
      return centerPane;
    } else {
      // Desktop: Show all panes that are provided
      return Row(
        children: [
          if (startPane != null) ...[
            _CollapsiblePane(
              width: startPaneWidth,
              collapsible: startPaneCollapsible,
              initiallyCollapsed: startPaneInitiallyCollapsed,
              child: startPane!,
            ),
            const VerticalDivider(width: 1),
          ],
          Expanded(child: centerPane),
          if (endPane != null) ...[
            const VerticalDivider(width: 1),
            SizedBox(width: endPaneWidth, child: endPane),
          ],
        ],
      );
    }
  }
}

class _CollapsiblePane extends StatefulWidget {
  final double width;
  final bool collapsible;
  final bool initiallyCollapsed;
  final Widget child;

  const _CollapsiblePane({
    required this.width,
    required this.collapsible,
    required this.initiallyCollapsed,
    required this.child,
  });

  @override
  State<_CollapsiblePane> createState() => _CollapsiblePaneState();
}

class _CollapsiblePaneState extends State<_CollapsiblePane> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed && widget.collapsible;
  }

  void _toggleCollapsed() {
    if (widget.collapsible) {
      setState(() {
        _isCollapsed = !_isCollapsed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.collapsible) {
      return SizedBox(width: widget.width, child: widget.child);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isCollapsed ? 60 : widget.width,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: Icon(
                  _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                ),
                onPressed: _toggleCollapsed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
