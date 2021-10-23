

// https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=
class SearchModel {
  String? keyword;
  final List<SearchItem> data;
  final HeadModel head;
  SearchModel({
    this.keyword,
    required this.head,
    required this.data});

  factory SearchModel.fromJson(Map<String,dynamic> json) {
    var dataJson = json['data'].toList();
    List<SearchItem> data = dataJson.map<SearchItem>((i)=>SearchItem.fromJson(i)).toList();
    return SearchModel(
        keyword: json['keyword'],
        head:HeadModel.fromJson(json['head']),
        data:data
    );
  }
  // Map<String, dynamic> toJson() =><String,dynamic> {
  //   'data':data,
  // };
}

class HeadModel {
  final Null? auth;
  final int? errcode;
  
  HeadModel({this.auth, this.errcode});

  factory HeadModel.fromJson(Map<String,dynamic> json) {
    return HeadModel(
      auth: json['auth'],
      errcode: json['errcode']
    );
  }
}

class SearchItem {
  final String? word;
  final String? type;
  final String? districtname;
  final String? url;

  SearchItem({
    this.word,
    this.type,
    this.districtname,
    this.url,
  });

  factory SearchItem.fromJson(Map<String,dynamic> json) {
    return SearchItem(
      word:json['word']??'',
      type:json['type']??'',
      districtname:json['districtname'] ??'',
      url:json['url']??'',
    );
  }
  // Map<String,dynamic> toJson()=> {
  //   'word':word??'',
  //   'type':type??'',
  //   'districtname':districtname??'',
  //   'url':url??'',
  // };
}