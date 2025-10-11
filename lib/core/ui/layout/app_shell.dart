import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/router/app_router.dart';
import 'package:retire1/core/ui/responsive/screen_size.dart';
import 'package:retire1/core/config/theme/app_theme.dart';

/// Provider for current navigation index
final currentIndexProvider = StateProvider<int>((ref) => 0);

/// Navigation item data
class NavItem {
  final String label;
  final String shortLabel; // Shorter label for bottom navigation
  final IconData icon;
  final String route;

  const NavItem({
    required this.label,
    required this.shortLabel,
    required this.icon,
    required this.route,
  });
}

/// Navigation items for the app
const navigationItems = [
  NavItem(label: 'Dashboard', shortLabel: 'Dashboard', icon: Icons.dashboard, route: AppRoutes.dashboard),
  NavItem(label: 'Parameters', shortLabel: 'Parameters', icon: Icons.settings_applications, route: AppRoutes.baseParameters),
  NavItem(label: 'Assets & Events', shortLabel: 'Assets', icon: Icons.account_balance_wallet, route: AppRoutes.assetsEvents),
  NavItem(label: 'Scenarios', shortLabel: 'Scenarios', icon: Icons.compare_arrows, route: AppRoutes.scenarios),
  NavItem(label: 'Projection', shortLabel: 'Projection', icon: Icons.show_chart, route: AppRoutes.projection),
];

/// App shell with responsive navigation
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ScreenSize(context);
    final currentIndex = ref.watch(currentIndexProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(currentIndex)),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state = themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
            tooltip: themeMode == ThemeMode.light ? 'Switch to Dark Mode' : 'Switch to Light Mode',
          ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go(AppRoutes.settings);
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Row(
        children: [
          // Navigation rail for tablet/desktop
          if (!screenSize.isPhone)
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                _onItemTapped(context, ref, index);
              },
              labelType: screenSize.isTablet ? NavigationRailLabelType.selected : NavigationRailLabelType.all,
              destinations: navigationItems
                  .map((item) => NavigationRailDestination(icon: Icon(item.icon), label: Text(item.label)))
                  .toList(),
            ),
          // Main content
          Expanded(child: child),
        ],
      ),
      // Bottom navigation for phone
      bottomNavigationBar: screenSize.isPhone
          ? NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                _onItemTapped(context, ref, index);
              },
              destinations: navigationItems
                  .map((item) => NavigationDestination(icon: Icon(item.icon), label: item.shortLabel))
                  .toList(),
            )
          : null,
    );
  }

  String _getTitle(int index) {
    if (index >= 0 && index < navigationItems.length) {
      return navigationItems[index].label;
    }
    return 'Retirement Planner';
  }

  void _onItemTapped(BuildContext context, WidgetRef ref, int index) {
    ref.read(currentIndexProvider.notifier).state = index;
    context.go(navigationItems[index].route);
  }
}
