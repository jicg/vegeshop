import 'package:flutter/material.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HistoryPageState();
  }
}

class HistoryPageState extends State<HistoryPage> {
  bool _loading = true;
  List<HistoryBean> _datas = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await Future.delayed(const Duration(seconds: 1), () => "1");
    setState(() {
      _loading = false;
      _datas.addAll([
        new HistoryBean("one", desc: "dfasdfasd"),
        new HistoryBean("two"),
        new HistoryBean("three"),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loading
        ? UIComm.loading
        : new ListView.builder(
            itemCount: _datas.length * 2,
            itemBuilder: _buildRow,
          );
  }

  Widget _buildRow(BuildContext context, int i) {
    if (i.isOdd) {
      return new Divider();
    }
    final index = i ~/ 2;
    print("$index\n");
    final d = this._datas[index];

    print("$d\n");

    // 如果是建议列表中最后一个单词对
    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      title: new Text(
        d.name == null ? "asdfasfa" : d.name,
        style: new TextStyle(fontSize: 18.0),
      ),
      subtitle: d.desc == null
          ? null
          : new Text(d.desc, style: new TextStyle(fontSize: 14.0)),
      trailing: new Icon(Icons.arrow_right),
      leading: new Icon(Icons.dashboard),
      onTap: () => {},
    );
  }
}

class HistoryBean {
  String name;
  String desc;

  HistoryBean(this.name, {this.desc});

//  @override
//  String toString() {
//    // TODO: implement toString
//    return "name:" + name + ",desc" + desc;
//  }
}
