import 'package:json_annotation/json_annotation.dart';

part 'bicycle_route_plan.g.dart';


@JsonSerializable()
class BicycleRoutePlan extends Object {

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'infocode')
  String infocode;

  @JsonKey(name: 'count')
  String count;

  @JsonKey(name: 'route')
  Route route;

  BicycleRoutePlan(this.status,this.info,this.infocode,this.count,this.route,);

  factory BicycleRoutePlan.fromJson(Map<String, dynamic> srcJson) => _$BicycleRoutePlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BicycleRoutePlanToJson(this);

}


@JsonSerializable()
class Route extends Object {

  @JsonKey(name: 'origin')
  String origin;

  @JsonKey(name: 'destination')
  String destination;

  @JsonKey(name: 'paths')
  List<Paths> paths;

  Route(this.origin,this.destination,this.paths,);

  factory Route.fromJson(Map<String, dynamic> srcJson) => _$RouteFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RouteToJson(this);

}


@JsonSerializable()
class Paths extends Object {

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'duration')
  String duration;

  @JsonKey(name: 'steps')
  List<Steps> steps;

  Paths(this.distance,this.duration,this.steps,);

  factory Paths.fromJson(Map<String, dynamic> srcJson) => _$PathsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PathsToJson(this);

}


@JsonSerializable()
class Steps extends Object {

  @JsonKey(name: 'instruction')
  String instruction;

  @JsonKey(name: 'orientation')
  String orientation;

  @JsonKey(name: 'road_name')
  String roadName;

  @JsonKey(name: 'step_distance')
  int stepDistance;

  @JsonKey(name: 'polyline')
  String polyline;

  Steps(this.instruction,this.orientation,this.roadName,this.stepDistance,this.polyline,);

  factory Steps.fromJson(Map<String, dynamic> srcJson) => _$StepsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StepsToJson(this);

}


