import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class Mine extends StatefulWidget {
  @override
  _MyPageState createState() {
    // TODO: implement createState
    return _MyPageState();
  }
}

class _MyPageState extends State<Mine> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: WebView(
        url: "https://m.ctrip.com/webapp/myctrip/",
        hideAppBar: true,
        backForbid: true,
        statusBarColor: "4c5bca",
      ),
    );
  }

}