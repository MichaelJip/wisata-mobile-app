import 'dart:convert';

import 'package:wisata_app/data/models/response/product_response_model.dart';

class OrderItem {
  final ProductItem product;
  int quantity;
  OrderItem({required this.product, required this.quantity});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.product == product &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => product.hashCode ^ quantity.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'product': product.toMap(), 'quantity': quantity};
  }

  Map<String, dynamic> toMapForLocal(int orderId) {
    return <String, dynamic>{
      'order_id': orderId,
      'product_id': product.id,
      'product_name': product.name,
      'quantity': quantity,
      'price': product.price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: ProductItem.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
