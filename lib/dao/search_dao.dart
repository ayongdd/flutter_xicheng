import 'dart:async';
import 'dart:convert' as convert;
import 'package:flutter_xiecheng/model/search_model.dart';
import 'package:http/http.dart' as http;

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
class SearchDao {
  static Future<dynamic> fetch(String url,String text) async {
     final response = await http.get(Uri.parse(url));
     if(response.statusCode == 200) {
       String res = convert.Utf8Decoder().convert(response.bodyBytes);//修复中文乱码
       var result = convert.jsonDecode(res); //转化成json
       //只有当当前输入的内容和服务器返回的内容一致时才渲染
       SearchModel model = SearchModel.fromJson(result);
       model.keyword = text;
       return model; //解析成模型数据
     }else {
       throw Exception('failed to load home_page.json');
     }
  }
}