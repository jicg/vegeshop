import 'package:flutter/material.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class PurDocNewPage extends StatefulWidget {
  const PurDocNewPage({Key key}) : super(key: key);

  @override
  State createState() {
    return new PurDocNewState();
  }
}

class PurDocNewState extends State<PurDocNewPage> {
  DateTime dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text("新增预购")),
      body: new SingleChildScrollView(
        child: new Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
          ),
          child: new Column(
            children: <Widget>[
              getCol(
                  "日期",
                  new InkWell(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          onConfirm: (date) => setState(() => dateTime = date),
                          currentTime: dateTime,
                          locale: LocaleType.zh);
                    },
                    child: new Row(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: new Text(
                              "${dateTime.year}-${dateTime.month}-${dateTime.day}"),
                        )
                      ],
                    ),
                  )),
              new Divider(),
              getCol(
                  "单号",
                  new TextField(
                    decoration: new InputDecoration(border: InputBorder.none),
                  )),
              new Divider(),
              getCol(
                  "备注",
                  new TextField(
                    decoration: new InputDecoration(border: InputBorder.none),
                  )),
              new Divider(),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    child: new Text("取消"),
                  ),
                  new SizedBox(
                    width: 20.0,
                  ),
                  new RaisedButton(
                    color: Colors.blue,
                    onPressed: () => Navigator.pop(context),
                    child: new Text(
                      "确定",
                      style: new TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
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
}
