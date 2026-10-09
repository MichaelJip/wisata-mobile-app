import 'package:flutter/material.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';

import '../../../core/core.dart';

class OrderDetailCard extends StatelessWidget {
  final CartItem cartItem;
  const OrderDetailCard({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final item = cartItem.product;
    final quantity = cartItem.quantity;
    final price = item.price ?? 0;
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.stroke),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name ?? '', style: const TextStyle(fontSize: 15.0)),
          Text(
            item.category?.name ?? '',
            style: const TextStyle(fontSize: 11.0),
          ),
          const SpaceHeight(8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${price.currencyFormatRp} x $quantity',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                (price * quantity).currencyFormatRp,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
