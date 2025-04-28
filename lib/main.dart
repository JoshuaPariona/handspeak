import 'package:flutter/material.dart';
import 'package:handspeak/router/main_router.dart';
import 'package:handspeak/theme/light.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HandSpeak());
}

class HandSpeak extends StatelessWidget {
  const HandSpeak({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "HandSpeak",
      theme: handspeakLightTheme,
      routerConfig: mainRouter,
    );
  }
}