import 'package:flutter/material.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';
import 'package:vegeshop/widgets/index/purdoc_new.dart';
import 'package:vegeshop/widgets/index/purdoc_single.dart';

class PurDocListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PurDocListPageState();
  }
}

class _PurDocListPageState extends State<PurDocListPage> {
  bool _loading = true;
  List<PurDoc> _datas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var value = await getPurDocs();
    if (mounted) {
      setState(() {
        this._datas.addAll(value);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _loading
          ? UIComm.loading
          : new ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              itemCount: _datas.length,
              itemBuilder: _buildRow,
            ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: new FloatingActionButton(
          onPressed: () => addPurDoc(context), child: new Icon(Icons.add)),
    );
  }

  addPurDoc(BuildContext context) {
//    UIComm.goto(
//        context, new PurDocSinglePage(readOnly: false, doc: new PurDoc()));
  UIComm.goto(context, new PurDocNewPage());
  }

  Widget _buildRow(BuildContext context, int index) {
    final d = this._datas[index];
    // 如果是建议列表中最后一个单词对
    return new Card(
      child: new ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          title: new Text(
            d.name.isEmpty ? "" : d.name,
            style: new TextStyle(fontSize: 18.0),
          ),
          subtitle: d.remark.isEmpty
              ? null
              : new Text(d.remark, style: new TextStyle(fontSize: 14.0)),
          trailing: new Icon(Icons.arrow_right),
          leading: new Icon(Icons.dashboard),
          onTap: () {
            UIComm.goto(context, new PurDocSinglePage());
          }),
    );
  }
}
