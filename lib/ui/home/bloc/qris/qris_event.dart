part of 'qris_bloc.dart';

@immutable
sealed class QrisEvent {}

final class GenerateQris extends QrisEvent {
  final String orderId;
  final int amount;
  GenerateQris(this.orderId, this.amount);
}

final class CheckQrisStatus extends QrisEvent {
  final String orderId;
  CheckQrisStatus(this.orderId);
}
