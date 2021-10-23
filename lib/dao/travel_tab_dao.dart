import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter_xiecheng/model/travel_tab_model.dart';
import 'package:http/http.dart' as http;

//旅拍类别接口
const TRAVEL_TAB_URL = 'https://www.devio.org/io/flutter_app/json/travel_page.json';
// var _client = http.Client();
class TravelTabDao{
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(Uri.parse(TRAVEL_TAB_URL));
    if(response.statusCode == 200) {
      String res = convert.Utf8Decoder().convert(response.bodyBytes);//修复中文乱码
      var result = convert.jsonDecode(res); //转化成json
      print('response.result');
      print(result);
      return TravelTabModel.fromJson(result); //解析成模型数据
    }else {
      throw Exception('failed to load home_page.json');
    }
  }
}