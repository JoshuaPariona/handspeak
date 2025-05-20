import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/data/routes.dart';



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EC6E9),
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text(
                'HANDSPEAK',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: const Color(0xFFFFFFFF),
                    letterSpacing: 2,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              const SizedBox(height: 30),
              IconButton(
                icon: const Icon(Icons.power_settings_new),
                iconSize: 45,
                color: const Color(0xFFFFFFFF),
                onPressed: () {
                  context.go(AppRoutes.welcome.path);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
