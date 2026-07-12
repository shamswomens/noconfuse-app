import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/store_links.dart';
import '../providers/app_state.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class NewLaunchesScreen extends StatelessWidget {
  const NewLaunchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final products = appState.newLaunches;

    return Scaffold(
      appBar: AppBar(title: const Text("New Collection")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: ProductCard(
              product: p,
              rank: i + 1,
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
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
