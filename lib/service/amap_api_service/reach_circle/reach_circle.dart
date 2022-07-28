import 'package:json_annotation/json_annotation.dart';

part 'reach_circle.g.dart';


@JsonSerializable()
class ReachCircle extends Object {

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'infocode')
  String infocode;

  @JsonKey(name: 'contain')
  List<dynamic> contain;

  @JsonKey(name: 'polylines')
  List<Polylines> polylines;

  ReachCircle(this.status,this.info,this.infocode,this.contain,this.polylines,);

  factory ReachCircle.fromJson(Map<String, dynamic> srcJson) => _$ReachCircleFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReachCircleToJson(this);

}


@JsonSerializable()
class Polylines extends Object {

  @JsonKey(name: 'outer')
  String outer;

  @JsonKey(name: 'inners')
  List<dynamic> inners;

  Polylines(this.outer,this.inners,);

  factory Polylines.fromJson(Map<String, dynamic> srcJson) => _$PolylinesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PolylinesToJson(this);

}


