class Artwork {
  final int id;
  final String slug;
  final String title;
  final String medium;
  final String? imageUrl;
  final String story;
  final String availability;
  final int? priceInPaise;
  final String currency;
  final List<String> moods;

  Artwork({
    required this.id,
    required this.slug,
    required this.title,
    required this.medium,
    this.imageUrl,
    required this.story,
    required this.availability,
    this.priceInPaise,
    required this.currency,
    required this.moods,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      title: json['title'] ?? 'Untitled',
      medium: json['medium'] ?? '',
      imageUrl: json['imageUrl'],
      story: json['story'] ?? '',
      availability: json['availability'] ?? 'AVAILABLE',
      priceInPaise: json['priceInPaise'],
      currency: json['currency'] ?? 'INR',
      moods: List<String>.from(json['moods'] ?? []),
    );
  }
}
