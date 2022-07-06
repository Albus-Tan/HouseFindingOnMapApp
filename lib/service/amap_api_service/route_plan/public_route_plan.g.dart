// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_route_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicRoutePlan _$PublicRoutePlanFromJson(Map<String, dynamic> json) =>
    PublicRoutePlan(
      json['status'] as String,
      json['info'] as String,
      json['infocode'] as String,
      Route.fromJson(json['route'] as Map<String, dynamic>),
      json['count'] as String,
    );

Map<String, dynamic> _$PublicRoutePlanToJson(PublicRoutePlan instance) =>
    <String, dynamic>{
      'status': instance.status,
      'info': instance.info,
      'infocode': instance.infocode,
      'route': instance.route,
      'count': instance.count,
    };

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      json['origin'] as String,
      json['destination'] as String,
      json['distance'] as String,
      Cost.fromJson(json['cost'] as Map<String, dynamic>),
      (json['transits'] as List<dynamic>)
          .map((e) => Transits.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'distance': instance.distance,
      'cost': instance.cost,
      'transits': instance.transits,
    };

Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
      taxiFee: json['taxi_fee'] as String?,
      duration: json['duration'] as String?,
      transitFee: json['transit_fee'] as String?,
    );

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
      'taxi_fee': instance.taxiFee,
    };

Transits _$TransitsFromJson(Map<String, dynamic> json) => Transits(
      Cost.fromJson(json['cost'] as Map<String, dynamic>),
      json['distance'] as String,
      json['walking_distance'] as String,
      json['nightflag'] as String,
      (json['segments'] as List<dynamic>)
          .map((e) => Segments.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransitsToJson(Transits instance) => <String, dynamic>{
      'cost': instance.cost,
      'distance': instance.distance,
      'walking_distance': instance.walkingDistance,
      'nightflag': instance.nightflag,
      'segments': instance.segments,
    };

// Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
//       json['duration'] as String,
//       json['transit_fee'] as String,
//     );
//
// Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
//       'duration': instance.duration,
//       'transit_fee': instance.transitFee,
//     };

Segments _$SegmentsFromJson(Map<String, dynamic> json) => Segments(
      Walking.fromJson(json['walking'] as Map<String, dynamic>?),
      Bus.fromJson(json['bus'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$SegmentsToJson(Segments instance) => <String, dynamic>{
      'walking': instance.walking,
      'bus': instance.bus,
    };

Walking _$WalkingFromJson(Map<String, dynamic> json) => Walking(
      json['destination'] as String,
      json['distance'] as String,
      json['origin'] as String,
      Cost.fromJson(json['cost'] as Map<String, dynamic>),
      (json['steps'] as List<dynamic>)
          .map((e) => Steps.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalkingToJson(Walking instance) => <String, dynamic>{
      'destination': instance.destination,
      'distance': instance.distance,
      'origin': instance.origin,
      'cost': instance.cost,
      'steps': instance.steps,
    };

// Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
//       json['duration'] as String,
//     );
//
// Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
//       'duration': instance.duration,
//     };

Steps _$StepsFromJson(Map<String, dynamic> json) => Steps(
      json['instruction'] as String,
      json['road'] as String,
      json['distance'] as String,
      Polyline.fromJson(json['polyline'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StepsToJson(Steps instance) => <String, dynamic>{
      'instruction': instance.instruction,
      'road': instance.road,
      'distance': instance.distance,
      'polyline': instance.polyline,
    };

Polyline _$PolylineFromJson(Map<String, dynamic> json) => Polyline(
      json['polyline'] as String,
    );

Map<String, dynamic> _$PolylineToJson(Polyline instance) => <String, dynamic>{
      'polyline': instance.polyline,
    };

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
      List<Buslines>.from((json['buslines']??<dynamic>[] as List<dynamic>)
          .map((e) => Buslines.fromJson(e as Map<String, dynamic>))),
    );

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
      'buslines': instance.buslines,
    };

Buslines _$BuslinesFromJson(Map<String, dynamic> json) => Buslines(
      Departure_stop.fromJson(json['departure_stop'] as Map<String, dynamic>),
      Arrival_stop.fromJson(json['arrival_stop'] as Map<String, dynamic>),
      json['name'] as String,
      json['id'] as String,
      json['type'] as String,
      json['distance'] as String,
      Cost.fromJson(json['cost'] as Map<String, dynamic>),
      Polyline.fromJson(json['polyline'] as Map<String, dynamic>),
      json['bus_time_tips'] as String,
      json['bustimetag'] as String,
      json['start_time'] as String,
      json['end_time'] as String,
      json['via_num'] as String,
      (json['via_stops'] as List<dynamic>)
          .map((e) => Via_stops.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BuslinesToJson(Buslines instance) => <String, dynamic>{
      'departure_stop': instance.departureStop,
      'arrival_stop': instance.arrivalStop,
      'name': instance.name,
      'id': instance.id,
      'type': instance.type,
      'distance': instance.distance,
      'cost': instance.cost,
      'polyline': instance.polyline,
      'bus_time_tips': instance.busTimeTips,
      'bustimetag': instance.bustimetag,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'via_num': instance.viaNum,
      'via_stops': instance.viaStops,
    };

Departure_stop _$Departure_stopFromJson(Map<String, dynamic> json) =>
    Departure_stop(
      json['name'] as String,
      json['id'] as String,
      json['location'] as String,
    );

Map<String, dynamic> _$Departure_stopToJson(Departure_stop instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'location': instance.location,
    };

Arrival_stop _$Arrival_stopFromJson(Map<String, dynamic> json) => Arrival_stop(
      json['name'] as String,
      json['id'] as String,
      json['location'] as String,
    );

Map<String, dynamic> _$Arrival_stopToJson(Arrival_stop instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'location': instance.location,
    };

Via_stops _$Via_stopsFromJson(Map<String, dynamic> json) => Via_stops(
      json['name'] as String,
      json['id'] as String,
      json['location'] as String,
    );

Map<String, dynamic> _$Via_stopsToJson(Via_stops instance) => <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'location': instance.location,
    };
