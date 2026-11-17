import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/artwork.dart';

import 'dart:async';

import '../models/category.dart';

class ApiService {
  static const String baseUrl = 'https://kalavista.onrender.com';

  // 1. Saari paintings laane ke liye
  static Future<List<Artwork>> getArtworks() async {
    final response = await http.get(Uri.parse('$baseUrl/api/artworks'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> list = data['list'] ?? data['data']; // API ke hisaab se
      return list.map((json) => Artwork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load artworks');
    }
  }

  // 2. Ask Kala (AI Chat) ke liye
  static Future<Map<String, dynamic>> askKala(String query) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/curator/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Kala is sleeping');
    }
  }

  // 3. Commission enquiry submit karne ke liye
  static Future<bool> submitCommission({
    required String name,
    required String email,
    required String artworkType,
    required String budget,
    required String message,
    required String timeline,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/commission-enquiries'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'artworkType': artworkType,
        'budget': budget,
        'message': message,
        'timeline': timeline,
      }),
    );

    // Agar status code 201 (Created) aata hai, matlab successful raha
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to submit commission');
    }
  }

  // 4. Categories fetch karne ke liye
  static Future<List<Category>> getCategories() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/categories'))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<dynamic> list = data['data'];
        return list.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Server returned status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}
