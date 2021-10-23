
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/model/common_model.dart';
import 'package:flutter_xiecheng/model/sales_box_model.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

class SaleNaV extends StatelessWidget {
  final SalesBoxModel salesBoxModel;
  const SaleNaV({Key? key,required this.salesBoxModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _salesBox(context),
    );
  }

  _salesBox(BuildContext context) {
    List<Widget> items = [];
    items.add(_top(context,salesBoxModel.icon));
    items.add(_item(context,salesBoxModel.bigCard1,salesBoxModel.bigCard2,true));
    items.add(_item(context,salesBoxModel.smallCard1,salesBoxModel.smallCard2,false));
    items.add(_item(context,salesBoxModel.smallCard3,salesBoxModel.smallCard4,false));
    return items;
  }

  Widget _top(BuildContext context, String icon) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(icon,height:20,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              // height: 22,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)
              ),
              child:GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      WebView(
                        url: salesBoxModel.moreUrl,
                      )
                  ));
                },
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('获取更多福利',style: TextStyle(color: Colors.white,fontSize: 12),),
                    Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,size: 12,)
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _item(BuildContext context, CommonModel model1,CommonModel model2,bool isBigBox) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top:BorderSide(width: 5,color: Color(int.parse('0xfff2f2f2'))))
      ),
      child:  Row(
        children: [
          Expanded(
            child:Container(
              decoration: BoxDecoration(
                border: Border(right: BorderSide(width: 2,color: Color(int.parse('0xfff2f2f2'))))
              ),
              child: GestureDetector(
                  onTap: () =>_goXC(context,model1),
                  child: Image.network(model1.icon?? "",height:isBigBox? 140:80,fit: BoxFit.fill,)
              ),
            ),
            flex: 1,),
          Expanded(
            child:GestureDetector(
                onTap: () =>_goXC(context,model2),
                child: Image.network(model2.icon?? "",height:isBigBox?140:80,fit: BoxFit.fill,)
            ),
            flex: 1,)
        ],
      ),
    );
  }

   _goXC(BuildContext context,CommonModel model) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
        WebView(
          url: model.url??'',
          title: model.title??'',
        )
    ));
  }
}
