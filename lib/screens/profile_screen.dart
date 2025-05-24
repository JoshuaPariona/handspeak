import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController emailController = TextEditingController();


  String avatarUrl = 'assets/images/avatars/avatar1.png';

  final List<String> avatarOptions = [
    'assets/images/avatars/avatar1.png',
    'assets/images/avatars/avatar2.png',
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      if (data != null) {
        nameController.text = data['name'] ?? '';
        aboutController.text = data['about'] ?? '';
        avatarUrl = data['avatar'] ?? avatarUrl;
        emailController.text = user.email ?? '';
        setState(() {});
      }
    }
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => isLoading = true);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text.trim(),
        'about': aboutController.text.trim(),
        'avatar': avatarUrl,
      });

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );
    }
  }

  void selectAvatar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 200,
          child: GridView.builder(
            itemCount: avatarOptions.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (_, index) {
              final path = avatarOptions[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    avatarUrl = path;
                  });
                  Navigator.pop(context); // Cierra el modal
                },
                child: CircleAvatar(
                  backgroundImage: AssetImage(path),
                  radius: 30,
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF72C3DC),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: avatarUrl.startsWith('http')
                            ? NetworkImage(avatarUrl)
                            : AssetImage(avatarUrl) as ImageProvider,
                        backgroundColor: Colors.transparent,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: selectAvatar,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Tu nombre",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: aboutController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Sobre ti",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006B7F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Guardar cambios",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}