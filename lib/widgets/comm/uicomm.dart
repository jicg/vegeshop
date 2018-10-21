import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UIComm {
  static final loading = new Center(
    child: new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      new Column(children: [
//          new Icon(Icons.airplay),
        SpinKitWave(color: Colors.blue, type: SpinKitWaveType.center),
      ]),
    ]),
  );

  static Future<T> goto<T extends Object>(BuildContext context, Widget to) {
    return Navigator.of(context).push(new MaterialPageRoute<T>(
      builder: (BuildContext context) {
        // todo new StorePage(args)
        return to; //new StorePage(arg);
      },
    ));
  }

  static void showError(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        bgcolor: "#fafafa",
        textcolor: "#ff0000");
  }

  static void showInfo(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        bgcolor: "#fafafa",
        textcolor: "#000000");
  }

//
//  static void goto2(BuildContext context,Widget to) {
//    Navigator.of(context).push(
//      new PageRouteBuilder(
//          pageBuilder:(context, _, __) {
//      // todo new StorePage(args)
//      return to; //new StorePage(arg);
//    },));
//  }
//
//
//
//  void _goto(TomBean d) {
//    Navigator.of(context).push(new PageRouteBuilder(
//        opaque: true,
//        pageBuilder: (BuildContext context, _, __) {
//          // todo new StorePage(args)
//          return new StorePage(readOnly: widget.readOnly); //new StorePage(arg);
//        },
//        transitionsBuilder: (context, animation, __, child) {
//          return new SlideTransition(
//            position: new Tween<Offset>(
//                    begin: const Offset(1.0, 0.0), end: Offset.zero)
//                .animate(animation),
//            child: child,
//          );
////        }
//
////        transitionsBuilder: (
////          BuildContext context,
////          Animation<double> animation,
////          Animation<double> secondaryAnimation,
////          Widget child,
////        ) {
////          return SlideTransition(
////            position: Tween<Offset>(
////              begin: const Offset(0.0, 1.0),
////              end: Offset.zero,
////            ).animate(animation),
////            child: SlideTransition(
////              position: Tween<Offset>(
////                begin: Offset.zero,
////                end: const Offset(0.0, 1.0),
////              ).animate(secondaryAnimation),
////              child: child,
////            ),
////          );
//        }));
//  }

}
