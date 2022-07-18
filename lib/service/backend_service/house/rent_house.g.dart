// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_house.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RentHouse _$RentHouseFromJson(Map<String, dynamic> json) => RentHouse(
      json['id'] as String,
      json['createTime'] as String,
      json['displaySource'] as String,
      json['displayRentType'] as String,
      json['icon'] as String,
      json['publishDate'] as String,
      json['pictures'] as String,
      json['title'] as String,
      json['location'] as String,
      json['longitude'] as String,
      json['latitude'] as String,
      json['rentType'] as int,
      json['onlineUrl'] as String,
      json['district'] as String,
      json['city'] as String,
      json['price'] as int,
      json['source'] as String,
      json['residential'] as String?,
      (json['squares'] as num).toDouble(),
      json['layout'] as String?,
      json['shi'] as int,
      json['ting'] as int,
      json['wei'] as int,
      json['metroLine'] as int,
      json['firstPicUrl'] as String,
    );

Map<String, dynamic> _$RentHouseToJson(RentHouse instance) => <String, dynamic>{
      'id': instance.id,
      'createTime': instance.createTime,
      'displaySource': instance.displaySource,
      'displayRentType': instance.displayRentType,
      'icon': instance.icon,
      'publishDate': instance.publishDate,
      'pictures': instance.pictures,
      'title': instance.title,
      'location': instance.location,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'rentType': instance.rentType,
      'onlineUrl': instance.onlineUrl,
      'district': instance.district,
      'city': instance.city,
      'price': instance.price,
      'source': instance.source,
      'residential': instance.residential,
      'squares': instance.squares,
      'layout': instance.layout,
      'shi': instance.shi,
      'ting': instance.ting,
      'wei': instance.wei,
      'metroLine': instance.metroLine,
      'firstPicUrl': instance.firstPicUrl,
    };
