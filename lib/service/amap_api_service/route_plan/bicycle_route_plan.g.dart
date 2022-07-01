// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bicycle_route_plan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BicycleRoutePlan _$BicycleRoutePlanFromJson(Map<String, dynamic> json) =>
    BicycleRoutePlan(
      json['status'] as String,
      json['info'] as String,
      json['infocode'] as String,
      json['count'] as String,
      Route.fromJson(json['route'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BicycleRoutePlanToJson(BicycleRoutePlan instance) =>
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
      (json['paths'] as List<dynamic>)
          .map((e) => Paths.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteToJson(Route instance) => <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'paths': instance.paths,
    };

Paths _$PathsFromJson(Map<String, dynamic> json) => Paths(
      json['distance'] as String,
      json['duration'] as String,
      (json['steps'] as List<dynamic>)
          .map((e) => Steps.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PathsToJson(Paths instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'steps': instance.steps,
    };

Steps _$StepsFromJson(Map<String, dynamic> json) => Steps(
      json['instruction'] as String,
      json['orientation'] as String,
      json['road_name'] as String,
      json['step_distance'] as int,
      json['polyline'] as String,
    );

Map<String, dynamic> _$StepsToJson(Steps instance) => <String, dynamic>{
      'instruction': instance.instruction,
      'orientation': instance.orientation,
      'road_name': instance.roadName,
      'step_distance': instance.stepDistance,
      'polyline': instance.polyline,
    };
