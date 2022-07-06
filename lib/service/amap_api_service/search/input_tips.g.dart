// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_tips.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputTips _$InputTipsFromJson(Map<String, dynamic> json) => InputTips(
      (json['tips'] as List<dynamic>)
          .map((e) => Tips.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['status'] as String,
      json['info'] as String,
      json['infocode'] as String,
      json['count'] as String,
    );

Map<String, dynamic> _$InputTipsToJson(InputTips instance) => <String, dynamic>{
      'tips': instance.tips,
      'status': instance.status,
      'info': instance.info,
      'infocode': instance.infocode,
      'count': instance.count,
    };

Tips _$TipsFromJson(Map<String, dynamic> json) => Tips(
      json['id'] as String,
      json['name'] as String,
      json['district'] as String,
      json['adcode'] as String,
      json['location'] as String,
      json['address'] as String,
      json['typecode'] as String,
      json['city'] as List<dynamic>,
    );

Map<String, dynamic> _$TipsToJson(Tips instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'district': instance.district,
      'adcode': instance.adcode,
      'location': instance.location,
      'address': instance.address,
      'typecode': instance.typecode,
      'city': instance.city,
    };
