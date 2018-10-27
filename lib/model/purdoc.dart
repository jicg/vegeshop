import 'package:vegeshop/utils/db.dart';

class PurDoc {
  int id = -1;
  String name;

  String billdate;

  String remark;

  PurDoc({this.id = -1, this.name, this.billdate, this.remark});
}

class PurDocItem {
  int id = -1;
  String goodName;
  int goodId;

  String billdate;

  String customerName;
  int customerId;

  double qty;

  String remark;

  int orderid;

  PurDocItem(
      {this.id,
      this.orderid,
      this.customerName,
      this.goodName,
      this.billdate,
      this.remark});
}

Future<List<PurDoc>> getPurDocs() async {
  var db = await DBHelper.getDB();
  List<Map> datas = await db
      .rawQuery("select id,name,billdate,remark from purdoc order by id desc");

  List<PurDoc> docs = [];
  for (Map m in datas) {
    docs.add(new PurDoc(
        id: m["id"],
        name: m["name"],
        billdate: m["billdate"],
        remark: m["remark"]));
  }
  await db.close();
  return docs;
}
