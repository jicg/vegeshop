import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:vegeshop/widgets/index/purdoc_item.dart';
import 'package:vegeshop/widgets/index/purdoc_new.dart';

class PurDocSinglePage extends StatefulWidget {
  final bool readOnly;
  final PurDoc doc;

  const PurDocSinglePage({Key key, this.readOnly, this.doc}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PurDocSinglePageState();
  }
}

class PurDocSinglePageState extends State<PurDocSinglePage> {
  PurDoc _doc;

  @override
  void initState() {
    super.initState();
    _doc = widget.doc;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_doc.name),
        actions: <Widget>[
          new FlatButton(
              onPressed: info,
              child: new Icon(
                Icons.info,
                color: Colors.white,
              ))
        ],
      ),
      body: new PurDocSingleWidget(readOnly: widget.readOnly, doc: _doc),
//      bottomSheet: ,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          UIComm.goto(
              context,
              new PurDocNewPage(
                doc: widget.doc,
              )).then((v) {
            if (v != null) {
              saveDoc(v);
            }
          });
        },
        child: new Icon(Icons.edit),
      ),
    );
  }

  void info() {
    showModalBottomSheet<void>(
        context: context,
        builder: (_) {
          return new BottomSheet(
              onClosing: () => {},
              builder: (context) {
                return new Container(
                  decoration: new BoxDecoration(),
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(10.0),
                        child: new Text(
                          "预购-详情",
                          style: new TextStyle(fontSize: 18.0),
                        ),
                      ),
                      new Divider(
                        color: Colors.black,
                        height: 0.0,
                      ),
                      new Container(
                        padding: EdgeInsets.all(20.0),
                        child: new Column(
                          children: <Widget>[
                            getCol("单号", new Text(_doc.name)),
                            new Divider(),
                            getCol("日期", new Text(_doc.billdate)),
                            new Divider(),
                            getCol(
                                "备注",
                                new Text(_doc.remark.isEmpty
                                    ? "欢迎使用软件"
                                    : _doc.remark)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }

  Widget getCol(String label, Widget value) {
    return new Row(
      children: <Widget>[
        new Container(
          child: new Text(label),
          width: 40.0,
        ),
        Expanded(
          child: value,
        )
      ],
    );
  }

  void saveDoc(PurDoc v) async {
    savePurDoc(v);
    setState(() {
      _doc = v;
    });
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
          UIComm.goto<List<PurDocItem>>(
              context,
              new PurDocItemPage(
                readOnly: widget.readOnly,
                doc: this.widget.doc,
                customer: d,
              )).then((onValue) {
            if (onValue != null && !widget.readOnly) {
              UIComm.showDialogWait(context, title: "保存中。。。");
              saveData(this.widget.doc, d, onValue);
            }
          });
        },
      ),
    );
  }

  Future<void> saveData(PurDoc p, Customer c, List<PurDocItem> items) async {
    try {
      await savePurDocCustomer(p, c);
      await reAddPurDocItems(p, c, items);
    } catch (e) {
      UIComm.showError("保存失败：$e");
    }
    Navigator.pop(context);
    return;
  }

  Future<void> loadData() async {
    List<Customer> datas = await getCustomers();
    setState(() {
      this._datas.clear();
      this._datas.addAll(datas);
    });
  }
}
