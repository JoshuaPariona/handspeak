import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handspeak/data/routes.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final List<String> avatarList = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
  ];

  String selectedAvatar = 'assets/images/avatars/avatar1.png';

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline, size: 48, color: Color(0xFF006B7F)),
                const SizedBox(height: 16),
                const Text(
                  "¡Registro exitoso!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF003366),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF006B7F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go(AppRoutes.dashboard.path);
                    },
                    child: const Text(
                      "Ir al inicio",
                      style: TextStyle(color: const Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;
      if (user != null) {
        await _saveUserData(user); // 👉 Guarda los datos en Firestore
        _showSuccessDialog();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error';
      if (e.code == 'email-already-in-use') {
        message = 'Este correo ya está registrado';
      } else if (e.code == 'weak-password') {
        message = 'La contraseña es muy débil';
      } else if (e.code == 'invalid-email') {
        message = 'Correo inválido';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveUserData(User user) async {
    final firestore = FirebaseFirestore.instance;

    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': nameController.text.trim(),
      'email': user.email,
      'avatar': selectedAvatar, // Ruta del avatar seleccionado
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6EC6E9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => context.go(AppRoutes.welcome.path),
                  child: const Text(
                    "← Volver",
                    style: TextStyle(
                      color: const Color(0xFF003366),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage("assets/images/welcome_girl.png"),
                backgroundColor: Colors.transparent,
              ),
              const SizedBox(height: 12),
              const Text(
                "¡Te damos la bienvenida!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003366),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Registrate para aprender lenguaje de señas.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nombre"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("Correo electrónico"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("Contraseña"),
                    const SizedBox(height: 4),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text("Selecciona tu avatar"),
                    const SizedBox(height: 4),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: avatarList.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final avatar = avatarList[index];
                        final isSelected = selectedAvatar == avatar;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAvatar = avatar;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected ? const Color(0xFF126E82) : Colors.transparent,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(avatar),
                              radius: 36,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF126E82),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Color(0xFFFFFFFF))
                            : const Text("Registrarse", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFFFFF))),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿Ya tienes cuenta? "),
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login.path),
                    child: const Text(
                      "Inicia sesión",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}