import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:retire1/core/ui/layout/app_shell.dart';
import 'package:retire1/features/assets/presentation/assets_events_screen.dart';
import 'package:retire1/features/auth/presentation/login_screen.dart';
import 'package:retire1/features/auth/presentation/register_screen.dart';
import 'package:retire1/features/auth/presentation/providers/auth_provider.dart';
import 'package:retire1/features/dashboard/presentation/dashboard_screen.dart';
import 'package:retire1/features/project/presentation/base_parameters_screen.dart';
import 'package:retire1/features/projection/presentation/projection_screen.dart';
import 'package:retire1/features/scenarios/presentation/scenarios_screen.dart';
import 'package:retire1/features/settings/presentation/settings_screen.dart';

/// Route names as constants
class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/';
  static const baseParameters = '/base-parameters';
  static const assetsEvents = '/assets-events';
  static const scenarios = '/scenarios';
  static const projection = '/projection';
  static const settings = '/settings';
}

/// App router provider that includes auth state
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) {
      final isAuthenticated = authState is Authenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.login;
      final isRegistering = state.matchedLocation == AppRoutes.register;

      // If not authenticated and not on login/register page, redirect to login
      if (!isAuthenticated && !isLoggingIn && !isRegistering) {
        return AppRoutes.login;
      }

      // If authenticated and on login/register page, redirect to dashboard
      if (isAuthenticated && (isLoggingIn || isRegistering)) {
        return AppRoutes.dashboard;
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: const RegisterScreen()),
      ),

      // Protected routes (with shell)
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
});
