import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_theme_controller.dart';

class SearchWidget extends GetView<HomeThemeController> {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeThemeController>(
      id: 'search',
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Search Bar
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000), // AppColors.cardShadow
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Left: Search Icon
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.search,
                          color: Color(0xFF757575), // AppColors.searchIcon
                          size: 24,
                        ),
                      ),
                      
                      // Middle: Placeholder
                      const Expanded(
                        child: Text(
                          'Search for "Cakes"',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF666666), // AppColors.searchText
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      
                      // Right: Lightning Icon
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.flash_on,
                          color: controller.currentCategory.primaryColor, // Dynamic!
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Favorite Button
              GestureDetector(
                onTap: () => controller.toggleFavorite(),
                child: Container(
                  width: 44, // Matches the search bar height
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Transparent background as per prompt
                    border: Border.all(color: Colors.white, width: 1.5), // White border
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    controller.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
