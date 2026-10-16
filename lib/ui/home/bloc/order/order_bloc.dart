import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/core/utils/either.dart';
import 'package:wisata_app/data/datasources/auth_local_datasource.dart';
import 'package:wisata_app/data/datasources/order_remote_datasource.dart';
import 'package:wisata_app/data/datasources/product_local_datasource.dart';
import 'package:wisata_app/data/models/order_item.dart';
import 'package:wisata_app/data/models/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(this._local, this._auth, this._remote) : super(const OrderState()) {
    on<OrderSubmitted>(_onSubmitted, transformer: droppable());
    on<OrderLocalFetched>(_onLocalFetched, transformer: restartable());
    on<OrderSynced>(_onSynced, transformer: droppable());
  }

  final OrderRemoteDatasource _remote;
  final ProductLocalDatasource _local;
  final AuthLocalDatasource _auth;

  Future<void> _onSubmitted(
    OrderSubmitted event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));

    final user = await _auth.getUser();
    final cashierId = user?.id;
    if (cashierId == null) {
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          message: 'Data kasir tidak ditemukan, silakan login ulang',
        ),
      );
      return;
    }

    final totalQuantity = event.items.fold<int>(
      0,
      (sum, i) => sum + i.quantity,
    );
    final totalPrice = event.items.fold<int>(
      0,
      (sum, i) => sum + (i.product.price ?? 0) * i.quantity,
    );

    if (event.nominalPayment < totalPrice) {
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          message: 'Nominal pembayaran kurang dari total tagihan',
        ),
      );
      return;
    }

    final order = OrderModel(
      paymentMethod: event.paymentMethod,
      nominalPayment: event.nominalPayment,
      orders: event.items,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
      cashierId: cashierId,
      cashierName: user?.name ?? '',
      transactionTime: DateTime.now().toIso8601String(),
      isSync: false,
    );

    try {
      final id = await _local.insertOder(order);
      emit(
        state.copyWith(
          status: OrderStatus.success,
          savedOrderId: id,
          orders: await _local.getAllOrder(),
          lastOrder: order,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: '$e'));
    }
  }

  Future<void> _onSynced(OrderSynced event, Emitter<OrderState> emit) async {
    emit(state.copyWith(isSyncing: true, failedSyncCount: 0));

    var failed = 0;
    try {
      final pending = await _local.getUnsyncedOrders();
      for (final order in pending) {
        final result = await _remote.postOrder(order);
        switch (result) {
          case Left():
            failed++;
          case Right():
            await _local.markOrderSynced(order.id!);
        }
      }
      emit(
        state.copyWith(
          isSyncing: false,
          failedSyncCount: failed,
          orders: await _local.getAllOrder(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isSyncing: false, failedSyncCount: failed, message: '$e'),
      );
    }
  }

  Future<void> _onLocalFetched(
    OrderLocalFetched event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      emit(
        state.copyWith(
          status: OrderStatus.success,
          orders: await _local.getAllOrder(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: OrderStatus.failure, message: '$e'));
    }
  }
}
