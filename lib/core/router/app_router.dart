import 'package:go_router/go_router.dart';
import '../ui/layout/app_shell.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/project/presentation/base_parameters_screen.dart';
import '../../features/assets/presentation/assets_events_screen.dart';
import '../../features/scenarios/presentation/scenarios_screen.dart';
import '../../features/projection/presentation/projection_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

/// Route names as constants
class AppRoutes {
  static const dashboard = '/';
  static const baseParameters = '/base-parameters';
  static const assetsEvents = '/assets-events';
  static const scenarios = '/scenarios';
  static const projection = '/projection';
  static const settings = '/settings';
}

/// App router configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const DashboardScreen()),
        ),
        GoRoute(
          path: AppRoutes.baseParameters,
          name: 'baseParameters',
          pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const BaseParametersScreen()),
        ),
        GoRoute(
          path: AppRoutes.assetsEvents,
          name: 'assetsEvents',
          pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const AssetsEventsScreen()),
        ),
        GoRoute(
          path: AppRoutes.scenarios,
          name: 'scenarios',
          pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const ScenariosScreen()),
        ),
        GoRoute(
          path: AppRoutes.projection,
          name: 'projection',
          pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const ProjectionScreen()),
        ),
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          pageBuilder: (context, state) => NoTransitionPage(key: state.pageKey, child: const SettingsScreen()),
        ),
      ],
    ),
  ],
);
