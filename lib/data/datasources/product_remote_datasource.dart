import 'package:dio/dio.dart';
import 'package:wisata_app/core/utils/dio_error_message.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

class ProductRemoteDatasource {
  ProductRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Either<String, ProductResponseModel>> getProducts({
    int page = 1,
    String keyword = '',
  }) async {
    try {
      final response = await _dio.get(
        '/product',
        queryParameters: {
          'page': page,
          if (keyword.isNotEmpty) 'keyword': keyword,
        },
      );
      return Right(ProductResponseModel.fromMap(response.data));
    } on DioException catch (e) {
      return Left(dioErrorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
