part of 'history_bloc.dart';

enum HistoryStatus { initial, loading, success, failure }

@immutable
final class HistoryState {
  const HistoryState({
    this.status = HistoryStatus.initial,
    this.orders = const [],
    this.message,
  });

  final HistoryStatus status;
  final List<OrderModel> orders;
  final String? message;

  HistoryState copyWith({
    HistoryStatus? status,
    List<OrderModel>? orders,
    String? message,
  }) => HistoryState(
    status: status ?? this.status,
    orders: orders ?? this.orders,
    message: message ?? this.message,
  );
}
