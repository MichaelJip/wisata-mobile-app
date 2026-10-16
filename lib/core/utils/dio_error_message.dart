import 'package:dio/dio.dart';

String dioErrorMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map) {
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      return errors.values
          .expand((v) => v is List ? v : [v])
          .map((v) => v.toString())
          .join('\n');
    }
    if (data['message'] != null) return data['message'].toString();
  }
  return e.message ?? 'Something went wrong';
}
