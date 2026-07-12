import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/store_links.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme.dart';
import '../utils/formatters.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final best = product.best;
    final wishlisted = appState.isWishlisted(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            onPressed: () => appState.toggleWishlist(product.id),
            icon: Icon(
              wishlisted ? Icons.favorite : Icons.favorite_border,
              color: wishlisted ? AppColors.accent : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: gradientAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(categoryIcon(product.category), size: 72, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.warn, size: 18),
              const SizedBox(width: 4),
              Text(product.rating.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Text("${fmtReviews(product.reviews)} reviews",
                  style: const TextStyle(color: AppColors.textMuted)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(product.category, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Lowest price", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(fmtRupees(best.value),
                          style: const TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.good)),
                      const SizedBox(width: 10),
                      if (product.savings > 0)
                        Text(fmtRupees(product.worst.value),
                            style: const TextStyle(
                                color: AppColors.textMuted,
                                decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                  Text("at ${best.key}", style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(storeUrl(best.key, product.name));
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      },
                      child: Text("View at ${best.key} →"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Compare across stores",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: stores.map((store) {
                final price = product.prices[store];
                final isBest = store == best.key && price != null;
                final isNA = price == null;
                return ListTile(
                  leading: Icon(
                    isBest ? Icons.verified : Icons.storefront_outlined,
                    color: isBest ? AppColors.good : AppColors.textMuted,
                  ),
                  title: Text(store),
                  subtitle: isBest ? const Text("Best price", style: TextStyle(color: AppColors.good)) : null,
                  trailing: isNA
                      ? const Text("Not listed", style: TextStyle(color: AppColors.textMuted))
                      : Text(fmtRupees(price),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isBest ? AppColors.good : AppColors.textPrimary)),
                  onTap: isNA
                      ? null
                      : () async {
                          final uri = Uri.parse(storeUrl(store, product.name));
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Full specifications",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: product.specs.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text(e.key,
                            style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
                      ),
                      Expanded(
                        child: Text(e.value,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              final uri = Uri.parse(videoSearchUrl(product.name));
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
            icon: const Icon(Icons.play_circle_outline),
            label: const Text("Watch review & unboxing videos"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
