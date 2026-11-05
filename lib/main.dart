import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/main_screen.dart';

void main() {
  runApp(const KalaVistaApp());
}

class KalaVistaApp extends StatelessWidget {
  const KalaVistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(
          0xFFF5EFE6,
        ), // Web wala cream color
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFa84d3f)),
        textTheme: TextTheme(
          // Web wale fonts define kiye
          displayLarge: GoogleFonts.cormorantGaramond(
            fontSize: 48,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2B2028),
          ),
          bodyLarge: GoogleFonts.manrope(
            fontSize: 16,
            color: const Color(0xFF2B2028),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}
