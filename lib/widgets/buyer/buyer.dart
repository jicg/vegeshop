import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BluyerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BluyerPageState();
  }
}

class _BluyerPageState extends State<BluyerPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
      title: new Text("你好"),
      centerTitle: true,
    ));
  }
}
