// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reach_circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReachCircle _$ReachCircleFromJson(Map<String, dynamic> json) => ReachCircle(
      json['status'] as String,
      json['info'] as String,
      json['infocode'] as String,
      json['contain'] as List<dynamic>,
      (json['polylines'] as List<dynamic>)
          .map((e) => Polylines.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReachCircleToJson(ReachCircle instance) =>
    <String, dynamic>{
      'status': instance.status,
      'info': instance.info,
      'infocode': instance.infocode,
      'contain': instance.contain,
      'polylines': instance.polylines,
    };

Polylines _$PolylinesFromJson(Map<String, dynamic> json) => Polylines(
      json['outer'] as String,
      json['inners'] as List<dynamic>,
    );

Map<String, dynamic> _$PolylinesToJson(Polylines instance) => <String, dynamic>{
      'outer': instance.outer,
      'inners': instance.inners,
    };
