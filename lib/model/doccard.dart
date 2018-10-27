import 'package:vegeshop/model/good.dart';

class DocCard {
  Good good;
  double qty = 0.0;
  String unit;

  DocCard(this.good, {this.qty = 0.0, this.unit = "斤"});
}
