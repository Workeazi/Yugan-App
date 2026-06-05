import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/constants/app_colors.dart';
import '../../home/models/product_model.dart';
import '../controller/mock_product_details_controller.dart';

class MockProductDetailsView extends StatelessWidget {
  final ProductModel product;

  MockProductDetailsView({super.key, required this.product}) {
    Get.delete<MockProductDetailsController>();
    Get.put(MockProductDetailsController(initialProduct: product));
  }

  MockProductDetailsController get controller => Get.find<MockProductDetailsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Container(
                color: const Color(0xFFF5F5F5),
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildImageGallery(context),
                            _buildProductInfo(),
                            _buildVariantSelection(),
                            _buildOffersSection(),
                            _buildExpandableSection('Seller Details', _buildSellerDetails()),
                            _buildExpandableSection('Other Information', _buildOtherInfo()),
                            _buildSimilarProducts(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomBar(),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          )
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
              final imageWidget = CachedNetworkImage(
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
            child: Obx(() => AnimatedSmoothIndicator(
                  activeIndex: controller.currentImageIndex.value,
                  count: controller.details.galleryImages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    activeDotColor: AppColors.primaryColor,
                    dotColor: Colors.black.withOpacity(0.26),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
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
                    color: AppColors.primaryColor),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    controller.details.rating.toString(),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              )
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
                    color: Colors.black87),
              ),
            ],
          )
        ],
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
          Obx(() => Wrap(
                spacing: 12,
                runSpacing: 12,
                children: List.generate(
                  controller.details.variants.length,
                  (index) {
                    final variant = controller.details.variants[index];
                    final isSelected =
                        controller.selectedVariantIndex.value == index;
                    return GestureDetector(
                      onTap: () => controller.selectVariant(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryColor.withOpacity(0.1)
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
                  },
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildOffersSection() {
    return Container(
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
          ...controller.details.offers.map((offer) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer,
                        size: 16, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(offer,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87)),
                  ],
                ),
              ))
        ],
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
          )
        ],
      ),
    );
  }

  Widget _buildSellerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Seller', controller.details.sellerName),
        _buildDetailRow('FSSAI', controller.details.sellerFssai),
        _buildDetailRow('Location', controller.details.sellerLocation),
      ],
    );
  }

  Widget _buildOtherInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Origin', controller.details.countryOfOrigin),
        _buildDetailRow('Shelf Life', controller.details.shelfLife),
        _buildDetailRow('Storage', controller.details.storageInstructions),
        _buildDetailRow('Ingredients', controller.details.ingredients),
      ],
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
                        child: CachedNetworkImage(
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
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
      ),
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
                            decoration: TextDecoration.lineThrough),
                      ),
                      const SizedBox(width: 4),
                      if (variant.discountPercent > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${variant.discountPercent}% OFF',
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                    ],
                  ),
                Text(
                  '₹${variant.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: controller.decrementQuantity,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.remove,
                            size: 20, color: AppColors.primaryColor),
                      ),
                    ),
                    Obx(() => Text(
                          controller.quantity.value.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    InkWell(
                      onTap: controller.incrementQuantity,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.add,
                            size: 20, color: AppColors.primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Get.snackbar(
                    'Added to Cart',
                    '${controller.quantity.value} item(s) added.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black87,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ADD',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
