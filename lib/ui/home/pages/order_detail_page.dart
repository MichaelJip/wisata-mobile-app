import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';
import 'package:wisata_app/ui/widgets/order_detail_card.dart';
import 'package:wisata_app/ui/widgets/payment_method_button.dart';

import '../../../core/core.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutBloc>().state;
    final cartItems = checkout.items.values.toList();
    int paymentButtonIndex = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Assets.images.back.image(),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: cartItems.length,
        separatorBuilder: (context, index) => const SpaceHeight(20.0),
        itemBuilder: (context, index) =>
            OrderDetailCard(cartItem: cartItems[index]),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(
              builder: (context, setState) => Row(
                children: [
                  Expanded(
                    child: PaymentMethodButton(
                      iconPath: Assets.icons.payment.qris.path,
                      label: 'QRIS',
                      isActive: paymentButtonIndex == 0,
                      onPressed: () => setState(() => paymentButtonIndex = 0),
                    ),
                  ),
                  const SpaceWidth(20.0),
                  Expanded(
                    child: PaymentMethodButton(
                      iconPath: Assets.icons.payment.tunai.path,
                      label: 'Tunai',
                      isActive: paymentButtonIndex == 1,
                      onPressed: () => setState(() => paymentButtonIndex = 1),
                    ),
                  ),
                  const SpaceWidth(20.0),
                  Expanded(
                    child: PaymentMethodButton(
                      iconPath: Assets.icons.payment.transfer.path,
                      label: 'Transfer',
                      isActive: paymentButtonIndex == 2,
                      onPressed: () => setState(() => paymentButtonIndex = 2),
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(24.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 30.0,
                    spreadRadius: 0,
                    offset: const Offset(0, -2),
                    color: AppColors.black.withValues(alpha: 8 / 100),
                    blurStyle: BlurStyle.outer,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Order Summary'),
                        Text(
                          checkout.totalPrice.currencyFormatRp,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Button.filled(
                      onPressed: () {
                        if (paymentButtonIndex == 0) {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => const PaymentQrisDialog(),
                          // );
                        } else if (paymentButtonIndex == 1) {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) =>
                          //       const PaymentTunaiDialog(totalPrice: 140000),
                          // );
                        }
                      },
                      label: 'Process',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
