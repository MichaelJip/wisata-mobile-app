import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/utils/either.dart';
import '../models/request/login_request_model.dart';
import '../models/response/login_response_model.dart';

class AuthRemoteDatasource {
  AuthRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Either<String, LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      final response = await _dio.post('/login', data: request.toMap());
      return Right(LoginResponseModel.fromMap(response.data));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : e.message ?? 'Something went wrong';
      return Left(message);
    }
  }
}

class AuthLocalDataResource {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: 'token', value: token);
  Future<String?> getToken() => _storage.read(key: 'token');
  Future<void> clear() => _storage.delete(key: 'token');
}
