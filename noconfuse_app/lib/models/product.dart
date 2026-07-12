class Product {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviews;
  final int? mrp;
  final String icon;
  final Map<String, int?> prices;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.mrp,
    required this.icon,
    required this.prices,
    required this.specs,
  });

  /// All (store, price) pairs that are actually listed (price != null).
  List<MapEntry<String, int>> get listedPrices => prices.entries
      .where((e) => e.value != null)
      .map((e) => MapEntry(e.key, e.value!))
      .toList();

  MapEntry<String, int> get best {
    final entries = listedPrices;
    return entries.reduce((a, b) => b.value < a.value ? b : a);
  }

  MapEntry<String, int> get worst {
    final entries = listedPrices;
    return entries.reduce((a, b) => b.value > a.value ? b : a);
  }

  int get savings => worst.value - best.value;

  int get savingsPct =>
      worst.value > 0 ? ((savings / worst.value) * 100).round() : 0;
}
