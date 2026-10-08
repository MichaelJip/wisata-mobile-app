import "package:dio/dio.dart";
import "package:wisata_app/data/datasources/auth_remote_datasource.dart";

class WisataApi {
  WisataApi({Dio? dio})
    : dio =
          dio ?? Dio(BaseOptions(baseUrl: String.fromEnvironment('BASE_URL'))) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthLocalDataResource().getToken();
          if (token != null) options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
}
