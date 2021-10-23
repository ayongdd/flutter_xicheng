import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/page/camera.dart';
import 'package:flutter_xiecheng/page/home.dart';
import 'package:flutter_xiecheng/page/mine.dart';
import 'package:flutter_xiecheng/page/search.dart';
import 'package:flutter_xiecheng/page/travel.dart';

class TabNavigator extends StatefulWidget {
   @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final  _controller = PageController(
    initialPage: 0, //初始页面
  );
  Color _defaultColor = Colors.grey;
  Color _activeColor = Colors.blue;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (int index) {
          setState(() {
            _controller.jumpToPage(index); //跳槽指定页面
            _currentIndex = index;
          });
        },
        controller: _controller,
        children: [
          HomePage(),
          Search(),
          Travel(),
          Mine(),
        ],
        physics:NeverScrollableScrollPhysics() //禁止左右滑动切换页面
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _controller.jumpToPage(index); //跳槽指定页面
            _currentIndex = index;
          });
        },
        items: [
          _bottomItem('首页',_currentIndex,0,Icons.home),
          _bottomItem('搜索',_currentIndex,1,Icons.search),
          _bottomItem('拍照',_currentIndex,2,Icons.camera_alt),
          _bottomItem('我的',_currentIndex,3,Icons.account_circle),
        ],
      ),
    );
  }

  _bottomItem(String title,int currentIndex,int index,IconData iconName) {
     return  BottomNavigationBarItem(
       icon: Icon(iconName, color: _defaultColor,),
       activeIcon: Icon(iconName,color: _activeColor,),
       title:Text(title,style: TextStyle(color:currentIndex == index ?_activeColor:_defaultColor ),),
     );
  }
}
