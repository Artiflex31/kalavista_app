import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilmReelScreen extends StatefulWidget {
  const FilmReelScreen({super.key});

  @override
  State<FilmReelScreen> createState() => _FilmReelScreenState();
}

class _FilmReelScreenState extends State<FilmReelScreen> {
  // PageController: Isse hume scroll ki exact position (page value) milegi
  final PageController _pageController = PageController(viewportFraction: 0.55);
  double _currentPage = 0.0;

  final List<Map<String, dynamic>> categories = [
    {'label': 'Monsoon Studies', 'count': 4, 'color': const Color(0xFF597c9d)},
    {'label': 'Anime Art', 'count': 6, 'color': const Color(0xFF7757a7)},
    {'label': 'Portraits', 'count': 3, 'color': const Color(0xFFa96e5c)},
    {'label': 'Watercolour', 'count': 5, 'color': const Color(0xFF4f8d91)},
    {'label': 'Charcoal', 'count': 2, 'color': const Color(0xFF3f3a3c)},
    {'label': 'Realistic', 'count': 7, 'color': const Color(0xFF6c8654)},
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050506), // Cinematic Dark Background
      body: Column(
        children: [
          const SizedBox(height: 60),

          // Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE KALAVISTA ARCHIVE',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFFe7a962),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The Film Reel.',
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // 3D Film Reel Carousel
          SizedBox(
            height: 420, // Height of the carousel area
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Top Film Reel Sprocket Holes
                _buildFilmHoles(),

                // 2. The 3D Cards
                PageView.builder(
                  controller: _pageController,
                  itemCount: categories.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // Math for 3D effect
                    double value = index - _currentPage;

                    // clamp value so extreme cards don't break
                    double clampedValue = value.clamp(-1.0, 1.0);

                    // Center pop: Scale 1.0 at center, shrinks to 0.7 at sides
                    double scale = 1.0 - (clampedValue.abs() * 0.3);

                    // Fade: Opacity 1.0 at center, fades to 0.3 at sides
                    double opacity = 1.0 - (clampedValue.abs() * 0.7);

                    // 3D Rotation: Cards rotate on Y axis to look like a film strip
                    double rotationY = clampedValue * 0.6; // radians

                    // Slight rotation on Z for the film twist
                    double rotationZ = clampedValue * -0.1;

                    // Translation: Cards on the side dip down slightly
                    double translationY = clampedValue.abs() * 30;

                    return Transform(
                      transform: Matrix4.identity()
                        ..scale(scale)
                        ..translate(0.0, translationY)
                        ..rotateY(rotationY)
                        ..rotateZ(rotationZ),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: opacity,
                        child: _buildCard(categories[index], index),
                      ),
                    );
                  },
                ),

                // 3. Bottom Film Reel Sprocket Holes
                _buildFilmHoles(),
              ],
            ),
          ),

          const Spacer(),

          // Scroll Hint
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Text(
              'SWIPE TO EXPLORE',
              style: GoogleFonts.manrope(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Card Design
  Widget _buildCard(Map<String, dynamic> category, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 200,
      // Portrait Aspect Ratio
      height: 300,
      decoration: BoxDecoration(
        color: category['color'],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Film border inside the card
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Text Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${category['count']} works',
                  style: GoogleFonts.manrope(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category['label'],
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Film Strip Sprocket Holes (Chhed) Design
  Widget _buildFilmHoles() {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics:
            const NeverScrollableScrollPhysics(), // Ye khud scroll nahi hoga
        itemCount: 30,
        itemBuilder: (context, index) {
          return Container(
            width: 20,
            height: 15,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A), // Dark hole color
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.white12),
            ),
          );
        },
      ),
    );
  }
}
