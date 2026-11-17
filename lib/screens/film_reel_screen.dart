import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/category.dart';
import '../models/artwork.dart';
import '../services/api_service.dart';
import 'all_artworks_screen.dart'; // Import karna mat bhoolna

class FilmReelScreen extends StatefulWidget {
  const FilmReelScreen({super.key});

  @override
  State<FilmReelScreen> createState() => _FilmReelScreenState();
}

class _FilmReelScreenState extends State<FilmReelScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  double _currentPage = 0.0;

  // Ab hum ek saath Categories aur Artworks dono fetch karenge
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _loadData();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  void _loadData() {
    // Future.wait ka use karke dono API ek saath call ki
    _dataFuture =
        Future.wait([ApiService.getCategories(), ApiService.getArtworks()])
            .then((results) {
              return {
                'categories': results[0] as List<Category>,
                'artworks': results[1] as List<Artwork>,
              };
            });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ✨ LOGIC: Category image dhundne ka function
  String? getThumbnailUrl(Category category, List<Artwork> artworks) {
    // 1. Agar category ki apni image hai, toh wahi use karo
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      return category.imageUrl;
    }

    // 2. Agar nahi hai, toh us category se juda pehla artwork dhundho
    final matchingArtwork = artworks.firstWhere(
      (art) => art.categories.contains(category.slug),
      orElse: () => artworks
          .first, // Agar koi artwork match nahi hua, toh sabse pehla utha lo
    );

    return matchingArtwork.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050506),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    'The Category Film.',
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

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFa84d3f),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final categories =
                      snapshot.data!['categories'] as List<Category>;
                  final artworks = snapshot.data!['artworks'] as List<Artwork>;

                  if (categories.isEmpty) {
                    return const Center(
                      child: Text(
                        'No categories found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        top: 30,
                        bottom: 30,
                        child: Container(color: const Color(0xFF1A1A1A)),
                      ),
                      Positioned(
                        top: 40,
                        left: 0,
                        right: 0,
                        child: _buildFilmHoles(),
                      ),
                      PageView.builder(
                        controller: _pageController,
                        itemCount: categories.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          double value = index - _currentPage;
                          double clampedValue = value.clamp(-1.0, 1.0);

                          double scale = 1.0 - (clampedValue.abs() * 0.3);
                          double opacity = 1.0 - (clampedValue.abs() * 0.7);
                          double rotationY = clampedValue * 0.5;

                          // Yahan humne thumbnail function call kiya
                          final thumbnailUrl = getThumbnailUrl(
                            categories[index],
                            artworks,
                          );

                          return Transform(
                            transform: Matrix4.identity()
                              ..scale(scale)
                              ..rotateY(rotationY),
                            alignment: Alignment.center,
                            child: Opacity(
                              opacity: opacity,
                              child: _buildCard(
                                categories[index],
                                thumbnailUrl,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: _buildFilmHoles(),
                      ),
                    ],
                  );
                },
              ),
            ),

            // "View All" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFa84d3f),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllArtworksScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'View All Artworks',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFFa84d3f),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 20),
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
      ),
    );
  }

  // _buildCard me ab thumbnailUrl parameter add ho gaya hai
  Widget _buildCard(Category category, String? thumbnailUrl) {
    final bool hasImage = thumbnailUrl != null && thumbnailUrl.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 100),
      decoration: BoxDecoration(
        color: category.accent,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: category.accent),
                errorWidget: (context, url, error) =>
                    Container(color: category.accent),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore Category',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.label,
                    style: GoogleFonts.cormorantGaramond(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilmHoles() {
    return SizedBox(
      height: 16,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 40,
        itemBuilder: (context, index) {
          return Container(
            width: 12,
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EFE6),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }
}
