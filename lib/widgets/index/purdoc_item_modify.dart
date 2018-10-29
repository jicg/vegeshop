import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegeshop/model/good.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';

class ModifyDocCardPage extends StatefulWidget {
  final PurDocItem item;

  const ModifyDocCardPage({Key key, this.item})
      : assert(item != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ModifyDocCardState();
  }
}

class ModifyDocCardState extends State<ModifyDocCardPage> {
  TextEditingController _qtycontroller;
  final _focusNode = FocusNode();
  String _unit = "斤";
  bool loading = true;
  List<DropdownMenuItem> _dmeans = [
    new DropdownMenuItem(value: "斤", child: new Text("斤"))
  ];

  @override
  void initState() {
    super.initState();
    this._qtycontroller = new TextEditingController(text: "${widget.item.qty}");
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _qtycontroller.selection = TextSelection(
            baseOffset: 0, extentOffset: _qtycontroller.value.text.length);
      }
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return loading
        ? UIComm.loading
        : new Scaffold(
            appBar: new AppBar(
              title: new Text("${widget.item.goodName}-修改"),
            ),
            body: new SingleChildScrollView(
              child: new Card(
                child: new Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            child: new Text("商品"),
                          ),
                          new Expanded(
                              flex: 1,
                              child: new Container(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: new Text("${widget.item.goodName}"),
                              )),
                          //new EditableText()
                        ],
                      ),
                      new Divider(),
                      new Row(
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            child: new Text("数量"),
                          ),
                          new Expanded(
                              flex: 1,
                              child: new Container(
                                child: new TextField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                                  autofocus: true,
                                  inputFormatters: [new NumericTextFormatter()],
                                  controller: _qtycontroller,
                                  focusNode: _focusNode,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none),
                                ),
                              )),
                          //new EditableText()
                        ],
                      ),
                      new Divider(),
                      new Row(
                        children: <Widget>[
                          new Container(
                            width: 40.0,
                            child: new Text("单位"),
                          ),
                          new Expanded(
                              flex: 1,
                              child: new Container(
                                child: new DropdownButton(
                                    isExpanded: true,
                                    onChanged: (v) {
                                      setState(() {
                                        _unit = v;
                                      });
                                    },
                                    value: _unit,
                                    items: _dmeans),
                              )),
                          //new EditableText()
                        ],
                      ),
                      new Divider(),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.all(10.0),
                            child: new RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: new Text(
                                "取消",
//                        style: new TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.all(10.0),
                            child: new RaisedButton(
                              padding: EdgeInsets.all(10.0),
                              onPressed: () {
                                //todo
//                        Navigator.pop(context);
                                _save(context);
                              },
                              color: Colors.blue,
                              child: new Text(
                                "保存",
                              ),
                            ),
                          ),
                          //new EditableText()
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  void _save(BuildContext context) {
    var qty = double.tryParse(_qtycontroller.value.text);
    if (qty == null) {
      UIComm.showError("非法数量！");
      return;
    }
    PurDocItem docItem = new PurDocItem(qty: qty, unit: _unit);
    Navigator.pop(context, docItem);
  }

  Future<void> loadData() async {
    List<String> us = await getUnits();
    List<DropdownMenuItem> dmeans = [];
    for (int i = 0; i < us.length; i++) {
      dmeans.add(new DropdownMenuItem(value: us[i], child: new Text(us[i])));
    }
    setState(() {
      loading = false;
      _dmeans.clear();
      _dmeans.addAll(dmeans);
    });
  }
}

class NumericTextFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
//    if (newValue.text.length == 0) {
//      return newValue.copyWith(text: '');
//    } else if (newValue.text.compareTo(oldValue.text) != 0) {
//      var doublle = double.tryParse(newValue.text);
//      if (double == null) {
//        return oldValue;
//      }
//      return newValue;
//    } else {
//      return newValue;
//    }
    return newValue;
  }
}
