class ProductModel {
  final String productName;
  final String criteria;
  final int price;
  final int stock;
  int quantity;

  ProductModel({
    required this.productName,
    required this.criteria,
    required this.price,
    required this.stock,
    this.quantity = 1,
  });
}
