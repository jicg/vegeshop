import 'package:vegeshop/model/customer.dart';
import 'package:vegeshop/utils/db.dart';

class PurDoc {
  int id = -1;
  String name;
  String billdate;
  String remark;

  List<PurDocItem> items = [];

  List<Customer> customers = [];

  PurDoc({this.id = -1, this.name, this.billdate, this.remark});

  @override
  String toString() {
    return 'PurDoc{id: $id, name: $name, billdate: $billdate, remark: $remark, items: $items, customers: $customers}';
  }
}

class PurDocItem {
  int id = -1;
  int orderid;

  String goodName;
  int goodId;

  String customerName;
  int customerId;

  double qty;
  String unit;

  PurDocItem(
      {this.id = -1,
      this.orderid,
      this.goodName,
      this.goodId,
      this.customerName,
      this.customerId,
      this.qty,
      this.unit});

  @override
  String toString() {
    return 'PurDocItem{id: $id, orderid: $orderid, goodName: $goodName, goodId: $goodId, customerName: $customerName, customerId: $customerId, qty: $qty, unit: $unit}';
  }
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

Future<List<PurDocItem>> getPurDocItemsByDocIDAndCustomer(
    int docid, int cid) async {
  print("$docid  $cid");
  if (docid == null || docid < 0) {
    return [];
  }
  var db = await DBHelper.getDB();
  List<Map> datas = await db.rawQuery(
      "select id,order_id,customer_name,customer_id,good_name,good_id,qty,unit "
      "from purdocitem "
      "where order_id = ? and customer_id = ? ",
      [docid, cid]);
  List<PurDocItem> docs = [];
  for (Map m in datas) {
    docs.add(new PurDocItem(
      id: m["id"],
      orderid: m["order_id"],
      goodName: m["good_name"],
      goodId: m["good_id"],
      customerId: m["customer_id"],
      customerName: m["customer_name"],
      qty: m["qty"],
      unit: m["unit"],
    ));
  }
  await db.close();
  return docs;
}
