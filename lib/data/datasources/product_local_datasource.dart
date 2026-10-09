import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

class ProductLocalDatasource {
  static const _productKey = 'product';

  Future<void> saveProductData(List<ProductItem> items) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
      _productKey,
      json.encode(items.map((e) => e.toMap()).toList()),
    );
  }

  Future<List<ProductItem>> getProducts() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(_productKey);
    if (data == null) return [];
    return (json.decode(data) as List)
        .map((e) => ProductItem.fromMap(e))
        .toList();
  }
}
