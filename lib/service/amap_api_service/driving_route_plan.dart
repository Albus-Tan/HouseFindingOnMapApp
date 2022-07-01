import 'package:json_annotation/json_annotation.dart';

part 'driving_route_plan.g.dart';

@JsonSerializable()
class DrivingRoutePlan extends Object {

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

  DrivingRoutePlan(this.status,this.info,this.infocode,this.count,this.route,);

  factory DrivingRoutePlan.fromJson(Map<String, dynamic> srcJson) => _$DrivingRoutePlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DrivingRoutePlanToJson(this);

}


@JsonSerializable()
class Route extends Object {

  @JsonKey(name: 'origin')
  String origin;

  @JsonKey(name: 'destination')
  String destination;

  @JsonKey(name: 'taxi_cost')
  String taxiCost;

  @JsonKey(name: 'paths')
  List<Paths> paths;

  Route(this.origin,this.destination,this.taxiCost,this.paths,);

  factory Route.fromJson(Map<String, dynamic> srcJson) => _$RouteFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RouteToJson(this);

}


@JsonSerializable()
class Paths extends Object {

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'restriction')
  String restriction;

  @JsonKey(name: 'steps')
  List<Steps> steps;

  Paths(this.distance,this.restriction,this.steps,);

  factory Paths.fromJson(Map<String, dynamic> srcJson) => _$PathsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PathsToJson(this);

}


@JsonSerializable()
class Steps extends Object {

  @JsonKey(name: 'instruction')
  String instruction;

  @JsonKey(name: 'orientation')
  String orientation;

  @JsonKey(name: 'step_distance')
  String stepDistance;

  @JsonKey(name: 'polyline')
  String polyline;

  Steps(this.instruction,this.orientation,this.stepDistance,this.polyline,);

  factory Steps.fromJson(Map<String, dynamic> srcJson) => _$StepsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StepsToJson(this);

}


