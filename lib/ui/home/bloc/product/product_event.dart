part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductSynced extends ProductEvent {}

class ProductLocalFetched extends ProductEvent {}
