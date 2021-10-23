
class CommonModel {
  final String? title;
  final String? url;
  final String? icon;
  final String? statusBarColor;
  final bool? hideAppBar;

  CommonModel({
    this.title,
    this.url,
    this.icon,
    this.statusBarColor,
    this.hideAppBar = false
  });

  factory CommonModel.fromJson(Map<String,dynamic> json) {
    return CommonModel(
        title:json['title']??'',
        url:json['url']??'',
        icon:json['icon'] ??'',
        statusBarColor:json['statusBarColor']??'',
        hideAppBar:json['hideAppBar']??false,
    );
  }
  Map<String,dynamic> toJson()=> {
    'title':title,
    'url':url,
    'icon':icon??'',
    'statusBarColor':statusBarColor??'',
    'hideAppBar':hideAppBar??true,
  };
}