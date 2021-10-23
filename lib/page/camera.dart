
import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/page/travel.dart';

class Camera extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Travel(),
      ),
    );
  }
}
