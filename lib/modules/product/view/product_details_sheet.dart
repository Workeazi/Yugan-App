import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../controller/product_details_sheet_controller.dart';
import '../../../core/widgets/safe_image.dart';
import '../../home/models/product_model.dart';
import '../controller/mock_product_details_controller.dart';
import '../widgets/animated_add_button.dart';
import '../widgets/circle_bottom_bar.dart';


void showProductDetailsSheet(
    BuildContext context, {
      required List<ProductModel> products,
      required int initialIndex,
    }) {
  for (final product in products) {
    if (!Get.isRegistered<MockProductDetailsController>(tag: product.name)) {
      Get.put(
        MockProductDetailsController(initialProduct: product),
        tag: product.name,
      );
    }
  }

  showDialog(
    context: context,
    barrierColor: Colors.black54,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: ChangeNotifierProvider(
        create: (_) => ProductDetailsSheetProvider(
          products: products,
          initialIndex: initialIndex,
        ),
        child: const _ProductDetailsSheet(),
      ),
    ),
  );

}



class _ProductDetailsSheet extends StatefulWidget {
  const _ProductDetailsSheet();

  @override
  State<_ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<_ProductDetailsSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _expandAnim; // 0 = popup, 1 = fullscreen

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _expandAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductDetailsSheetProvider>();
      for (int i = 0; i < provider.scrollControllers.length; i++) {
        final capturedIndex = i;
        provider.scrollControllers[capturedIndex].addListener(
              () => _onScroll(capturedIndex, provider),
        );
      }
    });
  }

  void _onScroll(int index, ProductDetailsSheetProvider provider) {
    if (index != provider.currentIndex) return;
    final sc = provider.scrollControllers[index];
    if (!sc.hasClients) return;

    final offset = sc.offset;

    if (!provider.isExpanded && offset > 10) {
      provider.setExpanded(true);
      _animController.forward();
    } else if (provider.isExpanded && offset <= 0) {
      provider.setExpanded(false);
      _animController.reverse();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductDetailsSheetProvider>();
    final screenHeight = MediaQuery.of(context).size.height;
    final popupHeight = screenHeight * 0.82;

    return AnimatedBuilder(
      animation: _expandAnim,
      builder: (context, child) {
        // Interpolate height: popup → fullscreen
        final height = popupHeight + (screenHeight - popupHeight) * _expandAnim.value;

        // Interpolate border radius: 24 → 0
        final radius = 24.0 * (1 - _expandAnim.value);

        // Interpolate bottom bar opacity: 1 → 0
        final bottomBarOpacity = (1 - _expandAnim.value).clamp(0.0, 1.0);

        // Interpolate horizontal padding: 16 → 0
        final horizontalPadding = 16.0 * (1 - _expandAnim.value);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: Column(
                children: [
                // ── Handle bar ──────────────────────────
                GestureDetector(
                  onTap: () {
                    if (provider.isExpanded) {
                      // Collapse back
                      provider.setExpanded(false);
                      _animController.reverse();
                      // Scroll page back to top
                      final sc = provider.scrollControllers[provider.currentIndex];
                      if (sc.hasClients) {
                        sc.animateTo(
                          0,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Paged content ───────────────────────
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(provider.products.length > 1 ? radius : 0),
                    ),
                    child: Container(
                      color: const Color(0xFFF5F5F5),
                    child: PageView.builder(
                      controller: provider.pageController,
                      itemCount: provider.products.length,
                      onPageChanged: provider.onPageChanged,
                      itemBuilder: (_, index) {
                        return ProductSheetPage(
                          product: provider.products[index],
                          products: provider.products,
                          currentIndex: provider.currentIndex,
                          onPageChanged: provider.onPageChanged,
                          scrollController: provider.scrollControllers[index],
                        );
                      },
                    ),
                  ),
                ),
                ),

                // ── Bottom bar fades out as it expands ──
                if (provider.products.length > 1)
                  Opacity(
                    opacity: bottomBarOpacity,
                    child: SizeTransition(
                      sizeFactor: ReverseAnimation(_expandAnim),
                      axisAlignment: -1,
                      child: Container(
                        color: Colors.transparent,
                        child: ScrollingBottomBar(
                          products: provider.products,
                          currentIndex: provider.currentIndex,
                          onPageChanged: provider.onPageChanged,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    },
    );
  }
}


class SheetBody extends StatefulWidget {
  final ScrollController scrollController;
  final DraggableScrollableController sheetController;
  final List<ProductModel> products;
  final int currentIndex;
  final PageController pageController;
  final void Function(int) onPageChanged;
  final double bottomPadding;
  final bool isExpanded;

  const SheetBody({super.key, 
    required this.scrollController,
    required this.sheetController,
    required this.products,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.bottomPadding,
    required this.isExpanded,
  });

  @override
  State<SheetBody> createState() => SheetBodyState();
}

class SheetBodyState extends State<SheetBody> {
  bool _showBottomBar = true;

  @override
  void initState() {
    super.initState();
    widget.sheetController.addListener(_onSheetSizeChanged);
  }

  @override
  void dispose() {
    widget.sheetController.removeListener(_onSheetSizeChanged);
    super.dispose();
  }

  void _onSheetSizeChanged() {
    if (!widget.sheetController.isAttached) return;
    final show = widget.sheetController.size <= 0.57;
    if (show != _showBottomBar) {
      setState(() => _showBottomBar = show);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
              child: Column(
                children: [
                  // Drag handle
                  DragHandle(sheetController: widget.sheetController),

                  // Paged product content
                  Expanded(
                    child: PageView.builder(
                      controller: widget.pageController,
                      itemCount: widget.products.length,
                      onPageChanged: widget.onPageChanged,
                      itemBuilder: (_, index) {
                        return ProductSheetPage(
                          product: widget.products[index],
                          products: widget.products,
                          currentIndex: widget.currentIndex,
                          onPageChanged: widget.onPageChanged,
                          scrollController: widget.scrollController,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1,
            child: child,
          ),
          child: (_showBottomBar && widget.products.length > 1)
              ? Container(
            key: const ValueKey('bottom_bar'),
            color: Colors.white,
            padding: EdgeInsets.only(bottom: widget.bottomPadding),
            child: ScrollingBottomBar(
              products: widget.products,
              currentIndex: widget.currentIndex,
              onPageChanged: widget.onPageChanged,
            ),
          )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }
}


class DragHandle extends StatelessWidget {
  final DraggableScrollableController sheetController;
  const DragHandle({super.key, required this.sheetController});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        if (sheetController.isAttached &&
            sheetController.size <= 0.56) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}


class ProductSheetPage extends StatelessWidget {
  final ProductModel product;
  final List<ProductModel> products;
  final int currentIndex;
  final void Function(int) onPageChanged;
  final ScrollController scrollController;

  const ProductSheetPage({super.key,
    required this.product,
    required this.products,
    required this.currentIndex,
    required this.onPageChanged,
    required this.scrollController,
  });

  MockProductDetailsController get controller =>
      Get.find<MockProductDetailsController>(tag: product.name);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: Colors.white,
                padding:
                EdgeInsets.only(bottom: products.length > 1 ? 40 : 16),
                child: Column(
                  children: [
                    _buildImageGallery(context),
                    _buildProductInfo(),
                    _buildVariantSelection(),
                    _buildPriceAddBar(),
                  ],
                ),
              ),
              if (products.length > 1)
                Positioned(
                  bottom: -25,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildInlineNavigator()),
                ),
            ],
          ),
        ),
        if (products.length > 1)
          const SliverToBoxAdapter(child: SizedBox(height: 35)),

        // ── Everything below is "full screen only" ──
        SliverToBoxAdapter(child: _buildOffersSection()),
        SliverToBoxAdapter(
            child: _buildExpandableSection(
                'Seller Details', _buildSellerDetails())),
        SliverToBoxAdapter(
            child: _buildExpandableSection(
                'Other Information', _buildOtherInfo())),
        SliverToBoxAdapter(child: _buildSimilarProducts()),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  // ── Image gallery ─────────────────────────
  Widget _buildImageGallery(BuildContext context) {
    final height = MediaQuery.of(context).size.width * 0.72;
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
              onPageChanged: (index, _) => controller.onImageChanged(index),
            ),
            itemBuilder: (context, index, _) {
              final img = SafeImage(
                imageUrl: controller.details.galleryImages[index],
                fit: BoxFit.contain,
                width: double.infinity,
              );
              return index == 0
                  ? Hero(
                  tag: 'hero_image_${controller.initialProduct.name}',
                  child: img)
                  : img;
            },
          ),
          Positioned(
            bottom: 10,
            child: Obx(
                  () => AnimatedSmoothIndicator(
                activeIndex: controller.currentImageIndex.value,
                count: controller.details.galleryImages.length,
                effect: const ExpandingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  activeDotColor: AppColors.primaryColor,
                  dotColor: Colors.black26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Product info ──────────────────────────
  Widget _buildProductInfo() {
    return Obx(
          () => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(controller.details.brand,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor)),
                Row(children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(controller.details.rating.toString(),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
            const SizedBox(height: 6),
            Text(controller.details.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(controller.details.shortDescription,
                style:
                const TextStyle(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.timer, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('Delivery in ${controller.details.deliveryTime}',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ]),
          ],
        ),
      ),
    );
  }

  // ── Variant chips ─────────────────────────
  Widget _buildVariantSelection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Variant',
              style:
              TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
                controller.details.variants.length, (i) {
              final v = controller.details.variants[i];
              final sel = controller.selectedVariantIndex.value == i;
              return GestureDetector(
                onTap: () => controller.selectVariant(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: sel
                        ? AppColors.primaryColor
                        .withValues(alpha: 0.1)
                        : Colors.white,
                    border: Border.all(
                      color: sel
                          ? AppColors.primaryColor
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(v.label,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: sel
                              ? AppColors.primaryColor
                              : Colors.black87)),
                ),
              );
            }),
          )),
        ],
      ),
    );
  }

  // ── Price + ADD bar ───────────────────────
  Widget _buildPriceAddBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            final v = controller.currentVariant;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (v.originalPrice > v.price)
                  Row(children: [
                    Text('₹${v.originalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 6),
                    if (v.discountPercent > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('${v.discountPercent}% OFF',
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                  ]),
                Text('₹${v.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            );
          }),
          AnimatedAddButton(controller: controller),
        ],
      ),
    );
  }

  // ── Inline floating product navigator ────
  Widget _buildInlineNavigator() {
    return SizedBox(
      height: 70,
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
                child: AnimatedScale(
                  scale: isSelected ? 1.25 : 0.75,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutBack,
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 4)
                          : null,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color:
                          Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                          : null,
                    ),
                    child: ClipOval(
                      child: AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.45,
                        duration: const Duration(milliseconds: 350),
                        child: SafeImage(
                            imageUrl: products[index].image,
                            fit: BoxFit.cover),
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

  // ── Offers ────────────────────────────────
  Widget _buildOffersSection() {
    return Obx(() => Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Offers',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...controller.details.offers.map((offer) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              const Icon(Icons.local_offer,
                  size: 16, color: Colors.green),
              const SizedBox(width: 8),
              Text(offer,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black87)),
            ]),
          )),
        ],
      ),
    ));
  }

  Widget _buildExpandableSection(String title, Widget content) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: content)
        ],
      ),
    );
  }

  Widget _buildSellerDetails() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Seller', controller.details.sellerName),
        _row('FSSAI', controller.details.sellerFssai),
        _row('Location', controller.details.sellerLocation),
      ],
    ));
  }

  Widget _buildOtherInfo() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _row('Origin', controller.details.countryOfOrigin),
        _row('Shelf Life', controller.details.shelfLife),
        _row('Storage', controller.details.storageInstructions),
        _row('Ingredients', controller.details.ingredients),
      ],
    ));
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 100,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54))),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black87))),
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
          const Text('Similar Products',
              style:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (_, i) => Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(children: [
                  Expanded(
                      child: SafeImage(
                          imageUrl: controller.details.galleryImages[0],
                          fit: BoxFit.cover)),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text('Similar Item ${i + 1}',
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2)),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}