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
        ProductModel(name: "Kashmir Apples", weight: "1kg", price: 199, originalPrice: 249, discountPercent: 20, image: "https://images.unsplash.com/photo-1560806887-1e4cd0b6fac6"),
        ProductModel(name: "Robusta Bananas", weight: "1 Dozen", price: 60, originalPrice: 80, discountPercent: 25, image: "https://images.unsplash.com/photo-1481349518771-20055b2a7b24"),
        ProductModel(name: "Fresh Orange Juice", weight: "1L", price: 120, image: "https://images.unsplash.com/photo-1621506289937-a8e4df240d0b"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Avocado", weight: "2 pcs", price: 249, originalPrice: 299, discountPercent: 16, image: "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578"),
        ProductModel(name: "Organic Strawberries", weight: "200g", price: 150, image: "https://images.unsplash.com/photo-1464965911861-746a04b4bca6"),
        ProductModel(name: "Dragon Fruit", weight: "1 pc", price: 80, image: "https://images.unsplash.com/photo-1527325678964-54921661f888"),
      ];
    } else {
      return [
        ProductModel(name: "Fresh Broccoli", weight: "500g", price: 40, image: "https://images.unsplash.com/photo-1459411621453-7b03977f4bfc"),
        ProductModel(name: "Mushrooms", weight: "200g", price: 55, originalPrice: 65, discountPercent: 15, image: "https://images.unsplash.com/photo-1511688878353-3a2f5be94cd7"),
        ProductModel(name: "Bell Peppers", weight: "3 pcs", price: 90, image: "https://images.unsplash.com/photo-1563514227147-6d2ff665a6a0"),
      ];
    }
  } else if (categoryName == "Electronics") {
    if (section == "best") {
      return [
        ProductModel(name: "Noise Cancelling Headphones", weight: "1 pc", price: 2999, originalPrice: 4999, discountPercent: 40, image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e"),
        ProductModel(name: "Wireless Mouse", weight: "1 pc", price: 499, originalPrice: 999, discountPercent: 50, image: "https://images.unsplash.com/photo-1527864550417-7fd91fc51a46"),
        ProductModel(name: "Mechanical Keyboard", weight: "1 pc", price: 1999, image: "https://images.unsplash.com/photo-1595225476474-87563907a212"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Smart Watch Pro", weight: "1 pc", price: 3499, originalPrice: 4999, discountPercent: 30, image: "https://images.unsplash.com/photo-1579586337278-3befd40fd17a"),
        ProductModel(name: "Bluetooth Speaker", weight: "1 pc", price: 1499, originalPrice: 2499, discountPercent: 40, image: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1"),
        ProductModel(name: "4K Action Camera", weight: "1 pc", price: 5999, image: "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f"),
      ];
    } else {
      return [
        ProductModel(name: "64GB Pen Drive", weight: "1 pc", price: 399, originalPrice: 699, discountPercent: 42, image: "https://images.unsplash.com/photo-1601524909162-ae8725290836"),
        ProductModel(name: "USB-C Hub", weight: "1 pc", price: 899, originalPrice: 1499, discountPercent: 40, image: "https://images.unsplash.com/photo-1550275994-cdc89cd1948f"),
        ProductModel(name: "Fast Wireless Charger", weight: "1 pc", price: 699, image: "https://images.unsplash.com/photo-1583863788434-e58a36330cf0"),
      ];
    }
  } else if (categoryName == "Beauty") {
    if (section == "best") {
      return [
        ProductModel(name: "Matte Lipstick", weight: "1 pc", price: 499, image: "https://images.unsplash.com/photo-1586495777744-4413f21062fa"),
        ProductModel(name: "Glow Face Wash", weight: "100ml", price: 199, image: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571"),
        ProductModel(name: "Rose Perfume", weight: "50ml", price: 899, image: "https://images.unsplash.com/photo-1594035910387-fea47794261f"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Anti-Aging Serum", weight: "30ml", price: 699, image: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be"),
        ProductModel(name: "Sunscreen SPF 50", weight: "50g", price: 349, image: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571"),
        ProductModel(name: "Hair Serum", weight: "100ml", price: 299, image: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b"),
      ];
    } else {
      return [
        ProductModel(name: "Body Lotion", weight: "200ml", price: 249, image: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be"),
        ProductModel(name: "Nail Polish Set", weight: "3 pcs", price: 199, image: "https://images.unsplash.com/photo-1519014816548-bf5fe059e98b"),
        ProductModel(name: "Charcoal Face Mask", weight: "50g", price: 150, image: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571"),
      ];
    }
  } else if (categoryName == "Fashion") {
    if (section == "best") {
      return [
        ProductModel(name: "Running Shoes", weight: "1 pair", price: 1499, image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff"),
        ProductModel(name: "Cotton T-Shirt", weight: "1 pc", price: 399, image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab"),
        ProductModel(name: "Slim Fit Jeans", weight: "1 pc", price: 999, image: "https://images.unsplash.com/photo-1542272604-780c40fb2616"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Leather Wallet", weight: "1 pc", price: 499, image: "https://images.unsplash.com/photo-1627123424574-724758594e93"),
        ProductModel(name: "Classic Sunglasses", weight: "1 pc", price: 799, image: "https://images.unsplash.com/photo-1511499767150-a48a237f0083"),
        ProductModel(name: "Analog Watch", weight: "1 pc", price: 1999, image: "https://images.unsplash.com/photo-1524592094714-0f0654e20314"),
      ];
    } else {
      return [
        ProductModel(name: "Canvas Backpack", weight: "1 pc", price: 899, image: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62"),
        ProductModel(name: "Formal Belt", weight: "1 pc", price: 299, image: "https://images.unsplash.com/photo-1627123424574-724758594e93"),
        ProductModel(name: "Polo Shirt", weight: "1 pc", price: 599, image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab"),
      ];
    }
  } else if (categoryName == "Grocery") {
    if (section == "best") {
      return [
        ProductModel(name: "Premium Basmati Rice", weight: "5kg", price: 549, image: "https://images.unsplash.com/photo-1586201375761-83865001e31c"),
        ProductModel(name: "Refined Sunflower Oil", weight: "1L", price: 145, image: "https://images.unsplash.com/photo-1474667520023-e28022b781bc"),
        ProductModel(name: "Toor Dal", weight: "1kg", price: 120, image: "https://images.unsplash.com/photo-1585996843486-5381a1796d4f"),
      ];
    } else if (section == "trending") {
      return [
        ProductModel(name: "Mixed Dry Fruits", weight: "500g", price: 499, image: "https://images.unsplash.com/photo-1596040033229-a9821ebd058d"),
        ProductModel(name: "Instant Coffee", weight: "100g", price: 199, image: "https://images.unsplash.com/photo-1559525839-b184a4d698c7"),
        ProductModel(name: "Green Tea Bags", weight: "25 pcs", price: 149, image: "https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9"),
      ];
    } else {
      return [
        ProductModel(name: "Whole Wheat Atta", weight: "5kg", price: 249, image: "https://images.unsplash.com/photo-1509440159596-0249088772ff"),
        ProductModel(name: "Salt", weight: "1kg", price: 25, image: "https://images.unsplash.com/photo-1622485601955-46f9f302be1b"),
        ProductModel(name: "Turmeric Powder", weight: "200g", price: 60, image: "https://images.unsplash.com/photo-1596040033229-a9821ebd058d"),
      ];
    }
  } else {
    // Generic fallback for Kids, Wedding, Home, 50% Off, Vacations, etc.
    return [
      ProductModel(name: "Premium $categoryName 1", weight: "1 unit", price: 299, image: "https://images.unsplash.com/photo-1610486027581-ea99d5901300"),
      ProductModel(name: "Essential $categoryName 2", weight: "1 unit", price: 149, image: "https://images.unsplash.com/photo-1610486027581-ea99d5901300"),
      ProductModel(name: "Luxury $categoryName 3", weight: "1 unit", price: 899, image: "https://images.unsplash.com/photo-1610486027581-ea99d5901300"),
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
