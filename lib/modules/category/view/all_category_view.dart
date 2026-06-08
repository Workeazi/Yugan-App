import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/widgets/safe_image.dart';
import '../../../core/widgets/scale_button.dart';
import 'category_store_view.dart';
import '../controller/category_controller.dart';
import '../model/category_model.dart';
import '../model/subcategory_model.dart';

class AllCategoriesView extends StatefulWidget {
  final bool showBackButton;
  const AllCategoriesView({super.key, this.showBackButton = true});

  @override
  State<AllCategoriesView> createState() => _AllCategoriesViewState();
}

class _AllCategoriesViewState extends State<AllCategoriesView>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: widget.showBackButton ? 44 : 10,
          titleSpacing: widget.showBackButton ? 0 : 16,
          leading: widget.showBackButton
              ? IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Iconsax.arrow_left_2_copy,
                      size: 20, color: Colors.black),
                )
              : const SizedBox(),
          centerTitle: false,
          title: Text(
            'Categories'.tr,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.search_normal_1_copy, color: Colors.black, size: 22),
              onPressed: () {
                // Handle search
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.error.isNotEmpty) {
            return Center(
              child: Text(controller.error.value, textAlign: TextAlign.center),
            );
          }
          final cats = controller.categories;
          if (cats.isEmpty) return Center(child: Text('No categories'.tr));

          return FadeTransition(
            opacity: _fadeController,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cats.isNotEmpty)
                    _buildShopByStoreSection(cats.firstWhere(
                        (c) => c.slug == 'shop-by-store',
                        orElse: () => cats[0])),
                  for (final cat in cats.where((c) => c.slug != 'shop-by-store'))
                    _buildGridSection(cat),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShopByStoreSection(CategoryModel cat) {
    final items = cat.subcategories.where((e) => !e.isAll).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Text(
            cat.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];

              return ScaleButton(
                onTap: () => _navigateToProductList(cat, item),
                child: Container(
                  width: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F7FD),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: item.image != null
                            ? SafeImage(
                                imageUrl: item.image!,
                                fit: BoxFit.contain,
                              )
                            : const Icon(Icons.storefront_outlined,
                                color: Colors.grey, size: 36),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          letterSpacing: -0.2,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildGridSection(CategoryModel cat) {
    final items = cat.subcategories.where((e) => !e.isAll).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),
          child: Text(
            cat.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: -0.2,
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return ScaleButton(
              onTap: () => _navigateToProductList(cat, item),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F7FD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: item.image != null
                          ? SafeImage(
                              imageUrl: item.image!,
                              fit: BoxFit.contain,
                            )
                          : const Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.1,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _navigateToProductList(CategoryModel cat, SubcategoryModel item) {
    Get.to(
      () => CategoryStoreView(
        categoryId: cat.id,
        categoryName: cat.name,
        categorySlug: cat.slug,
        subcategoryId: item.id,
        subcategoryName: item.name,
      ),
    );
  }
}
