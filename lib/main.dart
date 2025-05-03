import 'package:flutter/material.dart';
import 'package:handspeak/router/main_router.dart';
import 'package:handspeak/theme/light.dart';
import 'package:handspeak/data/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HandSpeak());
}

class HandSpeak extends StatelessWidget {
  const HandSpeak({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'HandSpeak',
      theme: AppTheme.lightTheme, // Usamos Theme centralizado
      routerConfig: mainRouter, // <-- aquí debes tener tu GoRouter en main_router.dart
      debugShowCheckedModeBanner: false,
      locale: const Locale('es'), // si usarás español
      supportedLocales: const [Locale('es')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
