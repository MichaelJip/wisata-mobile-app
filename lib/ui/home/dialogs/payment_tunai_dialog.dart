import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/data/models/order_item.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';
import 'package:wisata_app/ui/home/bloc/order/order_bloc.dart';
import 'package:wisata_app/ui/home/pages/payment_success_page.dart';

import '../../../core/core.dart';

class PaymentTunaiDialog extends StatefulWidget {
  final int totalPrice;
  const PaymentTunaiDialog({super.key, required this.totalPrice});

  @override
  State<PaymentTunaiDialog> createState() => _PaymentTunaiDialogState();
}

class _PaymentTunaiDialogState extends State<PaymentTunaiDialog> {
  final nominalController = TextEditingController();
  int paidIndex = -1;

  @override
  void initState() {
    nominalController.text = widget.totalPrice.currencyFormatRp;
    super.initState();
  }

  @override
  void dispose() {
    nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == OrderStatus.success) {
          context.read<CheckoutBloc>().add(CheckoutCleared());
          context.pushReplacement(const PaymentSuccessPage());
        } else if (state.status == OrderStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Gagal menyimpan order')),
          );
        }
      },
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SpaceHeight(12.0),
            CustomTextField(
              controller: nominalController,
              label: 'Masukkan Nominal',
            ),
            const SpaceHeight(20.0),
            Row(
              children: [
                Flexible(
                  child: Button.outlined(
                    label: 'Uang Pas',
                    borderRadius: 10.0,
                    fontSize: 12.0,
                    onPressed: () => setState(() {
                      paidIndex = 0;
                      nominalController.text =
                          widget.totalPrice.currencyFormatRp;
                    }),
                    textColor: paidIndex == 0
                        ? AppColors.white
                        : AppColors.grey,
                    color: paidIndex == 0
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                ),
                const SpaceWidth(10.0),
                Flexible(
                  child: Button.outlined(
                    label: 200000.currencyFormatRp,
                    borderRadius: 10.0,
                    fontSize: 12.0,
                    onPressed: () => setState(() {
                      paidIndex = 1;
                      nominalController.text = 200000.currencyFormatRp;
                    }),
                    textColor: paidIndex == 1
                        ? AppColors.white
                        : AppColors.grey,
                    color: paidIndex == 1
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
            const SpaceHeight(20.0),
            Row(
              children: [
                Flexible(
                  child: Button.outlined(
                    label: 150000.currencyFormatRp,
                    borderRadius: 10.0,
                    fontSize: 12.0,
                    onPressed: () => setState(() {
                      paidIndex = 2;
                      nominalController.text = 150000.currencyFormatRp;
                    }),
                    textColor: paidIndex == 2
                        ? AppColors.white
                        : AppColors.grey,
                    color: paidIndex == 2
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                ),
                const SpaceWidth(10.0),
                Flexible(
                  child: Button.outlined(
                    label: 300000.currencyFormatRp,
                    borderRadius: 10.0,
                    fontSize: 12.0,
                    onPressed: () => setState(() {
                      paidIndex = 3;
                      nominalController.text = 300000.currencyFormatRp;
                    }),
                    textColor: paidIndex == 3
                        ? AppColors.white
                        : AppColors.grey,
                    color: paidIndex == 3
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
            const SpaceHeight(24.0),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) => Button.filled(
                disabled:
                    paidIndex == -1 || state.status == OrderStatus.loading,
                onPressed: () {
                  final items = context
                      .read<CheckoutBloc>()
                      .state
                      .items
                      .values
                      .map(
                        (c) =>
                            OrderItem(product: c.product, quantity: c.quantity),
                      )
                      .toList();
                  context.read<OrderBloc>().add(
                    OrderSubmitted(
                      items: items,
                      paymentMethod: 'Tunai',
                      nominalPayment: int.parse(
                        nominalController.text.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        ),
                      ),
                    ),
                  );
                },
                label: 'Bayar',
                fontSize: 16.0,
                borderRadius: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
