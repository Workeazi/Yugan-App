import 'package:flutter/material.dart';

class CategoryBannerWidget extends StatelessWidget {
  final String category;
  final Color primaryColor;
  
  const CategoryBannerWidget({
    super.key, 
    required this.category,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    String title = "SALE LIVE NOW";
    String subtitle = "UP TO 70% OFF";
    
    if (category == "Fresh") {
      title = "Fresh Picks 🌿";
      subtitle = "Up to 30% Off";
    } else if (category == "Electronics") {
      title = "Tech Deals 🎧";
      subtitle = "Flat ₹500 Off";
    } else if (category == "50% Off") {
      title = "Half Price Store";
      subtitle = "Everything 50% Off";
    } else if (category == "Vacations") {
      title = "Travel Packages";
      subtitle = "Book Your Escape";
    } else if (category == "Kids") {
      title = "Kids Special";
      subtitle = "Toys & Clothing";
    } else if (category == "Wedding") {
      title = "Wedding Essentials";
      subtitle = "Your Special Day";
    } else if (category == "Home") {
      title = "Home Upgrade";
      subtitle = "Decor & More";
    } else if (category == "Beauty") {
      title = "Glow Up";
      subtitle = "Beauty & Skincare";
    } else if (category == "Fashion") {
      title = "Style Week";
      subtitle = "Trendy Fits";
    } else if (category == "Grocery") {
      title = "Daily Needs";
      subtitle = "Stock Up Now";
    }

    // Create a slightly darker shade for the gradient
    final HSLColor hsl = HSLColor.fromColor(primaryColor);
    final Color darkerColor = hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [primaryColor, darkerColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: darkerColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Text(
                title,
                key: ValueKey<String>(title),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Text(
                subtitle,
                key: ValueKey<String>(subtitle),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'SHOP NOW',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
