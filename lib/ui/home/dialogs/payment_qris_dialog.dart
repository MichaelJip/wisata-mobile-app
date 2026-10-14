import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:wisata_app/data/models/order_item.dart';
import 'package:wisata_app/data/models/response/qris_response_model.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';
import 'package:wisata_app/ui/home/bloc/order/order_bloc.dart';
import 'package:wisata_app/ui/home/bloc/qris/qris_bloc.dart';

import '../../../core/core.dart';
import '../pages/payment_success_page.dart';

class PaymentQrisDialog extends StatefulWidget {
  final int totalPrice;
  const PaymentQrisDialog({super.key, required this.totalPrice});

  @override
  State<PaymentQrisDialog> createState() => _PaymentQrisDialogState();
}

class _PaymentQrisDialogState extends State<PaymentQrisDialog> {
  String orderId = '';
  int tick = 0;

  @override
  void initState() {
    super.initState();
    orderId = 'order-${DateTime.now().millisecondsSinceEpoch}';
    _generate();
  }

  // URL gambar QR dari actions Midtrans ("generate-qr-code").
  String? _qrImageUrl(QrisResponseModel data) => data.actions
      ?.where((a) => a.name == 'generate-qr-code')
      .firstOrNull
      ?.url;

  void _generate() {
    context.read<QrisBloc>().add(GenerateQris(orderId, widget.totalPrice));
  }

  void _submitOrder() {
    final items = context
        .read<CheckoutBloc>()
        .state
        .items
        .values
        .map((c) => OrderItem(product: c.product, quantity: c.quantity))
        .toList();
    context.read<OrderBloc>().add(
      OrderSubmitted(
        items: items,
        paymentMethod: 'QRIS',
        nominalPayment: widget.totalPrice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<QrisBloc, QrisState>(
          listener: (context, state) {
            if (state is QrisPaid) _submitOrder();
          },
        ),
        BlocListener<OrderBloc, OrderState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == OrderStatus.success) {
              context.read<CheckoutBloc>().add(CheckoutCleared());
              context.pushReplacement(const PaymentSuccessPage());
            } else if (state.status == OrderStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Gagal menyimpan order'),
                ),
              );
            }
          },
        ),
      ],
      child: AlertDialog(
        content: BlocBuilder<QrisBloc, QrisState>(
          builder: (context, state) => switch (state) {
            QrisInitial() || QrisLoading() || QrisPaid() => const SizedBox(
              height: 200.0,
              width: 200.0,
              child: Center(child: CircularProgressIndicator()),
            ),
            QrisGenerated(:final data) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Show this QR code to customer'),
                const SpaceHeight(24.0),
                SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: _qrImageUrl(data) != null
                      ? Image.network(
                          _qrImageUrl(data)!,
                          loadingBuilder: (context, child, progress) =>
                              progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          errorBuilder: (context, error, stack) =>
                              const Center(child: Text('Gagal memuat QR')),
                        )
                      : QrImageView(
                          data: data.qrString ?? '',
                          version: QrVersions.auto,
                          size: 100.0,
                        ),
                ),
                const SpaceHeight(24.0),
                Countdown(
                  key: ValueKey(tick),
                  seconds: 5,
                  build: (context, time) => Text.rich(
                    TextSpan(
                      text: 'Check status in ',
                      children: [
                        TextSpan(
                          text: '${time.toInt()}s.',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onFinished: () {
                    context.read<QrisBloc>().add(CheckQrisStatus(orderId));
                    setState(() => tick++);
                  },
                ),
              ],
            ),
            QrisFailure(:final message) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, textAlign: TextAlign.center),
                const SpaceHeight(16.0),
                Button.filled(
                  label: 'Coba lagi',
                  borderRadius: 10.0,
                  onPressed: _generate,
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}
