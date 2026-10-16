import 'package:sqflite/sqflite.dart';
import 'package:wisata_app/data/datasources/app_database.dart';
import 'package:wisata_app/data/models/response/category_response_model.dart';

class CategoryLocalDatasource {
  static const _category = 'category';

  Future<void> replaceAll(List<CategoryItem> categories) async {
    final db = await AppDatabase.instance.db;
    await db.transaction((txn) async {
      await txn.delete(_category);
      final batch = txn.batch();
      for (final c in categories) {
        batch.insert(_category, {
          'categoryId': c.id,
          'name': c.name,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<List<CategoryItem>> getCategories() async {
    final db = await AppDatabase.instance.db;
    final rows = await db.query(_category, orderBy: 'name');
    return rows
        .map(
          (r) => CategoryItem(
            id: r['categoryId'] as int,
            name: r['name'] as String,
          ),
        )
        .toList();
  }
}
