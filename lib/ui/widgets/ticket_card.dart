import 'package:flutter/material.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';
import 'package:wisata_app/ui/home/dialogs/delete_ticket_dialog.dart';
import 'package:wisata_app/ui/home/dialogs/edit_ticket_dialog.dart';

import '../../../core/core.dart';

class TicketCard extends StatelessWidget {
  final ProductItem item;
  const TicketCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? '-',
                      style: const TextStyle(fontSize: 15.0),
                    ),
                    Text(
                      item.criteria?.name ?? '-',
                      style: const TextStyle(fontSize: 11.0),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => DeleteTicketDialog(id: item.id!),
                  );
                },
                icon: Assets.icons.delete.svg(),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditTicketDialog(item: item),
                  );
                },
                icon: Assets.icons.edit.svg(),
              ),
            ],
          ),
          const SpaceHeight(8.0),
          Text(
            item.price!.currencyFormatRp,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
