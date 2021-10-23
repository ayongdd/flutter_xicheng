
class ConfigModel {
  final String searchUrl;
  ConfigModel({required this.searchUrl});

  factory ConfigModel.fromJson(Map<String,dynamic> json) =>ConfigModel(searchUrl:json['searchUrl']);

  Map<String, dynamic> toJson() =>
      <String,dynamic>{
        'searchUrl':searchUrl
      };
}