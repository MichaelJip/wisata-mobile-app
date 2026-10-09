part of 'checkout_bloc.dart';

class CartItem {
  final ProductItem product;
  final int quantity;
  const CartItem(this.product, this.quantity);
}

@immutable
final class CheckoutState {
  const CheckoutState({this.items = const {}});

  final Map<int, CartItem> items;

  int quantity(int? id) => items[id]?.quantity ?? 0;

  int get totalQuantity => items.values.fold(0, (sum, i) => sum + i.quantity);

  int get totalPrice => items.values.fold(
    0,
    (sum, i) => sum + (i.product.price ?? 0) * i.quantity,
  );
}

final class CheckoutInitial extends CheckoutState {}
