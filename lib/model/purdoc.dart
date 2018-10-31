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

Future<int> savePurDoc(PurDoc p) async {
  var db = await DBHelper.getDB();
  int id = await DBHelper.firstIntValue(
      db, "select id from purdoc where id = ?", [p.id]);
  if (id != null && id > 0) {
    String sql =
        "update purdoc set name=?, billdate=? ,remark = ? where id = ?";
    await db.transaction((txn) async {
      await txn.rawUpdate(sql, [p.name, p.billdate, p.remark, p.id]);
    });
  } else {
    String sql = "INSERT INTO purdoc(name,billdate,remark) VALUES(?,?,?)";
    await db.transaction((txn) async {
      id = await txn.rawInsert(sql, [p.name, p.billdate, p.remark]);
    });
  }
//  await db.close();
  return id == null ? -1 : id;
}

Future<bool> savePurDocCustomer(PurDoc p, Customer c) async {
  var flag = false;
  var db = await DBHelper.getDB();
  var cnt = await DBHelper.firstIntValue(
      db,
      "select count(1) from purdoccustomer where order_id = ? and customer_id = ?",
      [p.id, c.id]);
  if (cnt > 0) {
    await db.transaction((txn) async {
      await txn.rawUpdate(
          "update purdoccustomer "
          "set customer_name = ?,customer_desc = ? , customer_issample = ? "
          "where order_id = ? and customer_id =? ",
          [
            c.name,
            c.desc,
            c.issample,
            p.id,
            c.id,
          ]);
    });
  } else {
    await db.transaction((txn) async {
      await txn.rawInsert(
          "insert into purdoccustomer (order_id,customer_id,customer_name,customer_desc,customer_issample)"
          "values ( ?,?,?,?,?)",
          [p.id, c.id, c.name, c.desc, c.issample]);
    });
  }
  flag = true;
  return flag;
}

Future<List<Customer>> getPurDocCustomers(PurDoc p) async {
  var db = await DBHelper.getDB();
  var sql =
      "select customer_id,customer_name,customer_desc,customer_issample  "
      "from purdoccustomer c "
      "where order_id = ? "
      "and exists (select 1 from purdocitem m where c.order_id = m.order_id and m.customer_id = c.customer_id)";
  List<Map> datas = await db.rawQuery(sql, [p.id]);
  List<Customer> cs = [];
  for (Map m in datas) {
    cs.add(new Customer(
        id: m["customer_id"],
        name: m["customer_name"],
        desc: m["customer_desc"],
        issample: m["customer_issample"] as int == 1));
  }
  return cs;
}

Future<int> delPurDocCustomer(PurDoc p, Customer c) async {
  var db = await DBHelper.getDB();
  return await db.rawDelete(
      "delete from purdoccustomer where order_id = ? and customer_id = ?",
      [p.id, c.id]);
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
//  await db.close();
  return docs;
}

Future<PurDoc> getLastPurDoc() async {
  var db = await DBHelper.getDB();
  List<Map> datas = await db.rawQuery(
      "select id,name,billdate,remark from purdoc order by id desc limit 1");
  List<PurDoc> docs = [];
  for (Map m in datas) {
    docs.add(new PurDoc(
        id: m["id"],
        name: m["name"],
        billdate: m["billdate"],
        remark: m["remark"]));
  }
  return docs.length == 0 ? null : docs[0];
}

Future<List<PurDocItem>> getPurDocItemsByDocIDAndCustomer(
    int docid, int cid) async {
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
  return docs;
}

//查询在明细中不存在的商品
Future<List<PurDocItem>> getPurDocGoodNotInItemsByDocIDAndCustomer(
    PurDoc p, Customer c) async {
  var db = await DBHelper.getDB();
  List<Map> datas = await db.rawQuery(
      "select name,id "
      "from good g "
      "where active = 0 "
      " and not exists (select 1 from  purdocitem p where p.good_id = g.id and p.order_id = ? and p.customer_id = ?) ",
      [p.id, c.id]);
  List<PurDocItem> docs = [];
  for (Map m in datas) {
    docs.add(new PurDocItem(
      id: -1,
      orderid: p.id,
      goodName: m["name"],
      goodId: m["id"],
      customerId: c.id,
      customerName: c.name,
      qty: 0.0,
      unit: "斤",
    ));
  }
  return docs;
}

Future<int> delPurDocItemsByDocIDAndCustomer(int docid, int cid) async {
  if (docid == null || docid < 0) {
    return 0;
  }
  var db = await DBHelper.getDB();
  return await db.rawDelete(
      "delete from purdocitem where order_id = ? and customer_id = ? ",
      [docid, cid]);
}

Future<bool> reAddPurDocItems(
    PurDoc p, Customer c, List<PurDocItem> items) async {
  var flag = false;
  var db = await DBHelper.getDB();
  String sql =
      "INSERT INTO purdocitem(order_id,customer_name,customer_id,good_name,good_id,qty,unit ) "
      "VALUES(?,?,?,?,?,?,?)";
  await db.transaction((txn) async {
    await txn.rawDelete(
        "delete from purdocitem where order_id = ? and customer_id = ? ",
        [p.id, c.id]);
    for (PurDocItem m in items) {
      await txn.rawInsert(sql, [
        p.id,
        m.customerName,
        m.customerId,
        m.goodName,
        m.goodId,
        m.qty,
        m.unit
      ]);
    }
  });
//  await db.close();
  flag = true;
  return flag;
}
