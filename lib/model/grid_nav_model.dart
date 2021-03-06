
import 'common_model.dart';

class GridNavModel {
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;

  GridNavModel({
    required this.hotel,
    required this.flight,
    required this.travel});

  factory GridNavModel.fromJson(Map<String,dynamic> json) =>GridNavModel(
      hotel: GridNavItem.fromJson(json['hotel']),
      flight:GridNavItem.fromJson(json['flight']),
      travel:GridNavItem.fromJson(json['travel'])
  );
  Map<String,dynamic> toJson() =><String,dynamic> {
    'hotel':hotel,
    'flight':flight,
    'travel':travel
  };
}

class GridNavItem {
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItem({
    required this.startColor,
    required this.endColor,
    required this.mainItem,
    required this.item1,
    required this.item2,
    required this.item3,
    required this.item4
  });
  factory GridNavItem.fromJson(Map<String,dynamic> json)=> GridNavItem(
    startColor:json['startColor'],
    endColor:json['endColor'],
    mainItem:CommonModel.fromJson(json['mainItem']),
    item1:CommonModel.fromJson(json['item1']),
    item2:CommonModel.fromJson(json['item2']),
    item3:CommonModel.fromJson(json['item3']),
    item4:CommonModel.fromJson(json['item4']),
  );

  Map<String,dynamic> toJson() {
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['startColor'] = this.startColor;
    data['endColor'] = this.endColor;
    data['mainItem'] = this.mainItem;
    data['item1'] = this.item1;
    data['item2'] = this.item2;
    data['item3'] = this.item3;
    data['item4'] = this.item4;
    return data;
  }
}