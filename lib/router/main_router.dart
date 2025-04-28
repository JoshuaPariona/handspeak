import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/layouts/dashboard_layout.dart';
import 'package:handspeak/screens/screens.dart';
import 'package:handspeak/data/routes.dart';

final GoRouter mainRouter = GoRouter(
  initialLocation: AppRoutes.welcome.path,
  routes: [
    GoRoute(
      path: AppRoutes.welcome.path,
      name: AppRoutes.welcome.name,
      builder: (context, state) => WelcomeScreen(),
      redirect: (context, state) {
        if (true) {
          return null;
        }
        return AppRoutes.dashboard.translate.path;
      }
    ),
    GoRoute(
      path: AppRoutes.login.path,
      name: AppRoutes.login.name,
      builder: (context, state) => LoginScreen(),
      redirect: (context, state) {
        if (true) {
          return null;
        }
        return AppRoutes.dashboard.translate.path;
      }
    ),
    GoRoute(
      path: AppRoutes.signin.path,
      name: AppRoutes.signin.name,
      builder: (context, state) => SigninScreen(),
      redirect: (context, state) {
        if (true) {
          return null;
        }
        return AppRoutes.dashboard.translate.path;
      }
    ),
    GoRoute(
      path: AppRoutes.dashboard.path,
      name: AppRoutes.dashboard.name,
      builder: (context, state) => Placeholder(),
      redirect: (context, state) {
        return AppRoutes.dashboard.translate.path;
      }
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
          path: AppRoutes.dashboard.learn.path,
          name: AppRoutes.dashboard.learn.name,
          builder: (context, state) => LearnScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard.store.path,
          name: AppRoutes.dashboard.store.name,
          builder: (context, state) => StoreScreen(),
        ),
        GoRoute(
          path: AppRoutes.dashboard.profile.path,
          name: AppRoutes.dashboard.profile.name,
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);