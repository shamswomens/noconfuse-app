import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_state.dart';
import '../theme.dart';
import '../utils/formatters.dart';
import '../widgets/category_strip.dart';
import '../widgets/deals_grid.dart';
import '../widgets/product_card.dart';
import '../data/store_links.dart';
import 'product_detail_screen.dart';
import 'auth_screen.dart';
import 'new_launches_screen.dart';
import 'top_rated_screen.dart';
import 'book_demo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _resultsKey = GlobalKey();

  void _scrollToResults() {
    final ctx = _resultsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final results = appState.filteredProducts;

    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            children: const [
              TextSpan(text: "No", style: TextStyle(color: AppColors.textPrimary)),
              TextSpan(text: "Confuse", style: TextStyle(color: AppColors.accent)),
            ],
          ),
        ),
        actions: [
          IconButton(
            tooltip: appState.isLoggedIn ? appState.currentUserName : "Sign in",
            icon: Icon(appState.isLoggedIn ? Icons.account_circle : Icons.login),
            onPressed: () {
              if (appState.isLoggedIn) {
                _showAccountSheet(context, appState);
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AuthScreen(initialLogin: true)));
              }
            },
          ),
          IconButton(
            tooltip: "Book a demo",
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const BookDemoScreen())),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (v) {
                appState.setQuery(v);
                _scrollToResults();
              },
              decoration: InputDecoration(
                hintText: "Search mobiles, TVs, fridges, laptops…",
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    appState.setQuery(_searchController.text);
                    _scrollToResults();
                  },
                ),
              ),
            ),
          ),
          const CategoryStrip(),
          const SizedBox(height: 18),
          _quickLinksRow(context, appState),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Offers by category",
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                const SizedBox(height: 4),
                Text("Big savings, sorted your way",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          DealsGrid(onTapCategory: (cat) {
            appState.quickCategory(cat, "");
            _scrollToResults();
          }),
          const SizedBox(height: 24),
          _priceRangeSection(context, appState),
          const SizedBox(height: 24),
          Padding(
            key: _resultsKey,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Top picks · ranked by rating",
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text("Best electronics right now",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                DropdownButton<SortMode>(
                  value: appState.sortMode,
                  dropdownColor: AppColors.surface,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: SortMode.rating, child: Text("Top rated")),
                    DropdownMenuItem(value: SortMode.priceLow, child: Text("Lowest price")),
                    DropdownMenuItem(value: SortMode.savings, child: Text("Biggest saving")),
                  ],
                  onChanged: (v) {
                    if (v != null) appState.setSort(v);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("${results.length} product${results.length == 1 ? '' : 's'} found",
                style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            _emptyState(context, appState)
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: List.generate(results.length, (i) {
                  final p = results[i];
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
                }),
              ),
            ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    children: [
                      TextSpan(text: "No", style: TextStyle(color: AppColors.textPrimary)),
                      TextSpan(text: "Confuse", style: TextStyle(color: AppColors.accent)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sample pricing data for demonstration · store links jump to real, live "
                  "Amazon / Flipkart / Croma / Reliance Digital pages · connect a retailer "
                  "API or price-tracking feed for live prices.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickLinksRow(BuildContext context, AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _quickChip(
              icon: Icons.new_releases_outlined,
              label: "New Collection",
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const NewLaunchesScreen())),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _quickChip(
              icon: Icons.favorite_border,
              label: "Top Rated",
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const TopRatedScreen())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickChip({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _priceRangeSection(BuildContext context, AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Price range", style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                "${fmtRupees(appState.minPrice.round())} – ${fmtRupees(appState.maxPrice.round())}",
                style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(appState.minPrice, appState.maxPrice),
            min: 0,
            max: 200000,
            divisions: 200,
            activeColor: AppColors.accent,
            inactiveColor: AppColors.border,
            onChanged: (v) => appState.setPriceRange(v.start, v.end),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context, AppState appState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: Column(
        children: [
          const Text("◇", style: TextStyle(fontSize: 32, color: AppColors.textMuted)),
          const SizedBox(height: 12),
          const Text("No products match that search and budget.",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text("Try widening the price range or clearing the search.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.textMuted)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              appState.resetAllFilters();
            },
            child: const Text("Reset filters"),
          ),
        ],
      ),
    );
  }

  void _showAccountSheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Signed in as", style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              const SizedBox(height: 4),
              Text(appState.currentUserEmail ?? "",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: const Text("My wishlist"),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const TopRatedScreen(wishlistOnly: true)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text("Sign out", style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  appState.logout();
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
