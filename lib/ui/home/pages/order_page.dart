import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/ui/home/bloc/category/category_bloc.dart';
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
  int? _selectedCategoryId;

  Future<void> _refresh() {
    final bloc = context.read<ProductBloc>();
    bloc.add(ProductSynced());
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
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            buildWhen: (previous, current) =>
                previous.categories != current.categories,
            builder: (context, state) {
              if (state.categories.isEmpty) return const SizedBox.shrink();
              return SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 6.0,
                  ),
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: _selectedCategoryId == null,
                      onSelected: (_) =>
                          setState(() => _selectedCategoryId = null),
                    ),
                    for (final category in state.categories) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(category.name ?? '-'),
                        selected: _selectedCategoryId == category.id,
                        onSelected: (_) =>
                            setState(() => _selectedCategoryId = category.id),
                      ),
                    ],
                  ],
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
                                      .add(ProductSynced()),
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

                final products = _selectedCategoryId == null
                    ? state.products
                    : state.products
                          .where((p) => p.categoryId == _selectedCategoryId)
                          .toList();

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: products.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(
                              height: 300,
                              child: Center(
                                child: Text('Tidak ada tiket di kategori ini'),
                              ),
                            ),
                          ],
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          separatorBuilder: (context, index) =>
                              const SpaceHeight(12.0),
                          itemCount: products.length,
                          itemBuilder: (context, index) =>
                              OrderCard(item: products[index]),
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
