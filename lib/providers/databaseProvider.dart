import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/menu_item.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database _database;
  static final int version = 13;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    String path = join(await getDatabasesPath(), 'uniDB.db');
    return await openDatabase(path, version: version,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE orders (
              id INTEGER PRIMARY KEY,
              rest_id INTEGER,
              name TEXT,
              descr TEXT,
              price REAL,
              image TEXT,
              rating REAL)''');

      await db.execute('''CREATE TABLE favorites (
              id INTEGER PRIMARY KEY,
              rest_id INTEGER,
              name TEXT,
              descr TEXT,
              price REAL,
              image TEXT,
              rating REAL)''');
    });
  }

  Future<List<MenuItem>> getOrders() async {
    final db = await database;
    List<Map> results =
        await db.query('orders', columns: MenuItem.columns, orderBy: "id ASC");

    List<MenuItem> orders = [];

    results.forEach((result) {
      orders.add(MenuItem.fromMap(result));
    });

    return orders;
  }

  addOrder(MenuItem order) async {
    final db = await database;
    db.insert('orders', order.toMap());

    notifyListeners();
  }

  deleteOrder(int id) async {
    final db = await database;
    db.delete('orders', where: 'id=?', whereArgs: [id]);

    notifyListeners();
  }

  Future<List<MenuItem>> getFavorites() async {
    final db = await database;
    List<Map> results = await db.query('favorites',
        columns: MenuItem.columns, orderBy: "id ASC");

    List<MenuItem> favorites = [];

    results.forEach((result) {
      favorites.add(MenuItem.fromMap(result));
    });

    return favorites;
  }

  addFavorite(MenuItem favorite) async {
    final db = await database;
    //db.insert('favorites', favorite.toMap());
    await db.rawInsert('''
      INSERT INTO favorites (id, rest_id, name, descr, price, image, rating) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''', [
      favorite.id,
      favorite.rest_id,
      favorite.name,
      favorite.descr,
      favorite.price,
      favorite.image,
      favorite.rating
    ]);

    notifyListeners();
  }

  deleteFavorite(int id) async {
    final db = await database;
    db.delete('favorites', where: 'id=?', whereArgs: [id]);

    notifyListeners();
  }
}
