import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/store_links.dart';
import '../models/product.dart';
import '../theme.dart';
import '../utils/formatters.dart';

class StorePriceStrip extends StatelessWidget {
  final Product product;
  const StorePriceStrip({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final bestStore = product.best.key;
    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: stores.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, i) {
          final store = stores[i];
          final price = product.prices[store];
          final isBest = store == bestStore && price != null;
          final isNA = price == null;
          return GestureDetector(
            onTap: isNA
                ? null
                : () async {
                    final uri = Uri.parse(storeUrl(store, product.name));
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
            child: Container(
              width: 96,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isBest ? AppColors.good.withOpacity(0.12) : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isBest ? AppColors.good : AppColors.border,
                  width: isBest ? 1.2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isBest)
                    const Text("BEST",
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.good)),
                  Text(store,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                  Text(
                    isNA ? "Not listed" : fmtRupees(price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isNA ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
