import 'dart:core';

/// The six stores this app compares, in display order.
const List<String> stores = [
  "Amazon",
  "Flipkart",
  "Sathya",
  "Vasanth & Co",
  "Croma",
  "Reliance Digital",
];

/// Builds the real, live search-results URL for a store + product name,
/// same behaviour as the original website's STORE_LINKS map.
String storeUrl(String store, String productName) {
  final q = Uri.encodeComponent(productName);
  switch (store) {
    case "Amazon":
      return "https://www.amazon.in/s?k=$q&tag=noconfuse-21";
    case "Flipkart":
      return "https://www.flipkart.com/search?q=$q";
    case "Sathya":
      return "https://www.google.com/search?q=${Uri.encodeComponent('site:sathya.in $productName')}";
    case "Vasanth & Co":
      return "https://www.google.com/search?q=${Uri.encodeComponent('site:vasanthandco.in $productName')}";
    case "Croma":
      return "https://www.croma.com/searchB?q=$q%3Arelevance&text=$q";
    case "Reliance Digital":
      return "https://www.reliancedigital.in/search?q=$q%3Arelevance&text=$q";
    default:
      return "https://www.google.com/search?q=${Uri.encodeComponent('$productName $store')}";
  }
}

String videoSearchUrl(String productName) {
  final q = Uri.encodeComponent("$productName review unboxing");
  return "https://www.youtube.com/results?search_query=$q";
}

/// Maps a category key to the everyday words a person might type in search,
/// so "laptop" surfaces every laptop even if that word isn't in every name.
const Map<String, List<String>> categoryKeywords = {
  "mobile": ["mobile", "mobiles", "phone", "phones", "smartphone", "smartphones"],
  "laptop": ["laptop", "laptops", "notebook", "notebooks", "macbook", "ultrabook"],
  "tv": ["tv", "tvs", "television", "televisions", "smart tv"],
  "earbuds": ["earbuds", "earbud", "buds", "headphone", "headphones", "earphone", "earphones"],
  "tablet": ["tablet", "tablets", "ipad"],
  "appliance": ["appliance", "appliances", "fridge", "refrigerator", "washing machine", "washer", "ac", "air conditioner"],
};

const Map<String, String> categoryLabels = {
  "all": "All",
  "mobile": "Mobiles",
  "laptop": "Laptops",
  "tv": "TVs",
  "earbuds": "Earbuds",
  "tablet": "Tablets",
  "appliance": "Appliances",
};
