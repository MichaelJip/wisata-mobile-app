import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';
import 'package:wisata_app/ui/home/dialogs/add_ticket_dialog.dart';
import 'package:wisata_app/ui/widgets/ticket_card.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  Future<void> _refresh() async {
    final bloc = context.read<ProductBloc>();
    final done = bloc.stream.firstWhere((element) => !element.isSyncing);
    bloc.add(ProductSynced());
    await done;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Tiket'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTicketDialog(),
              );
            },
            icon: Assets.icons.plus.svg(),
          ),
          const SpaceWidth(8.0),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listenWhen: (previous, current) =>
            current.status == ProductStatus.failure && current.message != null,
        listener: (context, state) => AppToast.error(context, state.message!),
        builder: (context, state) {
          if (state.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: state.products.length,
              separatorBuilder: (context, index) => const SpaceHeight(12.0),
              itemBuilder: (context, index) =>
                  TicketCard(item: state.products[index]),
            ),
          );
        },
      ),
    );
  }
}
