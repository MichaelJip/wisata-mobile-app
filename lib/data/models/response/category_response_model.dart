import 'dart:convert';

class CategoryResponseModal {
  final List<CategoryItem>? data;
  final Links? links;
  final Meta? meta;

  CategoryResponseModal({this.data, this.links, this.meta});

  CategoryResponseModal copyWith({
    List<CategoryItem>? data,
    Links? links,
    Meta? meta,
  }) => CategoryResponseModal(
    data: data ?? this.data,
    links: links ?? this.links,
    meta: meta ?? this.meta,
  );

  factory CategoryResponseModal.fromRawJson(String str) =>
      CategoryResponseModal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryResponseModal.fromJson(Map<String, dynamic> json) =>
      CategoryResponseModal(
        data: json["data"] == null
            ? []
            : List<CategoryItem>.from(
                json["data"]!.map((x) => CategoryItem.fromJson(x)),
              ),
        links: json["links"] == null ? null : Links.fromJson(json["links"]),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class CategoryItem {
  final int? id;
  final String? name;
  final String? description;
  final DateTime? createdAt;

  CategoryItem({this.id, this.name, this.description, this.createdAt});

  CategoryItem copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
  }) => CategoryItem(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
  );

  factory CategoryItem.fromRawJson(String str) =>
      CategoryItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Links {
  final String? first;
  final String? last;
  final dynamic prev;
  final dynamic next;

  Links({this.first, this.last, this.prev, this.next});

  Links copyWith({String? first, String? last, dynamic prev, dynamic next}) =>
      Links(
        first: first ?? this.first,
        last: last ?? this.last,
        prev: prev ?? this.prev,
        next: next ?? this.next,
      );

  factory Links.fromRawJson(String str) => Links.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    first: json["first"],
    last: json["last"],
    prev: json["prev"],
    next: json["next"],
  );

  Map<String, dynamic> toJson() => {
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

  Meta copyWith({
    int? currentPage,
    int? from,
    int? lastPage,
    List<Link>? links,
    String? path,
    int? perPage,
    int? to,
    int? total,
  }) => Meta(
    currentPage: currentPage ?? this.currentPage,
    from: from ?? this.from,
    lastPage: lastPage ?? this.lastPage,
    links: links ?? this.links,
    path: path ?? this.path,
    perPage: perPage ?? this.perPage,
    to: to ?? this.to,
    total: total ?? this.total,
  );

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    currentPage: json["current_page"],
    from: json["from"],
    lastPage: json["last_page"],
    links: json["links"] == null
        ? []
        : List<Link>.from(json["links"]!.map((x) => Link.fromJson(x))),
    path: json["path"],
    perPage: json["per_page"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links == null
        ? []
        : List<dynamic>.from(links!.map((x) => x.toJson())),
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

  Link copyWith({String? url, String? label, int? page, bool? active}) => Link(
    url: url ?? this.url,
    label: label ?? this.label,
    page: page ?? this.page,
    active: active ?? this.active,
  );

  factory Link.fromRawJson(String str) => Link.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"],
    label: json["label"],
    page: json["page"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "label": label,
    "page": page,
    "active": active,
  };
}
