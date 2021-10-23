
import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;
  const SubNav({Key? key,required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height:200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6)
      ),
      child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.3 //宽高比
      ),
        shrinkWrap:true,
        children: _subNav(context),
     ),
    );
  }

  _subNav(BuildContext context) {
    if(subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context,model));
    });
    return items;
  }

  _item(BuildContext context,CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context)=>
            WebView(
              url: model.url??'',
              statusBarColor: model.statusBarColor??'',
              hideAppBar: model.hideAppBar??false,
              title: model.title??'',
            ))
        );
      },
      child: Container(
        // height: 40,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Image.network(model.icon??'',fit: BoxFit.cover,width: 20,height: 20,),
            Text(model.title??'',style: TextStyle(fontSize: 13,color: Color(int.parse('0xff999999'))),)
          ],
        ),
      ),
    );
  }
}
