import 'package:flutter_sertifikasi/Model/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static Database? _db;

  static const String DB_Name = 'test1.db';
  static const String Table_User = 'usercash';
  static const int Version = 1;

  static const String C_UserID = 'user_id';
  static const String C_UserName = 'user_name';
  static const String C_Email = 'email';
  static const String C_Password = 'password';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE $Table_User ("
        " $C_UserID TEXT, "
        " $C_UserName TEXT, "
        " $C_Email TEXT,"
        " $C_Password TEXT, "
        " PRIMARY KEY ($C_UserID)"
        ")");
  }

  Future<int?> saveData(UserAuthModel user) async {
    var dbClient = await db;
    var res = await dbClient?.insert(Table_User, user.toMap());
    return res;
  }

  Future<UserAuthModel?> getLoginUser(String username, String password) async {
    var dbClient = await db;
    var res = await dbClient?.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_UserName = '$username' AND "
        "$C_Password = '$password'");

    if (res!.isNotEmpty) {
      return UserAuthModel.fromMap(res.first);
    }

    return null;
  }

  Future<int?> updateUser(UserAuthModel user) async {
    var dbClient = await db;
    var res = await dbClient?.update(Table_User, user.toMap(),
        where: '$C_UserID = ?', whereArgs: [user.user_id]);
    return res;
  }

  Future<int?> deleteUser(String user_id) async {
    var dbClient = await db;
    var res = await dbClient
        ?.delete(Table_User, where: '$C_UserID = ?', whereArgs: [user_id]);
    return res;
  }

  Future<UserAuthModel?> getUser(String userId) async {
    var dbClient = await db;
    var res = await dbClient
        ?.query(Table_User, where: '$C_UserID = ?', whereArgs: [userId]);

    if (res!.isNotEmpty) {
      return UserAuthModel.fromMap(res.first);
    }

    return null;
  }
}
