import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:wisata_app/core/core.dart';
import 'package:wisata_app/ui/widgets/menu_printer_content.dart';

import '../widgets/menu_printer_button.dart';

class SettingPrinterPage extends StatefulWidget {
  const SettingPrinterPage({super.key});

  @override
  State<SettingPrinterPage> createState() => _SettingPrinterPageState();
}

class _SettingPrinterPageState extends State<SettingPrinterPage> {
  int selectedIndex = 0;
  String macName = '';
  bool connected = false;
  List<BluetoothInfo> items = [];

  Future<void> getBluetooth() async {
    setState(() => items = []);
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;
    if (!mounted) return;
    setState(() => items = listResult);
  }

  Future<void> connect(String mac) async {
    setState(() => connected = false);
    final bool result = await PrintBluetoothThermal.connect(
      macPrinterAddress: mac,
    );
    if (!mounted) return;
    setState(() => connected = result);
  }

  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    if (!mounted) return;
    setState(() => connected = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Printer'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Container(
            width: context.deviceWidth / 2,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuPrinterButton(
                  label: 'Search',
                  onPressed: () {
                    getBluetooth();
                    selectedIndex = 0;
                    setState(() {});
                  },
                  isActive: selectedIndex == 0,
                ),
                MenuPrinterButton(
                  label: 'Disconnect',
                  onPressed: () {
                    selectedIndex = 1;
                    setState(() {});
                  },
                  isActive: selectedIndex == 1,
                ),
                MenuPrinterButton(
                  label: 'Test',
                  onPressed: () {
                    selectedIndex = 2;
                    setState(() {});
                  },
                  isActive: selectedIndex == 2,
                ),
              ],
            ),
          ),
          const SpaceHeight(34.0),
          _Body(
            macName: macName,
            datas: items,
            clickHandler: (mac) async {
              macName = mac;
              await connect(mac);
            },
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String macName;
  final List<BluetoothInfo> datas;
  final Function(String) clickHandler;

  const _Body({
    required this.macName,
    required this.datas,
    required this.clickHandler,
  });

  @override
  Widget build(BuildContext context) {
    if (datas.isEmpty) {
      return const Text('No data available');
    }
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: datas.length,
        separatorBuilder: (context, index) => const SpaceHeight(16.0),
        itemBuilder: (context, index) => InkWell(
          onTap: () => clickHandler(datas[index].macAdress),
          child: MenuPrinterContent(
            isSelected: macName == datas[index].macAdress,
            data: datas[index],
          ),
        ),
      ),
    );
  }
}
