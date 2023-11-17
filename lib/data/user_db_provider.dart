import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserDbProvider{

  static const tableName = 'user_table';
  static const dbName = 'market.db';
  static const userSql = 'CREATE TABLE $tableName (userId INTEGER PRIMARY KEY, userName TEXT, email TEXT, password TEXT, logged_in INTEGER)';
  static Database? db;


  static Future<Database> getDatabase() async {
    final path = join(await getDatabasesPath(), dbName);
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(userSql);
      },
      version: 1,
    );
  }

  Future insert(User user, String password) async {
    db = await getDatabase();
    db!.rawInsert('INSERT INTO $tableName VALUES(${user.displayName}, ${user.email}, $password)');
  }

}
