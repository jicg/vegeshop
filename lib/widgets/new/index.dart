import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewPageState();
  }
}

class NewPageState extends State<StatefulWidget> {
  final List<_CardBean> _datas = [
    new _CardBean(
        name: "商品资料",
        icon: new Icon(Icons.airport_shuttle, size: 16.0, color: Colors.blue),
        callback: () {}),
    new _CardBean(
        name: "饭店资料",
        icon: new Icon(Icons.account_balance, size: 16.0, color: Colors.blue),
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
          padding: EdgeInsets.symmetric(vertical: 10.0),
          children: <Widget>[
            new _VgCard(
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 5.0),
                title: new Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(
                        Icons.assignment,
                        size: 16.0,
                        color: Colors.blue,
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 3.0),
                        child: new Text(
                          "基础建档",
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: _datas.length,
                rowCount: 2,
                itemBuilder: _buildItem),
            _about(context),
          ],
        ));
  }

  Widget _about(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0, top: 20.0),
      padding: EdgeInsets.only(left: 48.0, right: 48.0, bottom: 20.0),
      color: Colors.white,
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: new Text("赞助作者",
                style: new TextStyle(fontSize: 20.0, letterSpacing: 3.0)),
          ),
          new Divider(
            height: 0.0,
          ),
//          new Container(
//              child: new Image.network(
//                  "https://gitee.com/jicg/easypos/raw/master/snapshot/alipay.png",
//                  fit: BoxFit.fitWidth)),
          new SizedBox(
            height: 240.0,
            width: 240.0,
            child: new Swiper(
              loop: false,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return new Image.network(
                  index.isOdd
                      ? "https://gitee.com/jicg/easypos/raw/master/snapshot/alipay.png"
                      : "https://gitee.com/jicg/easypos/raw/master/snapshot/wpay.png",
                  fit: BoxFit.fitHeight,
                );
              },
              pagination: null,
              control: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return new FlatButton(
      onPressed: _datas[index].callback,
      child: new Container(
          child: new Row(
        children: <Widget>[
          new Container(
            child: _datas[index].icon,
          ),
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

class _VgCard extends StatelessWidget {
  Widget title;
  int itemCount;
  int rowCount;
  Widget hdivider;
  EdgeInsets margin;

  IndexedWidgetBuilder itemBuilder;

  _VgCard(
      {this.title,
      this.rowCount = 2,
      this.hdivider,
      this.itemCount = 0,
      this.margin,
      this.itemBuilder});

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
        if (hdivider != null) {
          bodyws.add(hdivider);
        }
      }
      if (index % this.rowCount == 0 && bodyws.length > 0) {
        if (hdivider != null) {
          bodyws.removeLast();
        }

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
        margin: margin,
        child: new Column(
          children: ws,
        ));
  }
}

class _CardBean {
  String name;
  Widget icon;
  VoidCallback callback;

  _CardBean({this.name, this.icon, this.callback});
}

//
//final Widget hdivider = new Container(
//  height: 48.0,
//  width: 1.0,
//  decoration: new BoxDecoration(
//      border: new BorderDirectional(
//          start: new BorderSide(color: Colors.black12, width: 1.0))),
//);
