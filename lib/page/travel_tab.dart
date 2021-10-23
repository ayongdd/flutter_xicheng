import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xiecheng/dao/travel_dao.dart';
import 'package:flutter_xiecheng/model/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_xiecheng/util/navigator_util.dart';
import 'package:flutter_xiecheng/widget/loading_container.dart';
import 'package:flutter_xiecheng/widget/webview.dart';

const PAGE_SIZE = 10;
const TRAVEL_URL = 'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class TravelTabPage extends StatefulWidget {
  final String travelUrl ;
  final String groupChannelCode;
  const TravelTabPage({Key? key,required this.travelUrl, required this.groupChannelCode}) : super(key: key);

  @override
  _TravelTabState createState() => _TravelTabState();
}
 //切换导航使内容不会重绘
class _TravelTabState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems = [];
  int pageIndex = 1;
   bool isLoading = true;
   ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _loadData();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) { //判断是否滚动到底部
        _loadData(loadMore:true);
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  bool get wantKeepAlive=>true; //保持页面状态，使页面不重新渲染 配合 with AutomaticKeepAliveClientMixin 使用

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:LoadingContainer(
          isLoading: isLoading,
          child:RefreshIndicator(
            onRefresh: _handleRefresh,
            child: MediaQuery.removePadding(context: context,
              removeTop: true,
              child: new StaggeredGridView.countBuilder(
                controller: _scrollController,
                crossAxisCount: 4,
                itemCount: travelItems!.length,
                itemBuilder: (BuildContext context, int index) =>_TravelItem(index:index,item:travelItems[index]),
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),),
          )
      )
    );
  }

  void _loadData({loadMore = false}) {
    if(loadMore) {
      pageIndex++;
    }else{
      pageIndex = 1;
    }
    TravelDao.fetch(widget.travelUrl, widget.groupChannelCode,pageIndex, PAGE_SIZE)
        .then((TravelModel model)  {
          List<TravelItem> items = _filterItems(model.resultList);
          isLoading = false;
          setState(() {
            if(travelItems != null) {
              travelItems.addAll(items);
            }else {
              travelItems = items;
            }
           });
        }).catchError((err) {print(err);isLoading = false;});
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if(resultList == null) return [];
    List<TravelItem> filterItems = [];
    resultList.forEach((item) {
      if(item.article !=null) { //过滤article为空的模型
        filterItems.add(item);
      }
    });
    return filterItems;
  }


  Future<Null> _handleRefresh() async{
    _loadData();
    return null;
  }
}

class _TravelItem  extends StatelessWidget{
  final TravelItem item;
  final int index;

  const _TravelItem({Key? key,required this.item,required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        if(item.article.urls !=null && item.article.urls!.length>0) {
          NavigatorUtil.push(context, WebView(url:item.article.urls![0].h5Url ?? '',title:'详情'));
          // Navigator.push(context, MaterialPageRoute(
          //     builder: (context)=>WebView(url:item.article.urls![0].h5Url ?? '',title:'详情')));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(item.article.articleTitle ?? '',
                maxLines: 2,overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black87,fontSize: 14),),
              ),
              _infoText()
            ],
          ),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: [
        Image.network(item.article.images![0].dynamicUrl ?? ''),
        Positioned(
          bottom: 8,
            left: 8,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 3),
                  child: Icon(Icons.location_on,color: Colors.white,size: 12,),),
                  LimitedBox( //设置最大宽度组件
                    maxWidth: 120,
                    child: Text(_poiName(),maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white,fontSize: 12),),
                  )
                ],
              ),
            ))
      ],
    );
  }

  String _poiName() {
    return item.article.pois == null || item.article.pois!.length == 0? '未知'
        :item.article.pois![0].poiName ??'未知';
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              PhysicalModel(color: Colors.transparent,
                clipBehavior: Clip.antiAlias, //防锯齿裁切
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.article.author?.coverImage?.dynamicUrl ?? '',
                  width: 24,height: 24,),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(item.article.author?.nickName??'',
                  overflow: TextOverflow.ellipsis,maxLines: 1,
                  style: TextStyle(fontSize: 12),),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.thumb_up,size: 14,color: Colors.grey,),
              Padding(padding: EdgeInsets.only(left: 3),
              child: Text(item.article.likeCount.toString(),style: TextStyle(fontSize: 10),),)
            ],
          )
        ],
      ),
    );
  }
}

