import 'package:json_annotation/json_annotation.dart';

part 'public_route_plan.g.dart';


@JsonSerializable()
class PublicRoutePlan extends Object {

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'info')
  String info;

  @JsonKey(name: 'infocode')
  String infocode;

  @JsonKey(name: 'route')
  Route route;

  @JsonKey(name: 'count')
  String count;

  PublicRoutePlan(this.status,this.info,this.infocode,this.route,this.count,);

  factory PublicRoutePlan.fromJson(Map<String, dynamic> srcJson) => _$PublicRoutePlanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PublicRoutePlanToJson(this);

}


@JsonSerializable()
class Route extends Object {

  @JsonKey(name: 'origin')
  String origin;

  @JsonKey(name: 'destination')
  String destination;

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'transits')
  List<Transits> transits;

  Route(this.origin,this.destination,this.distance,this.transits,);

  factory Route.fromJson(Map<String, dynamic> srcJson) => _$RouteFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RouteToJson(this);

}


@JsonSerializable()
class Transits extends Object {

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'walking_distance')
  String walkingDistance;

  @JsonKey(name: 'nightflag')
  String nightflag;

  @JsonKey(name: 'segments')
  List<Segments> segments;

  Transits(this.distance,this.walkingDistance,this.nightflag,this.segments,);

  factory Transits.fromJson(Map<String, dynamic> srcJson) => _$TransitsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TransitsToJson(this);

}


@JsonSerializable()
class Segments extends Object {

  @JsonKey(name: 'walking')
  Walking walking;

  @JsonKey(name: 'bus')
  Bus bus;

  Segments(this.walking,this.bus,);

  factory Segments.fromJson(Map<String, dynamic> srcJson) => _$SegmentsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SegmentsToJson(this);

}


@JsonSerializable()
class Walking extends Object {

  @JsonKey(name: 'destination')
  String destination;

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'origin')
  String origin;

  @JsonKey(name: 'steps')
  List<Steps> steps;

  Walking(this.destination,this.distance,this.origin,this.steps,);

  factory Walking.fromJson(Map<String, dynamic> srcJson) => _$WalkingFromJson(srcJson);

  Map<String, dynamic> toJson() => _$WalkingToJson(this);

}


@JsonSerializable()
class Steps extends Object {

  @JsonKey(name: 'instruction')
  String instruction;

  @JsonKey(name: 'road')
  String road;

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'polyline')
  Polyline polyline;

  Steps(this.instruction,this.road,this.distance,this.polyline,);

  factory Steps.fromJson(Map<String, dynamic> srcJson) => _$StepsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StepsToJson(this);

}


@JsonSerializable()
class Polyline extends Object {

  @JsonKey(name: 'polyline')
  String polyline;

  Polyline(this.polyline,);

  factory Polyline.fromJson(Map<String, dynamic> srcJson) => _$PolylineFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PolylineToJson(this);

}


@JsonSerializable()
class Bus extends Object {

  @JsonKey(name: 'buslines')
  List<Buslines> buslines;

  Bus(this.buslines,);

  factory Bus.fromJson(Map<String, dynamic> srcJson) => _$BusFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BusToJson(this);

}


@JsonSerializable()
class Buslines extends Object {

  @JsonKey(name: 'departure_stop')
  Departure_stop departureStop;

  @JsonKey(name: 'arrival_stop')
  Arrival_stop arrivalStop;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'distance')
  String distance;

  @JsonKey(name: 'polyline')
  Polyline polyline;

  @JsonKey(name: 'bus_time_tips')
  String busTimeTips;

  @JsonKey(name: 'bustimetag')
  String bustimetag;

  @JsonKey(name: 'start_time')
  String startTime;

  @JsonKey(name: 'end_time')
  String endTime;

  @JsonKey(name: 'via_num')
  String viaNum;

  @JsonKey(name: 'via_stops')
  List<Via_stops> viaStops;

  Buslines(this.departureStop,this.arrivalStop,this.name,this.id,this.type,this.distance,this.polyline,this.busTimeTips,this.bustimetag,this.startTime,this.endTime,this.viaNum,this.viaStops,);

  factory Buslines.fromJson(Map<String, dynamic> srcJson) => _$BuslinesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BuslinesToJson(this);

}


@JsonSerializable()
class Departure_stop extends Object {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'location')
  String location;

  Departure_stop(this.name,this.id,this.location,);

  factory Departure_stop.fromJson(Map<String, dynamic> srcJson) => _$Departure_stopFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Departure_stopToJson(this);

}


@JsonSerializable()
class Arrival_stop extends Object {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'location')
  String location;

  Arrival_stop(this.name,this.id,this.location,);

  factory Arrival_stop.fromJson(Map<String, dynamic> srcJson) => _$Arrival_stopFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Arrival_stopToJson(this);

}

//
// @JsonSerializable()
// class Polyline extends Object {
//
//   @JsonKey(name: 'polyline')
//   String polyline;
//
//   Polyline(this.polyline,);
//
//   factory Polyline.fromJson(Map<String, dynamic> srcJson) => _$PolylineFromJson(srcJson);
//
//   Map<String, dynamic> toJson() => _$PolylineToJson(this);
//
// }


@JsonSerializable()
class Via_stops extends Object {

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'location')
  String location;

  Via_stops(this.name,this.id,this.location,);

  factory Via_stops.fromJson(Map<String, dynamic> srcJson) => _$Via_stopsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Via_stopsToJson(this);

}


