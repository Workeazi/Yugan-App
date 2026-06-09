import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/safe_image.dart';
import '../../home/models/product_model.dart';
import '../controller/mock_product_details_controller.dart';
import '../widgets/animated_add_button.dart';
import '../widgets/circle_bottom_bar.dart';

class MockProductDetailsView extends StatefulWidget {
  final List<ProductModel> products;
  final int initialIndex;

  const MockProductDetailsView({
    super.key,
    required this.products,
    this.initialIndex = 0,
  });

  @override
  State<MockProductDetailsView> createState() => _MockProductDetailsViewState();
}

class _MockProductDetailsViewState extends State<MockProductDetailsView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    // Pre-register all controllers so each page can always access its active one
    for (var product in widget.products) {
      if (!Get.isRegistered<MockProductDetailsController>(tag: product.name)) {
        Get.put(
          MockProductDetailsController(initialProduct: product),
          tag: product.name,
        );
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: MediaQuery.of(context).padding.top + 20,
              color: Colors.transparent,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.products.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    return MockProductDetailsPageContent(
                      product: widget.products[index],
                      products: widget.products,
                      currentIndex: _currentIndex,
                      onPageChanged: _onPageChanged,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ScrollingBottomBar(
        products: widget.products,
        currentIndex: _currentIndex,
        onPageChanged: _onPageChanged,
      ),

    );
  }
}

class MockProductDetailsPageContent extends StatelessWidget {
  final ProductModel product;
  final List<ProductModel> products;
  final int currentIndex;
  final void Function(int) onPageChanged;

  const MockProductDetailsPageContent({
    super.key,
    required this.product,
    required this.products,
    required this.currentIndex,
    required this.onPageChanged,
  });

  MockProductDetailsController get controller =>
      Get.find<MockProductDetailsController>(tag: product.name);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // SECTION 1: Product Card
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(bottom: products.length > 1 ? 40 : 16),
                child: Column(
                  children: [
                    _buildAppBar(),
                    _buildImageGallery(context),
                    _buildProductInfo(),
                    _buildVariantSelection(),
                    _buildPriceAddBar(),
                  ],
                ),
              ),
              // Floating Navigator precisely on the seam
              if (products.length > 1)
                Positioned(
                  bottom: -25,
                  // Halves the 50px navigator circle to float perfectly on the line
                  left: 0,
                  right: 0,
                  child: Center(child: _buildFixedNavigator()),
                ),
            ],
          ),
          if (products.length > 1) const SizedBox(height: 35),
          // Space out section 2 so navigator doesn't overlap it

          // SECTION 2: Details & Offers
          _buildOffersSection(),
          _buildExpandableSection('Seller Details', _buildSellerDetails()),
          _buildExpandableSection('Other Information', _buildOtherInfo()),
          _buildSimilarProducts(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPriceAddBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final variant = controller.currentVariant;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (variant.originalPrice > variant.price)
                  Row(
                    children: [
                      Text(
                        '₹${variant.originalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (variant.discountPercent > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${variant.discountPercent}% OFF',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                Text(
                  '₹${variant.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          }),
          AnimatedAddButton(controller: controller),
        ],
      ),
    );
  }

  Widget _buildFixedNavigator() {
    return Container(
      height: 70,
      color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(products.length, (index) {
            final isSelected = product.name == products[index].name;
            return GestureDetector(
              onTap: () => onPageChanged(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Center(
                  child: AnimatedScale(
                    scale: isSelected ?  1.25 : 0.75,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutBack,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOutBack,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 4)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.45,
                          duration: const Duration(milliseconds: 350),
                          child: SafeImage(
                            imageUrl: products[index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          const Row(
            children: [
              Icon(Icons.favorite_border, color: Colors.black87),
              SizedBox(width: 16),
              Icon(Icons.share, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    final height = MediaQuery.of(context).size.width * 0.8;
    return Container(
      color: Colors.white,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: controller.details.galleryImages.length,
            options: CarouselOptions(
              height: height,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                controller.onImageChanged(index);
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final imageWidget = SafeImage(
                imageUrl: controller.details.galleryImages[index],
                fit: BoxFit.contain,
                width: double.infinity,
              );

              if (index == 0) {
                return Hero(
                  tag: 'hero_image_${controller.initialProduct.name}',
                  child: imageWidget,
                );
              }
              return imageWidget;
            },
          ),
          Positioned(
            bottom: 12,
            child: Obx(
              () => AnimatedSmoothIndicator(
                activeIndex: controller.currentImageIndex.value,
                count: controller.details.galleryImages.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: AppColors.primaryColor,
                  dotColor: Colors.black.withValues(alpha: 0.26),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.details.brand,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      controller.details.rating.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              controller.details.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              controller.details.shortDescription,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Delivery in ${controller.details.deliveryTime}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantSelection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Variant',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(
            () => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(controller.details.variants.length, (
                index,
              ) {
                final variant = controller.details.variants[index];
                final isSelected =
                    controller.selectedVariantIndex.value == index;
                return GestureDetector(
                  onTap: () => controller.selectVariant(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withValues(alpha: 0.1)
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      variant.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Offers',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...controller.details.offers.map(
              (offer) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      offer,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection(String title, Widget content) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildSellerDetails() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Seller', controller.details.sellerName),
          _buildDetailRow('FSSAI', controller.details.sellerFssai),
          _buildDetailRow('Location', controller.details.sellerLocation),
        ],
      ),
    );
  }

  Widget _buildOtherInfo() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Origin', controller.details.countryOfOrigin),
          _buildDetailRow('Shelf Life', controller.details.shelfLife),
          _buildDetailRow('Storage', controller.details.storageInstructions),
          _buildDetailRow('Ingredients', controller.details.ingredients),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarProducts() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Similar Products',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SafeImage(
                          imageUrl: controller.details.galleryImages[0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Similar Item ${index + 1}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
