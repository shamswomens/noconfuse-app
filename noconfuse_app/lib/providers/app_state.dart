import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/products_data.dart';
import '../data/store_links.dart';
import '../models/product.dart';

enum SortMode { rating, priceLow, savings }

class AppState extends ChangeNotifier {
  // ---- Filters ----
  String query = "";
  String category = "all";
  double minPrice = 0;
  double maxPrice = 200000;
  SortMode sortMode = SortMode.rating;

  // ---- Auth (simple local mock — mirrors the site's login/register) ----
  String? currentUserName;
  String? currentUserEmail;
  final Map<String, String> _localAccounts = {}; // email -> password (demo only)

  // ---- Wishlist ----
  final Set<String> wishlist = {};

  AppState() {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserName = prefs.getString('user_name');
    currentUserEmail = prefs.getString('user_email');
    final saved = prefs.getStringList('wishlist') ?? [];
    wishlist.addAll(saved);
    notifyListeners();
  }

  Future<void> _persistWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('wishlist', wishlist.toList());
  }

  void toggleWishlist(String productId) {
    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
    } else {
      wishlist.add(productId);
    }
    _persistWishlist();
    notifyListeners();
  }

  bool isWishlisted(String id) => wishlist.contains(id);

  // ---- Auth actions ----
  Future<String?> register(String name, String email, String password) async {
    final key = email.trim().toLowerCase();
    if (key.isEmpty || password.length < 4) {
      return "Enter a valid email and a password of at least 4 characters.";
    }
    if (_localAccounts.containsKey(key)) {
      return "An account with that email already exists.";
    }
    _localAccounts[key] = password;
    return await _login(name, key);
  }

  Future<String?> login(String email, String password) async {
    final key = email.trim().toLowerCase();
    if (!_localAccounts.containsKey(key)) {
      // Demo convenience: allow first-time login to auto-register locally,
      // same forgiving spirit as the sample dataset this app ships with.
      _localAccounts[key] = password;
    } else if (_localAccounts[key] != password) {
      return "Incorrect password.";
    }
    return await _login(key.split('@').first, key);
  }

  Future<String?> _login(String name, String email) async {
    currentUserName = name;
    currentUserEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    notifyListeners();
    return null; // null == success
  }

  Future<void> logout() async {
    currentUserName = null;
    currentUserEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    notifyListeners();
  }

  bool get isLoggedIn => currentUserEmail != null;

  // ---- Filtering / search logic (mirrors script.js matchesFilters) ----
  bool _queryMatchesCategoryWord(String q, String cat) {
    if (q.isEmpty) return false;
    final kws = categoryKeywords[cat] ?? [];
    final words = q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toSet();
    final matchesKeyword = kws.any((k) => k.contains(' ') ? q.contains(k) : words.contains(k));
    return matchesKeyword || words.contains(cat);
  }

  bool _matches(Product p) {
    final q = query.trim().toLowerCase();
    final nameMatch = q.isEmpty || p.name.toLowerCase().contains(q);
    final categoryWordMatch = q.isNotEmpty && _queryMatchesCategoryWord(q, p.category);
    final searchMatch = nameMatch || categoryWordMatch;
    final catMatch = category == "all" || p.category == category;
    final bestPrice = p.best.value;
    final priceMatch = bestPrice >= minPrice && bestPrice <= maxPrice;
    return searchMatch && catMatch && priceMatch;
  }

  List<Product> get filteredProducts {
    final list = allProducts.where(_matches).toList();
    switch (sortMode) {
      case SortMode.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortMode.priceLow:
        list.sort((a, b) => a.best.value.compareTo(b.best.value));
        break;
      case SortMode.savings:
        list.sort((a, b) => b.savingsPct.compareTo(a.savingsPct));
        break;
    }
    return list;
  }

  List<Product> get topRatedPicks {
    final list = [...allProducts];
    list.sort((a, b) => b.rating.compareTo(a.rating));
    return list.take(10).toList();
  }

  /// A rotating "new launches" shelf — newest-looking items by id order,
  /// standing in for the site's admin-curated new-launches feed.
  List<Product> get newLaunches {
    final list = [...allProducts];
    list.sort((a, b) => b.id.compareTo(a.id));
    return list.take(10).toList();
  }

  void setQuery(String v) {
    query = v;
    notifyListeners();
  }

  void setCategory(String v) {
    category = v;
    notifyListeners();
  }

  void setPriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    notifyListeners();
  }

  void setSort(SortMode m) {
    sortMode = m;
    notifyListeners();
  }

  void quickCategory(String cat, String keyword) {
    category = cat;
    query = keyword;
    notifyListeners();
  }

  void resetAllFilters() {
    query = "";
    category = "all";
    minPrice = 0;
    maxPrice = 200000;
    sortMode = SortMode.rating;
    notifyListeners();
  }

  List<Product> productsForCategory(String cat) =>
      allProducts.where((p) => p.category == cat).toList()
        ..sort((a, b) => a.best.value.compareTo(b.best.value));
}
