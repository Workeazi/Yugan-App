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
        ProductModel(name: "Fresh Alphonso Mango", weight: "500g", price: 299, originalPrice: 399, discountPercent: 25, image: "https://images.unsplash.com/photo-1553279768-865429fa0078"),
        ProductModel(name: "Organic Spinach Bundle", weight: "200g", price: 49, image: "https://images.unsplash.com/photo-1576045057995-568f588f82fb"),
        ProductModel(name: "Farm Fresh Tomatoes", weight: "1kg", price: 60, originalPrice: 80, discountPercent: 25, image: "https://images.unsplash.com/photo-1592924357228-91a4daadcfea"),
        ProductModel(name: "A2 Cow Milk", weight: "1L", price: 85, image: "https://images.unsplash.com/photo-1563636619-e9143da7973b"),
        ProductModel(name: "Whole Wheat Bread", weight: "400g", price: 45, image: "https://images.unsplash.com/photo-1509440159596-0249088772ff"),
        ProductModel(name: "Fresh Paneer", weight: "200g", price: 85, originalPrice: 100, discountPercent: 15, image: "https://images.unsplash.com/photo-1559598467-f8b76c8155d0"),
      ];
    } else if (categoryName == "Electronics") {
      return [
        ProductModel(name: "Wireless Earbuds Pro", weight: "1 piece", price: 1299, originalPrice: 2499, discountPercent: 48, image: "https://images.unsplash.com/photo-1590658268037-6bf12165a8df"),
        ProductModel(name: "USB-C Fast Cable", weight: "1m", price: 199, image: "https://images.unsplash.com/photo-1583863788434-e58a36330cf0"),
        ProductModel(name: "20W Power Adapter", weight: "1 piece", price: 499, originalPrice: 999, discountPercent: 50, image: "https://images.unsplash.com/photo-1585862201084-25e6c7ab9827"),
        ProductModel(name: "10000mAh Powerbank", weight: "1 piece", price: 999, originalPrice: 1499, discountPercent: 33, image: "https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5"),
        ProductModel(name: "Bluetooth Speaker", weight: "1 piece", price: 899, image: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1"),
        ProductModel(name: "Smart Watch", weight: "1 piece", price: 1999, originalPrice: 3999, discountPercent: 50, image: "https://images.unsplash.com/photo-1579586337278-3befd40fd17a"),
      ];
    } else if (categoryName == "Beauty") {
      return [
        ProductModel(name: "Matte Red Lipstick", weight: "1 piece", price: 399, originalPrice: 599, discountPercent: 33, image: "https://images.unsplash.com/photo-1586495777744-4413f21062fa"),
        ProductModel(name: "Luxury Perfume", weight: "50ml", price: 1299, image: "https://images.unsplash.com/photo-1594035910387-fea47794261f"),
        ProductModel(name: "Vitamin C Face Wash", weight: "100ml", price: 249, originalPrice: 349, discountPercent: 28, image: "https://images.unsplash.com/photo-1556228578-0d85b1a4d571"),
        ProductModel(name: "Argan Oil Shampoo", weight: "200ml", price: 349, image: "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b"),
        ProductModel(name: "Face Moisturizer", weight: "50g", price: 450, image: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be"),
        ProductModel(name: "Nail Polish Combo", weight: "3 pieces", price: 199, originalPrice: 299, discountPercent: 33, image: "https://images.unsplash.com/photo-1519014816548-bf5fe059e98b"),
      ];
    } else if (categoryName == "Fashion") {
      return [
        ProductModel(name: "Classic White Sneakers", weight: "1 pair", price: 1999, originalPrice: 2999, discountPercent: 33, image: "https://images.unsplash.com/photo-1549298916-b41d501d3772"),
        ProductModel(name: "Cotton T-Shirt", weight: "1 piece", price: 499, image: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab"),
        ProductModel(name: "Denim Jeans", weight: "1 piece", price: 1299, originalPrice: 1999, discountPercent: 35, image: "https://images.unsplash.com/photo-1542272604-780c40fb2616"),
        ProductModel(name: "Analog Watch", weight: "1 piece", price: 2499, image: "https://images.unsplash.com/photo-1524592094714-0f0654e20314"),
        ProductModel(name: "Leather Wallet", weight: "1 piece", price: 699, originalPrice: 999, discountPercent: 30, image: "https://images.unsplash.com/photo-1627123424574-724758594e93"),
        ProductModel(name: "Running Shoes", weight: "1 pair", price: 1599, image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff"),
      ];
    } else if (categoryName == "Grocery") {
      return [
        ProductModel(name: "Basmati Rice", weight: "5kg", price: 549, originalPrice: 750, discountPercent: 26, image: "https://images.unsplash.com/photo-1586201375761-83865001e31c"),
        ProductModel(name: "Refined Sugar", weight: "1kg", price: 55, image: "https://images.unsplash.com/photo-1622485601955-46f9f302be1b"),
        ProductModel(name: "Sunflower Oil", weight: "1L", price: 145, originalPrice: 180, discountPercent: 19, image: "https://images.unsplash.com/photo-1474667520023-e28022b781bc"),
        ProductModel(name: "Spices Combo", weight: "500g", price: 299, image: "https://images.unsplash.com/photo-1596040033229-a9821ebd058d"),
        ProductModel(name: "Toor Dal", weight: "1kg", price: 135, originalPrice: 160, discountPercent: 15, image: "https://images.unsplash.com/photo-1585996843486-5381a1796d4f"),
        ProductModel(name: "Mixed Dry Fruits", weight: "500g", price: 499, originalPrice: 799, discountPercent: 37, image: "https://images.unsplash.com/photo-1596040033229-a9821ebd058d"),
      ];
    } else {
      // Generic mixed products for other categories
      return List.generate(6, (index) => ProductModel(
        name: "Premium $categoryName Item ${index + 1}", 
        weight: "1 unit", 
        price: (199.0 + (index * 100)), 
        originalPrice: (index % 2 == 0) ? (299.0 + (index * 100)) : null,
        discountPercent: (index % 2 == 0) ? 33 : 0,
        image: "https://images.unsplash.com/photo-1610486027581-ea99d5901300"
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
