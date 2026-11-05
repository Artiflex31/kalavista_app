import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/artwork.dart';
import '../services/api_service.dart';
import '../services/favourite_service.dart';
import 'artwork_detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late Future<List<Artwork>> futureArtworks;

  // --- SEARCH STATE ---
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // --- FAVOURITES STATE ---
  List<String> _favouriteSlugs = [];

  @override
  void initState() {
    super.initState();
    futureArtworks = ApiService.getArtworks();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favs = await FavouriteService.getFavourites();
    setState(() => _favouriteSlugs = favs);
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EFE6),
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'कला',
                style: GoogleFonts.manrope(
                  color: const Color(0xFFa84d3f),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Vista',
                style: GoogleFonts.cormorantGaramond(
                  color: const Color(0xFF2B2028),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Artwork>>(
        future: futureArtworks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final artworks = snapshot.data!;

          // --- SEARCH LOGIC ---
          // Jo user type karega, uske hisaab se list filter karega
          final filteredArtworks = artworks.where((artwork) {
            final query = _searchQuery.toLowerCase();
            return artwork.title.toLowerCase().contains(query) ||
                artwork.medium.toLowerCase().contains(query) ||
                artwork.moods.any((mood) => mood.toLowerCase().contains(query));
          }).toList();

          return Column(
            children: [
              // SEARCH BAR UI
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search artworks...',
                    hintStyle: GoogleFonts.manrope(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFa84d3f),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),

              // GALLERY GRID UI
              Expanded(
                child: filteredArtworks.isEmpty
                    ? Center(
                        child: Text(
                          'No artworks found for "$_searchQuery"',
                          style: GoogleFonts.manrope(color: Colors.black54),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filteredArtworks.length,
                        itemBuilder: (context, index) {
                          final artwork = filteredArtworks[index];
                          final bool isFav = _favouriteSlugs.contains(
                            artwork.slug,
                          );

                          return GestureDetector(
                            onTap: () {
                              // Navigation to Detail Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ArtworkDetailScreen(artwork: artwork),
                                ),
                              ).then((_) => _loadFavourites());
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      ClipRRect(
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
                                      // Favourite Heart Button
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: () async {
                                            await FavouriteService.toggleFavourite(
                                              artwork.slug,
                                            );
                                            _loadFavourites();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              isFav
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: const Color(0xFFa84d3f),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  artwork.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  formatPrice(artwork.priceInPaise),
                                  style: const TextStyle(
                                    color: Color(0xFFa84d3f),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  artwork.medium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
