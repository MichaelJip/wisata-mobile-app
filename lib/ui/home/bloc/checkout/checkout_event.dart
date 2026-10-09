part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

class CheckoutItemAdded extends CheckoutEvent {
  final ProductItem product;
  CheckoutItemAdded(this.product);
}

class CheckoutItemRemoved extends CheckoutEvent {
  final ProductItem product;
  CheckoutItemRemoved(this.product);
}

class CheckoutCleared extends CheckoutEvent {}
