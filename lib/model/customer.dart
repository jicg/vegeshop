import 'package:vegeshop/utils/db.dart';

class Customer {
  int id = -1;
  String name;
  String desc;

  Customer({this.id = -1, this.name, this.desc = ''});

  @override
  String toString() {
    return 'Customer{id: $id, name: $name, desc: $desc}';
  }
}

Future<List<Customer>> getCustomers() async {
  var db = await DBHelper.getDB();
  List<Map> data = await db.rawQuery("select id,name,remark from customer ");
  List<Customer> customs = [];
  for (Map m in data) {
    customs.add(new Customer(name: m["name"], id: m["id"], desc: m["remark"]));
  }
  await db.close();
  return customs;
}

Future<int> saveCustomer(Customer customer) async {
  var db = await DBHelper.getDB();
  int id = await DBHelper.firstIntValue(
      db, "select id from customer where name = ?", [customer.name]);
  if (id != null && id > 0) {
    String sql = "update customer set name=?, remark=? where id = ?";
    await db.transaction((txn) async {
      await txn.rawUpdate(sql, [customer.name, customer.desc, customer.id]);
    });
  } else {
    String sql = "INSERT INTO customer(name,remark) VALUES(?,?)";
    await db.transaction((txn) async {
      id = await txn.rawInsert(sql, [customer.name, customer.desc]);
    });
  }
  await db.close();
  return id == null ? -1 : id;
}

Future<bool> delCustomers(List<Customer> cs) async {
  var flag = false;
  var db = await DBHelper.getDB();
  await db.transaction((txn) async {
    for (int i = 0; i < cs.length; i++) {
      await txn.delete("customer", where: "id = ? ", whereArgs: [cs[i].id]);
    }
  });
  await db.close();
  flag = true;
  return flag;
}
