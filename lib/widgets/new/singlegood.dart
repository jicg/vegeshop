import 'package:flutter/material.dart';
import 'package:vegeshop/model/good.dart';

class SingleGoodPage extends StatefulWidget {
  final Good good;

  const SingleGoodPage({Key key, this.good}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SingleGoodState();
  }
}

class SingleGoodState extends State<SingleGoodPage> {
  TextEditingController _nameController;

  bool _active;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.good.id == null || widget.good.id < 0) {
      widget.good.id = -1;
    }
    _nameController = new TextEditingController(text: widget.good.name);
    _active = widget.good.active;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.good.id == -1 ? "新增" : "修改"),
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
                      width: 80.0,
                      child: new Text("商品名称"),
                    ),
                    new Expanded(
                        flex: 1,
                        child: new Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: new TextField(
                            autofocus: true,
                            controller: _nameController,
                            decoration:
                                new InputDecoration(border: InputBorder.none),
                          ),
                        )),
                    //new EditableText()
                  ],
                ),
                new Divider(),
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 80.0,
                      child: new Text("是否可用"),
                    ),
                    new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft,
                          child: new Switch(
                              value: _active,
                              onChanged: (val) {
                                setState(() {
                                  _active = val;
                                });
                              }),
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
                          _save(context);
                        },
                        color: Colors.blue,
                        child: new Text(
                          widget.good.id == -1 ? "新增" : "保存",
//                        style:
//                            new TextStyle(color: Colors.white, fontSize: 12.0),
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
    widget.good
      ..id = widget.good.id == -1 ? -1 : widget.good.id
      ..active = _active
      ..name = _nameController.value.text;

    Navigator.pop(context, widget.good);
  }
}
