import 'package:sqflite/sqflite.dart';
import 'package:wisata_app/data/models/order_model.dart';
import 'package:wisata_app/data/models/response/product_response_model.dart';

class ProductLocalDatasource {
  static const _product = 'product';
  static const _orders = 'orders';
  static const _orderItems = 'order_items';
  static const _category = 'category';

  Database? _db;

  Future<Database> get _database async => _db ??= await openDatabase(
    '${await getDatabasesPath()}/wisata.db',
    version: 2,
    onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE $_product (
        id INTEGER PRIMARY KEY,
        productId INTEGER UNIQUE,
        name TEXT NOT NULL,
        description TEXT,
        category_id INTEGER,
        price INTEGER,
        stock INTEGER,
        image TEXT,
        status TEXT,
        criteria TEXT,
        favorite INTEGER
      )
      ''');
      await db.execute('''
      CREATE TABLE $_category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryId INTEGER UNIQUE,
        name TEXT NOT NULL
      )
      ''');
      await _createOrderTables(db);
    },
    // v2: kolom tabel orders disamakan dengan OrderModel.toMapForLocal().
    // Tabel order lama dibuang karena belum ada data yang perlu dipertahankan.
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('DROP TABLE IF EXISTS $_orderItems');
        await db.execute('DROP TABLE IF EXISTS $_orders');
        await _createOrderTables(db);
      }
    },
  );

  Future<void> _createOrderTables(Database db) async {
    await db.execute('''
      CREATE TABLE $_orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        payment_method TEXT,
        nominal_payment INTEGER,
        total_price INTEGER,
        total_item INTEGER,
        cashier_id INTEGER,
        cashier_name TEXT,
        transaction_time TEXT,
        is_sync INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE $_orderItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        product_id INTEGER,
        product_name TEXT,
        quantity INTEGER,
        price INTEGER
      )
    ''');
  }

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

  //insert category
  Future<void> insertAllCategory(List<Category> categories) async {
    final db = await _database;
    final batch = db.batch();
    for (final category in categories) {
      batch.insert(_category, {
        'categoryId': category.id,
        'name': category.name,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
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
