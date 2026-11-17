import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/artwork.dart';
import '../services/api_service.dart';
import 'artwork_detail_screen.dart'; // Click karne par details pe jaane ke liye

class AllArtworksScreen extends StatefulWidget {
  const AllArtworksScreen({super.key});

  @override
  State<AllArtworksScreen> createState() => _AllArtworksScreenState();
}

class _AllArtworksScreenState extends State<AllArtworksScreen> {
  late Future<List<Artwork>> _artworksFuture;

  @override
  void initState() {
    super.initState();
    // Jaise hi screen khulegi, API se saare artworks mangwa lenge
    _artworksFuture = ApiService.getArtworks();
  }

  String formatPrice(int? paise) {
    if (paise == null) return 'Price on request';
    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(paise / 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Web wala cream background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2B2028)),
          onPressed: () => Navigator.pop(context), // Wapas pichhli screen par
        ),
        title: Text(
          'The Archive',
          style: GoogleFonts.cormorantGaramond(
            color: const Color(0xFF2B2028),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text (Web jaisa)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All works',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFFa84d3f),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'All artworks.',
                  style: GoogleFonts.cormorantGaramond(
                    color: const Color(0xFF2B2028),
                    fontSize: 42,
                    fontWeight: FontWeight.w600,
                    height: 0.9,
                  ),
                ),
              ],
            ),
          ),

          // The Grid
          Expanded(
            child: FutureBuilder<List<Artwork>>(
              future: _artworksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFa84d3f)),
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

                final artworks = snapshot.data!;

                // 👇 Yahan GridView use kiya gaya hai
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 Columns (Do-do artworks ek line me)
                    childAspectRatio:
                        0.65, // Height/Width ratio taaki card lamba dikhe
                    crossAxisSpacing: 16, // Columns ke beech ka gap
                    mainAxisSpacing: 16, // Rows ke beech ka gap
                  ),
                  itemCount: artworks.length,
                  itemBuilder: (context, index) {
                    final artwork = artworks[index];
                    return GestureDetector(
                      onTap: () {
                        // Click karne par details screen par jayenge
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArtworkDetailScreen(artwork: artwork),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: artwork.imageUrl ?? '',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Container(color: Colors.black12),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Title
                          Text(
                            artwork.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.cormorantGaramond(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: const Color(0xFF2B2028),
                            ),
                          ),
                          // Price & Medium
                          Text(
                            formatPrice(artwork.priceInPaise),
                            style: GoogleFonts.manrope(
                              color: const Color(0xFFa84d3f),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            artwork.medium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
