class ProductModel {
  final String name;
  final String weight;
  final double price;
  final double? originalPrice;
  final int discountPercent;
  final String image;

  ProductModel({
    required this.name,
    required this.weight,
    required this.price,
    this.originalPrice,
    this.discountPercent = 0,
    required this.image,
  });
}
