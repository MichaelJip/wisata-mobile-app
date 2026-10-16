import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/data/models/request/create_ticket_request_model.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';
import 'package:wisata_app/ui/home/bloc/product/product_bloc.dart';
import 'package:wisata_app/ui/widgets/category_dropdown.dart';

import '../../../core/core.dart';

class EditTicketDialog extends StatefulWidget {
  final ProductItem item;
  const EditTicketDialog({super.key, required this.item});

  @override
  State<EditTicketDialog> createState() => _EditTicketDialogState();
}

class _EditTicketDialogState extends State<EditTicketDialog> {
  static const _criterias = ['perorangan', 'rombongan'];
  late final _nameController = TextEditingController(text: widget.item.name);
  late final _priceController = TextEditingController(
    text: (widget.item.price ?? 0).currencyFormatRp,
  );
  late final _stockController = TextEditingController(
    text: '${widget.item.stock ?? 0}',
  );
  late int? _categoryId = widget.item.category?.id ?? widget.item.categoryId;
  late String _criteria = widget.item.criteria?.name ?? _criterias.first;

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
      AppToast.error(context, 'Nama dan kategori wajib diisi');
      return;
    }

    context.read<ProductBloc>().add(
      ProductUpdate(
        id: widget.item.id!,
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
              label: 'Stok',
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
              onChanged: (value) => setState(() => _criteria = value!),
            ),
            const SpaceHeight(40.0),
            Row(
              children: [
                Flexible(
                  child: Button.filled(
                    onPressed: () => context.pop(),
                    label: 'Batalkan',
                    fontSize: 14,
                    borderRadius: 8.0,
                    color: AppColors.buttonCancel,
                    textColor: AppColors.grey,
                  ),
                ),
                const SpaceWidth(40.0),
                Flexible(
                  child: Button.filled(
                    onPressed: _save,
                    fontSize: 14,
                    label: 'Simpan',
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
