import 'dart:async';
import 'dart:io';

import 'package:ecommerce/network/model/productListResponse.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final tableName = 'product';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await createDatabase();

    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ecommerce.db");

    var database = await openDatabase(path, version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $tableName ("
        "id INTEGER, "
        "slug TEXT, "
        "title TEXT, "
        "description TEXT, "
        "price INTEGER, "
        "featured_image TEXT, "
        "status TEXT, "
        "quantity INTEGER DEFAULT 0"
        ")");
  }

  addProduct(Product product) async {
    final db = await database;
    final res = await db.insert(tableName, product.toJson());
    return res;
  }

  deleteProduct(Product product) async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $tableName WHERE id = ?', [product.id]);
    return res;
  }

  updateProductQuantity(Product product, int curQnt) async {
    final db = await database;
    int count =
        await db.rawUpdate('UPDATE $tableName SET quantity = ? WHERE id = ?', [curQnt, product.id]);
    return count;
  }

  Future<List<Product>> getAllProduct() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM $tableName");

    List<Product> list = res.isNotEmpty ? res.map((c) => Product.fromJson(c)).toList() : [];

    return list;
  }

  Future<int> geProduct(id) async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery("SELECT COUNT(*) FROM $tableName WHERE id=$id"));
    return count;
  }
}
