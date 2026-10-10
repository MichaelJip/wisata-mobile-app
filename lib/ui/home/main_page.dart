import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/datasources/auth_local_datasource.dart';
import 'package:wisata_app/ui/auth/login_page.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';
import 'package:wisata_app/ui/home/pages/order_page.dart';
import 'package:wisata_app/ui/widgets/nav_item.dart';

class MainPage extends StatefulWidget {
  const new({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const OrderPage(),
    const Text('Ticket'),
    const Text('History'),
    Center(
      child: Button.filled(onPressed: _logout, label: "Logout"),
    ),
    // const TicketPage(),
    // const HistoryPage(),
    // const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await AuthLocalDatasource().removeAuthData();
    if (!mounted) return;
    context.pushAndRemoveUntil(const LoginPage(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (prev, curr) =>
          prev.isSyncing &&
          !curr.isSyncing &&
          !curr.isOffline &&
          curr.status == ProductStatus.success,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil diperbarui otomatis')),
        );
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 30.0,
              blurStyle: BlurStyle.outer,
              spreadRadius: 0,
              color: AppColors.black.withValues(alpha: 8 / 100),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              iconPath: Assets.icons.nav.home.path,
              label: 'Home',
              isActive: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            NavItem(
              iconPath: Assets.icons.nav.ticket.path,
              label: 'Ticket',
              isActive: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            const SpaceWidth(10.0),
            NavItem(
              iconPath: Assets.icons.nav.history.path,
              label: 'History',
              isActive: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            NavItem(
              iconPath: Assets.icons.nav.setting.path,
              label: 'Setting',
              isActive: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        // onTap: () => context.push(const QrScannerPage()),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
          child: Assets.icons.nav.scan.svg(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
