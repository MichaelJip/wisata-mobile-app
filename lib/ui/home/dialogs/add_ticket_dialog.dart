import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/data/models/request/create_ticket_request_model.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';
import 'package:wisata_app/ui/widgets/category_dropdown.dart';

import '../../../core/core.dart';

class AddTicketDialog extends StatefulWidget {
  const AddTicketDialog({super.key});

  @override
  State<AddTicketDialog> createState() => _AddTicketDialogState();
}

class _AddTicketDialogState extends State<AddTicketDialog> {
  static const _criterias = ['perorangan', 'rombongan'];
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  int? _categoryId;
  String _criteria = _criterias.first;

  int _parse(String text) =>
      int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _save() {
    if (_nameController.text.trim().isEmpty || _categoryId == null) {
      AppToast.error(context, "Nama dan kategori wajib diisi");
      return;
    }

    context.read<ProductBloc>().add(
      ProductCreate(
        data: CreateTicketRequestModel(
          name: _nameController.text.trim(),
          price: _parse(_priceController.text),
          stock: _parse(_stockController.text),
          categoryId: _categoryId,
          criteria: _criteria,
        ),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            const SpaceHeight(8.0),
            CustomTextField(controller: _nameController, label: 'Name'),
            const SpaceHeight(8.0),
            CustomTextField(
              controller: _priceController,
              label: 'Harga',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final parsedValue = _parse(value).currencyFormatRp;
                _priceController.value = TextEditingValue(
                  text: parsedValue,
                  selection: TextSelection.collapsed(
                    offset: parsedValue.length,
                  ),
                );
              },
            ),
            const SpaceHeight(8.0),
            CustomTextField(
              controller: _stockController,
              label: 'Stock',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SpaceHeight(8.0),
            CategoryDropdown(
              selectedId: _categoryId,
              onChanged: (value) => setState(() => _categoryId = value?.id),
            ),
            const SpaceHeight(8.0),
            CustomDropdown(
              value: _criteria,
              items: _criterias,
              label: 'Kriteria',
              onChanged: (value) => setState(() {
                _criteria = value!;
              }),
            ),
            const SpaceHeight(40.0),
            Row(
              children: [
                Flexible(
                  child: Button.filled(
                    onPressed: () => context.pop(),
                    label: 'Batalkan',
                    borderRadius: 8.0,
                    fontSize: 14,
                    color: AppColors.buttonCancel,
                    textColor: AppColors.grey,
                  ),
                ),
                const SpaceWidth(40.0),
                Flexible(
                  child: Button.filled(
                    onPressed: _save,
                    label: 'Simpan',
                    fontSize: 14,
                    borderRadius: 8.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
