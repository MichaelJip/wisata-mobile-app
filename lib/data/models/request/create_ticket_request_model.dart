// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreateTicketRequestModel {
  final String? name;
  final int? price;
  final int? stock;
  final int? categoryId;
  final String? criteria;
  final String status;

  CreateTicketRequestModel({
    required this.name,
    required this.price,
    required this.stock,
    required this.categoryId,
    required this.criteria,
    this.status = 'published',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'criteria': criteria,
      'status': status,
    };
  }

  factory CreateTicketRequestModel.fromMap(Map<String, dynamic> map) {
    return CreateTicketRequestModel(
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      stock: map['stock'] != null ? map['stock'] as int : null,
      categoryId: map['categoryId'] != null ? map['categoryId'] as int : null,
      criteria: map['criteria'] != null ? map['criteria'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateTicketRequestModel.fromJson(String source) =>
      CreateTicketRequestModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}
