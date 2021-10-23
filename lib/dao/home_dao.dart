import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter_xiecheng/model/home_model.dart';
import 'package:http/http.dart' as http;
// import '../model/home_model.dart';

const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';
// var _client = http.Client();
class HomeDao{
  static Future<HomeModel> fetch() async {
    final response = await http
        .get(Uri.parse(HOME_URL));
    if(response.statusCode == 200) {
      String res = convert.Utf8Decoder().convert(response.bodyBytes);//修复中文乱码
      var result = convert.jsonDecode(res); //转化成json
      return HomeModel.fromJson(result); //解析成模型数据
    }else {
      throw Exception('failed to load home_page.json');
    }
  }
}