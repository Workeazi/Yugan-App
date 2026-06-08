import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'product_card_widget.dart';
import '../controllers/home_theme_controller.dart';

class ProductGridWidget extends StatelessWidget {
  final CategoryModel? category;

  const ProductGridWidget({super.key, this.category});

  List<ProductModel> _getDummyProductsForCategory(String categoryName) {
    if (categoryName == "Fresh") {
      return [
        ProductModel(name: "Fresh Alphonso Mango", weight: "500g", price: 299, originalPrice: 399, discountPercent: 25, image: "assets/images/products/fresh_alphonso_mango.png"),
        ProductModel(name: "Organic Spinach Bundle", weight: "200g", price: 49, image: "assets/images/products/organic_spinach_bundle.png"),
        ProductModel(name: "Farm Fresh Tomatoes", weight: "1kg", price: 60, originalPrice: 80, discountPercent: 25, image: "assets/images/products/farm_fresh_tomatoes.png"),
        ProductModel(name: "A2 Cow Milk", weight: "1L", price: 85, image: "assets/images/products/a2_cow_milk.png"),
        ProductModel(name: "Whole Wheat Bread", weight: "400g", price: 45, image: "assets/images/products/whole_wheat_bread.png"),
        ProductModel(name: "Fresh Paneer", weight: "200g", price: 85, originalPrice: 100, discountPercent: 15, image: "assets/images/products/fresh_paneer.png"),
      ];
    } else if (categoryName == "Electronics") {
      return [
        ProductModel(name: "Wireless Earbuds Pro", weight: "1 piece", price: 1299, originalPrice: 2499, discountPercent: 48, image: "assets/images/products/wireless_earbuds_pro.png"),
        ProductModel(name: "USB-C Fast Cable", weight: "1m", price: 199, image: "assets/images/products/usb_c_fast_cable.png"),
        ProductModel(name: "20W Power Adapter", weight: "1 piece", price: 499, originalPrice: 999, discountPercent: 50, image: "assets/images/products/20w_power_adapter.png"),
        ProductModel(name: "10000mAh Powerbank", weight: "1 piece", price: 999, originalPrice: 1499, discountPercent: 33, image: "assets/images/products/10000mah_powerbank.png"),
        ProductModel(name: "Bluetooth Speaker", weight: "1 piece", price: 899, image: "assets/images/products/bluetooth_speaker.png"),
        ProductModel(name: "Smart Watch", weight: "1 piece", price: 1999, originalPrice: 3999, discountPercent: 50, image: "assets/images/products/smart_watch.png"),
      ];
    } else if (categoryName == "Beauty") {
      return [
        ProductModel(name: "Matte Red Lipstick", weight: "1 piece", price: 399, originalPrice: 599, discountPercent: 33, image: "assets/images/products/matte_red_lipstick.png"),
        ProductModel(name: "Luxury Perfume", weight: "50ml", price: 1299, image: "assets/images/products/luxury_perfume.png"),
        ProductModel(name: "Vitamin C Face Wash", weight: "100ml", price: 249, originalPrice: 349, discountPercent: 28, image: "assets/images/products/vitamin_c_face_wash.png"),
        ProductModel(name: "Argan Oil Shampoo", weight: "200ml", price: 349, image: "assets/images/products/argan_oil_shampoo.png"),
        ProductModel(name: "Face Moisturizer", weight: "50g", price: 450, image: "assets/images/products/face_moisturizer.png"),
        ProductModel(name: "Nail Polish Combo", weight: "3 pieces", price: 199, originalPrice: 299, discountPercent: 33, image: "assets/images/products/nail_polish_combo.png"),
      ];
    } else if (categoryName == "Fashion") {
      return [
        ProductModel(name: "Classic White Sneakers", weight: "1 pair", price: 1999, originalPrice: 2999, discountPercent: 33, image: "assets/images/products/classic_white_sneakers.png"),
        ProductModel(name: "Cotton T-Shirt", weight: "1 piece", price: 499, image: "assets/images/products/cotton_t_shirt.png"),
        ProductModel(name: "Denim Jeans", weight: "1 piece", price: 1299, originalPrice: 1999, discountPercent: 35, image: "assets/images/products/denim_jeans.png"),
        ProductModel(name: "Analog Watch", weight: "1 piece", price: 2499, image: "assets/images/products/analog_watch.png"),
        ProductModel(name: "Leather Wallet", weight: "1 piece", price: 699, originalPrice: 999, discountPercent: 30, image: "assets/images/products/leather_wallet.png"),
        ProductModel(name: "Running Shoes", weight: "1 pair", price: 1599, image: "assets/images/products/running_shoes.png"),
      ];
    } else if (categoryName == "Grocery") {
      return [
        ProductModel(name: "Basmati Rice", weight: "5kg", price: 549, originalPrice: 750, discountPercent: 26, image: "assets/images/products/basmati_rice.png"),
        ProductModel(name: "Refined Sugar", weight: "1kg", price: 55, image: "assets/images/products/refined_sugar.png"),
        ProductModel(name: "Sunflower Oil", weight: "1L", price: 145, originalPrice: 180, discountPercent: 19, image: "assets/images/products/sunflower_oil.png"),
        ProductModel(name: "Spices Combo", weight: "500g", price: 299, image: "assets/images/products/spices_combo.png"),
        ProductModel(name: "Toor Dal", weight: "1kg", price: 135, originalPrice: 160, discountPercent: 15, image: "assets/images/products/toor_dal.png"),
        ProductModel(name: "Mixed Dry Fruits", weight: "500g", price: 499, originalPrice: 799, discountPercent: 37, image: "assets/images/products/mixed_dry_fruits.png"),
      ];
    } else {
      // Generic mixed products for other categories
      return List.generate(6, (index) => ProductModel(
        name: "Premium $categoryName Item ${index + 1}", 
        weight: "1 unit", 
        price: (199.0 + (index * 100)), 
        originalPrice: (index % 2 == 0) ? (299.0 + (index * 100)) : null,
        discountPercent: (index % 2 == 0) ? 33 : 0,
        image: "https://picsum.photos/seed/1610486027581/400"
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (category != null) {
      final products = _getDummyProductsForCategory(category!.label);
      return _buildGrid(products, category!.primaryColor, category!.label);
    }

    return GetBuilder<HomeThemeController>(
      id: 'productGrid',
      builder: (controller) {
        final currentCat = controller.currentCategory;
        final products = _getDummyProductsForCategory(currentCat.label);
        return _buildGrid(products, currentCat.primaryColor, currentCat.label);
      },
    );
  }

  Widget _buildGrid(List<ProductModel> products, Color primaryColor, String categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  categoryName == "All" ? "Explore Marketplace" : "Explore $categoryName",
                  key: ValueKey<String>("header_$categoryName"),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth >= 900) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth >= 600) {
              crossAxisCount = 3;
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: GridView.builder(
                key: ValueKey<String>("grid_$categoryName"),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.65, // Taller to fit new button
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCardWidget(
                    product: product,
                    primaryColor: primaryColor,
                    products: products,
                    index: index,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

