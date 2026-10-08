import 'dart:convert';

class LoginResponseModel {
  final String? token;
  final User? user;

  LoginResponseModel({this.token, this.user});

  factory LoginResponseModel.fromJson(String str) =>
      LoginResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromMap(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {"token": token, "user": user?.toMap()};
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final dynamic phone;
  final String? role;

  User({this.id, this.name, this.email, this.phone, this.role});

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    role: json["role"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
  };
}
