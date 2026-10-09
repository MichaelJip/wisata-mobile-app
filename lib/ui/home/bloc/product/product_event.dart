part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductFetched extends ProductEvent {}

class ProductRefreshed extends ProductEvent{}

class ProductSearched extends ProductEvent {
  final String query;
  ProductSearched(this.query);
}
