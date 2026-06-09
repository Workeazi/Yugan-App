import 'package:get/get.dart';
import '../../home/models/product_model.dart';
import '../model/mock_product_details_model.dart';

class MockProductDetailsController extends GetxController {
  final ProductModel initialProduct;


  late final Rx<MockProductDetailsModel> rxDetails;

  MockProductDetailsController({required this.initialProduct});

  var selectedVariantIndex = 0.obs;
  var currentImageIndex = 0.obs;
  var quantity = 1.obs;
  var isAddedToCart = false.obs;

  MockProductDetailsModel get details => rxDetails.value;

  @override
  void onInit() {
    super.onInit();

    rxDetails = Rx<MockProductDetailsModel>(
      MockProductDetailsModel(
        name: initialProduct.name,
        category: 'Grocery',
        brand: 'YUGAN Fresh',
        shortDescription:
        'Premium quality product delivered straight to your door. Enjoy the best quality with YUGAN.',
        rating: 4.8,
        deliveryTime: '15 mins',
        galleryImages: [
          initialProduct.image,
          initialProduct.image,
          initialProduct.image,
          initialProduct.image,
        ],
        variants: [
          MockVariant(
            label: initialProduct.weight,
            price: initialProduct.price,
            originalPrice:
            initialProduct.originalPrice ?? (initialProduct.price * 1.2),
            discountPercent: initialProduct.discountPercent,
          ),
          MockVariant(
            label: '2 x ${initialProduct.weight}',
            price: initialProduct.price * 2,
            originalPrice:
            (initialProduct.originalPrice ?? (initialProduct.price * 1.2)) *
                2,
            discountPercent: initialProduct.discountPercent,
          ),
          MockVariant(
            label: '3 Pack',
            price: initialProduct.price * 2.8,
            originalPrice:
            (initialProduct.originalPrice ?? (initialProduct.price * 1.2)) *
                3,
            discountPercent: initialProduct.discountPercent + 5,
          ),
        ],
        sellerName: 'YUGAN Retail Pvt Ltd',
        sellerFssai: 'FSSAI Lic. No. 10012022000456',
        sellerLocation: 'Bangalore, Karnataka',
        countryOfOrigin: 'India',
        shelfLife: 'Best before 6 months from packaging',
        storageInstructions:
        'Store in a cool, dry place away from direct sunlight.',
        ingredients: '100% natural, no artificial preservatives added.',
        offers: [
          '₹150 OFF on SBI Credit Cards',
          '10% Cashback on Paytm Wallet',
        ],
      ),
    );
  }


  MockVariant get currentVariant => details.variants[selectedVariantIndex.value];

  void selectVariant(int index) {
    selectedVariantIndex.value = index;
  }

  void onImageChanged(int index) {
    currentImageIndex.value = index;
  }

  void incrementQuantity() {
    quantity.value++;
    isAddedToCart.value = true;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    } else {
      quantity.value = 1;
      isAddedToCart.value = false;
    }
  }
}