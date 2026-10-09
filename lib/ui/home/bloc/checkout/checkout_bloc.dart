import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutState()) {
    on<CheckoutItemAdded>((event, emit) {
      final id = event.product.id;
      if (id == null) return;
      final items = Map<int, CartItem>.from(state.items);
      items[id] = CartItem(event.product, state.quantity(id) + 1);
      emit(CheckoutState(items: items));
    });

    on<CheckoutItemRemoved>((event, emit) {
      final id = event.product.id;
      if (id == null) return;
      final qty = state.quantity(id);
      if (qty == 0) return;
      final items = Map<int, CartItem>.from(state.items);
      if (qty == 1) {
        items.remove(id);
      } else {
        items[id] = CartItem(event.product, qty - 1);
      }
      emit(CheckoutState(items: items));
    });

    on<CheckoutCleared>((event, emit) => emit(const CheckoutState()));
  }
}
