import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:kartly_e_commerce/core/constants/app_colors.dart';
import 'package:kartly_e_commerce/core/services/login_service.dart';
import 'package:kartly_e_commerce/modules/account/view/settings_view.dart';

import '../../../core/routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/customer_basic_info_controller.dart';
import '../controller/customer_dashboard_controller.dart';

class AccountView extends StatelessWidget {
  final bool showBackButton;
  const AccountView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final infoCtrl = Get.put(CustomerBasicInfoController(), permanent: false);
    final dashCtrl = Get.put(CustomerDashboardController(), permanent: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Premium minimal background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                onPressed: () => Get.back(),
              )
            : null,
        title: Text(
          'MY ACCOUNT'.tr,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.message_question_copy, color: Colors.black, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Iconsax.more_copy, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (LoginService().isLoggedIn()) {
            await infoCtrl.fetchBasicInfo();
            dashCtrl.loadFromStorage();
          }
        },
        color: AppColors.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Information Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Obx(() {
                  // Unconditionally evaluate Rx variables so GetX tracks them
                  final currentName = infoCtrl.name.value;
                  final currentPhone = infoCtrl.phone.value;
                  final currentEmail = infoCtrl.email.value;
                  
                  final isLoggedIn = LoginService().isLoggedIn();
                  
                  final name = isLoggedIn && currentName.isNotEmpty ? currentName : 'Guest User'.tr;
                  final phone = isLoggedIn && currentPhone.isNotEmpty ? currentPhone : 'Not Available'.tr;
                  final email = isLoggedIn && currentEmail.isNotEmpty ? currentEmail : 'Not Available'.tr;
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        phone,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Membership Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2C3E50), Color(0xFF000000)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "YUGAN Plus",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                            ),
                            const SizedBox(height: 12),
                            _benefitRow(Icons.check_circle, "Unlimited Free Delivery"),
                            const SizedBox(height: 6),
                            _benefitRow(Icons.check_circle, "Exclusive Discounts"),
                            const SizedBox(height: 6),
                            _benefitRow(Icons.check_circle, "Priority Support"),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text("JOIN NOW", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Quick Actions Grid
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quick Actions",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8,
                      children: [
                        _quickAction(Iconsax.location_copy, "Addresses", () => Get.toNamed(AppRoutes.myAddressView)),
                        _quickAction(Iconsax.card_copy, "Payments", () => _comingSoon("Payment Methods")),
                        _quickAction(Iconsax.undo_copy, "Refunds", () => Get.toNamed(AppRoutes.refundRequestListView)),
                        _quickAction(Iconsax.wallet_3_copy, "Wallet", () => Get.toNamed(AppRoutes.myWalletView)),
                        _quickAction(Iconsax.heart_copy, "Wishlist", () => _comingSoon("Wishlist")),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Past Orders Section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Past Orders",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.myOrderListView),
                          child: const Text("View All", style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      final orderCount = dashCtrl.totalOrder.value;
                      if (!LoginService().isLoggedIn() || orderCount == 0) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(Iconsax.box_search, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              const Text(
                                "No Orders Yet",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to home to explore
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: const Text("Explore YUGAN"),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink(); // Could show real orders if available
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Menu Sections
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    _menuListItem(Iconsax.shopping_bag_copy, "Orders", "Current, delivered, cancelled", () => Get.toNamed(AppRoutes.myOrderListView)),
                    _menuListItem(Iconsax.heart_copy, "Wishlist", "Favorite and saved products", () => _comingSoon("Wishlist")),
                    _menuListItem(Iconsax.presention_chart_copy, "Rewards", "Reward points and benefits", () => _comingSoon("Rewards")),
                    _menuListItem(Iconsax.ticket_copy, "Coupons", "Available and used coupons", () => _comingSoon("Coupons")),
                    _menuListItem(Iconsax.notification_copy, "Notifications", "Offers, order updates", () => _comingSoon("Notifications")),
                    _menuListItem(Iconsax.setting_2_copy, "Settings", "Dark mode, language, privacy", () => Get.to(() => const SettingsView())),
                    _menuListItem(Iconsax.message_question_copy, "Help & Support", "FAQs, Contact Support", () => Get.toNamed(AppRoutes.contactUsView)),
                    _menuListItem(Iconsax.info_circle_copy, "About Us", "Company info, terms, privacy", () => Get.toNamed(AppRoutes.privacyPolicyView)),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Logout Section
              if (LoginService().isLoggedIn())
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _showLogoutDialog(context, authCtrl, dashCtrl, infoCtrl),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Iconsax.logout_1_copy, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Text(
                              "Logout".tr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.loginView),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 16),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _quickAction(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.black87, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
      onTap: onTap,
    );
  }

  void _comingSoon(String feature) {
    Get.snackbar(
      "Coming Soon",
      "$feature will be available in the next update!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showLogoutDialog(BuildContext context, AuthController authCtrl, CustomerDashboardController dashCtrl, CustomerBasicInfoController infoCtrl) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await authCtrl.logout();
              infoCtrl.avatarUrl.value = '';
              infoCtrl.name.value = '';
              infoCtrl.email.value = '';
              infoCtrl.phone.value = '';
              dashCtrl.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
