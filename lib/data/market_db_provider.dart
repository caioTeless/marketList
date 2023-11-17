import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/market_list.dart';

class MarketDbProvider {
  static const tableName = 'market_table';
  static const dbName = 'market.db';
  static const marketSql =
      'CREATE TABLE $tableName (productId INTEGER PRIMARY KEY, productName TEXT, productAmount INTEGER, cMarked int)';
  static Database? db;

  static Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(marketSql);
      },
      version: 1,
    );
  }

  Future insert(MarketList list) async {
    db = await getDatabase();
    db!.insert(
      tableName,
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future update(MarketList list) async {
    db = await getDatabase();
    db!.update(
      tableName,
      list.toMap(),
      where: 'productId = ?',
      whereArgs: [list.productId],
    );
  }

  Future delete(MarketList list) async {
    db = await getDatabase();
    db!.delete(
      tableName,
      where: 'productId = ?',
      whereArgs: [list.productId],
    );
  }

  Future<List<MarketList>> readAll() async {
    db = await getDatabase();
    final data = await db!.query(tableName);
    return List.generate(
      data.length,
      (index) => MarketList.fromMap(data[index]),
    );
  }

  Future<MarketList> readById(int productId) async {
    db = await getDatabase();
    final data = await db!.query(
      tableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
    return MarketList.fromMap(data[0]);
  }

  Future deleteAll(bool marked) async {
    db = await getDatabase();
    if (!marked) {
      await db!.rawDelete('DELETE FROM $tableName WHERE cMarked = 0');
    } else {
      await db!.rawDelete('DELETE FROM $tableName WHERE cMarked = 1');
    }
  }

  Future setProductMarked(int productId) async {
    db = await getDatabase();
    await db!.rawUpdate(
        'UPDATE $tableName SET cMarked = 1 WHERE productId = $productId');
  }

  Future setAllProductsMarked() async {
    db = await getDatabase();
    await db!.rawUpdate(
        'UPDATE $tableName SET cMarked = 1');
  }
  Future undoAllProductsMarked() async {
    db = await getDatabase();
    await db!.rawUpdate(
        'UPDATE $tableName SET cMarked = 0');
  }

  Future<List<MarketList>> readAllWithoutMarked() async {
    db = await getDatabase();
    final data = await db!.rawQuery(
        'SELECT productId, productName, productAmount, cMarked FROM $tableName WHERE cMarked = 0');
    return List.generate(
      data.length,
      (index) => MarketList.fromMap(data[index]),
    );
  }

  Future<List<MarketList>> readAllMarked() async {
    db = await getDatabase();
    final data = await db!.rawQuery(
        'SELECT productId, productName, productAmount, cMarked FROM $tableName WHERE cMarked = 1');
    return List.generate(
      data.length,
      (index) => MarketList.fromMap(data[index]),
    );
  }
}
