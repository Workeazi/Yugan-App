import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_theme_controller.dart';
import '../../bottom_navbar/controller/bottom_navbar_controller.dart' as kartly_bottom_nav;

class HeaderWidget extends GetView<HomeThemeController> {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeThemeController>(
      id: 'header',
      builder: (controller) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                controller.currentCategory.primaryColor, // Dynamic!
                controller.currentCategory.primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Row(
            children: [
              // LEFT: Delivery Address
              const Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "To: 53/103-104, Coimbatore, Tamil Nadu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // RIGHT: Profile Circle
              GestureDetector(
                onTap: () {
                  // Switch bottom navbar to Account tab (index 4)
                  if (Get.isRegistered<kartly_bottom_nav.BottomNavbarController>()) {
                    Get.find<kartly_bottom_nav.BottomNavbarController>().currentIndex.value = 4;
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.3),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 22,
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
