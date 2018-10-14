
import 'package:flutter/material.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _NewPageState();
  }

}

class _NewPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: [ new Text("新增"),],
      ),
    );

  }
}