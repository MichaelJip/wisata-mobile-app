import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:wisata_app/data/datasources/auth_local_datasource.dart";

class WisataApi {
  WisataApi({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: const String.fromEnvironment('BASE_URL'),
              connectTimeout: const Duration(seconds: 8),
              receiveTimeout: const Duration(seconds: 15),
            ),
          ) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthLocalDatasource().getToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          if (kDebugMode) {
            debugPrint('API --> ${options.method} ${options.uri}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              'API <-- ${response.statusCode} ${response.requestOptions.uri}',
            );
          }
          handler.next(response);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            debugPrint(
              'API xxx ${e.response?.statusCode ?? e.type.name} ${e.requestOptions.uri}',
            );
          }
          handler.next(e);
        },
      ),
    );
  }

  final Dio dio;
}
