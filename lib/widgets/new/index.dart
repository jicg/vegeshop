import 'package:flutter/material.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _NewPageState();
  }
}

class _NewPageState extends State<StatefulWidget> {
  List<CardBean> _datas = [
    new CardBean(
        name: "商品资料",
        icon: new Icon(Icons.account_balance, size: 14.0, color: Colors.white),
        callback: () {}),
    new CardBean(
        name: "商品资料",
        icon: new Icon(Icons.account_balance, size: 14.0, color: Colors.white),
        callback: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(
            "基础资料",
          ),
        ),
        body: new ListView(
          children: <Widget>[
            new VgCard(
                title: new Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.keyboard_arrow_right),
                      new Text(
                        "基础建档",
                        style: new TextStyle(fontSize: 18.0),
                      )
                    ],
                  ),
                ),
                itemCount: _datas.length,
                rowCount: 2,
                itemBuilder: _buildItem),
          ],
        ));
  }

  Widget _buildItem(BuildContext context, int index) {
    return new FlatButton(
      onPressed: _datas[index].callback,
      child: new Container(
          child: new Row(
        children: <Widget>[
          new Container(
              child: new CircleAvatar(
            radius: 10.0,
            child: _datas[index].icon,
            backgroundColor: new Color(0xFF63616D),
          )),
          new Container(
            margin: EdgeInsets.only(left: 4.0),
            child: new Text(_datas[index].name,
                style: new TextStyle(color: Colors.black, fontSize: 14.0)),
          )
        ],
      )),
    );
  }
}

class VgCard extends StatelessWidget {
  Widget title;
  int itemCount;
  int rowCount;

  IndexedWidgetBuilder itemBuilder;

  VgCard({this.title, this.rowCount = 2, this.itemCount = 0, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    final List<Widget> ws = [];
    if (title != null) {
      ws.add(new Container(
        alignment: Alignment.centerLeft,
        child: title,
      ));
      ws.add(new Divider(
        height: 0.0,
      ));
    }
    List<Widget> bodyws = [];
    var i = 0;
    for (; i < this.itemCount; i++) {
      var tw = new Expanded(child: itemBuilder(context, i));
      var index = i + 1;
      if (tw != null) {
        bodyws.add(tw);
        final Widget hdivider = new Container(
          height: 48.0,
          width: 1.0,
          decoration: new BoxDecoration(
              border: new BorderDirectional(
                  start: new BorderSide(color: Colors.black12, width: 1.0))),
        );
        bodyws.add(hdivider);
      }
      if (index % this.rowCount == 0 && bodyws.length > 0) {
        bodyws.removeLast();
        ws.add(new Row(children: bodyws));
        ws.add(new Divider(
          height: 0.0,
        ));
        bodyws = [];
      }
    }
    if ((i + 1) % this.itemCount != 0) {
      ws.add(new Row(children: bodyws));
      bodyws = null;
    } else {
      ws.removeLast();
    }

    return new Card(
        margin: EdgeInsets.all(5.0),
        child: new Column(
          children: ws,
        ));
  }
}

class CardBean {
  String name;
  Icon icon;
  VoidCallback callback;

  CardBean({this.name, this.icon, this.callback});
}
