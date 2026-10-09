import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/ui/home/bloc/checkout/checkout_bloc.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';
import 'package:wisata_app/ui/home/pages/order_detail_page.dart';
import 'package:wisata_app/ui/widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        context.read<ProductBloc>().add(ProductFetched());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() {
    final bloc = context.read<ProductBloc>();
    bloc.add(ProductRefreshed());
    return bloc.stream.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Penjualan Ticket")),
      body: Column(
        children: [
          BlocBuilder<ProductBloc, ProductState>(
            buildWhen: (previous, current) =>
                previous.isOffline != current.isOffline,
            builder: (context, state) {
              if (state.isOffline) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.wifi_off, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Mode offline. Tarik ke bawah untuk mencoba lagi.",
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsetsGeometry.fromLTRB(20, 8, 20, 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) =>
                      context.read<ProductBloc>().add(ProductSearched(value)),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state.status == ProductStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == ProductStatus.failure &&
                    state.products.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(state.message ?? 'Error'),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<ProductBloc>()
                                      .add(ProductRefreshed()),
                                  child: const Text("Coba lagi"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    itemCount:
                        state.products.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return OrderCard(item: state.products[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, cart) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Order Summary'),
                    Text(
                      cart.totalPrice.currencyFormatRp,
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
                  height: 48,
                  width: 120,
                  disabled: cart.items.isEmpty,
                  onPressed: () {
                    context.push(const OrderDetailPage());
                  },
                  label: 'Process',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
