import 'package:flutter/material.dart';

/// A card component that adapts based on content and screen size
class ResponsiveCard extends StatefulWidget {
  /// Optional title for the card
  final String? title;

  /// Optional subtitle
  final String? subtitle;

  /// Optional description text
  final String? description;

  /// Main content of the card
  final Widget? child;

  /// Optional badge to display in the top right
  final Widget? badge;

  /// Whether the card can be expanded/collapsed
  final bool expandable;

  /// Initial expanded state (for expandable cards)
  final bool initiallyExpanded;

  /// On tap callback
  final VoidCallback? onTap;

  /// Optional trailing widget (e.g., icon button)
  final Widget? trailing;

  /// Optional leading widget (e.g., icon)
  final Widget? leading;

  const ResponsiveCard({
    super.key,
    this.title,
    this.subtitle,
    this.description,
    this.child,
    this.badge,
    this.expandable = false,
    this.initiallyExpanded = false,
    this.onTap,
    this.trailing,
    this.leading,
  });

  @override
  State<ResponsiveCard> createState() => _ResponsiveCardState();
}

class _ResponsiveCardState extends State<ResponsiveCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  void _toggleExpanded() {
    if (widget.expandable) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? headerContent;
    if (widget.title != null || widget.subtitle != null || widget.leading != null) {
      headerContent = Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: theme.textTheme.titleMedium,
                  ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.badge != null) ...[
            const SizedBox(width: 8),
            widget.badge!,
          ],
          if (widget.trailing != null) ...[
            const SizedBox(width: 8),
            widget.trailing!,
          ],
          if (widget.expandable) ...[
            const SizedBox(width: 8),
            Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ],
      );
    }

    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (headerContent != null) headerContent,
        if (widget.description != null &&
            (!widget.expandable || _isExpanded)) ...[
          const SizedBox(height: 8),
          Text(
            widget.description!,
            style: theme.textTheme.bodyMedium,
          ),
        ],
        if (widget.child != null && (!widget.expandable || _isExpanded)) ...[
          if (headerContent != null || widget.description != null)
            const SizedBox(height: 12),
          widget.child!,
        ],
      ],
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap ?? (widget.expandable ? _toggleExpanded : null),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: cardContent,
        ),
      ),
    );
  }
}
