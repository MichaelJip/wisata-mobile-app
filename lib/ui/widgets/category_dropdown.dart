import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wisata_app/data/models/response/category_response_model.dart';
import 'package:wisata_app/ui/home/bloc/category/category_bloc.dart';

import '../../core/core.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    super.key,
    required this.selectedId,
    required this.onChanged,
  });

  final int? selectedId;
  final ValueChanged<CategoryItem?> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        final selected = state.categories
            .where((c) => c.id == selectedId)
            .firstOrNull;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kategori',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            const SpaceHeight(12.0),
            DropdownSearch<CategoryItem>(
              items: (filter, _) => state.categories
                  .where(
                    (c) => (c.name ?? '').toLowerCase().contains(
                      filter.toLowerCase(),
                    ),
                  )
                  .toList(),
              itemAsString: (c) => c.name ?? '-',
              compareFn: (a, b) => a.id == b.id,
              selectedItem: selected,
              onChanged: onChanged,
              popupProps: const PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(hintText: 'Cari kategori'),
                ),
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: 'Pilih kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
