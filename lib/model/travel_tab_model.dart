class TravelTabModel {
  String url;
  List<TravelTab> tabs;

  TravelTabModel({required this.url,required this.tabs});


  factory TravelTabModel.fromJson(Map<String, dynamic> json) {
    return TravelTabModel(
      url: json["url"],
      tabs: List.of(json["tabs"]).map((i) => TravelTab.fromJson(i)).toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.tabs != null) {
      data['tabs'] = this.tabs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TravelTab {
  String labelName;
  String groupChannelCode;

  TravelTab({required this.labelName,required this.groupChannelCode});

  factory TravelTab.fromJson(Map<String, dynamic> json) {
     return TravelTab(
         labelName: json['labelName'],
         groupChannelCode: json['groupChannelCode']
     );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['labelName'] = this.labelName;
    data['groupChannelCode'] = this.groupChannelCode;
    return data;
  }
}