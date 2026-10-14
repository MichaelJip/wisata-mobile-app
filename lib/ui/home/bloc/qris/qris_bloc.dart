import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:wisata_app/data/datasources/midtrans_remote_datasource.dart';
import 'package:wisata_app/data/models/response/qris_response_model.dart';

part 'qris_event.dart';
part 'qris_state.dart';

class QrisBloc extends Bloc<QrisEvent, QrisState> {
  QrisBloc(this._datasource) : super(QrisInitial()) {
    on<GenerateQris>(_onGenerate);
    on<CheckQrisStatus>(_onCheckStatus);
  }

  final MidtransRemoteDatasource _datasource;

  Future<void> _onGenerate(GenerateQris event, Emitter<QrisState> emit) async {
    emit(QrisLoading());
    try {
      final result = await _datasource.generateQRCode(
        event.orderId,
        event.amount,
      );
      emit(QrisGenerated(result));
    } on DioException catch (e) {
      emit(QrisFailure(_dioMessage(e)));
    } catch (e) {
      log('Generate QRIS error: $e', name: 'QrisBloc');
      emit(QrisFailure(e.toString()));
    }
  }

  String _dioMessage(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'Tidak ada koneksi internet. QRIS tidak dapat dibuat.';
    }
    final status = e.response?.statusCode;
    final data = e.response?.data;
    log('QRIS API error [$status]: $data', name: 'QrisBloc');
    final message = data is Map ? data['status_message'] : data;
    return 'Gagal [$status]: $message';
  }

  Future<void> _onCheckStatus(
    CheckQrisStatus event,
    Emitter<QrisState> emit,
  ) async {
    try {
      final result = await _datasource.checkPaymentStatus(event.orderId);
      switch (result.transactionStatus) {
        case 'settlement':
        case 'capture':
          emit(QrisPaid());
        case 'expire':
        case 'cancel':
        case 'deny':
          emit(QrisFailure('Pembayaran ${result.transactionStatus}'));
        default:
          break;
      }
    } catch (e) {
      emit(QrisFailure(e.toString()));
    }
  }
}
