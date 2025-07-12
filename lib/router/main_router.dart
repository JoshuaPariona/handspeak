import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/layouts/dashboard_layout.dart';
import 'package:handspeak/screens/screens.dart';
import 'package:handspeak/data/routes.dart';

final GoRouter mainRouter = GoRouter(
  initialLocation: AppRoutes.splash.path,
  routes: [
    GoRoute(
      path: AppRoutes.splash.path,
      name: AppRoutes.splash.name,
      builder: (context, state) => SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome.path,
      name: AppRoutes.welcome.name,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.login.path,
      name: AppRoutes.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signin.path,
      name: AppRoutes.signin.name,
      builder: (context, state) => SigninScreen(),
    ),
    GoRoute(
      path: AppRoutes.avatarPicker.path,
      name: AppRoutes.avatarPicker.name,
      builder: (context, state) => AvatarPickerScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard.path,
      name: AppRoutes.dashboard.name,
      builder: (context, state) => Placeholder(),
      redirect: (context, state) {
        return AppRoutes.dashboard.translate.path;
      },
    ),
    ShellRoute(
      builder: (context, state, child) => DashboardLayout(child),
      routes: [
        GoRoute(
          path: AppRoutes.dashboard.translate.path,
          name: AppRoutes.dashboard.translate.name,
          builder: (context, state) => TranslateScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard.profile.path,
          name: AppRoutes.dashboard.profile.name,
          builder: (context, state) => ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard.camera.path,
          name: AppRoutes.dashboard.camera.name,
          builder: (context, state) => CameraScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard.history.path,
          name: AppRoutes.dashboard.history.name,
          builder: (context, state) => HistoryScreen(),
        ),
      ],
    ),
  ],
);
