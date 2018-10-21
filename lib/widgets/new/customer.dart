import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';

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
      ),
      body: loading
          ? UIComm.loading
          : new Container(
              color: Colors.white,
              child: ListView.builder(
                  itemCount: _customers.length * 2, itemBuilder: _itemBuilder)),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    /////
    if (index.isOdd) {
      return new Divider();
    }
    index = index ~/ 2;
    var c = _customers[index];
    return new FlatButton(
        onPressed: () {},
        child: new ListTile(
          title: new Text("${c.name}"),
          subtitle: new Text("${c.desc}"),
        ));
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
