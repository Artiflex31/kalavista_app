import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/artwork.dart';

class ArtworkDetailScreen extends StatelessWidget {
  final Artwork artwork;

  // Hum gallery screen se yahan 'artwork' ka data bhejenge
  const ArtworkDetailScreen({super.key, required this.artwork});

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
      backgroundColor: const Color(0xFFF5EFE6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF2B2028),
        ), // Back button ka color
      ),
      // SingleChildScrollView isliye taaki agar text lamba ho toh scroll ho sake
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bada Image
            // Bada Image (Bina crop hue, original aspect ratio ke saath)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: artwork.imageUrl ?? '',
                  width: double.infinity, // Screen ki puri chaudai lega
                  fit: BoxFit
                      .fitWidth, // Height apne aap image ke hisaab se badhegi
                  placeholder: (context, url) => Container(
                    height: 300, // Loading ke waqt thodi jagah gherega
                    color: Colors.black12,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 300,
                    color: Colors.black12,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Text Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medium Label
                  Text(
                    artwork.medium.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: const Color(0xFFa84d3f), // Terracotta color
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Title
                  Text(
                    artwork.title,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 42,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      color: const Color(0xFF2B2028),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Text(
                    formatPrice(artwork.priceInPaise),
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B2028),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // The Story
                  Text(
                    'The Story',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2B2028),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    artwork.story,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFa84d3f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        // Abhi ke liye bas ek message dikhayenge
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout coming soon!'),
                          ),
                        );
                      },
                      child: Text(
                        'Buy this artwork',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
