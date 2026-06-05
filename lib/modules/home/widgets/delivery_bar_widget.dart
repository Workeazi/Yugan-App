import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_theme_controller.dart';

class DeliveryBarWidget extends StatelessWidget {
  const DeliveryBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeThemeController>(
      id: 'deliveryBar',
      builder: (controller) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: controller.currentCategory.primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_shipping, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'FREE DELIVERY ON ORDERS ABOVE ₹99',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
