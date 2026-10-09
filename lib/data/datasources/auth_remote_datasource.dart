import 'package:dio/dio.dart';
import 'package:wisata_app/core/utils/dio_error_message.dart';

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
      return Left(dioErrorMessage(e));
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      await _dio.post('/logout');
      return Right("Logout success");
    } on DioException catch (e) {
      return Left(dioErrorMessage(e));
    }
  }
}
