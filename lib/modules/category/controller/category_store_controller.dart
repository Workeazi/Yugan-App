import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/models/product_model.dart';

class CategoryStoreController extends GetxController {
  final RxList<ProductModel> bestSelling = <ProductModel>[].obs;
  final RxList<ProductModel> trending = <ProductModel>[].obs;
  final RxList<ProductModel> recommended = <ProductModel>[].obs;
  final RxList<Map<String, dynamic>> offers = <Map<String, dynamic>>[].obs;
  
  final RxString bannerTitle = ''.obs;
  final RxString storeTitle = ''.obs;

  void loadCategoryData(String categoryName, String categorySlug) {
    storeTitle.value = categoryName;

    final slug = categorySlug.toLowerCase();
    
    // Fresh Store
    if (slug.contains('fresh') || slug.contains('vegetable') || slug.contains('fruit') || slug.contains('meat') || slug.contains('dairy')) {
      bannerTitle.value = "Fresh $categoryName";
      bestSelling.assignAll([
        ProductModel(name: "Fresh Tomato", weight: "1kg", price: 40, image: "assets/images/products/tomato.png"),
        ProductModel(name: "Potato", weight: "1kg", price: 35, image: "assets/images/products/potato.png"),
        ProductModel(name: "Onion", weight: "1kg", price: 45, image: "assets/images/products/onion.png"),
        ProductModel(name: "Carrot", weight: "500g", price: 30, image: "assets/images/products/carrot.png"),
      ]);
      trending.assignAll([
        ProductModel(name: "Organic Vegetables Basket", weight: "1 set", price: 199, image: "assets/images/products/organic_veg.png"),
        ProductModel(name: "Exotic Fruits Pack", weight: "1 set", price: 299, image: "assets/images/products/exotic_fruits.png"),
      ]);
      recommended.assignAll([
        ProductModel(name: "Farm Fresh Milk", weight: "1L", price: 65, image: "assets/images/products/milk.png"),
        ProductModel(name: "Free Range Eggs", weight: "6 pcs", price: 55, image: "assets/images/products/eggs.png"),
      ]);
      offers.assignAll([
        {"title": "20% OFF Vegetables", "subtitle": "Fresh daily harvests", "color": Colors.green.shade600},
        {"title": "Buy 1 Get 1", "subtitle": "On Fresh Juices", "color": Colors.green.shade400},
      ]);
    }
    // Beauty Store
    else if (slug.contains('beauty') || slug.contains('skin') || slug.contains('hair') || slug.contains('bath') || slug.contains('makeup')) {
      bannerTitle.value = "Beauty Essentials";
      bestSelling.assignAll([
        ProductModel(name: "Matte Lipstick", weight: "1 pc", price: 499, image: "assets/images/products/lipstick.png"),
        ProductModel(name: "Herbal Shampoo", weight: "200ml", price: 299, image: "assets/images/products/shampoo.png"),
        ProductModel(name: "Glow Face Wash", weight: "100ml", price: 199, image: "assets/images/products/facewash.png"),
      ]);
      trending.assignAll([
        ProductModel(name: "Anti-Aging Serum", weight: "30ml", price: 699, image: "assets/images/products/serum.png"),
        ProductModel(name: "Sunscreen SPF 50", weight: "50g", price: 349, image: "assets/images/products/sunscreen.png"),
      ]);
      recommended.assignAll([
        ProductModel(name: "Body Lotion", weight: "200ml", price: 249, image: "assets/images/products/lotion.png"),
        ProductModel(name: "Charcoal Face Mask", weight: "50g", price: 150, image: "assets/images/products/facemask.png"),
      ]);
      offers.assignAll([
        {"title": "Beauty Deals", "subtitle": "Up to 50% OFF", "color": Colors.pink.shade400},
        {"title": "Skincare Special", "subtitle": "Glow more, pay less", "color": Colors.purple.shade400},
      ]);
    }
    // Electronics Store
    else if (slug.contains('electronic') || slug.contains('tech') || slug.contains('mobile')) {
      bannerTitle.value = "Tech Deals";
      bestSelling.assignAll([
        ProductModel(name: "Wireless Headphones", weight: "1 pc", price: 2999, originalPrice: 4999, discountPercent: 40, image: "assets/images/products/headphones.png"),
        ProductModel(name: "10000mAh Power Bank", weight: "1 pc", price: 999, originalPrice: 1999, discountPercent: 50, image: "assets/images/products/powerbank.png"),
        ProductModel(name: "Mechanical Keyboard", weight: "1 pc", price: 1999, image: "assets/images/products/keyboard.png"),
      ]);
      trending.assignAll([
        ProductModel(name: "Smart Watch Pro", weight: "1 pc", price: 3499, originalPrice: 4999, discountPercent: 30, image: "assets/images/products/smartwatch.png"),
        ProductModel(name: "Bluetooth Speaker", weight: "1 pc", price: 1499, originalPrice: 2499, discountPercent: 40, image: "assets/images/products/speaker.png"),
      ]);
      recommended.assignAll([
        ProductModel(name: "64GB Pen Drive", weight: "1 pc", price: 399, originalPrice: 699, discountPercent: 42, image: "assets/images/products/pendrive.png"),
        ProductModel(name: "Fast Wireless Charger", weight: "1 pc", price: 699, image: "assets/images/products/charger.png"),
      ]);
      offers.assignAll([
        {"title": "Electronics Sale", "subtitle": "Flat ₹500 OFF", "color": Colors.blue.shade600},
        {"title": "Accessory Fest", "subtitle": "Buy 2 Get 1 Free", "color": Colors.cyan.shade600},
      ]);
    }
    // Fashion Store
    else if (slug.contains('fashion') || slug.contains('clothing') || slug.contains('wear')) {
      bannerTitle.value = "Fashion Hub";
      bestSelling.assignAll([
        ProductModel(name: "Running Shoes", weight: "1 pair", price: 1499, image: "assets/images/products/shoes.png"),
        ProductModel(name: "Cotton T-Shirt", weight: "1 pc", price: 399, image: "assets/images/products/tshirt.png"),
        ProductModel(name: "Slim Fit Jeans", weight: "1 pc", price: 999, image: "assets/images/products/jeans.png"),
      ]);
      trending.assignAll([
        ProductModel(name: "Leather Wallet", weight: "1 pc", price: 499, image: "assets/images/products/wallet.png"),
        ProductModel(name: "Classic Sunglasses", weight: "1 pc", price: 799, image: "assets/images/products/sunglasses.png"),
      ]);
      recommended.assignAll([
        ProductModel(name: "Canvas Backpack", weight: "1 pc", price: 899, image: "assets/images/products/backpack.png"),
        ProductModel(name: "Formal Belt", weight: "1 pc", price: 299, image: "assets/images/products/belt.png"),
      ]);
      offers.assignAll([
        {"title": "Clothing Sale", "subtitle": "Upgrade your wardrobe", "color": Colors.orange.shade500},
        {"title": "Footwear Deals", "subtitle": "Step up your game", "color": Colors.deepOrange.shade400},
      ]);
    }
    // Grocery / General Store
    else {
      bannerTitle.value = "$categoryName Supermart";
      bestSelling.assignAll([
        ProductModel(name: "Premium Basmati Rice", weight: "5kg", price: 549, image: "assets/images/products/rice.png"),
        ProductModel(name: "Refined Sunflower Oil", weight: "1L", price: 145, image: "assets/images/products/oil.png"),
        ProductModel(name: "Toor Dal", weight: "1kg", price: 120, image: "assets/images/products/dal.png"),
      ]);
      trending.assignAll([
        ProductModel(name: "Mixed Dry Fruits", weight: "500g", price: 499, image: "assets/images/products/dryfruits.png"),
        ProductModel(name: "Instant Coffee", weight: "100g", price: 199, image: "assets/images/products/coffee.png"),
      ]);
      recommended.assignAll([
        ProductModel(name: "Whole Wheat Atta", weight: "5kg", price: 249, image: "assets/images/products/atta.png"),
        ProductModel(name: "Turmeric Powder", weight: "200g", price: 60, image: "assets/images/products/turmeric.png"),
      ]);
      offers.assignAll([
        {"title": "Grocery Sale", "subtitle": "Premium quality savings", "color": Colors.brown.shade500},
        {"title": "Snack Deals", "subtitle": "Crunchy savings", "color": Colors.orange.shade700},
      ]);
    }
  }
}
