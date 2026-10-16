import 'dart:convert';

class TicketResponsePostModel {
  final Data? data;

  TicketResponsePostModel({this.data});

  factory TicketResponsePostModel.fromRawJson(String str) =>
      TicketResponsePostModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TicketResponsePostModel.fromJson(Map<String, dynamic> json) =>
      TicketResponsePostModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"data": data?.toJson()};
}

class Data {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final String? stock;
  final dynamic image;
  final String? status;
  final String? criteria;
  final bool? favorite;
  final String? categoryId;
  final Category? category;

  Data({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.image,
    this.status,
    this.criteria,
    this.favorite,
    this.categoryId,
    this.category,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"]?.toString(),
    stock: json["stock"]?.toString(),
    image: json["image"],
    status: json["status"],
    criteria: json["criteria"],
    favorite: json["favorite"] == true || json["favorite"] == 1,
    categoryId: json["category_id"]?.toString(),
    category: json["category"] == null
        ? null
        : Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "image": image,
    "status": status,
    "criteria": criteria,
    "favorite": favorite,
    "category_id": categoryId,
    "category": category?.toJson(),
  };
}

class Category {
  final int? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
