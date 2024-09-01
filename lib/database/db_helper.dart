// ignore_for_file: avoid_print

import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    /*   id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, desc TEXT, createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP   */
    await database.execute("""CREATE TABLE customers(      
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    address TEXT,
    city TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase("sqlite_testing.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<int> createData(
      String? name, String? address, String? city) async {
    final db = await SQLHelper.db();

    final customers = {
      "name": name,
      "address": address,
      "city": city
    }; // data was given here

    final id = await db.insert("customers", customers,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query("customers", orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getSingleData(int id) async {
    final db = await SQLHelper.db();
    return db.query("customers", where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String? name, String? address, String? city) async {
    final db = await SQLHelper.db();
    final customers = {
      "name": name,
      "address": address,
      "city": city,
    };
    final result = await db
        .update("customers", customers, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteData(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("customers", where: "id = ?", whereArgs: [id]);
    } catch (e) {
      print(e);
    }
  }
}
