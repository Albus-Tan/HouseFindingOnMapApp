import 'package:json_annotation/json_annotation.dart';

part 'input_tips.g.dart';


@JsonSerializable()
class InputTips extends Object {

  @JsonKey(name: 'tips')
  List<Tips> tips;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'infocode')
  String infocode;

  @JsonKey(name: 'count')
  String count;

  InputTips(this.tips,this.status,this.info,this.infocode,this.count,);

  factory InputTips.fromJson(Map<String, dynamic> srcJson) => _$InputTipsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$InputTipsToJson(this);

}


@JsonSerializable()
class Tips extends Object {

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'adcode')
  String adcode;

  @JsonKey(name: 'location')
  String location;

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'typecode')
  String typecode;

  @JsonKey(name: 'city')
  List<dynamic> city;

  Tips(this.id,this.name,this.district,this.adcode,this.location,this.address,this.typecode,this.city,);

  factory Tips.fromJson(Map<String, dynamic> srcJson) => _$TipsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TipsToJson(this);

}


