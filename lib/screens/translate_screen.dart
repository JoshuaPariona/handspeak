import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:handspeak/data/colors.dart';
import 'package:handspeak/data/routes.dart';
import 'package:go_router/go_router.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({Key? key}) : super(key: key);

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  Future<void> _loadUserAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _avatarUrl = snapshot.data()?['avatar'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Volver', style: TextStyle(color: Colors.transparent)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.history, color: Colors.white),
                        onPressed: () {
                          context.go(AppRoutes.dashboard.history.path);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: () {
                          context.pushNamed(AppRoutes.dashboard.camera.name);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            if (_avatarUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _avatarUrl!,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        filterQuality: FilterQuality.high,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Escribe aquí...',
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
