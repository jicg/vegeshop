import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/good.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm//uicomm.dart';

class PurDocItemPage extends StatefulWidget {
  final bool readOnly;
  final PurDoc doc;
  final Customer customer;

  const PurDocItemPage({Key key, this.readOnly, this.doc, this.customer})
      : assert(doc != null),
        assert(customer != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new PurDocItemPageState();
  }
}

class PurDocItemPageState extends State<PurDocItemPage> {
  List<Good> _goods = [];
  List<Good> _goodsShow = [];
  List<Good> _goodsSelected = [];
  bool loading = true;
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    final grid2 = new GridView.builder(
        itemCount: _goodsShow == null ? 0 : _goodsShow.length,
        padding: const EdgeInsets.all(4.0),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          //主轴间隔
          mainAxisSpacing: 5.0,
          //横轴间隔
          crossAxisSpacing: 5.0,
        ),
        itemBuilder: _buildRow);

    final Widget body = loading ? UIComm.loading : grid2;

    final Widget page = new Scaffold(
        appBar: new AppBar(
            automaticallyImplyLeading: true,
            title:
                new Text("${widget.customer.name}预购 ${editable ? '-新增' : ''}")),
        body: body,
//        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//        floatingActionButton: widget.readOnly
//            ? null
//            : new FloatingActionButton(
////            child: new Icon(Icons.save),
//                child: new Text(editable ? "完成" : "修改"),
//                onPressed: () {
//                  setState(() {
//                    editable = !editable;
//                    _goodsShow.clear();
//                    if (editable) {
//                      _goodsShow.addAll(_goods);
//                    } else {
//                      _goodsShow.addAll(_goodsSelected);
//                    }
//                  });
//                })
        floatingActionButton: widget.readOnly
            ? null
            : new FloatingActionButton(
                child: new Icon(Icons.save),
                onPressed: () {
//                  setState(() {
//                    editable = !editable;
//                    _goodsShow.clear();
//                    if (editable) {
//                      _goodsShow.addAll(_goods);
//                    } else {
//                      _goodsShow.addAll(_goodsSelected);
//                    }
//                  });
                  Navigator.pop(context, this.widget.doc);
                }));

    return page;
  }

  Widget _buildRow(BuildContext context, int index) {
    if (index >= _goodsShow.length) {
      return null;
    }
    return new GoodCell(
        good: _goodsShow[index],
        onPressed: () => () {
              if (!editable) {
                return;
              }
              if (_goodsSelected.contains(_goodsShow[index])) {
                setState(() {
                  _goodsSelected.remove(_goodsShow[index]);
                });
              } else {
                setState(() {
                  _goodsSelected.add(_goodsShow[index]);
                });
              }
            },
        color: _goodsSelected.contains(_goodsShow[index])
            ? Colors.blue
            : Colors.white,
        fontColor: _goodsSelected.contains(_goodsShow[index])
            ? Colors.white
            : Colors.black);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    Future.wait([getGoods()]).then((resps) {
      if (mounted) {
        setState(() {
          loading = false;
          if (resps[0] != null && resps[0].length > 0) {
            _goods = resps[0];
          }
          editable = !this.widget.readOnly;
          if (editable) {
            _goodsShow.addAll(_goods);
          } else {
            _goodsShow.addAll(_goodsSelected);
          }
        });
      }
    }).catchError((e) {
      loading = false;
      print("exception:$e");
    });
  }
}

class GoodCell extends StatefulWidget {
  final Good good;
  final Color color;
  final VoidCallback onPressed;
  final Color fontColor;
  final bool simple;

  const GoodCell(
      {Key key,
      this.good,
      this.color,
      this.onPressed,
      this.fontColor,
      this.simple = false})
      : assert(good != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _GoodCellState();
  }
}

class _GoodCellState extends State<GoodCell> {
  _GoodCellState();

  @override
  Widget build(BuildContext context) {
    final sw = new Text(
      widget.good.name,
      style: new TextStyle(
          fontSize: 24.0,
          color: this.widget.fontColor,
          fontWeight: FontWeight.bold),
    );
    final mw = new Text(
      widget.good.name,
      style: new TextStyle(
          fontSize: 24.0,
          color: this.widget.fontColor,
          fontWeight: FontWeight.bold),
    );

    return new FlatButton(
      //alignment: AlignmentDirectional.center,
      color: widget.color,
      child: this.widget.simple ? sw : mw,
      onPressed: widget.onPressed,
    );
  }
}
