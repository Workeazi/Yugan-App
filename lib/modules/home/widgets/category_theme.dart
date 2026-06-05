import 'package:flutter/material.dart';

class CategoryTheme {
  final String name;
  final IconData icon;
  final Color primaryColor;
  final Color backgroundColor;

  const CategoryTheme({
    required this.name,
    required this.icon,
    required this.primaryColor,
    required this.backgroundColor,
  });
}

class CategoryConfig {
  static const List<CategoryTheme> categories = [
    CategoryTheme(
      name: 'All',
      icon: Icons.shopping_basket,
      primaryColor: Color(0xFF8A038C),
      backgroundColor: Color(0xFFF3E5F5), // Light purple tint
    ),
    CategoryTheme(
      name: 'Fresh',
      icon: Icons.eco,
      primaryColor: Color(0xFF4CAF50),
      backgroundColor: Color(0xFFE8F5E9), // Light green tint
    ),
    CategoryTheme(
      name: 'Electronics',
      icon: Icons.headphones,
      primaryColor: Color(0xFF8A038C),
      backgroundColor: Color(0xFFF3E5F5), // Light purple tint
    ),
    CategoryTheme(
      name: '50% Off',
      icon: Icons.local_offer,
      primaryColor: Color(0xFF5E35B1),
      backgroundColor: Color(0xFFEDE7F6), // Light violet tint
    ),
    CategoryTheme(
      name: 'Vacations',
      icon: Icons.card_travel,
      primaryColor: Color(0xFF00BCD4),
      backgroundColor: Color(0xFFE0F7FA), // Light cyan tint
    ),
    CategoryTheme(
      name: 'Kids',
      icon: Icons.toys,
      primaryColor: Color(0xFF8A038C),
      backgroundColor: Color(0xFFF3E5F5), // Light purple tint
    ),
    CategoryTheme(
      name: 'Wedding',
      icon: Icons.favorite,
      primaryColor: Color(0xFF800020),
      backgroundColor: Color(0xFFFCE4EC), // Light maroon tint
    ),
    CategoryTheme(
      name: 'Home',
      icon: Icons.light,
      primaryColor: Color(0xFF8A038C),
      backgroundColor: Color(0xFFF3E5F5), // Light purple tint
    ),
    CategoryTheme(
      name: 'Beauty',
      icon: Icons.face,
      primaryColor: Color(0xFF8A038C),
      backgroundColor: Color(0xFFF3E5F5), // Light purple tint
    ),
    CategoryTheme(
      name: 'Fashion',
      icon: Icons.checkroom,
      primaryColor: Color(0xFF8A038C),
      backgroundColor: Color(0xFFF3E5F5), // Light purple tint
    ),
    CategoryTheme(
      name: 'Grocery',
      icon: Icons.shopping_bag,
      primaryColor: Color(0xFFFF9800),
      backgroundColor: Color(0xFFFFF3E0), // Light orange tint
    ),
  ];
}
