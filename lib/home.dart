import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/utils/db.dart';
//import 'package:vegeshop/widgets/buyer/buyer.dart';
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

    initPlatformState(Platform.isIOS
        ? [Permission.Camera]
        : [Permission.WriteExternalStorage, Permission.RecordAudio]);
  }

  void initPlatformState(List<Permission> ps) async {
    for (Permission p in ps) {
      try {
        if (await SimplePermissions.checkPermission(p)) {
          continue;
        }
        final res = await SimplePermissions.requestPermission(p);
        if (res != PermissionStatus.authorized) {
          _showDialog();
          break;
        }
      } catch (e) {
        print("权限请求异常:$e");
      }
    }

    try {
      await DBHelper.getDB();
      int cnt = await getCustomerTotal();
      if (cnt == 0) {
        saveCustomer(
            new Customer(name: "我的小店", desc: "", issys: true, issample: true));
      }
    } catch (e) {
      print("初始化数据库失败 $e");
    }
  }

  _showDialog() {
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
              content: new Text('是否前去设置未开通权限'),
              actions: <Widget>[
                new FlatButton(onPressed: () => exit(0), child: new Text('确定'))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.assignment), title: new Text("预购")),
//          new BottomNavigationBarItem(
//              icon: new Icon(Icons.airplay), title: new Text("结账")),
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
//          new BluyerPage(),
          new NewPage(),
        ],
        index: _curIndex,
      ),
    );
  }
}
