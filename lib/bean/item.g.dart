// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
      (json['Android'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['拓展资源'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['瞎推荐'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['App'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['福利'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['iOS'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['休息视频'] as List)
          ?.map((e) => e == null
              ? null
              : DetailsItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'Android': instance.Android,
      '拓展资源': instance.ziyuan,
      '瞎推荐': instance.tuijian,
      'App': instance.App,
      'iOS': instance.iOS,
      '休息视频': instance.video,
      '福利': instance.fuli
    };
