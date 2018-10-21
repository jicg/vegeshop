import 'package:flutter/material.dart';
import 'package:vegeshop/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

//import 'package:splashscreen/splashscreen.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '蔬菜小店',
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
//        const Locale('en', 'US'),
      ],
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
        pageTransitionsTheme: new PageTransitionsTheme(builders: const {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        scaffoldBackgroundColor: new Color(0xFFEBEBEB),
      ),

//    routes: <String, WidgetBuilder>{
//      "/home": (BuildContext context) => new MyHomePage(),
//    },
      home: new MyHomePage(title: '蔬菜小店'),
    );
  }
}
//
//class MyApp extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    _MyAppState createState() => new _MyAppState();
//  }
//  // This widget is the root of your appslication.
//
//}
//
//
//
//class _MyAppState extends State<MyApp> {
//  @override
//  Widget build(BuildContext context) {
//    return new SplashScreen(
//        seconds: 14,
//        navigateAfterSeconds: new MaterialApp(
//          title: '蔬菜小店',
//          theme: new ThemeData(
//            primarySwatch: Colors.blue,
//            scaffoldBackgroundColor: new Color(0xFFEBEBEB),
//          ),
//          home: new MyHomePage(title: '蔬菜小店'),
////      routes: {
////        "/home":new StorePage(),
////      },
//        ),
//        title: new Text('Welcome In SplashScreen',
//          style: new TextStyle(
//              fontWeight: FontWeight.bold,
//              fontSize: 20.0
//          ),),
//        image: new Image.network('https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=d&word=%E6%89%8B%E6%9C%BApng&hs=2&pn=0&spn=0&di=113181673770&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&ie=utf-8&oe=utf-8&cl=2&lm=-1&cs=3276516485%2C1200895328&os=797425845%2C4237368450&simid=0%2C0&adpicid=0&lpn=0&ln=30&fr=ala&fm=&sme=&cg=&bdtype=0&oriquery=%E6%89%8B%E6%9C%BApng&objurl=http%3A%2F%2Fpic.qiantucdn.com%2F58pic%2F26%2F74%2F56%2F97r58PICJXW_1024.png!%2Ffw%2F780%2Fwatermark%2Furl%2FL3dhdGVybWFyay12MS40LnBuZw%3D%3D%2Falign%2Fcenter%2Fcrop%2F0x1009a0a0&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Bcbrtv_z%26e3Bv54AzdH3FgjortvAzdH3Fdm09cml0_z%26e3Bip4s&gsm=0&islist=&querylist='),
//        backgroundColor: Colors.white,
//        styleTextUnderTheLoader: new TextStyle(),
//        photoSize: 100.0,
//        onClick: ()=>print("Flutter Egypt"),
//        loaderColor: Colors.red
//    );
//  }
//}
