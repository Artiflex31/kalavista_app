import 'package:shared_preferences/shared_preferences.dart';

class FavouriteService {
  static const String _key = 'kalavista_favourites';

  // Saari favourite slugs (IDs) laao
  static Future<List<String>> getFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Favourite toggle karo (Add / Remove)
  static Future<bool> toggleFavourite(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList(_key) ?? [];

    bool isFav = favourites.contains(slug);
    if (isFav) {
      favourites.remove(slug); // Agar pehle se hai, toh hata do
    } else {
      favourites.add(slug); // Agar nahi hai, toh add karo
    }

    await prefs.setStringList(_key, favourites);
    return !isFav; // Return karo ki ab kya status hai
  }
}
