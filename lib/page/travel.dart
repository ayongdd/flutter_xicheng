
import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/travel_tab_dao.dart';
import 'package:flutter_xiecheng/model/travel_tab_model.dart';
import 'package:flutter_xiecheng/page/travel_tab.dart';

class Travel extends StatefulWidget {
  @override
  _TravelState createState() => _TravelState();
}

class _TravelState extends State<Travel> with TickerProviderStateMixin {
  late TabController _controller;
  List<TravelTab> tabs = [];
  late TravelTabModel travelTabModel;

  @override
  void initState() {
    // TODO: implement initState
    _controller = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model){
      _controller = TabController(length: model.tabs.length, vsync: this); //解决异步请求数据延迟，页面显示空白的bug
       setState(() {
         tabs = model.tabs;
         travelTabModel = model;
       });
    }).catchError((err) {
      print(err); //捕捉错误并打印
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color:Colors.white,
            padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
            child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
              indicator:UnderlineTabIndicator(
                borderSide: BorderSide(
                  color:Color(0xff2fcfbb),
                  width: 3
                ),
                insets: EdgeInsets.only(bottom: 10),
              ),
              tabs: tabs.map((TravelTab tab) {
                return Tab(
                  text: tab.labelName,
                );
              }).toList(),
            ),
          ),
          Flexible(child: TabBarView(
            controller: _controller,
            children: tabs.map((TravelTab tab) {
              return TravelTabPage(travelUrl:travelTabModel.url, groupChannelCode: tab.groupChannelCode);
              // return Text(tab.groupChannelCode);
            }).toList(),
          ))
        ],
      ),
    );
  }
}
