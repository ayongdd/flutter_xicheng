import 'common_model.dart';
import 'config_model.dart';
import 'grid_nav_model.dart';
import 'sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;
  final List<CommonModel> bannerList;
  final List<CommonModel> subNavList;
  final List<CommonModel> localNavList;

  HomeModel({
    required this.config,
    required this.gridNav,
    required this.salesBox,
    required this.bannerList,
    required this.subNavList,
    required this.localNavList
});

  factory HomeModel.fromJson(Map<String,dynamic> json) {
    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList = localNavListJson.map((i)=>CommonModel.fromJson(i)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList = subNavListJson.map((i)=>CommonModel.fromJson(i)).toList();

    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList = bannerListJson.map((i)=>CommonModel.fromJson(i)).toList();

    return HomeModel(
        config:new ConfigModel.fromJson(json['config']),
        gridNav:new GridNavModel.fromJson(json['gridNav']) ,
        salesBox:new SalesBoxModel.fromJson(json['salesBox']),
        bannerList:bannerList,
        subNavList:subNavList,
        localNavList:localNavList
    );
  }

  Map<String, dynamic> toJson() =><String,dynamic> {
    'config':config,
    'gridNav':gridNav,
    'salesBox':salesBox,
    'bannerList':bannerList.toList(),
    'subNavList':subNavList.toList(),
    'localNavList':localNavList.toList(),
  };
}