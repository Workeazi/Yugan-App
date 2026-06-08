import 'package:get/get.dart';

import '../../../data/repositories/category_repository.dart';
import '../model/category_model.dart';
import '../model/subcategory_model.dart';

class CategoryController extends GetxController {
  CategoryController(CategoryRepository repo);

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      // Delay to simulate network request
      await Future.delayed(const Duration(milliseconds: 500));

      final List<CategoryModel> mockCategories = const [
        CategoryModel(
          id: 1,
          name: "Shop by Store",
          slug: "shop-by-store",
          icon: "assets/images/products/shop.png",
          subcategories: [
            SubcategoryModel(id: 101, name: "Print Store", slug: "print-store", image: "assets/images/products/print_store.png"),
            SubcategoryModel(id: 102, name: "Health Hub", slug: "health-hub", image: "assets/images/products/health_hub.png"),
            SubcategoryModel(id: 103, name: "Sports & Fitness", slug: "sports-fitness", image: "assets/images/products/sports.png"),
            SubcategoryModel(id: 104, name: "Electronics", slug: "electronics", image: "assets/images/products/electronics.png"),
            SubcategoryModel(id: 105, name: "Fashion", slug: "fashion", image: "assets/images/products/fashion.png"),
            SubcategoryModel(id: 106, name: "Beauty", slug: "beauty", image: "assets/images/products/beauty.png"),
          ],
        ),
        CategoryModel(
          id: 2,
          name: "Fresh Items",
          slug: "fresh-items",
          icon: "assets/images/products/fresh.png",
          subcategories: [
            SubcategoryModel(id: 201, name: "Fresh Vegetables", slug: "fresh-vegetables", image: "assets/images/products/vegetables.png"),
            SubcategoryModel(id: 202, name: "Fresh Fruits", slug: "fresh-fruits", image: "assets/images/products/fruits.png"),
            SubcategoryModel(id: 203, name: "Dairy, Bread & Eggs", slug: "dairy-bread-eggs", image: "assets/images/products/dairy.png"),
            SubcategoryModel(id: 204, name: "Meat & Seafood", slug: "meat-seafood", image: "assets/images/products/meat.png"),
          ],
        ),
        CategoryModel(
          id: 3,
          name: "Grocery & Kitchen",
          slug: "grocery-kitchen",
          icon: "assets/images/products/grocery.png",
          subcategories: [
            SubcategoryModel(id: 301, name: "Atta, Rice & Dal", slug: "atta-rice-dal", image: "assets/images/products/rice.png"),
            SubcategoryModel(id: 302, name: "Masalas", slug: "masalas", image: "assets/images/products/masalas.png"),
            SubcategoryModel(id: 303, name: "Oils & Ghee", slug: "oils-ghee", image: "assets/images/products/oil.png"),
            SubcategoryModel(id: 304, name: "Cereals & Breakfast", slug: "cereals-breakfast", image: "assets/images/products/cereals.png"),
          ],
        ),
        CategoryModel(
          id: 4,
          name: "Snacks & Drinks",
          slug: "snacks-drinks",
          icon: "assets/images/products/snacks.png",
          subcategories: [
            SubcategoryModel(id: 401, name: "Cold Drinks & Juices", slug: "cold-drinks", image: "assets/images/products/pepsi.png"),
            SubcategoryModel(id: 402, name: "Ice Creams", slug: "ice-creams", image: "assets/images/products/icecream.png"),
            SubcategoryModel(id: 403, name: "Chips & Namkeens", slug: "chips-namkeen", image: "assets/images/products/lays.png"),
            SubcategoryModel(id: 404, name: "Chocolates", slug: "chocolates", image: "assets/images/products/chocolates.png"),
            SubcategoryModel(id: 405, name: "Biscuits & Cakes", slug: "biscuits", image: "assets/images/products/biscuits.png"),
            SubcategoryModel(id: 406, name: "Tea & Coffee", slug: "tea-coffee", image: "assets/images/products/coffee.png"),
            SubcategoryModel(id: 407, name: "Sauces & Spreads", slug: "sauces-spreads", image: "assets/images/products/sauces.png"),
            SubcategoryModel(id: 408, name: "Sweet Corner", slug: "sweet-corner", image: "assets/images/products/sweets.png"),
            SubcategoryModel(id: 409, name: "Noodles & Pasta", slug: "noodles-pasta", image: "assets/images/products/noodles.png"),
            SubcategoryModel(id: 410, name: "Frozen Food", slug: "frozen-food", image: "assets/images/products/frozen.png"),
            SubcategoryModel(id: 411, name: "Dry Fruits", slug: "dry-fruits", image: "assets/images/products/dry_fruits.png"),
            SubcategoryModel(id: 412, name: "Paan Corner", slug: "paan-corner", image: "assets/images/products/paan.png"),
          ],
        ),
        CategoryModel(
          id: 5,
          name: "Beauty & Wellness",
          slug: "beauty-wellness",
          icon: "assets/images/products/beauty.png",
          subcategories: [
            SubcategoryModel(id: 501, name: "Bath & Body", slug: "bath-body", image: "assets/images/products/bath.png"),
            SubcategoryModel(id: 502, name: "Hair Care", slug: "hair-care", image: "assets/images/products/hair.png"),
            SubcategoryModel(id: 503, name: "Skincare", slug: "skincare", image: "assets/images/products/skincare.png"),
            SubcategoryModel(id: 504, name: "Makeup", slug: "makeup", image: "assets/images/products/makeup.png"),
            SubcategoryModel(id: 505, name: "Feminine Hygiene", slug: "feminine-hygiene", image: "assets/images/products/hygiene.png"),
            SubcategoryModel(id: 506, name: "Sexual Wellness", slug: "sexual-wellness", image: "assets/images/products/wellness.png"),
            SubcategoryModel(id: 507, name: "Health & Pharma", slug: "health-pharma", image: "assets/images/products/pharma.png"),
            SubcategoryModel(id: 508, name: "Baby Care", slug: "baby-care", image: "assets/images/products/baby.png"),
          ],
        ),
        CategoryModel(
          id: 6,
          name: "Household & Lifestyle",
          slug: "household-lifestyle",
          icon: "assets/images/products/household.png",
          subcategories: [
            SubcategoryModel(id: 601, name: "Home & Kitchen", slug: "home-kitchen", image: "assets/images/products/kitchen.png"),
            SubcategoryModel(id: 602, name: "Puja Store", slug: "puja-store", image: "assets/images/products/puja.png"),
            SubcategoryModel(id: 603, name: "Cleaners", slug: "cleaners", image: "assets/images/products/cleaners.png"),
            SubcategoryModel(id: 604, name: "Toys & Stationery", slug: "toys-stationery", image: "assets/images/products/toys.png"),
            SubcategoryModel(id: 605, name: "Electronics", slug: "electronics", image: "assets/images/products/electronics_house.png"),
            SubcategoryModel(id: 606, name: "Jewellery", slug: "jewellery", image: "assets/images/products/jewellery.png"),
            SubcategoryModel(id: 607, name: "Pet Care", slug: "pet-care", image: "assets/images/products/pets.png"),
            SubcategoryModel(id: 608, name: "Sports", slug: "sports", image: "assets/images/products/sports_equip.png"),
          ],
        ),
      ];

      final withAll = mockCategories.map(_injectAllProducts).toList();

      categories.assignAll(withAll);
      if (selectedIndex.value >= categories.length) selectedIndex.value = 0;
    } catch (e) {
      error.value = 'Something went wrong'.tr;
      categories.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(int index) {
    if (index != selectedIndex.value) selectedIndex.value = index;
  }

  CategoryModel _injectAllProducts(CategoryModel cat) {
    final subs = List<SubcategoryModel>.from(cat.subcategories);

    final alreadyHasAll = subs.any((s) => s.isAll);
    if (!alreadyHasAll) {
      subs.insert(
        0,
        const SubcategoryModel(
          id: 0,
          name: 'All Products',
          slug: 'all-products',
          children: [],
        ),
      );
    }

    return CategoryModel(
      id: cat.id,
      name: cat.name,
      slug: cat.slug,
      icon: cat.icon,
      subcategories: subs,
    );
  }
}
