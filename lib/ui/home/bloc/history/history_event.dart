part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent {}

final class HistoryFetched extends HistoryEvent {}