import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UIComm {
  static final loading =  new Center(
    child: new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      new Column(children: [
//          new Icon(Icons.airplay),
        SpinKitWave(color: Colors.blue, type: SpinKitWaveType.center),
      ]),
    ]),
  );
}
