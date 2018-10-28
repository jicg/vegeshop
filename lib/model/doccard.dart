import 'package:vegeshop/model/good.dart';

class DocCard {
  Good good;
  double qty = 0.0;
  String unit;

  DocCard(this.good, {this.qty = 0.0, this.unit = "斤"});

  @override
  String toString() {
    return 'DocCard{good: $good, qty: $qty, unit: $unit}';
  }


}
