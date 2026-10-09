import 'dart:convert';

class ProductResponseModel {
  final List<ProductItem>? data;
  final Links? links;
  final Meta? meta;

  ProductResponseModel({this.data, this.links, this.meta});

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        data: json["data"] == null
            ? []
            : List<ProductItem>.from(
                json["data"]!.map((x) => ProductItem.fromMap(x)),
              ),
        links: json["links"] == null ? null : Links.fromMap(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromMap(json["meta"]),
      );

  Map<String, dynamic> toMap() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    "links": links?.toMap(),
    "meta": meta?.toMap(),
  };
}

class ProductItem {
  final int? id;
  final String? name;
  final String? description;
  final int? price;
  final int? stock;
  final String? image;
  final Status? status;
  final Criteria? criteria;
  final bool? favorite;
  final int? categoryId;
  final Category? category;

  ProductItem({
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

  factory ProductItem.fromJson(String str) =>
      ProductItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductItem.fromMap(Map<String, dynamic> json) => ProductItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    image: json["image"],
    status: statusValues.map[json["status"]],
    criteria: criteriaValues.map[json["criteria"]],
    favorite: json["favorite"],
    categoryId: json["category_id"],
    category: json["category"] == null
        ? null
        : Category.fromMap(json["category"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "image": image,
    "status": statusValues.reverse[status],
    "criteria": criteriaValues.reverse[criteria],
    "favorite": favorite,
    "category_id": categoryId,
    "category": category?.toMap(),
  };
}

class Category {
  final int? id;
  final String? name;

  Category({this.id, this.name});

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) =>
      Category(id: json["id"], name: json["name"]);

  Map<String, dynamic> toMap() => {"id": id, "name": name};
}

enum Criteria { perorangan, rombongan }

final criteriaValues = EnumValues({
  "perorangan": Criteria.perorangan,
  "rombongan": Criteria.rombongan,
});

enum Status { published }

final statusValues = EnumValues({"published": Status.published});

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final String? next;

  Links({this.first, this.last, this.prev, this.next});

  factory Links.fromJson(String str) => Links.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Links.fromMap(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toMap() => {
    "first": first,
    "last": last,
    "prev": prev,
    "next": next,
  };
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<Link>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromMap(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toMap() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toMap())),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  };
}

class Link {
  final String? url;
  final String? label;
  final int? page;
  final bool? active;

  Link({this.url, this.label, this.page, this.active});

  factory Link.fromJson(String str) => Link.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Link.fromMap(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    page: json["page"],
    active: json["active"],
  );

  Map<String, dynamic> toMap() => {
    "url": url,
    "label": label,
    "page": page,
    "active": active,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
