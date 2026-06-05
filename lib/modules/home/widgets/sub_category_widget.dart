import 'package:flutter/material.dart';
import 'package:kartly_e_commerce/core/constants/app_colors.dart';

class SubCategoryWidget extends StatelessWidget {
  final String? category;
  const SubCategoryWidget({super.key, this.category});

  final List<Map<String, dynamic>> _subCategories = const [
    {
      'title': 'Pantry\nessentials',
      'offer': 'UP TO 60% OFF',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'title': 'Snacks &\nindulgences',
      'offer': 'UP TO 60% OFF',
      'icon': Icons.cookie_outlined,
    },
    {
      'title': 'Cleaning &\nhome needs',
      'offer': 'UP TO 50% OFF',
      'icon': Icons.cleaning_services_outlined,
    },
    {
      'title': 'Home\nkitchen',
      'offer': 'UP TO 80% OFF',
      'icon': Icons.kitchen_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 140,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          scrollDirection: Axis.horizontal,
          itemCount: _subCategories.length,
          itemBuilder: (context, index) {
            final category = _subCategories[index];
            return Container(
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                color: const Color(0xFF5E125E), // Solid deep purple from screenshot
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.instamartPrimary.withValues(alpha: 0.5),
                ),
              ),
              child: Stack(
                children: [
                  // Top Title
                  Positioned(
                    top: 12,
                    left: 4,
                    right: 4,
                    child: Text(
                      category['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  // Middle Icon (Placeholder for actual product images)
                  Positioned(
                    top: 50,
                    left: 0,
                    right: 0,
                    child: Icon(
                      category['icon'],
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
                  // Bottom Yellow Banner
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFD54F), // Yellow
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(11),
                          bottomRight: Radius.circular(11),
                        ),
                      ),
                      child: Text(
                        category['offer'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF5E125E), // Purple text
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
