import 'package:dio/dio.dart';

String dioErrorMessage(DioException e) {
  final data = e.response?.data;
  return data is Map && data['message'] != null
      ? data['message'].toString()
      : e.message ?? 'Something went wrong';
}
