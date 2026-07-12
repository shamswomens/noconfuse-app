import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/products_data.dart';
import '../data/store_links.dart';
import '../providers/app_state.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class TopRatedScreen extends StatelessWidget {
  final bool wishlistOnly;
  const TopRatedScreen({super.key, this.wishlistOnly = false});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    final products = wishlistOnly
        ? (allProducts.where((p) => appState.isWishlisted(p.id)).toList()
          ..sort((a, b) => b.rating.compareTo(a.rating)))
        : appState.topRatedPicks;

    return Scaffold(
      appBar: AppBar(title: Text(wishlistOnly ? "My wishlist" : "Top rated picks")),
      body: products.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text("Nothing here yet -- tap the heart icon on any product to save it.",
                    textAlign: TextAlign.center),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, i) {
                final p = products[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: ProductCard(
                    product: p,
                    rank: i + 1,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
                    onVisitStore: () async {
                      final uri = Uri.parse(storeUrl(p.best.key, p.name));
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                  ),
                );
              },
            ),
    );
  }
}
