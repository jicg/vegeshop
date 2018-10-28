import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:vegeshop/widgets/index/purdoc_item.dart';

class PurDocSinglePage extends StatelessWidget {
  final bool readOnly;
  final PurDoc doc;

  const PurDocSinglePage({Key key, this.readOnly, this.doc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: doc.id == -1 ? new Text("新增预购") : new Text(doc.name)),
      body: new PurDocSingleWidget(readOnly: readOnly, doc: doc),
    );
  }
}

class PurDocSingleWidget extends StatefulWidget {
  final bool readOnly;
  final PurDoc doc;

  const PurDocSingleWidget({Key key, this.readOnly, this.doc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PurDocSingleState();
  }
}

class PurDocSingleState extends State<PurDocSingleWidget> {
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
          UIComm.goto<PurDoc>(
              context,
              new PurDocItemPage(
                readOnly: widget.readOnly,
                doc: this.widget.doc,
                customer: d,
              )).then((onValue) {
            UIComm.showInfo(onValue.toString());
            //savePurDoc(onValue);
          });
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
