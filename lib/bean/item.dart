import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gank/bean/details_item.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  Item(this.Android,this.ziyuan,this.tuijian,this.App,this.fuli,this.iOS,this.video);

  List<DetailsItem> Android;
  @JsonKey(name: '拓展资源')
  List<DetailsItem> ziyuan;
  @JsonKey(name: '瞎推荐')
  List<DetailsItem> tuijian;
  List<DetailsItem> App;
  List<DetailsItem> iOS;
  @JsonKey(name: '休息视频')
  List<DetailsItem> video;
  @JsonKey(name: '福利')
  List<DetailsItem> fuli;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
