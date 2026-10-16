import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/data/datasources/auth_local_datasource.dart';
import 'package:wisata_app/ui/auth/login_page.dart';
import 'package:wisata_app/ui/home/bloc/category/category_bloc.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';
import 'package:wisata_app/ui/settings/setting_printer_page.dart';
import 'package:wisata_app/ui/widgets/setting_button.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _syncing = false;

  Future<void> _sync() async {
    if (_syncing) return;
    setState(() {
      _syncing = true;
    });

    final categoryBloc = context.read<CategoryBloc>();
    final productBloc = context.read<ProductBloc>();

    final categoryDone = categoryBloc.stream.firstWhere(
      (element) => !element.isSyncing,
    );
    categoryBloc.add(CategorySynced());
    await categoryDone;

    final productDone = productBloc.stream.firstWhere(
      (element) => !element.isSyncing,
    );
    productBloc.add(ProductSynced());
    final result = await productDone;

    if (!mounted) return;
    setState(() {
      _syncing = false;
    });
    if (result.isOffline) {
      AppToast.error(context, 'Gagal sync, mode offline');
    } else {
      AppToast.success(context, 'Sync selesai');
    }
  }

  Future<void> _logout() async {
    await AuthLocalDatasource().removeAuthData();
    if (!mounted) return;
    context.pushAndRemoveUntil(const LoginPage(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setting')),
      body: GridView.count(
        padding: const EdgeInsets.all(24.0),
        crossAxisCount: 2,
        crossAxisSpacing: 15.0,
        mainAxisSpacing: 24.0,
        children: [
          SettingButton(
            iconPath: Assets.icons.settings.printer.path,
            title: 'Printer',
            subtitle: 'kelola printer',
            onPressed: () {
              context.push(const SettingPrinterPage());
            },
          ),
          SettingButton(
            iconPath: Assets.icons.settings.logout.path,
            title: 'Logout',
            subtitle: 'keluar dari aplikasi',
            onPressed: () {
              _logout();
            },
          ),
          SettingButton(
            iconPath: Assets.icons.settings.syncData.path,
            title: 'Sync Data',
            subtitle: 'sinkronasi online',
            onPressed: () {
              _sync();
            },
          ),
          SettingButton(
            iconPath: Assets.icons.settings.syncData.path,
            title: 'Server Key',
            subtitle: 'input server key',
            onPressed: () {
              // showDialog(
              //   context: context,
              //   builder: (context) => const SyncDataDialog(),
              // );
            },
          ),
        ],
      ),
    );
  }
}
