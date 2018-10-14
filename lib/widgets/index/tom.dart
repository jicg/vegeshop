import 'package:flutter/material.dart';

class TomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new TomPageState();
  }
}

class TomPageState extends State<TomPage> {
  List<TomBean> _datas = [
    new TomBean("我的门店"),
    new TomBean("饭店", desc: "我的店铺旁边的饭店"),
  ];

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: 2,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        itemBuilder: _buildRow);
  }

  Widget _buildRow(context, index) {
    TomBean d = _datas[index];
    return new Card(
      child: new ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
//      isThreeLine: true,
        title: new Text(
          d.title,
          style: new TextStyle(fontSize: 18.0),
        ),
        subtitle: d.desc == null
            ? null
            : new Text(d.desc, style: new TextStyle(fontSize: 14.0)),
        trailing: new Icon(Icons.arrow_right),
        leading: new Icon(Icons.dashboard),
        onTap: () => {},
      ),
//      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
////      isThreeLine: true,
//      title: new Text(d.title,style:new TextStyle(fontSize: 18.0),),
//      subtitle: new Text(d.desc, style: new TextStyle(fontSize: 14.0)),
//      onTap: () => {},
    );
  }
}

class TomBean {
  String title;
  String desc;

  TomBean(this.title, {this.desc});
}
