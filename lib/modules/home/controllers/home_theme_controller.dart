import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category_model.dart';

class HomeThemeController extends GetxController {
  var selectedIndex = 0.obs;
  var isFavorite = false.obs;
  
  late CategoryModel currentCategory;
  
  final List<CategoryModel> categories = [
    CategoryModel(
      label: "All",
      icon: Icons.shopping_basket,
      primaryColor: const Color(0xFF97009A),
      backgroundColor: const Color(0xFF97009A),
    ),
    CategoryModel(
      label: "Fresh",
      icon: Icons.eco,
      primaryColor: Colors.green, // Green
      backgroundColor: Colors.green.shade100,
    ),
    CategoryModel(
      label: "Electronics",
      icon: Icons.headphones,
      primaryColor: Colors.blue, // Blue
      backgroundColor: Colors.blue.shade100,
    ),
    CategoryModel(
      label: "50% Off",
      icon: Icons.local_offer,
      primaryColor: Colors.red, // Red
      backgroundColor: Colors.red.shade100,
    ),
    CategoryModel(
      label: "Vacations",
      icon: Icons.luggage,
      primaryColor: Colors.teal, // Teal
      backgroundColor: Colors.teal.shade100,
    ),
    CategoryModel(
      label: "Kids",
      icon: Icons.child_care,
      primaryColor: Colors.purple, // Purple
      backgroundColor: Colors.purple.shade100,
    ),
    CategoryModel(
      label: "Wedding",
      icon: Icons.favorite,
      primaryColor: const Color(0xFFB76E79), // Rose Gold
      backgroundColor: const Color(0xFFF0D9DC),
    ),
    CategoryModel(
      label: "Home",
      icon: Icons.lightbulb_outline,
      primaryColor: Colors.brown, // Brown
      backgroundColor: Colors.brown.shade100,
    ),
    CategoryModel(
      label: "Beauty",
      icon: Icons.face,
      primaryColor: Colors.pink, // Pink
      backgroundColor: Colors.pink.shade100,
    ),
    CategoryModel(
      label: "Fashion",
      icon: Icons.checkroom,
      primaryColor: Colors.orange, // Orange
      backgroundColor: Colors.orange.shade100,
    ),
    CategoryModel(
      label: "Grocery",
      icon: Icons.shopping_bag,
      primaryColor: Colors.amber.shade700, // Yellow (Amber for better visibility)
      backgroundColor: Colors.amber.shade100,
    ),
  ];
  
  @override
  void onInit() {
    super.onInit();
    currentCategory = categories[0];
  }

  void selectCategory(int index) {
    if (index == selectedIndex.value) return;
    
    selectedIndex.value = index;
    currentCategory = categories[index];
    update(['header', 'search', 'categoryNav', 'productGrid', 'homeBackground', 'contentSection', 'deliveryBar']);
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
    update(['search']);
  }
}
