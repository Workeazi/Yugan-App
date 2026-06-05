import 'package:get/get.dart';

class CategoryNavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void selectCategory(int index) {
    selectedIndex.value = index;
  }
}
