import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:vegeshop/widgets/index/store.dart';

class TomReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "sdfasdf",
        ),
        automaticallyImplyLeading: true,
      ),
      body: new TomPage(readOnly: true),
    );
  }
}

class TomPage extends StatefulWidget {
  final bool readOnly;

  TomPage({this.readOnly = false});

  @override
  State<StatefulWidget> createState() {
    return new TomPageState();
  }
}

class TomPageState extends State<TomPage> {
  List<Customer> _datas = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: _datas.length,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        itemBuilder: _buildRow);
  }

  Widget _buildRow(context, index) {
    final Customer d = _datas[index];
    return new Card(
      child: new ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        title: new Text(
          d.name,
          style: new TextStyle(fontSize: 18.0),
        ),
        subtitle: d.desc.isEmpty
            ? null
            : new Text(d.desc, style: new TextStyle(fontSize: 14.0)),
        trailing: new Icon(Icons.arrow_right),
        leading: new Icon(Icons.dashboard),
        onTap: () {
          UIComm.goto(
              context,
              new StorePage(
                readOnly: widget.readOnly,
              ));
        },
      ),
    );
  }

  Future<void> loadData() async {
    List<Customer> datas = await getCustomers();
    setState(() {
      this._datas.clear();
      this._datas.addAll(datas);
    });
  }
}

class TomBean {
  String title;
  String desc;

  TomBean(this.title, {this.desc});
}
