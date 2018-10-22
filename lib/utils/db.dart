import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vegeshop/model/good.dart';
//import 'package:permission_handler/permission_handler.dart';

class DBHelper {
  static const String _PATH = "vegeshop";

  static const String _DBNAME = "vegeshop.db";

  static const List<String> sql_createTables = [
    'CREATE TABLE good (id INTEGER PRIMARY KEY,name TEXT,active int default 0);',
    'CREATE TABLE customer (id INTEGER PRIMARY KEY,name TEXT,remark TEXT);',
    'CREATE TABLE doc (id INTEGER PRIMARY KEY, billdate TEXT);',
    'CREATE TABLE docitem (id INTEGER PRIMARY KEY, billdate TEXT,good_id int ,order_id int,active int default 0 );',
  ];

  static Future<Database> _createNewDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    try {
//      documentsDirectory=await getExternalStorageDirectory();
//    }catch(e){
//      documentsDirectory= await getApplicationDocumentsDirectory();
//    };

    String path = join(documentsDirectory.path, _PATH, _DBNAME);
    Database db;
    if (!await new Directory(dirname(path)).exists()) {
      try {
        print("--------create start-------------\n");
        await new Directory(dirname(path)).create(recursive: true);
        db = await openDatabase(path);
        for (int i = 0; i < sql_createTables.length; i++) {
          print(sql_createTables[i]);
          await db.execute(sql_createTables[i]);
        }
        print("--------create end-------------\n");
      } catch (e) {
        print("数据库异常:$e");
        print("--------create fail -------------\n");
      }
    } else {
      print("--------open start-------------\n");
      db = await openDatabase(path);
      print("--------open end-------------\n");
    }
    var open = db.isOpen;
    print("--------db $open-------------\n");
    return db;
  }

  static Future<Database> getDB() async {
    return await _createNewDb();
  }

  static Future<int> firstIntValue(Database db, String sql, List args) async {
    return Sqflite.firstIntValue(await db.rawQuery(sql, args));
  }

  static Future<int> addGood(Good good) async {
    var db = await getDB();
    int id = Sqflite.firstIntValue(
        await db.rawQuery("select id from good where name = '${good.name}'"));
    if (id != null && id > 0) {
      String sql = "update good set name=?, active=? where id = ?";
      await db.transaction((txn) async {
        await txn.rawUpdate(sql, ['${good.name}', '0', '$id']);
      });
    } else {
      String sql = "INSERT INTO good(name,active) VALUES('${good.name}',0)";
      await db.transaction((txn) async {
        id = await txn.rawInsert(sql);
      });
    }
    await db.close();
    return id == null ? -1 : id;
  }

  static Future<List<Good>> getGoods() async {
    var db = await getDB();
//    List<Map> d = await db.rawQuery("SELECT t.* FROM sqlite_master t");
//    print("$d \n");
    List<Map> data =
        await db.rawQuery("select id,name,active from good where active = 0");
    List<Good> goods = [];
    for (Map m in data) {
      goods.add(new Good(
          name: m["name"], id: m["id"], active: m["active"] as int == 0));
    }
    await db.close();
    return goods;
  }

  static Future<bool> delGoods(List<Good> goods) async {
//    List<int> ids = [];
    var flag = false;
    var db = await getDB();
    await db.transaction((txn) async {
      for (int i = 0; i < goods.length; i++) {
        await txn.delete("good", where: "id = ? ", whereArgs: [goods[i].id]);
      }
    });
    await db.close();
    flag = true;
    return flag;
  }
}
