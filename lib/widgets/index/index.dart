import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vegeshop/widgets/index/history.dart';
import 'package:vegeshop/widgets/index/tom.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new IndexPageState();
  }
}

class IndexPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new DefaultTabController(
      length: 2,
      child: new Column(
        children: [
          AppBar(
            title: new TabBar(
              tabs: [
                new Tab(text: "明天"),
                new Tab(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.history,
                      ),
                      new Text(" 历史"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            flex: 1,
            child: new TabBarView(children: [new TomPage(), new HistoryPage()]),
          ),
        ],
      ),
    );
  }
}
