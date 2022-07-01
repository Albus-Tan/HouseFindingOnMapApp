// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driving_route_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrivingRoutePlan _$DrivingRoutePlanFromJson(Map<String, dynamic> json) =>
    DrivingRoutePlan(
      json['status'] as String,
      json['info'] as String,
      json['infocode'] as String,
      json['count'] as String,
      Route.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DrivingRoutePlanToJson(DrivingRoutePlan instance) =>
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
      (json['steps'] as List<dynamic>)
          .map((e) => Steps.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PathsToJson(Paths instance) => <String, dynamic>{
      'distance': instance.distance,
      'restriction': instance.restriction,
      'steps': instance.steps,
    };

Steps _$StepsFromJson(Map<String, dynamic> json) => Steps(
      json['instruction'] as String,
      json['orientation'] as String,
      json['step_distance'] as String,
      json['polyline'] as String,
    );

Map<String, dynamic> _$StepsToJson(Steps instance) => <String, dynamic>{
      'instruction': instance.instruction,
      'orientation': instance.orientation,
      'step_distance': instance.stepDistance,
      'polyline': instance.polyline,
    };
