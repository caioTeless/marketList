import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/configuration.dart';

class ConfigurationDbProvider {
  static const tableName = 'configuration_table';
  static const dbName = 'market.db';
  static const marketSql =
      'CREATE TABLE $tableName (configurationId INTEGER PRIMARY KEY, checkProductsDone INTEGER, checkRememberPassword INTEGER, checkEditRemoveProducts INTEGER, checkRemoveSelectedItems INTEGER)';
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

  Future insert(Configuration list) async {
    db = await getDatabase();
    db!.insert(
      tableName,
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future update(Configuration list) async {
    db = await getDatabase();
    db!.update(
      tableName,
      list.toMap(),
      where: 'configurationId = ?',
      whereArgs: [list.configurationId],
    );
  }

  Future delete(Configuration list) async {
    db = await getDatabase();
    db!.delete(
      tableName,
      where: 'configurationId = ?',
      whereArgs: [list.configurationId],
    );
  }

  Future<List<Configuration>> readAll() async {
    db = await getDatabase();
    final data = await db!.query(tableName);
    return List.generate(
      data.length,
      (index) => Configuration.fromMap(data[index]),
    );
  }

  Future<Configuration> readById(int configurationId) async {
    db = await getDatabase();
    final data = await db!.query(
      tableName,
      where: 'configurationId = ?',
      whereArgs: [configurationId],
    );
    return Configuration.fromMap(data[0]);
  }

}
