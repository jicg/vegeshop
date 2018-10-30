import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:permission_handler/permission_handler.dart';

class DBHelper {
  static const int DBVERSION = 3;

  static const String _PATH = "vegeshop2";

  static const String _DBNAME = "vegeshop.db";

  static Database _database;

  static Future<Database> _createNewDb() async {
    if (_database != null && _database.isOpen) {
      return _database;
    }
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    try {
      documentsDirectory = await getExternalStorageDirectory();
    } catch (e) {
      documentsDirectory = await getApplicationDocumentsDirectory();
    }
    String path = join(documentsDirectory.path, _PATH, _DBNAME);
    if (!await new Directory(dirname(path)).exists()) {
      await new Directory(dirname(path)).create(recursive: true);
    }
    _database = await openDatabase(path);
    int version = await _database.getVersion();
    if (version == null) {
      version = 0;
    }
    print("version $version , curversion $DBVERSION");
    if (version != DBVERSION) {
      await _updb(_database, version, DBVERSION);
      await _database.setVersion(DBVERSION);
    }
    return _database;
  }

  static Future<Database> getDB() async {
    return await _createNewDb();
  }

  static Future<Database> closeDB() async {
    return await (await _createNewDb()).close();
  }

  static Future<int> firstIntValue(Database db, String sql, List args) async {
    return Sqflite.firstIntValue(await db.rawQuery(sql, args));
  }

  static _updb(Database db, int before, int after) async {
    for (int i = before + 1; i <= after; i++) {
      try {
        await _upversion(db, i);
      } catch (e) {
        print(e);
      }
    }
  }

  static _upversion(Database db, int version) async {
    switch (version) {
      case 1:
        const List<String> sql_createTables = [
          'CREATE TABLE good (id INTEGER PRIMARY KEY,name TEXT,active int default 0);',
          'CREATE TABLE customer (id INTEGER PRIMARY KEY,name TEXT,remark TEXT,issys int default 0,issample int default 0);',
          'CREATE TABLE purdoc (id INTEGER PRIMARY KEY,name TEXT,remark TEXT, billdate VARCHAR(20));',
          'CREATE TABLE purdocitem (id INTEGER PRIMARY KEY, good_name TEXT,good_id int ,order_id int,qty FLOAT,unit VARCHAR(80));',
          'CREATE TABLE doc (id INTEGER PRIMARY KEY, billdate VARCHAR(20));',
          'CREATE TABLE docitem (id INTEGER PRIMARY KEY, billdate TEXT,good_id int ,order_id int );',
        ];
        for (int i = 0; i < sql_createTables.length; i++) {
          print(sql_createTables[i]);
          await db.execute(sql_createTables[i]);
        }
        break;
      case 2:
        await db.execute("alter table purdoc add column udate datetime;");
        await db.execute("alter table purdoc add column cdate datetime;");
        await db
            .execute("alter table purdocitem add column customer_name text;");
        await db.execute("alter table purdocitem add column customer_id int;");
        await db.execute(
            "CREATE TABLE purdoccustomer (id INTEGER PRIMARY KEY, order_id int,customer_name VARCHAR(200), customer_desc VARCHAR(200),customer_id int);");
        break;
      case 3:
        await db.execute("alter table purdoccustomer add column customer_issample int default 0;");
        break;
    }
  }
}
