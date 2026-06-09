import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../core/widgets/safe_image.dart';
import '../../home/models/product_model.dart';

class ScrollingBottomBar extends StatefulWidget {
  final List<ProductModel> products;
  final int currentIndex;
  final void Function(int index) onPageChanged;

  const ScrollingBottomBar({
    super.key,
    required this.products,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  State<ScrollingBottomBar> createState() => _ScrollingBottomBarState();
}

class _ScrollingBottomBarState extends State<ScrollingBottomBar> {
  CarouselSliderController? _carouselController;

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselSliderController();
  }

  @override
  void didUpdateWidget(covariant ScrollingBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _carouselController?.animateToPage(widget.currentIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.transparent,
      child: CarouselSlider.builder(
        carouselController: _carouselController,
        itemCount: widget.products.length,
        options: CarouselOptions(
          height: 90,
          viewportFraction: 0.25,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          initialPage: widget.currentIndex,
          enableInfiniteScroll: false,
          onPageChanged: (index, reason) {
            if (reason != CarouselPageChangedReason.controller) {
              widget.onPageChanged(index);
            }
          },
        ),
        itemBuilder: (context, index, realIndex) {
          final isActive = index == widget.currentIndex;

          return GestureDetector(
            onTap: () => widget.onPageChanged(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: isActive
                    ? Border.all(color: Colors.white, width: 4)
                    : Border.all(color: Colors.transparent, width: 0),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
                    : [],
              ),
              child: Container(
                margin: EdgeInsets.all(isActive ? 3 : 0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: Colors.grey, width: 2)
                      : null,
                ),
                child: ClipOval(
                  child: AnimatedOpacity(
                    opacity: isActive ? 1.0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    child: SafeImage(
                      imageUrl: widget.products[index].image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}