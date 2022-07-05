// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walking_route_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalkingRoutePlan _$WalkingRoutePlanFromJson(Map<String, dynamic> json) =>
    WalkingRoutePlan(
      json['status'] as String,
      json['info'] as String,
      json['infocode'] as String,
      json['count'] as String,
      Route.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WalkingRoutePlanToJson(WalkingRoutePlan instance) =>
    <String, dynamic>{
      'status': instance.status,
      'info': instance.info,
      'infocode': instance.infocode,
      'count': instance.count,
      'route': instance.route,
    };

Route _$RouteFromJson(Map<String, dynamic> json) => Route(
      json['origin'] as String,
      json['destination'] as String,
      json['taxi_cost'] as String,
      (json['paths'] as List<dynamic>)
          .map((e) => Paths.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'taxi_cost': instance.taxiCost,
      'paths': instance.paths,
    };

Paths _$PathsFromJson(Map<String, dynamic> json) => Paths(
      json['distance'] as String,
      json['restriction'] as String,
      Cost.fromJson(json['cost'] as Map<String, dynamic>),
      (json['steps'] as List<dynamic>)
          .map((e) => Steps.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PathsToJson(Paths instance) => <String, dynamic>{
      'distance': instance.distance,
      'restriction': instance.restriction,
      'cost': instance.cost,
      'steps': instance.steps,
    };

Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
      json['duration'] as String,
      json['tolls'] as String,
      json['toll_distance'] as String,
      json['traffic_lights'] as String,
    );

Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
      'duration': instance.duration,
      'tolls': instance.tolls,
      'toll_distance': instance.tollDistance,
      'traffic_lights': instance.trafficLights,
    };

Steps _$StepsFromJson(Map<String, dynamic> json) => Steps(
      json['instruction'] as String,
      json['orientation'] as String,
      json['step_distance'] as String,
      Cost.fromJson(json['cost'] as Map<String, dynamic>),
      json['polyline'] as String,
    );

Map<String, dynamic> _$StepsToJson(Steps instance) => <String, dynamic>{
      'instruction': instance.instruction,
      'orientation': instance.orientation,
      'step_distance': instance.stepDistance,
      'cost': instance.cost,
      'polyline': instance.polyline,
    };
//
// Cost _$CostFromJson(Map<String, dynamic> json) => Cost(
//       json['duration'] as String,
//       json['tolls'] as String,
//       json['toll_distance'] as String,
//       json['toll_road'] as String,
//       json['traffic_lights'] as String,
//     );
//
// Map<String, dynamic> _$CostToJson(Cost instance) => <String, dynamic>{
//       'duration': instance.duration,
//       'tolls': instance.tolls,
//       'toll_distance': instance.tollDistance,
//       'toll_road': instance.tollRoad,
//       'traffic_lights': instance.trafficLights,
//     };
