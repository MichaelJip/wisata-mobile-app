import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/product_local_datasource.dart';
import 'package:wisata_app/data/datasources/product_remote_datasource.dart';

class ProductSyncService {
  ProductSyncService(this._remote, this._local);

  final ProductRemoteDatasource _remote;
  final ProductLocalDatasource _local;

  Future<Either<String, int>> sync({int perPage = 100}) async {
    final result = await _remote.getAllProducts(perPage: perPage);
    switch (result) {
      case Left(:final value):
        return Left(value);
      case Right(:final value):
        await _local.saveProductData(value);
        return Right(value.length);
    }
  }
}
