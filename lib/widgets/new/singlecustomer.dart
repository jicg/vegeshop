import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';

class SingleCustomerPage extends StatefulWidget {
  final Customer customer;

  const SingleCustomerPage({Key key, this.customer}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new SingleCustomerState();
  }
}

class SingleCustomerState extends State<SingleCustomerPage> {
  TextEditingController _nameController;
  TextEditingController _descController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.customer.id == null || widget.customer.id < 0) {
      widget.customer.id = -1;
    }
    _nameController = new TextEditingController(text: widget.customer.name);
    _descController = new TextEditingController(text: widget.customer.desc);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.customer.id == -1 ? "新增" : "修改"),
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
                      child: new Text("名称"),
                    ),
                    new Expanded(
                        flex: 1,
                        child: new Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(top: 12.0),
                      width: 40.0,
                      child: new Text("描述"),
                    ),
                    new Expanded(
                        flex: 1,
                        child: new Container(
                          child: new TextField(
                            controller: _descController,
                            maxLines: 4,
                            decoration:
                                new InputDecoration(border: InputBorder.none),
                          ),
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
                          widget.customer.id == -1 ? "新增" : "保存",
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
    widget.customer
      ..id = widget.customer.id == -1 ? -1 : widget.customer.id
      ..desc = _descController.value.text
      ..name = _nameController.value.text;

    Navigator.pop(context, widget.customer);
  }
}
