import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/product_local_datasource.dart';
import 'package:wisata_app/data/datasources/product_remote_datasource.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._remote, this._local) : super(const ProductState()) {
    on<ProductSynced>(_onSynced, transformer: droppable());
    on<ProductLocalFetched>(_onLocalFetched, transformer: restartable());
    _watchConnectivity();
  }

  final ProductRemoteDatasource _remote;
  final ProductLocalDatasource _local;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  bool _isOnline(List<ConnectivityResult> results) =>
      !results.contains(ConnectivityResult.none);

  // Sync otomatis saat koneksi berubah dari mati -> hidup,
  // walaupun app sudah terbuka sebelumnya.
  Future<void> _watchConnectivity() async {
    final connectivity = Connectivity();
    var wasOnline = _isOnline(await connectivity.checkConnectivity());

    _connectivitySub = connectivity.onConnectivityChanged.listen((results) {
      final online = _isOnline(results);
      if (online && !wasOnline) add(ProductSynced());
      wasOnline = online;
    });
  }

  @override
  Future<void> close() {
    _connectivitySub?.cancel();
    return super.close();
  }

  Future<void> _onLocalFetched(
    ProductLocalFetched event,
    Emitter<ProductState> emit,
  ) async {
    final products = await _local.getProducts();
    if (products.isEmpty) return;
    emit(state.copyWith(status: ProductStatus.success, products: products));
  }

  Future<void> _onSynced(
    ProductSynced event,
    Emitter<ProductState> emit,
  ) async {
    emit(
      state.copyWith(
        isSyncing: true,
        status: state.products.isEmpty ? ProductStatus.loading : state.status,
      ),
    );

    final result = await _remote.getAllProducts();

    switch (result) {
      case Left(:final value):
        final local = await _local.getProducts();
        if (local.isEmpty) {
          emit(
            state.copyWith(
              status: ProductStatus.failure,
              message: value,
              isSyncing: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: ProductStatus.success,
              products: local,
              isOffline: true,
              isSyncing: false,
            ),
          );
        }
      case Right(:final value):
        final categories = {
          for (final p in value)
            if (p.category?.id != null) p.category!.id!: p.category!,
        }.values.toList();

        await _local.removeAllProduct();
        await _local.insertAllCategory(categories);
        await _local.insertAllProduct(value);

        emit(
          state.copyWith(
            status: ProductStatus.success,
            products: await _local.getProducts(),
            isOffline: false,
            isSyncing: false,
          ),
        );
    }
  }
}
