import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/data/datasources/product_local_datasource.dart';
import 'package:wisata_app/data/models/order_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(this._local) : super(const HistoryState()) {
    on<HistoryFetched>(_onFetched, transformer: restartable());
  }

  final ProductLocalDatasource _local;

  Future<void> _onFetched(HistoryFetched e, Emitter<HistoryState> emit) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      final orders = await _local.getAllOrder();
      orders.sort((a, b) => b.transactionTime.compareTo(a.transactionTime));
      emit(state.copyWith(status: HistoryStatus.success, orders: orders));
    } catch (e) {
      emit(state.copyWith(status: HistoryStatus.failure, message: '$e'));
    }
  }
}
