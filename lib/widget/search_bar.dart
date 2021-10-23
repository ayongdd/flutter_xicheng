import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SearchBarType {home,normal,homeLight}
class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool?hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() ?leftButtonClick;
  final void Function()?rightButtonClick;
  final void Function()?speakClick;
  final void Function()?inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar({
    Key? key,
    this.enabled = false,
    this.hideLeft,
    this.searchBarType = SearchBarType.home,
    this.hint = '',
    this.defaultText = '网红打卡圣地',
    this.leftButtonClick,
     this.rightButtonClick,
     this.speakClick,
     this.inputBoxClick,
     required this.onChanged}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();

}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    if(widget.defaultText != null) {
      setState(() {
        _controller.text=widget.defaultText;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal ? 
        _genNormalSearch():_genHomeSearch();
  }

  _genNormalSearch() { //默认样式
    return Container(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _wrapTap( //左边返回键
            Container(
              padding: EdgeInsets.fromLTRB(10, 3, 5, 5),
              // child:Text(widget.hideLeft.toString()),
              child: widget.hideLeft ?? false? Icon(Icons.arrow_back_ios,color: Colors.grey,size: 26,):null
            ),
            widget.leftButtonClick??(){}
          ),
          Expanded( //中奖输入框
            flex: 1,
            child: _inputBox()
          ),
          _wrapTap(Container( //右边输入按钮
            padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
            child: Text('搜索',style:TextStyle(color:Colors.blue,fontSize: 17)),
          ), widget.rightButtonClick ?? (){})

        ],
      ),
    );
  }
  _wrapTap(Widget child,void Function() callback) {
    return GestureDetector(
      onTap: () {
        if(callback != null) callback();
      },
      child: child,
    );
  }
  _genHomeSearch() { //首页搜索框
    return Container(
      child: Row(
        children: [
          _wrapTap( //左边返回键
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: [
                    Text('上海',style: TextStyle(color:_homeFontColor(),fontSize: 14),),
                    Icon(
                      Icons.expand_more,
                      color: _homeFontColor(),
                      size: 22,
                    )
                  ],),
              ),
              widget.leftButtonClick??(){}
          ),
          Expanded( //输入框
              flex: 1,
              child: _inputBox(),
          ),
          _wrapTap(Container( //右边输入按钮
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Icon(Icons.comment,color: _homeFontColor(),size: 26,),
          ), widget.rightButtonClick??(){})

        ],
      ),
    );
  }

  _inputBox() { //输入框
    Color inputBoxColor;
    if(widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    }else inputBoxColor = Color(int.parse('0xffEDEDED'));
    return Container(
            height: 30,
            // color: Colors.red,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                color:inputBoxColor,
                borderRadius: BorderRadius.circular(
                    widget.searchBarType == SearchBarType.normal? 5 :15
                )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    Icons.search,
                    size: 20,
                    color:widget.searchBarType == SearchBarType.normal
                        ? Color(0xffA9A9A9):Colors.blue
                ),
                Expanded(
                  flex: 1,
                  child: widget.searchBarType == SearchBarType.normal ?
                  TextField(
                    controller: _controller,
                    onChanged: _onChanged,
                    autofocus: true,
                    style: TextStyle(fontSize: 18,color:Colors.black,fontWeight: FontWeight.w300),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                        isDense: true, //清除默认内边距
                        border:InputBorder.none,
                        hintText: widget.hint,
                        hintStyle: TextStyle(fontSize: 15)
                    ),
                  ):
                  _wrapTap(Container(
                      child:Text(widget.defaultText,style: TextStyle(fontSize: 13,color: Colors.grey),)
                  ), widget.inputBoxClick??(){}),
                ),
                !showClear ? _wrapTap(
                    Icon(
                      Icons.mic,
                      color: widget.searchBarType == SearchBarType.normal ? Colors.blue : Colors.grey,
                    ),widget.speakClick??(){})
                    :_wrapTap(
                    Icon(
                      Icons.close,
                      size: 22,
                      color: Colors.grey,
                    ),() {
                  setState(() {
                    _controller.clear(); //清除控制器
                  });
                  _onChanged('');
                })
              ],
            ),
          // )
        );
  }

  _onChanged(String text) {
    if(text.length>0) {
      setState(() {
        showClear = true;
      });
    }else {
      setState(() {
        showClear = false;
      });
    }
    if(widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight? Colors.black54:Colors.white;
  }
}
