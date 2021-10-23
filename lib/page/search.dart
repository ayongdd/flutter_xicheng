import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/search_dao.dart';
import 'package:flutter_xiecheng/model/search_model.dart';
import 'package:flutter_xiecheng/page/speak.dart';
import 'package:flutter_xiecheng/util/navigator_util.dart';
import 'package:flutter_xiecheng/widget/search_bar.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
class Search extends StatefulWidget {
  final bool?hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const Search({Key? key,
    this.hideLeft,
    this.searchUrl = URL,
    this.keyword = '',
    this.hint='旅游 酒店'}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<SearchItem> searchModel = []; //当前搜索返回结果
  String keyword = '';

   @override
   void initState() {
     if(widget.keyword != null) { //触发搜索
       _onTextChange(widget.keyword);
     }
     super.initState();
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child:Column(
          children: [
            _appBar(),
            MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: searchModel.length,
                    itemBuilder: (BuildContext context,int position){
                      return _item(position);
                })),)
          ],
        ),
      ),
    );
  }

   _onTextChange(String text) async{
    keyword = text;
    if(text.length == 0) {
      setState(() {
        searchModel = <SearchItem>[];
      });
      return;
    }
    String url = widget.searchUrl+text;
    SearchDao.fetch(url,text)
    .then((model) => {
      //只有当当前输入的内容和服务端返回的内容一致时才渲染
      if(model.keyword == keyword) {
        setState((){
          searchModel = model.data;
        })
      }
    }).catchError((err)=>print(err));
  }

  _appBar() {
     return Column(
       children: [
         Container(
           decoration:  BoxDecoration(
             gradient:LinearGradient(
               colors: [Color(0x66000000),Colors.transparent],
               begin: Alignment.topCenter,
               end:Alignment.bottomCenter
             )
           ),
           child: Container(
             padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top),
             height: 80,
             decoration: BoxDecoration(color: Colors.white),
             child: SearchBar(
               enabled :false,
               hideLeft:widget.hideLeft,
               searchBarType:SearchBarType.normal,
               hint:widget.hint,
               defaultText:widget.keyword,
               leftButtonClick :() {Navigator.pop(context);},
               rightButtonClick :() {},
               speakClick:_jumpToSpeak,
               inputBoxClick :(){},
               onChanged :_onTextChange,
             ),
           ),
         )
       ],
     );
  }

  //'wordwoc'.split('w') -> [,ord,oc] ;
  _item(int positon) {
    if(searchModel.length == 0) return null;
    SearchItem item = searchModel[positon];
    // return Text(item.word ?? '');
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(context, WebView(url:item.url??'', title:'详情页'));
         // Navigator.push(context,
         // MaterialPageRoute(builder: (BuildContext context)=>
         //     WebView(url:item.url??'', title:'详情页')
         // ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border:Border(bottom: BorderSide(width: 0.3,color:Colors.grey))
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(width: 300,child:_title(item),),
                Container(width: 300,child:_subTitle(item),),
                // Container(width: 300,child:Text('${item.districtname??''}-${item.word??''}'),),
                // Container(width: 300,child:Text('${item.type??''}-${item.type??''}'),)
              ],
            )
          ],
        ),
      ),
    );
  }

  _title(SearchItem item) {
     if(item == null) return null;
     List<TextSpan> spans = [];
     spans.addAll(_keywordTextSpans(item.word, keyword));
     return RichText(text: TextSpan(children: spans));
  }

  _subTitle(SearchItem item) {
     return null;
  }

  _keywordTextSpans(String? word, keyword) { //给搜索关键字添加高亮
     List<TextSpan> spans = [];
     if(word==null || word.length == 0) return spans;
     List<String> arr = word.split(keyword);
     if(arr.length == 1) { //如果没有匹配到关键词则转化成大写再切割一遍
       arr = word.split(keyword.toUpperCase());
     }
     TextStyle normalStyle =TextStyle(fontSize: 16,color: Colors.black87);
     TextStyle keywordStyle =TextStyle(fontSize: 16,color: Colors.orange);
     //'wordwoc'.split('w')-> [,ord,oc] 利用此原理找到搜索关键词的位置精选高亮替换
    for(int i =0;i<arr.length;i++) {
      if((i+1)%2 == 0) {
        spans.add(TextSpan(text:keyword,style: keywordStyle));
      }
      String val = arr[i];
      if(val != null && val.length>0) {
        spans.add(TextSpan(text:val,style: normalStyle));
      }
    }
    return spans;
  }

  void _jumpToSpeak() { //跳转到语言说话
     Navigator.push(context,MaterialPageRoute(builder: (context)=>SpeakPage()));
  }
}
