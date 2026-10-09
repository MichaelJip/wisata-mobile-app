import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_app/data/models/response/login_response_model.dart';

class AuthLocalDatasource {
  static const _tokenKey = 'token';
  static const _userKey = 'user';

  final _secure = const FlutterSecureStorage();

  Future<void> saveAuthData(LoginResponseModel data) async {
    await _secure.write(key: _tokenKey, value: data.token ?? '');
    final pref = await SharedPreferences.getInstance();
    await pref.setString(_userKey, json.encode(data.user?.toMap()));
  }

  Future<String?> getToken() => _secure.read(key: _tokenKey);

  Future<User?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(_userKey);
    if (data == null) return null;
    final map = json.decode(data);
    return map == null ? null : User.fromMap(map);
  }

  Future<bool> isLogin() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> removeAuthData() async {
    await _secure.delete(key: _tokenKey);
    final pref = await SharedPreferences.getInstance();
    await pref.remove(_userKey);
  }
}
