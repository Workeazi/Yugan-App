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
      primaryColor: const Color(0xFF4CAF50),
      backgroundColor: const Color(0xFFE8F5E9),
    ),
    CategoryModel(
      label: "Electronics",
      icon: Icons.headphones,
      primaryColor: const Color(0xFF7E57C2),
      backgroundColor: const Color(0xFFEDE7F6),
    ),
    CategoryModel(
      label: "50% Off",
      icon: Icons.local_offer,
      primaryColor: const Color(0xFF5E35B1),
      backgroundColor: const Color(0xFFD1C4E9),
    ),
    CategoryModel(
      label: "Vacations",
      icon: Icons.luggage,
      primaryColor: const Color(0xFF3F51B5),
      backgroundColor: const Color(0xFFE8EAF6),
    ),
    CategoryModel(
      label: "Kids",
      icon: Icons.child_care,
      primaryColor: const Color(0xFF8E24AA),
      backgroundColor: const Color(0xFFF3E5F5),
    ),
    CategoryModel(
      label: "Wedding",
      icon: Icons.favorite,
      primaryColor: const Color(0xFF800020),
      backgroundColor: const Color(0xFFFCE4EC),
    ),
    CategoryModel(
      label: "Home",
      icon: Icons.lightbulb_outline,
      primaryColor: const Color(0xFF6A1B9A),
      backgroundColor: const Color(0xFFEDE7F6),
    ),
    CategoryModel(
      label: "Beauty",
      icon: Icons.face,
      primaryColor: const Color(0xFFC2185B),
      backgroundColor: const Color(0xFFFCE4EC),
    ),
    CategoryModel(
      label: "Fashion",
      icon: Icons.checkroom,
      primaryColor: const Color(0xFF8E24AA),
      backgroundColor: const Color(0xFFF3E5F5),
    ),
    CategoryModel(
      label: "Grocery",
      icon: Icons.shopping_bag,
      primaryColor: const Color(0xFF263238),
      backgroundColor: const Color(0xFFECEFF1),
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
