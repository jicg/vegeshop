import 'package:flutter/material.dart';
import 'package:vegeshop/utils/db.dart';

class Good {
  int id = -1;
  String name;
  bool active;

  Good({this.id = -1, @required this.name, this.active = true});

  @override
  String toString() {
    return 'Good{id: $id, name: $name, active: $active}';
  }
}

Future<List<Good>> getGoods() async {
  var db = await DBHelper.getDB();
  List<Map> data =
      await db.rawQuery("select id,name,active from good where active = 0");
  List<Good> goods = [];
  for (Map m in data) {
    goods.add(new Good(
        name: m["name"], id: m["id"], active: m["active"] as int == 0));
  }
//  await db.close();
  return goods;
}

//Future<List<Good>> getGoodsByPage(int page) async {
//  return await DBHelper.getGoods();
//}

Future<int> addGood(Good good) async {
  var db = await DBHelper.getDB();
  int id = await DBHelper.firstIntValue(
      db, "select id from good where id = ?", [good.id]);
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
//  await db.close();
  return id == null ? -1 : id;
}

Future<bool> delGoods(List<Good> goods) async {
  var flag = false;
  var db = await DBHelper.getDB();
  await db.transaction((txn) async {
    for (int i = 0; i < goods.length; i++) {
      await txn.delete("good", where: "id = ? ", whereArgs: [goods[i].id]);
    }
  });
//  await db.close();
  flag = true;
  return flag;
}

Future<List<String>> getUnits() async {
  return ["斤", "个", "包", "贷", "颗"];
}
