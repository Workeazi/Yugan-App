import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../home/widgets/category_banner_widget.dart';
import '../../home/widgets/category_content_widgets.dart' show HorizontalProductList;
import '../../home/widgets/product_grid_widget.dart';
import '../controller/category_store_controller.dart';

class CategoryStoreView extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final String categorySlug;
  final int? subcategoryId;
  final String? subcategoryName;

  const CategoryStoreView({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    this.subcategoryId,
    this.subcategoryName,
  });

  @override
  State<CategoryStoreView> createState() => _CategoryStoreViewState();
}

class _CategoryStoreViewState extends State<CategoryStoreView> {
  late final CategoryStoreController controller;
  late final Color themeColor;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CategoryStoreController(), tag: 'store_${widget.subcategoryId ?? widget.categoryId}');
    final slug = widget.categorySlug.toLowerCase();
    
    // Theme mapping
    if (slug.contains('fresh') || slug.contains('vegetable') || slug.contains('fruit') || slug.contains('meat') || slug.contains('dairy')) {
      themeColor = Colors.green;
    } else if (slug.contains('beauty') || slug.contains('skin') || slug.contains('hair') || slug.contains('bath') || slug.contains('makeup')) {
      themeColor = Colors.pink;
    } else if (slug.contains('electronic') || slug.contains('tech') || slug.contains('mobile')) {
      themeColor = Colors.blue;
    } else if (slug.contains('fashion') || slug.contains('clothing') || slug.contains('wear')) {
      themeColor = Colors.orange;
    } else if (slug.contains('sport')) {
      themeColor = Colors.purple;
    } else if (slug.contains('household') || slug.contains('home') || slug.contains('grocery') || slug.contains('rice')) {
      themeColor = Colors.brown;
    } else if (slug.contains('offer') || slug.contains('sale')) {
      themeColor = Colors.red;
    } else {
      themeColor = Colors.deepPurple;
    }

    controller.loadCategoryData(widget.subcategoryName ?? widget.categoryName, widget.categorySlug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() => Text(
          controller.storeTitle.value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
        )),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.search_normal_1_copy, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.shopping_cart_copy, color: Colors.white, size: 22),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              // Banner Carousel
              if (controller.bannerTitle.isNotEmpty)
                CategoryBannerWidget(
                  category: controller.bannerTitle.value,
                  primaryColor: themeColor,
                ),

              // Best Selling
              if (controller.bestSelling.isNotEmpty)
                HorizontalProductList(
                  title: "Best Selling",
                  products: controller.bestSelling.toList(),
                  primaryColor: themeColor,
                ),

              // Offers
              if (controller.offers.isNotEmpty)
                StoreOffersWidget(
                  offers: controller.offers.toList(),
                  primaryColor: themeColor,
                ),

              // Trending
              if (controller.trending.isNotEmpty)
                HorizontalProductList(
                  title: "Trending Now",
                  products: controller.trending.toList(),
                  primaryColor: themeColor,
                ),

              // Recommended
              if (controller.recommended.isNotEmpty)
                HorizontalProductList(
                  title: "Recommended For You",
                  products: controller.recommended.toList(),
                  primaryColor: themeColor,
                ),

              // Grid
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  children: [
                    Text(
                      "All Products",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
              ),
              const ProductGridWidget(),
              const SizedBox(height: 120),
            ],
          );
        }),
      ),
    );
  }
}

class StoreOffersWidget extends StatefulWidget {
  final List<Map<String, dynamic>> offers;
  final Color primaryColor;

  const StoreOffersWidget({super.key, required this.offers, required this.primaryColor});

  @override
  State<StoreOffersWidget> createState() => _StoreOffersWidgetState();
}

class _StoreOffersWidgetState extends State<StoreOffersWidget> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients && widget.offers.isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.offers.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
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

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            "Exclusive Offers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.offers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final offer = widget.offers[index];
              final Color color = offer["color"] as Color? ?? widget.primaryColor;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      offer["title"] as String? ?? '',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer["subtitle"] as String? ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.offers.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 16 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? widget.primaryColor : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
