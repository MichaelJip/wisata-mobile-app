import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final instance = AppDatabase._();
  static const _product = 'product';
  static const _orders = 'orders';
  static const _orderItems = 'order_items';
  static const _category = 'category';

  Future<Database>? _db;
  Future<Database> get db async => _db ??= _open();

  Future<Database> _open() async => openDatabase(
    '${await getDatabasesPath()}/wisata.db',
    version: 3,
    onCreate: (db, v) async {
      await _createProduct(db);
      await _createCategory(db);
      await _createOrderTables(db);
    },
    onUpgrade: (db, old, v) async {
      if (old < 2) {
        await db.execute('DROP TABLE IF EXISTS order_items');
        await db.execute('DROP TABLE IF EXISTS orders');
        await _createOrderTables(db);
      }
      if (old < 3) await _createCategory(db);
    },
  );

  Future<void> _createProduct(Database db) async {
    await db.execute('''
       CREATE TABLE IF NOT EXISTS $_product (
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
  }

  Future<void> _createCategory(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_category (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryId INTEGER UNIQUE,
        name TEXT NOT NULL
      )
      ''');
  }

  Future<void> _createOrderTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_orders (
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
      CREATE TABLE IF NOT EXISTS $_orderItems (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        product_id INTEGER,
        product_name TEXT,
        quantity INTEGER,
        price INTEGER
      )
    ''');
  }
}
