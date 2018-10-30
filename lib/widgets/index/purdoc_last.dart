import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:vegeshop/widgets/index/purdoc_item.dart';

class PurDocLastPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PurDocLastPageState();
  }
}

class PurDocLastPageState extends State<PurDocLastPage> {
  PurDoc _doc;
  List<Customer> _customers = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Widget w = _doc != null ?new Container(
        color: Colors.white,
        child: new DefaultTabController(
            length: _customers.length,
            child: new Column(
              children: <Widget>[
                new Column(
                  children: [
                    new Container(
                      child: new Column(
                        children: <Widget>[
                          getcol("单号", _doc.name),
                          new Divider(
                            height: 0.0,
                          ),
                          getcol("日期", _doc.billdate),
                          new Divider(
                            height: 0.0,
                          ),
                          getcol("备注", _doc.remark),
                        ],
                      ),
                    ),
                  ],
                ),
                new Divider(),
                new Container(
                  child: new TabBar(
                      labelColor: Colors.black,
                      tabs: _customers.map((c) {
                        return new Container(
                            padding: EdgeInsets.all(10.0),
                            child: new Text(c.name));
                      }).toList()),
                ),
                new Expanded(
                  child: new TabBarView(
                      children: _customers.map((Customer c) {
                    return new PurDocItemPage(
                        readOnly: true, doc: _doc, customer: c);
                  }).toList()),
                ),
              ],
            ))):new Container();
    return loading ? UIComm.loading :  w;
  }

  Widget getcol(String label, String val) {
    return new Row(
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            label,
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        new Expanded(
          child: Text(
            val,
            style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Future<void> loadData() async {
    var doc = await getLastPurDoc();
    var customers = await getPurDocCustomers(doc);
    if (mounted) {
      setState(() {
        _doc = doc;
        _customers.addAll(customers);
        loading = false;
      });
    }
  }
}
