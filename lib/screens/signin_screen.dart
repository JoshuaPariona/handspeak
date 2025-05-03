import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/data/routes.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
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
                    const Text("Nombres:"),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 16),
                    const Text("Apellidos:"),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 16),
                    const Text("Correo electrónico:"),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: _inputDecoration(),
                    ),
                    const SizedBox(height: 16),
                    const Text("Contraseña:"),
                    const SizedBox(height: 8),
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration().copyWith(
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
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          // Acción al registrarse
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006B7F),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Registrarse", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Ya tienes una cuenta? "),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login.path),
                    child: const Text(
                      "Iniciar sesión",
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

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF3F3F3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}