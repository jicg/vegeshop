class Customer {
  int id;
  String name;
  String desc;

  Customer({this.id = -1, this.name, this.desc = ''});
}

Future<List<Customer>> getCustomers() async {
  print("start \n");
  await new Future.delayed(const Duration(seconds: 1), () => "1");
  print("end \n");
  return [
    new Customer(name: "隔壁饭店", id: 8, desc: "我家附件"),
    new Customer(name: "黄闷鸡", id: 9, desc: "黄闷鸡"),
  ];
//  return await DBHelper.getGoods();
}
