import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../controller/bottom_navbar_controller.dart';

class BottomNavbarView extends StatelessWidget {
  const BottomNavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomNavbarController());

    Future<bool> showExitDialog() async {
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              '${'Exit App'.tr}?',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            content: Text('${'Do you want to exit the app'.tr}?'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkProductCardColor
                : AppColors.lightBackgroundColor,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text('No'.tr),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text('Yes'.tr),
              ),
            ],
          );
        },
      );

      return result ?? false;
    }

    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final shouldExit = await showExitDialog();

        if (!context.mounted) return;

        final navigator = Navigator.of(context);

        if (shouldExit) {
          if (navigator.canPop()) {
            navigator.pop(true);
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Obx(
        () => Scaffold(
          body: controller.screens[controller.currentIndex.value],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: (index) {
                controller.currentIndex.value = index;
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.instamartPrimary,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              showUnselectedLabels: true,
              elevation: 0,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Iconsax.home_1_copy),
                  activeIcon: const Icon(Iconsax.home_1),
                  label: 'Home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Iconsax.category_copy),
                  activeIcon: const Icon(Iconsax.category),
                  label: 'Categories'.tr,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Iconsax.shopping_cart_copy),
                  activeIcon: const Icon(Icons.shopping_cart),
                  label: 'Cart'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
