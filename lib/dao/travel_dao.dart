import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter_xiecheng/model/travel_model.dart';
import 'package:http/http.dart' as http;

//旅拍页接口
var Params = {
  "districtId": -1,
  "groupChannelCode": "tourphoto_global1",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 2,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {},
  "contentType": "json"
};

class TravelDao{
  static Future<TravelModel> fetch(
      String url,
      String groupChannelCode,
      int pageIndex,
      int pageSize
      ) async {
    Map paramsMap = {};
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    paramsMap['groupChannelCode'] = groupChannelCode;
    Params['pagePara'] = paramsMap;

    print('travelsssssssssss111');
    // body接受String类型的参数 所以需要用jsonEncode转化成String
    final response = await http.post(Uri.parse(url),body: convert.jsonEncode(Params));
    if(response.statusCode == 200) {
      String res = convert.Utf8Decoder().convert(response.bodyBytes);//修复中文乱码
      var result = convert.jsonDecode(res); //转化成json
      return TravelModel.fromJson(result); //解析成模型数据
    }else {
      throw Exception('failed to load travel');
    }
  }
}