import 'package:flutter/material.dart';
import 'package:vegeshop/model/good.dart';
import 'package:vegeshop/widgets/comm/uicomm.dart';

//import 'package:vegeshop/widgets/new/index.dart';
import 'package:vegeshop/widgets/new/singlegood.dart';

class GoodManagerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _GoodManagerState();
  }
}

class _GoodManagerState extends State<GoodManagerPage> {
  int _defalutRowPageCount = 5;

  bool loading = true;

  GoodsDataSource table = GoodsDataSource();

  List<DataColumn> getColumn() {
    return [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('商品名')),
      DataColumn(label: Text('状态')),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    await table.loadData();
    setState(() {
      loading = false;
    });
  }

  void del(BuildContext context) {
    if (table.goodsSel.length == 0) {
      UIComm.showError("请选择要删除的商品！");
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("删除"),
            content: new Text(
              "确定删除？删除后将无法恢复！",
              style: new TextStyle(color: Colors.red),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: new Text("取消"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: new Text("确定"),
              )
            ],
          );
        }).then((value) {
      print(value);
      if (value != null && value) {
        UIComm.showInfo("删除成功！");
      }
    });
  }

  void edit(BuildContext context) {
    if (table.goodsSel.length != 1) {
      UIComm.showError(
          table.goodsSel.length == 0 ? "请选择要修改的商品" : "只能选择一个要修改的商品！");
      return;
    }
//    var nameController = new TextEditingController(text: "fasdfasd");
//    var activeController = new TextEditingController(text: "fasdfasd");
    // nameController.selection(new TextSelection(baseOffset: 0, extentOffset: 4));
    UIComm.goto(context, new SingleGoodPage(table.goodsSel[0])).then((value) {
      if (value != null) {
        table.notifyListeners();
      }
    });
  }

  void add(BuildContext context) {
    UIComm.goto(context, new SingleGoodPage(null)).then((value) {
      if (value != null) {
        table.goods.insert(0, value);
        table.notifyListeners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: new Text("商品管理"),
          actions: [
            new FlatButton(
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  add(context);
                })
          ]),
      body: loading
          ? UIComm.loading
          : new SingleChildScrollView(
              child: new PaginatedDataTable(
                actions: <Widget>[
                  new RaisedButton.icon(
                      label: new Text(
                        "删除",
                        style: new TextStyle(fontSize: 12.0),
                      ),
                      icon: new Icon(
                        Icons.delete,
                        size: 12.0,
                      ),
                      onPressed: () {
                        del(context);
                      }),
                  new RaisedButton.icon(
                      label:
                          new Text("修改", style: new TextStyle(fontSize: 12.0)),
                      icon: new Icon(
                        Icons.edit,
                        size: 12.0,
                      ),
                      onPressed: () {
                        edit(context);
                      })
                ],
                rowsPerPage: _defalutRowPageCount,
                onRowsPerPageChanged: (value) {
                  setState(() {
                    _defalutRowPageCount = value;
                  });
                },
                initialFirstRowIndex: 0,
                availableRowsPerPage: [5],
                onPageChanged: (value) {
                  print('$value');
                },
                onSelectAll: table.selectAll,
                header: Text('商品'),
                columns: getColumn(),
                source: table,
              ),
            ),
    );
  }
}

class GoodsDataSource extends DataTableSource {
  List<Good> goods = [];
  List<Good> goodsSel = [];

  loadData() async {
    goods = await getGoods();
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    // TODO: implement getRow
    var good = goods[index];
    return DataRow.byIndex(
        cells: [
          new DataCell(new Text("${good.id}")),
          new DataCell(
            new Container(
              child: new Text(
                "${good.name}",
              ),
            ),
          ),
          new DataCell(new Chip(
              backgroundColor:
                  good.active ? Colors.lightBlueAccent : Colors.grey,
              label: new Text(
                "${good.active ? '正常' : '作废'}",
                style: new TextStyle(fontSize: 10.0),
              ))),
        ],
        index: index,
        selected: goodsSel.contains(good),
        onSelectChanged: (isSelected) {
          if (isSelected) {
            goodsSel.add(good);
          } else {
            goodsSel.remove(good);
          }
          notifyListeners();
        });
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  } // TODO: implement isRowCountApproximate

  @override
  bool get isRowCountApproximate => false;

  // TODO: implement rowCount
  @override
  int get rowCount => goods.length;

  // TODO: implement selectedRowCount
  @override
  int get selectedRowCount => goodsSel.length;

  void selectAll(bool checked) {
    if (checked) {
      goodsSel.clear();
      goodsSel.addAll(goods);
    } else {
      goodsSel.clear();
    }
    notifyListeners();
  }
}
