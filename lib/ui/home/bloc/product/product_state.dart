part of 'product_bloc.dart';

enum ProductStatus { initial, loading, success, failure }

@immutable
final class ProductState {
  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.query = '',
    this.page = 1,
    this.hasReachedMax = false,
    this.message,
    this.isOffline = false,
    this.isSyncing = false,
  });

  final ProductStatus status;
  final List<ProductItem> products;
  final String query;
  final int page;
  final bool hasReachedMax;
  final String? message;
  final bool isOffline;
  final bool isSyncing;

  ProductState copyWith({
    ProductStatus? status,
    List<ProductItem>? products,
    String? query,
    int? page,
    bool? hasReachedMax,
    String? message,
    bool? isOffline,
    bool? isSyncing,
  }) => ProductState(
    status: status ?? this.status,
    products: products ?? this.products,
    query: query ?? this.query,
    page: page ?? this.page,
    hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    message: message ?? this.message,
    isOffline: isOffline ?? this.isOffline,
    isSyncing: isSyncing ?? this.isSyncing,
  );
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final ProductResponseModel data;
  const ProductLoaded(this.data);
}

final class ProductFailure extends ProductState {
  const ProductFailure(String message)
    : super(status: ProductStatus.failure, message: message);
}
