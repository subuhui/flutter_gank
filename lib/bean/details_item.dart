import 'package:json_annotation/json_annotation.dart';
part 'details_item.g.dart';

@JsonSerializable()
class DetailsItem {

  DetailsItem(this.id, this.createdAt, this.desc, this.images,
      this.publishedAt, this.source, this.type, this.url, this.used, this.who);

  @JsonKey(name: '_id')
  String id;
  String createdAt;
  String desc;
  List<String> images;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;
  bool isTitle = false;
  String title;

  factory DetailsItem.fromJson(Map<String, dynamic> json) => _$DetailsItemFromJson(json);

  Map<String, dynamic> toJson() => _$DetailsItemToJson(this);
}
