import 'package:flutter/material.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/index/purdoc_single.dart';

class PurDocLastPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PurDocLastPageState();
  }
}

class PurDocLastPageState extends State<PurDocLastPage> {
  PurDoc doc;

  @override
  Widget build(BuildContext context) {
    return new PurDocSingleWidget(
      readOnly: true,
      doc: doc,
    );
  }

  Future<void> loadData() async {}
}
