part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class OrderSubmitted extends OrderEvent {
  OrderSubmitted({
    required this.items,
    required this.paymentMethod,
    required this.nominalPayment,
  });

  final List<OrderItem> items;
  final String paymentMethod;
  final int nominalPayment;
}

final class OrderLocalFetched extends OrderEvent {}
