import 'package:flutter/material.dart';
import 'package:vegeshop/widgets/index/store.dart';

class TomReadPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "sdfasdf",
        ),
        automaticallyImplyLeading: true,
      ),
      body: new TomPage(readOnly: true),
    );
  }
}

class TomPage extends StatefulWidget {
  final bool readOnly;

  TomPage({this.readOnly = false});

  @override
  State<StatefulWidget> createState() {
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
        itemCount: _datas.length,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        itemBuilder: _buildRow);
  }

  Widget _buildRow(context, index) {
    final TomBean d = _datas[index];
    return new Card(
      child: new ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        title: new Text(
          d.title,
          style: new TextStyle(fontSize: 18.0),
        ),
        subtitle: d.desc == null
            ? null
            : new Text(d.desc, style: new TextStyle(fontSize: 14.0)),
        trailing: new Icon(Icons.arrow_right),
        leading: new Icon(Icons.dashboard),
        onTap: () {
          _goto(d);
        },
      ),
    );
  }

  void _goto(TomBean d) {
    Navigator.of(context).push(new PageRouteBuilder(
        opaque: true,
        pageBuilder: (BuildContext context, _, __) {
          // todo new StorePage(args)
          return new StorePage(readOnly: widget.readOnly); //new StorePage(arg);
        },
        transitionsBuilder: (context, animation, __, child) {
          return new SlideTransition(
            position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(animation),
            child: child,
          );
//        }

//        transitionsBuilder: (
//          BuildContext context,
//          Animation<double> animation,
//          Animation<double> secondaryAnimation,
//          Widget child,
//        ) {
//          return SlideTransition(
//            position: Tween<Offset>(
//              begin: const Offset(0.0, 1.0),
//              end: Offset.zero,
//            ).animate(animation),
//            child: SlideTransition(
//              position: Tween<Offset>(
//                begin: Offset.zero,
//                end: const Offset(0.0, 1.0),
//              ).animate(secondaryAnimation),
//              child: child,
//            ),
//          );
        }));
  }
}

class TomBean {
  String title;
  String desc;

  TomBean(this.title, {this.desc});
}
