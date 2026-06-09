import 'package:get/get.dart';

import '../../category/view/all_category_view.dart';
import '../../home/view/home_view.dart';
import '../../product/view/cart_view.dart';

class BottomNavbarController extends GetxController {
  var currentIndex = 0.obs;
  var screens = [
    const HomeView(),
    const AllCategoriesView(showBackButton: false),
    CartView(),
  ].obs;
}
