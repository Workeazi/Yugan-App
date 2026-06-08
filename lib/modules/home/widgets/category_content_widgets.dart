import 'dart:async';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_card_widget.dart';
import 'product_card_widget.dart';

class HorizontalProductList extends StatefulWidget {
  final String title;
  final List<ProductModel> products;
  final Color primaryColor;

  const HorizontalProductList({
    super.key,
    required this.title,
    required this.products,
    required this.primaryColor,
  });

  @override
  State<HorizontalProductList> createState() => _HorizontalProductListState();
}

class _HorizontalProductListState extends State<HorizontalProductList> {
  late final ScrollController _scrollController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_scrollController.hasClients && widget.products.isNotEmpty) {
        final maxExtent = _scrollController.position.maxScrollExtent;
        final currentOffset = _scrollController.offset;
        final double nextOffset = currentOffset + 162; // 150 width + 12 gap

        if (currentOffset >= maxExtent - 50) {
          // Reset to start if we reached the end
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        } else {
          // Scroll to next item
          _scrollController.animateTo(
            nextOffset.clamp(0.0, maxExtent),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: widget.primaryColor),
            ],
          ),
        ),
        SizedBox(
          height: 240, // Fixed height for horizontal cards
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: widget.products.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 150, // Fixed width for horizontal cards
                child: ProductCardWidget(
                  product: widget.products[index],
                  primaryColor: widget.primaryColor,
                  products: widget.products,
                  index: index,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Data Helpers ---
List<ProductModel> _getCategoryProducts(String categoryName, String section) {
  if (categoryName == "Fresh") {
    if (section == "best") {
      return [
        ProductModel(name: "Kashmir Apples", weight: "1kg", price: 199, originalPrice: 249, discountPercent: 20, image: "assets/images/products/kashmir_apples.png"),
        ProductModel(name: "Robusta Bananas", weight: "1 Dozen", price: 60, originalPrice: 80, discountPercent: 25, image: "assets/images/products/robusta_bananas.png"),
        ProductModel(name: "Fresh Orange Juice", weight: "1L", price: 120, image: "assets/images/products/fresh_orange_juice.png"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Avocado", weight: "2 pcs", price: 249, originalPrice: 299, discountPercent: 16, image: "assets/images/products/avocado.png"),
        ProductModel(name: "Organic Strawberries", weight: "200g", price: 150, image: "assets/images/products/organic_strawberries.png"),
        ProductModel(name: "Dragon Fruit", weight: "1 pc", price: 80, image: "assets/images/products/dragon_fruit.png"),
      ];
    } else {
      return [
        ProductModel(name: "Fresh Broccoli", weight: "500g", price: 40, image: "assets/images/products/fresh_broccoli.png"),
        ProductModel(name: "Mushrooms", weight: "200g", price: 55, originalPrice: 65, discountPercent: 15, image: "assets/images/products/mushrooms.png"),
        ProductModel(name: "Bell Peppers", weight: "3 pcs", price: 90, image: "assets/images/products/bell_peppers.png"),
      ];
    }
  } else if (categoryName == "Electronics") {
    if (section == "best") {
      return [
        ProductModel(name: "Noise Cancelling Headphones", weight: "1 pc", price: 2999, originalPrice: 4999, discountPercent: 40, image: "assets/images/products/noise_cancelling_headphones.png"),
        ProductModel(name: "Wireless Mouse", weight: "1 pc", price: 499, originalPrice: 999, discountPercent: 50, image: "assets/images/products/wireless_mouse.png"),
        ProductModel(name: "Mechanical Keyboard", weight: "1 pc", price: 1999, image: "assets/images/products/mechanical_keyboard.png"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Smart Watch Pro", weight: "1 pc", price: 3499, originalPrice: 4999, discountPercent: 30, image: "assets/images/products/smart_watch_pro.png"),
        ProductModel(name: "Bluetooth Speaker", weight: "1 pc", price: 1499, originalPrice: 2499, discountPercent: 40, image: "assets/images/products/bluetooth_speaker.png"),
        ProductModel(name: "4K Action Camera", weight: "1 pc", price: 5999, image: "assets/images/products/4k_action_camera.png"),
      ];
    } else {
      return [
        ProductModel(name: "64GB Pen Drive", weight: "1 pc", price: 399, originalPrice: 699, discountPercent: 42, image: "assets/images/products/64gb_pen_drive.png"),
        ProductModel(name: "USB-C Hub", weight: "1 pc", price: 899, originalPrice: 1499, discountPercent: 40, image: "assets/images/products/usb_c_hub.png"),
        ProductModel(name: "Fast Wireless Charger", weight: "1 pc", price: 699, image: "assets/images/products/fast_wireless_charger.png"),
      ];
    }
  } else if (categoryName == "Beauty") {
    if (section == "best") {
      return [
        ProductModel(name: "Matte Lipstick", weight: "1 pc", price: 499, image: "assets/images/products/matte_lipstick.png"),
        ProductModel(name: "Glow Face Wash", weight: "100ml", price: 199, image: "assets/images/products/glow_face_wash.png"),
        ProductModel(name: "Rose Perfume", weight: "50ml", price: 899, image: "assets/images/products/rose_perfume.png"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Anti-Aging Serum", weight: "30ml", price: 699, image: "assets/images/products/anti_aging_serum.png"),
        ProductModel(name: "Sunscreen SPF 50", weight: "50g", price: 349, image: "assets/images/products/sunscreen_spf_50.png"),
        ProductModel(name: "Hair Serum", weight: "100ml", price: 299, image: "assets/images/products/hair_serum.png"),
      ];
    } else {
      return [
        ProductModel(name: "Body Lotion", weight: "200ml", price: 249, image: "assets/images/products/body_lotion.png"),
        ProductModel(name: "Nail Polish Set", weight: "3 pcs", price: 199, image: "assets/images/products/nail_polish_set.png"),
        ProductModel(name: "Charcoal Face Mask", weight: "50g", price: 150, image: "assets/images/products/charcoal_face_mask.png"),
      ];
    }
  } else if (categoryName == "Fashion") {
    if (section == "best") {
      return [
        ProductModel(name: "Running Shoes", weight: "1 pair", price: 1499, image: "assets/images/products/running_shoes.png"),
        ProductModel(name: "Cotton T-Shirt", weight: "1 pc", price: 399, image: "assets/images/products/cotton_t_shirt.png"),
        ProductModel(name: "Slim Fit Jeans", weight: "1 pc", price: 999, image: "assets/images/products/slim_fit_jeans.png"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Leather Wallet", weight: "1 pc", price: 499, image: "assets/images/products/leather_wallet.png"),
        ProductModel(name: "Classic Sunglasses", weight: "1 pc", price: 799, image: "assets/images/products/classic_sunglasses.png"),
        ProductModel(name: "Analog Watch", weight: "1 pc", price: 1999, image: "assets/images/products/analog_watch.png"),
      ];
    } else {
      return [
        ProductModel(name: "Canvas Backpack", weight: "1 pc", price: 899, image: "assets/images/products/canvas_backpack.png"),
        ProductModel(name: "Formal Belt", weight: "1 pc", price: 299, image: "assets/images/products/formal_belt.png"),
        ProductModel(name: "Polo Shirt", weight: "1 pc", price: 599, image: "assets/images/products/polo_shirt.png"),
      ];
    }
  } else if (categoryName == "Grocery") {
    if (section == "best") {
      return [
        ProductModel(name: "Premium Basmati Rice", weight: "5kg", price: 549, image: "assets/images/products/premium_basmati_rice.png"),
        ProductModel(name: "Refined Sunflower Oil", weight: "1L", price: 145, image: "assets/images/products/refined_sunflower_oil.png"),
        ProductModel(name: "Toor Dal", weight: "1kg", price: 120, image: "assets/images/products/toor_dal.png"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Mixed Dry Fruits", weight: "500g", price: 499, image: "assets/images/products/mixed_dry_fruits.png"),
        ProductModel(name: "Instant Coffee", weight: "100g", price: 199, image: "assets/images/products/instant_coffee.png"),
        ProductModel(name: "Green Tea Bags", weight: "25 pcs", price: 149, image: "assets/images/products/green_tea_bags.png"),
      ];
    } else {
      return [
        ProductModel(name: "Whole Wheat Atta", weight: "5kg", price: 249, image: "assets/images/products/whole_wheat_atta.png"),
        ProductModel(name: "Salt", weight: "1kg", price: 25, image: "assets/images/products/salt.png"),
        ProductModel(name: "Turmeric Powder", weight: "200g", price: 60, image: "assets/images/products/turmeric_powder.png"),
      ];
    }
  } else {
    // Generic fallback for Kids, Wedding, Home, 50% Off, Vacations, etc.
    return [
      ProductModel(name: "Premium $categoryName 1", weight: "1 unit", price: 299, image: "assets/images/products/premium_all_1.png"),
      ProductModel(name: "Essential $categoryName 2", weight: "1 unit", price: 149, image: "assets/images/products/essential_all_2.png"),
      ProductModel(name: "Luxury $categoryName 3", weight: "1 unit", price: 899, image: "assets/images/products/luxury_all_3.png"),
    ];
  }
}

// --- Specific Section Widgets ---

class BestSellingWidget extends StatelessWidget {
  final String categoryName;
  final Color primaryColor;

  const BestSellingWidget({super.key, required this.categoryName, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return HorizontalProductList(
      title: "Best Selling", 
      products: _getCategoryProducts(categoryName, "best"), 
      primaryColor: primaryColor,
    );
  }
}

class TrendingWidget extends StatelessWidget {
  final String categoryName;
  final Color primaryColor;

  const TrendingWidget({super.key, required this.categoryName, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return HorizontalProductList(
      title: "Trending Now", 
      products: _getCategoryProducts(categoryName, "trending"), 
      primaryColor: primaryColor,
    );
  }
}

class RecommendedWidget extends StatelessWidget {
  final String categoryName;
  final Color primaryColor;

  const RecommendedWidget({super.key, required this.categoryName, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return HorizontalProductList(
      title: "Recommended For You", 
      products: _getCategoryProducts(categoryName, "recommended"), 
      primaryColor: primaryColor,
    );
  }
}

// --- Offers Widget (Auto-Scrolling PageView Carousel) ---
class OffersWidget extends StatefulWidget {
  final String categoryName;
  final Color primaryColor;

  const OffersWidget({super.key, required this.categoryName, required this.primaryColor});

  @override
  State<OffersWidget> createState() => _OffersWidgetState();
}

class _OffersWidgetState extends State<OffersWidget> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  List<Map<String, dynamic>> _getOffersForCategory(String category) {
    if (category == "Fresh") {
      return [
        {"title": "20% OFF Fruits", "subtitle": "Farm fresh directly to you", "color": const Color(0xFF4CAF50)},
        {"title": "Buy 1 Get 1", "subtitle": "On Fresh Juices", "color": const Color(0xFFFF9800)},
        {"title": "Combo Deals", "subtitle": "Vegetable basket savings", "color": const Color(0xFF8BC34A)},
      ];
    } else if (category == "Electronics") {
      return [
        {"title": "Headphone Sale", "subtitle": "Up to 40% OFF", "color": const Color(0xFF2196F3)},
        {"title": "Powerbank Deals", "subtitle": "Never run out of charge", "color": const Color(0xFF3F51B5)},
        {"title": "Accessory Fest", "subtitle": "Flat ₹200 OFF", "color": const Color(0xFF00BCD4)},
      ];
    } else if (category == "Beauty") {
      return [
        {"title": "Makeup Offers", "subtitle": "Top brands discounted", "color": const Color(0xFFE91E63)},
        {"title": "Skincare Deals", "subtitle": "Glow more, pay less", "color": const Color(0xFF9C27B0)},
        {"title": "Perfume Discounts", "subtitle": "Luxury scents", "color": const Color(0xFFF06292)},
      ];
    } else if (category == "Fashion") {
      return [
        {"title": "Clothing Sale", "subtitle": "Upgrade your wardrobe", "color": const Color(0xFFFF5252)},
        {"title": "Footwear Deals", "subtitle": "Step up your game", "color": const Color(0xFFFF7043)},
        {"title": "Accessories Offers", "subtitle": "Complete your look", "color": const Color(0xFF795548)},
      ];
    } else if (category == "Grocery") {
      return [
        {"title": "Rice Offers", "subtitle": "Premium quality", "color": const Color(0xFF009688)},
        {"title": "Oil Discounts", "subtitle": "Healthy choices", "color": const Color(0xFFFFB300)},
        {"title": "Snack Deals", "subtitle": "Crunchy savings", "color": const Color(0xFFFF5722)},
      ];
    } else {
      return [
        {"title": "50% OFF", "subtitle": "On select ${widget.categoryName}", "color": const Color(0xFFFF5252)},
        {"title": "Buy 1 Get 1", "subtitle": "Weekend Special", "color": const Color(0xFF4CAF50)},
        {"title": "Flat ₹200 OFF", "subtitle": "Orders above ₹999", "color": const Color(0xFF2196F3)},
      ];
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.9);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final offers = _getOffersForCategory(widget.categoryName);
        _currentPage = (_currentPage + 1) % offers.length;
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
    final offers = _getOffersForCategory(widget.categoryName);

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
            itemCount: offers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: offer["color"] as Color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (offer["color"] as Color).withValues(alpha: 0.3),
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
                      offer["title"] as String,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      offer["subtitle"] as String,
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
        // Dots Indicator
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(offers.length, (index) {
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

