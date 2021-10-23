
import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class Banners extends StatelessWidget {
  final List<CommonModel> bannerList;
  final double appBarAlpha;
  const Banners({Key? key,required this.bannerList,required this.appBarAlpha}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: FutureBuilder(
        builder: (context,snapshot) {
          if(bannerList.length>0) {
            return Swiper(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>WebView(
                          url: bannerList[index].url??'',
                        )));
                  },
                  child:Image.network(
                    bannerList[index].icon ?? '',
                    fit: BoxFit.fill,
                  ),
                );
              },
              itemCount: bannerList.length,
              pagination: new SwiperPagination(),
              // control: new SwiperControl(), //左右箭头
            );
          }else {
            return new CircularProgressIndicator();
          }
        },
      )
    );
  }
}
