import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/doccard.dart';
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
        card: new DocCard(_goodsShow[index]),
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
        onCardQtyPressed: () {
          UIComm.showInfo(_goodsShow[index].toString());
        },
        checked: _goodsSelected.contains(
          _goodsShow[index],
        ));
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
    Future.wait([getGoods(), getUnit()]).then((resps) {
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
  final DocCard card;
  final VoidCallback onPressed;
  final VoidCallback onCardQtyPressed;

  final bool checked;

  const GoodCell(
      {Key key,
      this.good,
      this.card,
      this.checked = false,
      this.onPressed,
      this.onCardQtyPressed})
      : assert(good != null || card != null),
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
    final sw = this.widget.card != null
        ? new Container(
            child: new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    widget.card.good.name,
                    style: new TextStyle(
                        fontSize: 24.0,
                        color: widget.checked ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  widget.checked
                      ? new FlatButton(
                          onPressed: () {
                            widget.onCardQtyPressed();
                          },
                          child: new Container(
                              padding: EdgeInsets.all(10.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text(
                                    "${widget.card.qty} ${widget.card.unit}",
                                    style: new TextStyle(
                                        color: widget.checked
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new Container(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ))
                                ],
                              )),
                        )
                      : new Container(),
                ],
              ),
            ),
          )
        : new Text(
            widget.good.name,
            style: new TextStyle(
                fontSize: 24.0,
                color: widget.checked ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          );

    return new FlatButton(
      color: widget.checked ? Colors.blue : Colors.white,
      child: sw,
      //alignment: AlignmentDirectional.center,
      onPressed: widget.onPressed,
    );
  }
}
