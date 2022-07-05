import 'package:json_annotation/json_annotation.dart';

part 'walking_route_plan.g.dart';


@JsonSerializable()
class WalkingRoutePlan extends Object {

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

  WalkingRoutePlan(this.status,this.info,this.infocode,this.count,this.route,);

  factory WalkingRoutePlan.fromJson(Map<String, dynamic> srcJson) => _$WalkingRoutePlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$WalkingRoutePlanToJson(this);

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

  @JsonKey(name: 'cost')
  Cost cost;

  @JsonKey(name: 'steps')
  List<Steps> steps;

  Paths(this.distance,this.restriction,this.cost,this.steps,);

  factory Paths.fromJson(Map<String, dynamic> srcJson) => _$PathsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PathsToJson(this);

}


@JsonSerializable()
class Cost extends Object {

  @JsonKey(name: 'duration')
  String duration;

  @JsonKey(name: 'tolls')
  String tolls;

  @JsonKey(name: 'toll_distance')
  String tollDistance;

  @JsonKey(name: 'traffic_lights')
  String trafficLights;

  Cost(this.duration,this.tolls,this.tollDistance,this.trafficLights,);

  factory Cost.fromJson(Map<String, dynamic> srcJson) => _$CostFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CostToJson(this);

}


@JsonSerializable()
class Steps extends Object {

  @JsonKey(name: 'instruction')
  String instruction;

  @JsonKey(name: 'orientation')
  String orientation;

  @JsonKey(name: 'step_distance')
  String stepDistance;

  @JsonKey(name: 'cost')
  Cost cost;

  @JsonKey(name: 'polyline')
  String polyline;

  Steps(this.instruction,this.orientation,this.stepDistance,this.cost,this.polyline,);

  factory Steps.fromJson(Map<String, dynamic> srcJson) => _$StepsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StepsToJson(this);

}

//
// @JsonSerializable()
// class Cost extends Object {
//
//   @JsonKey(name: 'duration')
//   String duration;
//
//   @JsonKey(name: 'tolls')
//   String tolls;
//
//   @JsonKey(name: 'toll_distance')
//   String tollDistance;
//
//   @JsonKey(name: 'toll_road')
//   String tollRoad;
//
//   @JsonKey(name: 'traffic_lights')
//   String trafficLights;
//
//   Cost(this.duration,this.tolls,this.tollDistance,this.tollRoad,this.trafficLights,);
//
//   factory Cost.fromJson(Map<String, dynamic> srcJson) => _$CostFromJson(srcJson);
//
//   Map<String, dynamic> toJson() => _$CostToJson(this);
//
// }
//

