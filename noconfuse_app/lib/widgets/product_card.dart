import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import '../data/store_links.dart';
import 'store_price_strip.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int rank;
  final VoidCallback onTap;
  final VoidCallback onVisitStore;

  const ProductCard({
    super.key,
    required this.product,
    required this.rank,
    required this.onTap,
    required this.onVisitStore,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final best = product.best;
    final worst = product.worst;
    final hasSavings = product.savings > 0;
    final wishlisted = appState.isWishlisted(product.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      rank.toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: gradientAccent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(categoryIcon(product.category),
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14.5),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 14, color: AppColors.warn),
                            const SizedBox(width: 2),
                            Text(product.rating.toStringAsFixed(1),
                                style: const TextStyle(fontSize: 12.5)),
                            const SizedBox(width: 8),
                            Text("${fmtReviews(product.reviews)} reviews",
                                style: const TextStyle(
                                    fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => appState.toggleWishlist(product.id),
                    icon: Icon(
                      wishlisted ? Icons.favorite : Icons.favorite_border,
                      color: wishlisted ? AppColors.accent : AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Lowest price",
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(fmtRupees(best.value),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.good)),
                          if (hasSavings) ...[
                            const SizedBox(width: 6),
                            Text(fmtRupees(worst.value),
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                    decoration: TextDecoration.lineThrough)),
                          ],
                        ],
                      ),
                      Text("at ${best.key}",
                          style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                  const Spacer(),
                  if (hasSavings)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.good.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text("${product.savingsPct}% OFF",
                          style: const TextStyle(
                              color: AppColors.good,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              StorePriceStrip(product: product),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Full specs", style: TextStyle(fontSize: 12.5)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onVisitStore,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text("View at ${best.key}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
