import 'package:flutter/material.dart';

class Category {
  final int id;
  final String slug;
  final String label;
  final Color accent;
  final String? imageUrl;

  Category({
    required this.id,
    required this.slug,
    required this.label,
    required this.accent,
    this.imageUrl,
  });

  // API se aane wale JSON ko Dart object me badalne ke liye
  factory Category.fromJson(Map<String, dynamic> json) {
    // Hex color (#597c9d) ko Flutter Color me convert karna
    Color parsedColor = const Color(0xFF597c9d); // Default color

    if (json['accent'] != null && json['accent'].toString().startsWith('#')) {
      String hex = json['accent'].toString().replaceAll('#', '');
      parsedColor = Color(int.parse('FF$hex', radix: 16));
    }

    return Category(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      label: json['label'] ?? 'Unknown',
      accent: parsedColor,
      imageUrl: json['imageUrl'],
    );
  }
}
