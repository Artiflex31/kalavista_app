import 'package:flutter/material.dart';

import 'gallery_screen.dart';
import 'commissions_screen.dart';
import 'ask_kala_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Ye hamari 3 main screens ki list hai
  final List<Widget> _screens = [
    const GalleryScreen(),
    const CommissionsScreen(),
    const AskKalaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack ka use isliye karte hain taaki jab hum tab change karein,
      // toh purane tab ka data (jaise chat history ya scroll position) delete na ho.
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFFF5EFE6),
        indicatorColor: const Color(0xFFa84d3f).withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.grid_view, color: Colors.black54),
            selectedIcon: Icon(Icons.grid_view, color: Color(0xFFa84d3f)),
            label: 'Gallery',
          ),
          NavigationDestination(
            icon: Icon(Icons.brush, color: Colors.black54),
            selectedIcon: Icon(Icons.brush, color: Color(0xFFa84d3f)),
            label: 'Commissions',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome, color: Colors.black54),
            selectedIcon: Icon(Icons.auto_awesome, color: Color(0xFFa84d3f)),
            label: 'Ask Kala',
          ),
        ],
      ),
    );
  }
}
