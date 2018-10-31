import 'package:flutter/material.dart';
import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/model/purdoc.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';

class PurDocLastPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PurDocLastPageState();
  }
}

class PurDocLastPageState extends State<PurDocLastPage> {
  PurDoc _doc;
  List<Customer> _customers = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final Widget w = _doc != null
        ? new Container(
            margin: EdgeInsets.all(6.0),
//        color: Colors.white,
            decoration: new BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                      blurRadius: 20.0,
                      offset: new Offset(1.0, 3.0),
                      spreadRadius: 1.0)
                ],
                borderRadius: new BorderRadius.circular(2.0)),
            child: new DefaultTabController(
                length: _customers.length,
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: new Center(
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Container(
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Icon(Icons.label, size: 18.0),
                                  new SizedBox(
                                    width: 5.0,
                                  ),
                                  new Text(
                                    _doc.billdate,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new SizedBox(
                              width: 8.0,
                            ),
                            new Text(_doc.name,
                                style: new TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.0,
                                )),
                            new SizedBox(
                              width: 2.0,
                            ),
                            new InkWell(
                              child: new Icon(
                                Icons.info,
                                size: 14.0,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                if (_doc.remark.isNotEmpty) {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return new SimpleDialog(
                                          children: <Widget>[
                                            new Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: new Text(_doc.remark),
                                            )
                                          ],
                                        );
                                      });
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
//                    new SizedBox(height:10.0),
                    new Divider(
                      height: 0.0,
                    ),
                    new Expanded(
                      child: new Container(

//                          transform: Matrix4.translationValues(0.0, -5.0, 1.0),
                          decoration: new BoxDecoration(
                            color: Colors.white,
//                            boxShadow: [
//                              new BoxShadow(
//                                  blurRadius: 1.0,
//                                  offset: new Offset(1.0, 1.0),
//                                  spreadRadius: 1.0)
//                            ],
//                              borderRadius: new BorderRadius.circular(2.0)
                          ),
                          child: new Column(
                            children: <Widget>[
                              new TabBar(
                                  isScrollable: true,
                                  labelColor: Colors.black,
                                  tabs: _customers.map((c) {
                                    return new Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: new Text(c.name));
                                  }).toList()),
                              new Container(
                                decoration: new BoxDecoration(
                                  color: Colors.grey,
                                  border: new Border(
                                      bottom: new BorderSide(
                                          color: Colors.black12)),
                                  boxShadow: [
                                    new BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3.0,
                                        offset: new Offset(0.0, 1.0),
                                        spreadRadius: 2.0)
                                  ],
                                ),
                                height: 0.5,
                              ),
                              new Expanded(
                                  child: new Container(
                                margin: EdgeInsets.symmetric(horizontal: 15.0),
                                child: new TabBarView(
                                    children: _customers.map((Customer c) {
                                  return new PurDocItemWidget(
                                      doc: _doc, customer: c);
//                                  return new PurDocItemPage(
//                                      readOnly: true, doc: _doc, customer: c);
                                }).toList()),
                              )),
                            ],
                          )),
                    ),
                  ],
                )))
        : new Container();
    return loading ? UIComm.loading : w;
  }

  Future<void> loadData() async {
    var doc = await getLastPurDoc();
    var customers = await getPurDocCustomers(doc);
    if (mounted) {
      setState(() {
        _doc = doc;
        _customers.addAll(customers);
        loading = false;
      });
    }
  }
}

class PurDocItemWidget extends StatefulWidget {
  final PurDoc doc;
  final Customer customer;

  const PurDocItemWidget({Key key, this.doc, this.customer}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _PurDocItemWidgetState();
  }
}

class _PurDocItemWidgetState extends State<PurDocItemWidget> {
  List<PurDocItem> _items = [];
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return _loading
        ? UIComm.loading
        : new Container(
            child: new ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, index) {
                  return new Divider(
                    height: 0.0,
                  );
                },
                padding: EdgeInsets.all(0.0),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return new ListTile(
                    title: new Container(
                        child: new Row(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: new Text(
                            _items[index].goodName,
                            style: new TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                        new Expanded(child: new SizedBox()),
                        widget.customer.issample
                            ? new SizedBox()
                            : new Text(
                                "${_items[index].qty}  ${_items[index].unit}",
                                style: new TextStyle(fontSize: 24.0),
                              )
                      ],
                    )),
                  );
                }),
          );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    var items = await getPurDocItemsByDocIDAndCustomer(
        widget.doc.id, widget.customer.id);
    if (mounted) {
      setState(() {
        _items.clear();
        _items.addAll(items);
        _loading = false;
      });
    }
  }
}
