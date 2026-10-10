part of 'order_bloc.dart';

enum OrderStatus { initial, loading, success, failure }

@immutable
final class OrderState {
  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.savedOrderId,
    this.lastOrder,
    this.message,
  });

  final OrderStatus status;
  final List<OrderModel> orders;
  final OrderModel? lastOrder;
  final int? savedOrderId;
  final String? message;

  OrderState copyWith({
    OrderStatus? status,
    List<OrderModel>? orders,
    int? savedOrderId,
    OrderModel? lastOrder,
    String? message,
  }) => OrderState(
    status: status ?? this.status,
    orders: orders ?? this.orders,
    lastOrder: lastOrder ?? this.lastOrder,
    savedOrderId: savedOrderId ?? this.savedOrderId,
    message: message ?? this.message,
  );
}
