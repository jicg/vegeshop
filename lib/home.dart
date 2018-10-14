import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegeshop/utils/db.dart';
import 'package:vegeshop/widgets/buyer/buyer.dart';
import 'package:vegeshop/widgets/index/index.dart';
import 'dart:io';
import 'package:vegeshop/widgets/new/index.dart';

import 'package:simple_permissions/simple_permissions.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curIndex = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    print("initState");

    initPlatformState(
        [Permission.WriteExternalStorage, Permission.RecordAudio]);
  }

  void initPlatformState(List<Permission> ps) async {
    for (Permission p in ps) {
      final res = await SimplePermissions.requestPermission(p);
      if (res != PermissionStatus.authorized) {
        _showDialog();
        break;
      }
    }


    try {
      var db = await DBHelper.getDB();
      var open = db.isOpen;
      print("--------home $open----------\n");
      await db.rawQuery("select 1 from good ");
    } catch (e) {
      print("初始化数据库失败 $e");
    }
  }

  _showDialog() {
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      child: new AlertDialog(
          content: new Text('是否前去设置未开通权限'),
          actions: <Widget>[
            new FlatButton(onPressed: () => exit(0), child: new Text('确定'))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.assignment), title: new Text("预购")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.airplay), title: new Text("结账")),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.add), title: new Text("基础")),
        ],
        currentIndex: _curIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _curIndex = index;
          });
        },
      ),
      body: new IndexedStack(
        children: <Widget>[
          new IndexPage(),
          new BluyerPage(),
          new NewPage(),
        ],
        index: _curIndex,
      ),
    );
  }
}
