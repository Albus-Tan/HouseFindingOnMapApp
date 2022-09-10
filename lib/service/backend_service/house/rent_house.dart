import 'package:app/routes/house_detail_page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rent_house.g.dart';

@JsonSerializable()
class RentHouse extends Object {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'createTime')
  String createTime;

  @JsonKey(name: 'displaySource')
  String displaySource;

  @JsonKey(name: 'displayRentType')
  String displayRentType;

  @JsonKey(name: 'icon')
  String icon;

  @JsonKey(name: 'publishDate')
  String publishDate;

  @JsonKey(name: 'pictures')
  String pictures;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'location')
  String location;

  @JsonKey(name: 'longitude')
  String longitude;

  @JsonKey(name: 'latitude')
  String latitude;

  @JsonKey(name: 'rentType')
  int rentType;

  @JsonKey(name: 'onlineUrl')
  String onlineUrl;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'price')
  int price;

  @JsonKey(name: 'source')
  String source;

  @JsonKey(name: 'residential')
  String? residential;

  @JsonKey(name: 'squares')
  double squares;

  @JsonKey(name: 'layout')
  String? layout;

  @JsonKey(name: 'shi')
  int shi;

  @JsonKey(name: 'ting')
  int ting;

  @JsonKey(name: 'wei')
  int wei;

  @JsonKey(name: 'metroLine')
  int metroLine;

  @JsonKey(name: 'firstPicUrl')
  String firstPicUrl;

  @JsonKey(name: 'compress')
  String compress;

  RentHouse(
    this.id,
    this.createTime,
    this.displaySource,
    this.displayRentType,
    this.icon,
    this.publishDate,
    this.pictures,
    this.title,
    this.location,
    this.longitude,
    this.latitude,
    this.rentType,
    this.onlineUrl,
    this.district,
    this.city,
    this.price,
    this.source,
    this.residential,
    this.squares,
    this.layout,
    this.shi,
    this.ting,
    this.wei,
    this.metroLine,
    this.firstPicUrl,
    this.compress,
  );

  factory RentHouse.fromJson(Map<String, dynamic> srcJson) =>
      _$RentHouseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RentHouseToJson(this);

  HouseDetail toDetail() {
    return HouseDetail(
      title: title,
      pricePerMonth: price,
      squares: squares,
      shiNumber: shi,
      community: district,
      image: firstPicUrl,
      district: "上海",
      latitude: latitude,
      longitude: longitude,
      location: location,
      hid: id,
      layout: layout ?? '',
      compressedImage: compress,
    );
  }
}
