import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retire1/core/ui/responsive/layout_breakpoints.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';
import 'package:retire1/core/config/theme/app_theme.dart';

/// Demo screen to visualize responsive behavior
class ResponsiveDemoScreen extends ConsumerWidget {
  const ResponsiveDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ScreenSize(context);
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Layout Demo'),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state = themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
            tooltip: themeMode == ThemeMode.light ? 'Switch to Dark Mode' : 'Switch to Light Mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Device Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Device Information', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _InfoRow(label: 'Device Type', value: screenSize.deviceType, icon: _getDeviceIcon(screenSize)),
                    _InfoRow(label: 'Screen Width', value: '${screenSize.width.toStringAsFixed(1)} px'),
                    _InfoRow(label: 'Screen Height', value: '${screenSize.height.toStringAsFixed(1)} px'),
                    _InfoRow(label: 'Orientation', value: screenSize.isPortrait ? 'Portrait' : 'Landscape'),
                    _InfoRow(label: 'Spacing', value: '${screenSize.spacing.toStringAsFixed(1)} px'),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenSize.spacing),

            // Breakpoints Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Layout Breakpoints', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _BreakpointIndicator(
                      label: 'Phone',
                      range: '< ${LayoutBreakpoints.phoneMax} px',
                      isActive: screenSize.isPhone,
                    ),
                    _BreakpointIndicator(
                      label: 'Tablet',
                      range: '${LayoutBreakpoints.phoneMax} - ${LayoutBreakpoints.tabletMax} px',
                      isActive: screenSize.isTablet,
                    ),
                    _BreakpointIndicator(
                      label: 'Desktop',
                      range: '>= ${LayoutBreakpoints.desktopMin} px',
                      isActive: screenSize.isDesktop,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenSize.spacing),

            // Responsive Grid Demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Responsive Grid', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _ResponsiveGrid(screenSize: screenSize),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenSize.spacing),

            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Testing Instructions', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Text(
                      '1. Resize the window to see values update\n'
                      '2. Rotate the device to test orientation changes\n'
                      '3. Try different device simulators (iPhone, iPad, etc.)\n'
                      '4. Notice how spacing and grid columns adapt',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getDeviceIcon(ScreenSize screenSize) {
    if (screenSize.isPhone) return Icons.phone_android;
    if (screenSize.isTablet) return Icons.tablet;
    return Icons.computer;
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoRow({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _BreakpointIndicator extends StatelessWidget {
  final String label;
  final String range;
  final bool isActive;

  const _BreakpointIndicator({required this.label, required this.range, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isActive ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isActive ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.circle_outlined,
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  range,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isActive ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  final ScreenSize screenSize;

  const _ResponsiveGrid({required this.screenSize});

  @override
  Widget build(BuildContext context) {
    // Determine number of columns based on screen size
    int columns;
    if (screenSize.isPhone) {
      columns = 2;
    } else if (screenSize.isTablet) {
      columns = 3;
    } else {
      columns = 4;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: screenSize.spacing,
        mainAxisSpacing: screenSize.spacing,
        childAspectRatio: 1.5,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
            ),
          ),
        );
      },
    );
  }
}
