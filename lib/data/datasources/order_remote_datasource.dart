import 'package:dio/dio.dart';
import 'package:wisata_app/core/utils/dio_error_message.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/models/order_model.dart';

class OrderRemoteDatasource {
  OrderRemoteDatasource(this._dio);

  final Dio _dio;

  Future<Either<String, String>> postOrder(OrderModel order) async {
    try {
      await _dio.post('/order', data: order.toRemoteMap());
      return Right('Success');
    } on DioException catch (e) {
      return Left(dioErrorMessage(e));
    } catch (e) {
      return Left(e.toString());
    }
  }
}
