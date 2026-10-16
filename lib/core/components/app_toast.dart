import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static void success(BuildContext context, String message) =>
      _show(context, ToastificationType.success, message);

  static void error(BuildContext context, String message) =>
      _show(context, ToastificationType.error, message);

  static void info(BuildContext context, String message) =>
      _show(context, ToastificationType.info, message);

  static void _show(
    BuildContext context,
    ToastificationType type,
    String message,
  ) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(message),
    );
  }
}
