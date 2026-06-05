class MockVariant {
  final String label;
  final double price;
  final double originalPrice;
  final int discountPercent;

  MockVariant({
    required this.label,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
  });
}

class MockProductDetailsModel {
  final String name;
  final String category;
  final String brand;
  final String shortDescription;
  final double rating;
  final String deliveryTime;
  final List<String> galleryImages;
  final List<MockVariant> variants;
  final String sellerName;
  final String sellerFssai;
  final String sellerLocation;
  final String countryOfOrigin;
  final String shelfLife;
  final String storageInstructions;
  final String ingredients;
  final List<String> offers;

  MockProductDetailsModel({
    required this.name,
    required this.category,
    required this.brand,
    required this.shortDescription,
    required this.rating,
    required this.deliveryTime,
    required this.galleryImages,
    required this.variants,
    required this.sellerName,
    required this.sellerFssai,
    required this.sellerLocation,
    required this.countryOfOrigin,
    required this.shelfLife,
    required this.storageInstructions,
    required this.ingredients,
    required this.offers,
  });
}
