part of 'qris_bloc.dart';

@immutable
sealed class QrisState {}

final class QrisInitial extends QrisState {}

final class QrisLoading extends QrisState {}

final class QrisGenerated extends QrisState {
  final QrisResponseModel data;
  QrisGenerated(this.data);
}

final class QrisPaid extends QrisState {}

final class QrisFailure extends QrisState {
  final String message;
  QrisFailure(this.message);
}
