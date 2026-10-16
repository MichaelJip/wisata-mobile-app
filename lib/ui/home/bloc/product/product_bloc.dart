import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/product_local_datasource.dart';
import 'package:wisata_app/data/datasources/product_remote_datasource.dart';
import 'package:wisata_app/data/models/request/create_ticket_request_model.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._remote, this._local) : super(const ProductState()) {
    on<ProductSynced>(_onSynced, transformer: sequential());
    on<ProductCreate>(_onCreate, transformer: sequential());
    on<ProductUpdate>(_onUpdate, transformer: sequential());
    on<ProductDelete>(_onDelete, transformer: sequential());
    on<ProductLocalFetched>(_onLocalFetched, transformer: restartable());
    _watchConnectivity();
  }

  final ProductRemoteDatasource _remote;
  final ProductLocalDatasource _local;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  bool _isOnline(List<ConnectivityResult> results) =>
      !results.contains(ConnectivityResult.none);

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
        await _local.removeAllProduct();
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

  Future<void> _onCreate(
    ProductCreate event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _remote.createProduct(event.data);

    switch (result) {
      case Left(:final value):
        emit(state.copyWith(status: ProductStatus.failure, message: value));
      case Right():
        add(ProductSynced());
    }
  }

  Future<void> _onUpdate(
    ProductUpdate event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _remote.updateProduct(event.data, event.id);

    switch (result) {
      case Left(:final value):
        emit(state.copyWith(status: ProductStatus.failure, message: value));
      case Right():
        add(ProductSynced());
    }
  }

  Future<void> _onDelete(
    ProductDelete event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _remote.deleteProduct(event.id);

    switch (result) {
      case Left(:final value):
        emit(state.copyWith(status: ProductStatus.failure, message: value));
      case Right():
        add(ProductSynced());
    }
  }
}
