import 'package:flutter/material.dart';

class CategoryModel {
  final String label;
  final IconData icon;
  final Color primaryColor;
  final Color backgroundColor;
  
  CategoryModel({
    required this.label,
    required this.icon,
    required this.primaryColor,
    required this.backgroundColor,
  });
}
