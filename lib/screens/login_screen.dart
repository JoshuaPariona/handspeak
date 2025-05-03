import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/data/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF61C4D9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      context.go(AppRoutes.welcome.path);
                    },
                    child: const Text(
                      "Volver",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage("assets/images/welcome_girl.png"),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Correo electrónico:", style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("Contraseña:", style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B7F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Iniciar sesión", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(Icons.g_mobiledata, size: 30, color: Colors.black),
                  ),
                  SizedBox(width: 24),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(Icons.facebook, size: 30, color: Colors.black),
                  ),
                  SizedBox(width: 24),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(Icons.apple, size: 30, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No tienes cuenta? "),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.signin.path),
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}