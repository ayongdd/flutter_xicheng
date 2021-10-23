import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/home_dao.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'dart:convert' as convert;

import 'package:flutter_xiecheng/model/home_model.dart';
import 'package:flutter_xiecheng/model/sales_box_model.dart';
import 'package:flutter_xiecheng/page/search.dart';
import 'package:flutter_xiecheng/util/navigator_util.dart';
import 'package:flutter_xiecheng/widget/grid_nav.dart';
import 'package:flutter_xiecheng/widget/loading_container.dart';
import 'package:flutter_xiecheng/widget/local_nav.dart';
import 'package:flutter_xiecheng/widget/sales_nav.dart';
import 'package:flutter_xiecheng/widget/search_bar.dart';
import 'package:flutter_xiecheng/widget/sub_nav.dart';
import 'package:flutter_xiecheng/widget/banner.dart';
import '../model/grid_nav_model.dart';

const APP_SCROLL_OFFSET = 100; //设置滚动距离的常量
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';
class HomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<HomePage> {
  String resultString = '';
  List<CommonModel> localNavList = [];
  late GridNavModel gridNavList;
  late List<CommonModel> subNavLists;
  late SalesBoxModel salesBoxModel;
  List<CommonModel> bannerList= [];
  bool _loading = true;
  double appBarAlpha = 0; //appBar的滚动透明度
  // List<GridNavModel> gridNavList;
  @override
  void initState() {
    super.initState();
    // _loading = true;
    _loadData();
  }
  Future<Null> _loadData() async{
    try{
      HomeModel model = await HomeDao.fetch();
      print('xxxxxxxxxxxxx');
      print(convert.jsonEncode(model));
      setState(() {
        localNavList = model.localNavList;
        gridNavList = model.gridNav;
        subNavLists = model.subNavList;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _loading = false;
      });
    }catch(e) {
      print(e);
      setState(() {
        resultString = e.toString();
        _loading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top; //计算设备statusBar高度
    return Scaffold (
      backgroundColor: Color(0xfff2f2f2), //页面的背景图片
      // appBar: AppBar(backgroundColor:Colors.red,),
      body: NotificationListener( //监听页面滚动
        onNotification: _onScrollListen,
        child: MediaQuery.removePadding( //移除顶部的安全距离
            removeTop: true,
            context: context,
            child: LoadingContainer( //自定义loading组件
                isLoading: _loading,
                child: RefreshIndicator( //上拉刷新
                  onRefresh: _loadData,
                  child: Stack(
                    children: [
                      _List(),
                      _appBar(statusBarHeight),
                    ],
                  )
                ))),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.white,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
      //     children: [
      //       IconButton(onPressed:() {
      //         Navigator.pushNamed(context, 'home');
      //       }, icon:Icon(Icons.home)),
      //       IconButton(onPressed:() {
      //         Navigator.pushNamed(context, 'search');
      //       }, icon: Icon(Icons.search)),
      //       IconButton(onPressed:() {}, icon: Icon(Icons.photo_camera)),
      //       IconButton(onPressed:() {}, icon: Icon(Icons.person)),
      //     ],
      //   ),
      // ),
    );
  }
  Widget _appBar(statusBarHeight) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //appBar渐变遮罩背景
              colors: [Color(0x66000000),Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.only(top:statusBarHeight),
            color: Color.fromARGB((appBarAlpha*255).toInt(), 255, 255, 255), //改变透明度 a的值在0- 255
            child: SearchBar(
              enabled :false,
              hideLeft:true,
              searchBarType:appBarAlpha>0.2?SearchBarType.homeLight:SearchBarType.home,
              hint:'请搜索',
              defaultText:SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick :() {},
              rightButtonClick :() {},
              speakClick:_jumpToSpeak,
              inputBoxClick: _jumpToSearch,
              onChanged :(String value) {},
            ),
          )
        ),
        Container(
          height: appBarAlpha >0.2? 0.5:0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 0.5)],
          ),
        )
      ],
    );
    // return  Positioned(
    //     top:0,
    //     left: 0,
    //     child: Opacity(
    //       opacity: appBarAlpha,
    //       child: Container(
    //         width: MediaQuery.of(context).size.width,
    //         height:statusBarHeight+40,
    //         decoration: BoxDecoration(
    //             color: Colors.white
    //         ),
    //         child:Center(
    //           child:Padding(
    //             padding: EdgeInsets.only(top:statusBarHeight),
    //             child: Text('首页',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    //           ),
    //         ),
    //       ),
    //     )
    // );
  }
  Widget _List() {
     return  ListView( //内容
       children: [
         Banners(bannerList:bannerList,appBarAlpha:appBarAlpha),
         Padding(
           padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
           child:LocalNav(localNavList:localNavList,),),
         Padding(padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
           child:  GridNav(gridNavModel: gridNavList),),
         Padding(padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
           child:  SubNav(subNavList: subNavLists),),
         Padding(padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
           child:  SaleNaV(salesBoxModel: salesBoxModel),)
         // Text(resultString),
         // GridNav(gridNavModel: gridNavModel,name: '哈哈',)
       ],
     );
  }

  bool _onScrollListen(Notification notification) { //监听页面滚动动态计算appBar的透明度
    // notification 有四个值分别是：
    // ScrollStartNotification 开始滚动
    // ScrollUpdateNotification 正在滚动
    // ScrollEndNotification  滚动停止
    // OverscrollNotification 滚动到边界
    // notification.metrics.pixels 滚动距离
    if(notification is ScrollUpdateNotification && notification.depth == 0) { //判断是否是滚动中
      double offset = notification.metrics.pixels;
      double alpha = offset/APP_SCROLL_OFFSET;
      if(alpha<0) {
        alpha = 0;
      }else if(alpha>1) {
        alpha = 1;
      }
      setState(() {
        appBarAlpha = alpha;
      });
      print(appBarAlpha);
    }
    return true;
  }

  _goPage(BuildContext context,String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  _jumpToSearch() { //跳转到搜索页
    NavigatorUtil.push(context,Search(hideLeft: true,hint:SEARCH_BAR_DEFAULT_TEXT));
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context)=>Search(hideLeft: true,hint:SEARCH_BAR_DEFAULT_TEXT)));
  }

  void _jumpToSpeak() {
    Navigator.pushNamed(context, 'speak');
  }
}
