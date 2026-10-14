import 'package:flutter/material.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/ui/settings/setting_printer_page.dart';
import 'package:wisata_app/ui/widgets/setting_button.dart';

class SettingPage extends StatefulWidget {
  const new({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          // SettingButton(
          //   iconPath: Assets.icons.settings.logout.path,
          //   title: 'Logout',
          //   subtitle: 'keluar dari aplikasi',
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) => const LogoutTicketDialog(),
          //     );
          //   },
          // ),
          // SettingButton(
          //   iconPath: Assets.icons.settings.syncData.path,
          //   title: 'Sync Data',
          //   subtitle: 'sinkronasi online',
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) => const SyncDataDialog(),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
