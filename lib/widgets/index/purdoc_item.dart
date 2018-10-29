import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/good.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm//uicomm.dart';
import 'package:vegeshop/widgets/index/purdoc_item_modify.dart';

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
//  List<Good> _goods = [];
//  List<Good> _goodsShow = [];
//  List<Good> _goodsSelected = [];
//  List<PurDocItem> _items = [];
  List<PurDocItem> _itemsShow = [];
  List<PurDocItem> _itemsSelected = [];

//  List<DocCard> _cards = [];
  bool loading = true;
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    final grid2 = new GridView.builder(
        itemCount: _itemsShow == null ? 0 : _itemsShow.length,
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
            title: new Container(
              child:
                  new Text("${widget.customer.name}预购${editable ? '-新增' : ''}"),
            )),
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
                  if (editable && _itemsSelected.length > 0) {
                    this.widget.doc.items.clear();
                    this.widget.doc.items.addAll(_itemsSelected);
                    if (!this
                        .widget
                        .doc
                        .customers
                        .contains(this.widget.customer)) {
                      this.widget.doc.customers.add(this.widget.customer);
                    }
                  }
                  Navigator.pop(context, this.widget.doc);
                }));

    return page;
  }

  Widget _buildRow(BuildContext context, int index) {
    if (index >= _itemsShow.length) {
      return null;
    }
    return new ItemCellWidget(
        item: _itemsShow[index],
        sample: widget.customer.issample,
        onPressed: () {
          if (!editable) {
            return;
          }
          if (_itemsSelected.contains(_itemsShow[index])) {
            setState(() {
              if (!mounted) {
                return;
              }
              _itemsSelected.remove(_itemsShow[index]);
            });
          } else {
            setState(() {
              if (!mounted) {
                return;
              }
              _itemsSelected.add(_itemsShow[index]);
            });
          }
        },
        onCardQtyPressed: () {
          goToChangeQtyPage(index);
        },
        checked: _itemsSelected.contains(
          _itemsShow[index],
        ));
  }

  void goToChangeQtyPage(int index) {
    UIComm.goto<PurDocItem>(
        context,
        new ModifyDocCardPage(
          item: _itemsShow[index],
        )).then((value) {
      UIComm.showInfo(value.toString());
      setState(() {
        if (mounted) {
          _itemsShow[index].unit = value.unit;
          _itemsShow[index].qty = value.qty;
        }
      });
    });
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

  Future<List<PurDocItem>> loadAllCards() async {
    List<PurDocItem> itemsShow = [];
    if (!widget.readOnly) {
      var goods = await getGoods();
      for (Good good in goods) {
        itemsShow.add(new PurDocItem(
            goodId: good.id,
            goodName: good.name,
            customerName: widget.customer.name,
            customerId: widget.customer.id,
            qty: 0.0,
            unit: "斤"));
      }
    }
    return itemsShow;
  }

  Future<List<PurDocItem>> loadItems() async {
    return await getPurDocItemsByDocIDAndCustomer(
        widget.doc.id, widget.customer.id);
  }

  void loadData() {
    Future.wait([
      loadAllCards(),
      loadItems(),
    ]).then((resps) {
      if (mounted) {
        setState(() {
          if (!mounted) {
            return;
          }
          editable = !widget.readOnly;
          loading = false;
          if (editable) {
            _itemsShow.addAll(resps[0]);
            _itemsSelected.addAll(resps[1]);
          } else {
            _itemsShow.addAll(resps[1]);
            _itemsSelected.addAll(resps[1]);
          }
        });
      }
    }).catchError((e) {
      loading = false;
      print("exception:$e");
    });
  }
}

class ItemCellWidget extends StatefulWidget {
  final PurDocItem item;
  final bool sample;

  final VoidCallback onPressed;
  final VoidCallback onCardQtyPressed;

  final bool checked;

  const ItemCellWidget(
      {Key key,
      this.item,
      this.sample,
      this.onPressed,
      this.onCardQtyPressed,
      this.checked})
      : assert(item != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ItemCellWidgetState();
  }
}

class _ItemCellWidgetState extends State<ItemCellWidget> {
  _ItemCellWidgetState();

  @override
  Widget build(BuildContext context) {
    final sw = this.widget.sample
        ? new Text(
            widget.item.goodName,
            style: new TextStyle(
                fontSize: 24.0,
                color: widget.checked ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold),
          )
        : new Container(
            padding: EdgeInsets.all(0.0),
            child: new Center(
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Expanded(
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        new Text(
                          widget.item.goodName,
                          style: new TextStyle(
                              fontSize: 24.0,
                              color:
                                  widget.checked ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        new Container(
                          padding: EdgeInsets.all(10.0),
                          child: widget.checked
                              ? new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Text(
                                      "${widget.item.qty} ${widget.item.unit}",
                                      style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : null,
                        )
                      ])),
                  widget.checked
                      ? new InkWell(
                          onTap: () {
                            widget.onCardQtyPressed();
                          },
                          child: new Container(
                            color: Colors.red,
                            padding: EdgeInsets.all(8.0),
                            child: new Center(
                              child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    new Text("编辑")
                                  ]),
                            ),
                          ))
                      : new Container(),
                ],
              ),
            ),
          );

    return new FlatButton(
      padding: EdgeInsets.all(0.0),
      color: widget.checked ? Colors.blue : Colors.white,
      child: sw,
      //alignment: AlignmentDirectional.center,
      onPressed: widget.onPressed,
    );
  }
}
