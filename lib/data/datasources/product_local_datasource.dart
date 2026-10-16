import 'package:sqflite/sqflite.dart';
import 'package:wisata_app/data/datasources/app_database.dart';
import 'package:wisata_app/data/models/order_model.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

class ProductLocalDatasource {
  static const _product = 'product';
  static const _orders = 'orders';
  static const _orderItems = 'order_items';
  static const _category = 'category';

  Future<Database> get _database => AppDatabase.instance.db;

  Future<void> init() async {
    await _database;
  }

  //insert product
  Future<void> insertAllProduct(List<ProductItem> products) async {
    final db = await _database;
    final batch = db.batch();
    for (final product in products) {
      batch.insert(
        _product,
        product.toLocalMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  //remove all product
  Future<void> removeAllProduct() async {
    final db = await _database;
    await db.delete(_product);
  }

  // get product
  Future<List<ProductItem>> getProducts() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*, c.name as category_name
      FROM $_product p
      LEFT JOIN $_category c on p.category_id = c.categoryId
    ''');
    return List.generate(maps.length, (i) {
      final productMap = maps[i];
      final categoryMap = {
        'id': productMap['category_id'],
        'name': productMap['category_name'],
      };
      return ProductItem.fromLocalMap(productMap)
          .copyWith(category: Category.fromMap(categoryMap));
    });
  }

  //save order
  Future<int> insertOder(OrderModel order) async {
    final db = await _database;
    // Transaction: order dan item-nya tersimpan semua atau batal semua.
    return db.transaction((txn) async {
      final id = await txn.insert(_orders, order.toMapForLocal());
      for (final item in order.orders) {
        await txn.insert(_orderItems, item.toMapForLocal(id));
      }
      return id;
    });
  }

  // get all order
  Future<List<OrderModel>> getAllOrder() async {
    final db = await _database;
    final result = await db.query('orders', orderBy: 'id DESC');

    return result.map((e) => OrderModel.fromLocalMap(e)).toList();
  }
}
