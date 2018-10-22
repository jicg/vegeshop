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
//  print("start \n");
//  await new Future.delayed(const Duration(seconds: 1), () => "1");
//  print("end \n");
//  return [
//    new Good(name: "测试001", id: 8, active: true),
//    new Good(name: "测试002", id: 9, active: true),
//    new Good(name: "测试003", id: 10, active: true),
//    new Good(name: "测试004", id: 11, active: true),
//    new Good(name: "测试005", id: 12, active: true),
//    new Good(name: "测试006", id: 13, active: true),
//    new Good(name: "测试007", id: 14, active: true),
//    new Good(name: "测试008", id: 15, active: true),
//    new Good(name: "测试00asdfasfasdfasdfasdfasfasfsafasfasdfasdf8", id: 16, active: true),
//  ];
  return await DBHelper.getGoods();
}

Future<List<Good>> getGoodsByPage(int page) async {
  return await DBHelper.getGoods();
}

Future<int> addGood(Good good) async {
  return await DBHelper.addGood(good);
}


Future<bool> delGoods(List<Good> goods) async {
  return await DBHelper.delGoods(goods);
}