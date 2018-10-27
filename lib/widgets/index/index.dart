import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vegeshop/widgets/index/purdoc_list.dart';
import 'package:vegeshop/widgets/index/purdoc_last.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new IndexPageState();
  }
}

class IndexPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Column(
        children: [
          AppBar(
            title: new TabBar(
              tabs: [
                new Tab(text: "最近预购"),
                new Tab(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.history,
                      ),
                      new Text(" 预购历史"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Expanded(
            flex: 1,
            child: new TabBarView(children: [new PurDocLastPage(), new PurDocListPage()]),
          ),
        ],
      ),
    );
  }
}
