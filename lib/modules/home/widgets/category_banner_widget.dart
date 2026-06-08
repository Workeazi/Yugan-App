import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CategoryBannerWidget extends StatefulWidget {
  final String category;
  final Color primaryColor;
  
  const CategoryBannerWidget({
    super.key, 
    required this.category,
    required this.primaryColor,
  });

  @override
  State<CategoryBannerWidget> createState() => _CategoryBannerWidgetState();
}

class _CategoryBannerWidgetState extends State<CategoryBannerWidget> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final bannerCount = _getBannersForCategory(widget.category).length;
        _currentPage = (_currentPage + 1) % bannerCount;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, String>> _getBannersForCategory(String category) {
    if (category == "Fresh") {
      return [
        {"title": "Fresh Picks 🌿", "subtitle": "Up to 30% Off"},
        {"title": "Organic Weekend", "subtitle": "Healthy Choices"},
        {"title": "Daily Harvest", "subtitle": "Farm to Home"},
      ];
    } else if (category == "Electronics") {
      return [
        {"title": "Tech Deals 🎧", "subtitle": "Flat ₹500 Off"},
        {"title": "Gadget Fest", "subtitle": "Top Upgrades"},
        {"title": "Smart Living", "subtitle": "Future is Now"},
      ];
    } else if (category == "50% Off") {
      return [
        {"title": "Half Price Store", "subtitle": "Everything 50% Off"},
        {"title": "Clearance Sale", "subtitle": "Massive Drops"},
        {"title": "Steal Deals", "subtitle": "Don't Miss Out"},
      ];
    } else if (category == "Vacations") {
      return [
        {"title": "Travel Packages", "subtitle": "Book Your Escape"},
        {"title": "Weekend Getaway", "subtitle": "Relax & Unwind"},
        {"title": "Global Tours", "subtitle": "Explore the World"},
      ];
    } else if (category == "Kids") {
      return [
        {"title": "Kids Special", "subtitle": "Toys & Clothing"},
        {"title": "Back to School", "subtitle": "Fresh Supplies"},
        {"title": "Little Stars", "subtitle": "Big Smiles"},
      ];
    } else if (category == "Wedding") {
      return [
        {"title": "Wedding Essentials", "subtitle": "Your Special Day"},
        {"title": "Bridal Collection", "subtitle": "Elegant Styles"},
        {"title": "Gifting Made Easy", "subtitle": "For Loved Ones"},
      ];
    } else if (category == "Home") {
      return [
        {"title": "Home Upgrade", "subtitle": "Decor & More"},
        {"title": "Kitchen Essentials", "subtitle": "Cook with Love"},
        {"title": "Cozy Living", "subtitle": "Make It Yours"},
      ];
    } else if (category == "Beauty") {
      return [
        {"title": "Glow Up", "subtitle": "Beauty & Skincare"},
        {"title": "Makeup Madness", "subtitle": "Top Brands"},
        {"title": "Self Care", "subtitle": "Pamper Yourself"},
      ];
    } else if (category == "Fashion") {
      return [
        {"title": "Style Week", "subtitle": "Trendy Fits"},
        {"title": "Sneaker Fest", "subtitle": "Step Up"},
        {"title": "Winter Wear", "subtitle": "Stay Warm"},
      ];
    } else if (category == "Grocery") {
      return [
        {"title": "Daily Needs", "subtitle": "Stock Up Now"},
        {"title": "Pantry Staples", "subtitle": "Always Ready"},
        {"title": "Snack Time", "subtitle": "Craving Solved"},
      ];
    }
    
    // Default fallback
    return [
      {"title": "SALE LIVE NOW", "subtitle": "UP TO 70% OFF"},
      {"title": "MEGA SAVINGS", "subtitle": "Don't Miss Out"},
      {"title": "NEW ARRIVALS", "subtitle": "Explore Trends"},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final banners = _getBannersForCategory(widget.category);
    final HSLColor hsl = HSLColor.fromColor(widget.primaryColor);
    final Color darkerColor = hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [widget.primaryColor, darkerColor],
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
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: banners.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        banner["title"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner["subtitle"]!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: widget.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Text(
                          'SHOP NOW',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 24,
              child: AnimatedSmoothIndicator(
                activeIndex: _currentPage,
                count: banners.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
