import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BluyerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new BluyerPageState();
  }
}

class BluyerPageState extends State<BluyerPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
      title: new Text("你好"),
      centerTitle: true,
    ));
  }
}
