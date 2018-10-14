
import 'package:flutter/material.dart';

class NewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new NewPageState();
  }

}

class NewPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new Column(
        children: [ new Text("新增"),],
      ),
    );

  }
}