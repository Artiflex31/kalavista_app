import 'package:flutter/material.dart';

import 'gallery_screen.dart';
import 'commissions_screen.dart';
import 'ask_kala_screen.dart';
import 'film_reel_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 4 Screens ka sahi order
  final List<Widget> _screens = [
    const FilmReelScreen(), // 0: Explore (Film Reel)
    const GalleryScreen(), // 1: Gallery (All Artworks)
    const CommissionsScreen(), // 2: Commissions Form
    const AskKalaScreen(), // 3: AI Chat
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xFFF5EFE6),
        indicatorColor: const Color(0xFFa84d3f).withValues(alpha: 0.2),
        // 4 Destinations (Icons)
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_mosaic, color: Colors.black54),
            selectedIcon: Icon(
              Icons.auto_awesome_mosaic,
              color: Color(0xFFa84d3f),
            ),
            label: 'Explore',
          ),
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
