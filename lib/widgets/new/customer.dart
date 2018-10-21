import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
                onPressed: () {},
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
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: '编辑',
          color: Colors.greenAccent,
          icon: Icons.edit,
          onTap: () {
            UIComm.showInfo("编辑 ${c.name}");
          },
        ),
        IconSlideAction(
          caption: '删除',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            UIComm.showInfo("删除 ${c.name}");
          },
        ),
      ],
      child: new ListTile(
        title: new Text("${c.name}"),
        subtitle: new Text("${c.desc}"),
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
}
