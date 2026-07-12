import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme.dart';

class _Deal {
  final String label;
  final String category;
  final String badge;
  final List<Color> colors;
  final IconData icon;
  const _Deal(this.label, this.category, this.badge, this.colors, this.icon);
}

const _deals = [
  _Deal("Mobiles", "mobile", "Up to 40% Off", [Color(0xFF7C6CF6), Color(0xFF3E8BFF)], Icons.smartphone),
  _Deal("Laptops", "laptop", "Up to 35% Off", [Color(0xFF00D9C0), Color(0xFF0091AD)], Icons.laptop_mac),
  _Deal("TVs", "tv", "Up to 45% Off", [Color(0xFFFF6B9D), Color(0xFFFF3D7F)], Icons.tv),
  _Deal("Earbuds & Headphones", "earbuds", "Up to 60% Off", [Color(0xFFFFD166), Color(0xFFFF8A3D)], Icons.headphones),
  _Deal("Tablets", "tablet", "Up to 30% Off", [Color(0xFF5EE1E6), Color(0xFF3E6BFF)], Icons.tablet_mac),
  _Deal("Fridge, AC & Appliances", "appliance", "50-80% Off", [Color(0xFF37D67A), Color(0xFF0FA968)], Icons.kitchen),
];

class DealsGrid extends StatelessWidget {
  final void Function(String category) onTapCategory;
  const DealsGrid({super.key, required this.onTapCategory});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: _deals.length,
      itemBuilder: (context, i) {
        final d = _deals[i];
        return GestureDetector(
          onTap: () => onTapCategory(d.category),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: d.colors),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(d.icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Text(d.label,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5)),
                const SizedBox(height: 4),
                Text(d.badge,
                    style: TextStyle(
                        fontSize: 11.5, color: d.colors.first, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Text("Shop now", style: TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 12, color: AppColors.textMuted),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
