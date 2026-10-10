import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/product_remote_datasource.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._datasource) : super(const ProductState()) {
    on<ProductFetched>(_onFetched, transformer: droppable());
    on<ProductSearched>(_onSearched, transformer: restartable());
    on<ProductRefreshed>(_onRefreshed, transformer: restartable());
  }

  final ProductRemoteDatasource _datasource;

  Future<void> _onFetched(
    ProductFetched event,
    Emitter<ProductState> emit,
  ) async {
    if (state.hasReachedMax) return;
    await _load(emit);
  }

  Future<void> _onSearched(
    ProductSearched event,
    Emitter<ProductState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (emit.isDone) return;
    emit(ProductState(status: ProductStatus.loading, query: event.query));
    await _load(emit);
  }

  Future<void> _onRefreshed(
    ProductRefreshed event,
    Emitter<ProductState> emit,
  ) async {
    final result = await _datasource.getProducts(page: 1, keyword: state.query);

    switch (result) {
      case Left(:final value):
        emit(state.copyWith(status: ProductStatus.failure, message: value));
      case Right(:final value):
        final meta = value.meta;
        emit(
          ProductState(
            status: ProductStatus.success,
            products: value.data ?? const [],
            query: state.query,
            page: 2,
            hasReachedMax: (meta?.currentPage ?? 1) >= (meta?.lastPage ?? 1),
          ),
        );
    }
  }

  Future<void> _load(Emitter<ProductState> emit) async {
    final result = await _datasource.getProducts(
      page: state.page,
      keyword: state.query,
    );
    switch (result) {
      case Left(:final value):
        emit(state.copyWith(status: ProductStatus.failure, message: value));
      case Right(:final value):
        final meta = value.meta;
        emit(
          state.copyWith(
            status: ProductStatus.success,
            products: [...state.products, ...?value.data],
            page: state.page + 1,
            hasReachedMax: (meta?.currentPage ?? 1) >= (meta?.lastPage ?? 1),
          ),
        );
    }
  }
}
