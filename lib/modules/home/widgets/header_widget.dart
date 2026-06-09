import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_theme_controller.dart';

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
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "To: 53/103-104, Coimbatore, Tamil Nadu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: controller.currentCategory.primaryColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: controller.currentCategory.primaryColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
                      size: 24,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // RIGHT: Profile Circle
              GestureDetector(
                onTap: () {
                  Get.toNamed('/account_view');
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.3),
                    border: Border.all(
                      color: controller.currentCategory.primaryColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white, 
                      width: 2
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    color: controller.currentCategory.primaryColor.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
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
