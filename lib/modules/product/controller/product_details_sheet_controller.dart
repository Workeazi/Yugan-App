import 'package:flutter/material.dart';
import '../../home/models/product_model.dart';

class ProductDetailsSheetProvider extends ChangeNotifier {
  final List<ProductModel> products;
  
  int _currentIndex;
  int get currentIndex => _currentIndex;

  late final PageController pageController;
  late final List<ScrollController> scrollControllers;

  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  ProductDetailsSheetProvider({
    required this.products,
    required int initialIndex,
  }) : _currentIndex = initialIndex {
    pageController = PageController(initialPage: initialIndex);
    scrollControllers = List.generate(
      products.length,
      (_) => ScrollController(),
    );
  }

  void onPageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    
    if (pageController.hasClients && pageController.page?.round() != index) {
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void setExpanded(bool expanded) {
    if (_isExpanded == expanded) return;
    _isExpanded = expanded;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    for (final sc in scrollControllers) {
      sc.dispose();
    }
    super.dispose();
  }
}
