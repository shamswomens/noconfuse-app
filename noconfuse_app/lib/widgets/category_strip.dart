import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme.dart';

class _CatItem {
  final String label;
  final IconData icon;
  final String category;
  final String keyword;
  const _CatItem(this.label, this.icon, this.category, this.keyword);
}

const _items = [
  _CatItem("Mobiles", Icons.smartphone, "mobile", ""),
  _CatItem("Laptops", Icons.laptop_mac, "laptop", ""),
  _CatItem("TVs", Icons.tv, "tv", ""),
  _CatItem("Earbuds", Icons.headphones, "earbuds", ""),
  _CatItem("Tablets", Icons.tablet_mac, "tablet", ""),
  _CatItem("Fridge", Icons.kitchen, "appliance", "fridge"),
  _CatItem("Washing\nMachine", Icons.local_laundry_service, "appliance", "washing machine"),
  _CatItem("All", Icons.grid_view_rounded, "all", ""),
];

class CategoryStrip extends StatelessWidget {
  const CategoryStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return SizedBox(
      height: 92,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = _items[i];
          final isActive = appState.category == item.category &&
              (item.keyword.isEmpty || appState.query == item.keyword);
          return GestureDetector(
            onTap: () => appState.quickCategory(item.category, item.keyword),
            child: Container(
              width: 74,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent.withOpacity(0.15) : AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon,
                      color: isActive ? AppColors.accent : AppColors.textMuted, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isActive ? AppColors.textPrimary : AppColors.textMuted,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
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
