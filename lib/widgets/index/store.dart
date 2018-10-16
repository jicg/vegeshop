import 'package:flutter/material.dart';
import 'package:vegeshop/model/good.dart';
import 'package:vegeshop/widgets/comm//uicomm.dart';

class StorePage extends StatefulWidget {
  final bool readOnly;

  StorePage({this.readOnly: false});

  @override
  State<StatefulWidget> createState() {
    return new StorePageState();
  }
}

class StorePageState extends State<StorePage> {
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

    return new Scaffold(
        appBar:
            new AppBar(automaticallyImplyLeading: true, title: new Text("当前")),
        body: loading ? UIComm.loading : grid2,
        floatingActionButton: widget.readOnly
            ? null
            : new FloatingActionButton(
//            child: new Icon(Icons.save),
                child: new Text(editable ? "完成" : "修改"),
                onPressed: () {
                  setState(() {
                    editable = !editable;
                    _goodsShow.clear();
                    if (editable) {
                      _goodsShow.addAll(_goods);
                    } else {
                      _goodsShow.addAll(_goodsSelected);
                    }
                  });
                }));
  }

  Widget _buildRow(BuildContext context, int index) {
    if (index >= _goodsShow.length) {
      return null;
    }
    return new GoodCell(
        good: _goodsShow[index],
        onPressed: () {
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

  GoodCell(
      {@required this.good,
      @required this.onPressed,
      this.color,
      this.fontColor});

  @override
  State<StatefulWidget> createState() {
    return new _GoodCellState();
  }
}

class _GoodCellState extends State<GoodCell> {
  _GoodCellState();

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(
      //alignment: AlignmentDirectional.center,
      color: widget.color,
      child: new Text(
        widget.good.name,
        style: new TextStyle(
            fontSize: 24.0,
            color: this.widget.fontColor,
            fontWeight: FontWeight.bold),
      ),
      onPressed: widget.onPressed,
    );
  }
}
