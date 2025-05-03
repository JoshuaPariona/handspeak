import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/data/routes.dart';
import 'package:handspeak/data/colors.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'HANDSPEAK',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColor.onPrimary,
                      letterSpacing: 2,
                    ),
              ),
              const SizedBox(height: 30),
              IconButton(
                icon: const Icon(Icons.power_settings_new),
                iconSize: 45,
                color: AppColor.onPrimary,
                onPressed: () {
                  context.go(AppRoutes.welcome.path); // Asegúrate que esta ruta exista
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
