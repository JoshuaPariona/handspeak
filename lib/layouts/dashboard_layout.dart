import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handspeak/data/routes.dart'; // Asegúrate de tener los nombres de ruta

class DashboardLayout extends StatelessWidget {
  final Widget child;
  const DashboardLayout(this.child, {super.key});

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.contains(AppRoutes.dashboard.translate.path)) {
      return 0;
    } else if (location.contains(AppRoutes.dashboard.profile.path)) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard.translate.path);
        break;
      case 1:
        context.go(AppRoutes.dashboard.profile.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      appBar: AppBar(title: Text('Handspeak', style: TextStyle(color: Colors.blue)), backgroundColor: Colors.white),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Traducir',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
