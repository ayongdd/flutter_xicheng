import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/navigator/tab_navigator.dart';
import 'package:flutter_xiecheng/page/speak.dart';
import 'page/camera.dart';
import 'page/home.dart';
import 'page/mine.dart';
import 'page/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter之旅',
       theme: ThemeData(
         primarySwatch: Colors.red
       ),
       // initialRoute:'home', //默认路由
       home:TabNavigator(),
       routes: <String,WidgetBuilder> {
         "home":(BuildContext context)=>HomePage(),
         "search":(BuildContext context)=>Search(),
         "camera":(BuildContext context)=>Camera(),
         "mine":(BuildContext context)=>Mine(),
         "speak":(BuildContext context)=>SpeakPage()
       },
     );
  }
}
