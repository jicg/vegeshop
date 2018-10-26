import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:vegeshop/widgets/new/singlecustomer.dart';

class CustomManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CustomManagerState();
  }
}

class CustomManagerState extends State<CustomManagerPage> {
  List<Customer> _customers = [];

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("客户管理"),
          actions: <Widget>[
            new FlatButton(
                onPressed: () {
                  add(context);
                },
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: loading
            ? UIComm.loading
            : new Card(
                color: Colors.white,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _customers.length * 2,
                    itemBuilder: _itemBuilder),
              ));
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (index.isOdd) {
      return new Divider(
        height: 0.0,
      );
    }
    index = index ~/ 2;
    var c = _customers[index];
    return new Slidable(
      secondaryActions: c.issys
          ? []
          : <Widget>[
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  del(context, c);
                  //UIComm.showInfo("删除 ${c.name}");
                },
              ),
            ],
      child: new ListTile(
        title: new Text("${c.name}"),
        subtitle: c.desc.isEmpty ? null : new Text("${c.desc}"),
        onTap: () {
          edit(context, c);
        },
      ),
      delegate: new SlidableScrollDelegate(),
    );
  }

  void loadData() async {
    final cus = await getCustomers();

    _customers.clear();
    _customers.addAll(cus);

    setState(() {
      loading = false;
    });
  }

  void del(BuildContext context, Customer c) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("删除"),
            content: new Text(
              "确定删除？删除后将无法恢复！",
              style: new TextStyle(color: Colors.red),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text("取消"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: new Text("确定"),
              )
            ],
          );
        }).then((value) {
      print(value);
      if (value != null && value) {
//        UIComm.showInfo("删除成功！");
        delsysn(c);
      }
    });
  }

  void delsysn(Customer c) async {
    bool flag = await delCustomers([c]);
    if (flag) {
      UIComm.showInfo("删除成功！");
      setState(() {
        _customers.remove(c);
      });
    }
  }

  void edit(BuildContext context, Customer c) {
    UIComm.goto(context, new SingleCustomerPage(customer: c)).then((value) {
      if (value != null) {
        savesysn(value);
      }
    });
  }

  void add(BuildContext context) {
    UIComm.goto(context, new SingleCustomerPage(customer: new Customer()))
        .then((value) {
      if (value != null) {
        savesysn(value);
      }
    });
  }

  void savesysn(Customer value) async {
    print(value.toString());
    int id = await saveCustomer(value);
    UIComm.showInfo(value.id == -1 ? "新增成功！" : "修改成功！");
    if (value.id == -1) {
      value.id = id;
    }

    setState(() {
      if (!_customers.contains(value)) {
        _customers.add(value);
      }
    });
  }
}
