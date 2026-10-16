part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class ProductSynced extends ProductEvent {}

class ProductLocalFetched extends ProductEvent {}

class ProductCreate extends ProductEvent {
  ProductCreate({required this.data});

  final CreateTicketRequestModel data;
}

class ProductUpdate extends ProductEvent {
  ProductUpdate({required this.data, required this.id});

  final CreateTicketRequestModel data;
  final int id;
}

class ProductDelete extends ProductEvent {
  ProductDelete({required this.id});
  final int id;
}
