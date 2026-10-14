import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wisata_app/data/models/response/qris_response_model.dart';
import 'package:wisata_app/data/models/response/qris_status_response_model.dart';

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(utf8.encode('$serverKey:'));
    final authHeader = 'Basic $base64Credentials';

    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode(
    String orderId,
    int grossAmount,
  ) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(
        const String.fromEnvironment('SERVER_KEY'),
      ),
    };
    final body = jsonEncode({
      'payment_type': 'gopay',
      'transaction_details': {'order_id': orderId, 'gross_amount': grossAmount},
    });

    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('MIDTRANS_URL'),
        headers: headers,
      ),
    );

    final response = await dio.post('/v2/charge', data: body);
    debugPrint('QRIS charge [${response.statusCode}]: ${response.data}');

    return QrisResponseModel.fromMap(response.data);
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(String orderId) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(
        const String.fromEnvironment('SERVER_KEY'),
      ),
    };

    final dio = Dio(
      BaseOptions(
        baseUrl: const String.fromEnvironment('MIDTRANS_URL'),
        headers: headers,
      ),
    );

    final response = await dio.get('/v2/$orderId/status');
    debugPrint('QRIS status [${response.statusCode}]: ${response.data}');

    return QrisStatusResponseModel.fromMap(response.data);
  }
}
