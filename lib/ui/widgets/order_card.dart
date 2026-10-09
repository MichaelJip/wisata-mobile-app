import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';

class OrderCard extends StatefulWidget {
  final ProductItem item;
  const OrderCard({super.key, required this.item});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  final quantityNotifier = ValueNotifier(0);

  @override
  void dispose() {
    quantityNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
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
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name ?? '',
                  style: const TextStyle(fontSize: 15.0),
                ),
              ),
              InkWell(
                onTap: () =>
                    context.read<CheckoutBloc>().add(CheckoutItemRemoved(item)),
                child: Assets.icons.reduceQuantity.svg(),
              ),
              BlocSelector<CheckoutBloc, CheckoutState, int>(
                selector: (state) => state.quantity(item.id),
                builder: (context, qty) => Text(
                  '$qty',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () =>
                    context.read<CheckoutBloc>().add(CheckoutItemAdded(item)),
                child: Assets.icons.addQuantity.svg(),
              ),
            ],
          ),
          Text(
            item.criteria?.name ?? '',
            style: const TextStyle(fontSize: 11.0),
          ),
          const SpaceHeight(8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price.currencyFormatRp,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              BlocSelector<CheckoutBloc, CheckoutState, int>(
                selector: (state) => state.quantity(item.id),
                builder: (context, qty) => Text(
                  (price * qty).currencyFormatRp,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // ValueListenableBuilder(
              //   valueListenable: quantityNotifier,
              //   builder: (context, value, _) => Text(
              //     (price * value).currencyFormatRp,
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
