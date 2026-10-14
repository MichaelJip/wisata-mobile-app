import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wisata_app/data/dataoutputs/transaction_print.dart';
import 'package:wisata_app/ui/home/bloc/order/order_bloc.dart';
import 'package:wisata_app/ui/home/main_page.dart';

import '../../../core/core.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrderBloc>().state;
    final order = state.lastOrder;
    if (order == null) return const Scaffold(body: SizedBox());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Payment Receipt',
          style: TextStyle(color: AppColors.white),
        ),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Assets.images.back.image(color: AppColors.white),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: context.deviceHeight / 2,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.0),
              ),
              color: AppColors.primary,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Assets.images.receiptCard.provider(),
                alignment: Alignment.topCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(60.0),
              child: Column(
                children: [
                  const Text(
                    'PAYMENT RECEIPT',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SpaceHeight(16.0),
                  QrImageView(
                    data: 'order-${state.savedOrderId}',
                    version: QrVersions.auto,
                  ),
                  const SpaceHeight(16.0),
                  const Text('Scan this QR code to verify tickets'),
                  const SpaceHeight(20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tagihan'),
                      Text(order.totalPrice.currencyFormatRp),
                    ],
                  ),
                  const SpaceHeight(40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Metode Bayar'), Text(order.paymentMethod)],
                  ),
                  const SpaceHeight(8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Waktu'),
                      Text(
                        DateTime.parse(order.transactionTime).toFormattedDate(),
                      ),
                    ],
                  ),
                  const SpaceHeight(8.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Status'), Text('Lunas')],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(36, 0, 36, 20),
        child: Button.filled(
          onPressed: () async {
            final connected = await PrintBluetoothThermal.connectionStatus;
            if (!connected) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Printer belum terhubung")),
              );
              return;
            }
            final bytes = await TransactionPrint.instance.printQRCode(
              order.id.toString() + order.transactionTime,
            );
            await PrintBluetoothThermal.writeBytes(bytes);
            if (!context.mounted) return;
            context.pushReplacement(const MainPage());
          },
          label: 'Cetak Transaksi',
          borderRadius: 10.0,
        ),
      ),
    );
  }
}
