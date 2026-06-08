import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controller/mock_product_details_controller.dart';

class AnimatedAddButton extends StatelessWidget {
  final MockProductDetailsController controller;

  const AnimatedAddButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isAdded = controller.isAddedToCart.value;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: 48,
        width: isAdded ? 120 : 100,
        decoration: BoxDecoration(
          color: isAdded ? AppColors.primaryColor.withValues(alpha: 0.1) : AppColors.primaryColor,
          borderRadius: BorderRadius.circular(24),
          border: isAdded ? Border.all(color: AppColors.primaryColor) : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isAdded
              ? Row(
                  key: const ValueKey('quantity_selector'),
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () => controller.decrementQuantity(),
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.remove, color: AppColors.primaryColor, size: 20),
                      ),
                    ),
                    Text(
                      '${controller.quantity.value}',
                      style: const TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.incrementQuantity(),
                      behavior: HitTestBehavior.opaque,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(Icons.add, color: AppColors.primaryColor, size: 20),
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  key: const ValueKey('add_button'),
                  onTap: () => controller.incrementQuantity(),
                  behavior: HitTestBehavior.opaque,
                  child: const Center(
                    child: Text(
                      'ADD',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
        ),
      );
    });
  }
}
