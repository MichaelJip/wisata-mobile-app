import 'package:dio/dio.dart';
import 'package:wisata_app/core/utils/dio_error_message.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/models/request/create_ticket_request_model.dart';
import 'package:wisata_app/data/models/response/create_ticket_response_model.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

class ProductRemoteDatasource {
  ProductRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Either<String, ProductResponseModel>> getProducts({
    int page = 1,
    int? perPage,
    String keyword = '',
  }) async {
    try {
      final response = await _dio.get(
        '/product',
        queryParameters: {
          'page': page,
          'per_page': ?perPage,
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

  Future<Either<String, List<ProductItem>>> getAllProducts({
    int perPage = 100,
  }) async {
    final first = await getProducts(page: 1, perPage: perPage);
    switch (first) {
      case Left(:final value):
        return Left(value);
      case Right(:final value):
        final items = [...?value.data];
        final lastPage = value.meta?.lastPage ?? 1;
        for (var page = 2; page <= lastPage; page++) {
          final next = await getProducts(page: page, perPage: perPage);
          switch (next) {
            case Left(:final value):
              return Left(value);
            case Right(:final value):
              items.addAll(value.data ?? []);
          }
        }
        return Right(items);
    }
  }

  Future<Either<String, TicketResponsePostModel>> createProduct(
    CreateTicketRequestModel data,
  ) async {
    try {
      final response = await _dio.post('/product', data: data.toMap());
      return Right(TicketResponsePostModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(dioErrorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, TicketResponsePostModel>> updateProduct(
    CreateTicketRequestModel data,
    int id,
  ) async {
    try {
      final response = await _dio.patch('/product/$id', data: data.toMap());
      return Right(TicketResponsePostModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(dioErrorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deleteProduct(int id) async {
    try {
      await _dio.delete('/product/$id');
      return Right("Success");
    } on DioException catch (e) {
      return Left(dioErrorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
