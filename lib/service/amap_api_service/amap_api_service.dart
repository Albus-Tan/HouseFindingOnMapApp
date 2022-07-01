import 'dart:async';
import 'dart:convert';

import 'package:app/service/amap_api_service/route_plan/bicycle_route_plan.dart';
import 'package:app/service/amap_api_service/route_plan/driving_route_plan.dart';
import 'package:app/service/amap_api_service/route_plan/public_route_plan.dart';
import 'package:app/service/amap_api_service/route_plan/walking_route_plan.dart';
import 'package:http/http.dart' as http;

Future<DrivingRoutePlan> fetchDrivingRoutePlan() async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/driving?'
        'key=beba67dedb3de25a4f91da96b33c62c0&'
        'origin=116.481028,39.989643&destination=116.434446,39.90816&'
        'show_fields=polyline'),
  );
  final responseJson = jsonDecode(response.body);
  return DrivingRoutePlan.fromJson(responseJson);
}

Future<WalkingRoutePlan> fetchWalkingRoutePlan() async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/walking?'
        'origin=116.434307,39.90909&destination=116.434446,39.90816&'
        'key=beba67dedb3de25a4f91da96b33c62c0&show_fields=polyline'),
  );
  final responseJson = jsonDecode(response.body);
  return WalkingRoutePlan.fromJson(responseJson);
}

Future<PublicRoutePlan> fetchPublicRoutePlan() async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/transit/'
        'integrated?origin=116.434307,39.90909&'
        'destination=116.434446,39.70816&'
        'key=beba67dedb3de25a4f91da96b33c62c0&'
        'show_fields=polyline&city1=021&city2=021'),
  );
  final responseJson = jsonDecode(response.body);
  return PublicRoutePlan.fromJson(responseJson);
}

Future<BicycleRoutePlan> fetchBicycleRoutePlan() async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/bicycling?'
        'origin=116.434307,39.90909&destination=116.434446,39.90816&'
        'key=beba67dedb3de25a4f91da96b33c62c0&show_fields=polyline'),
  );
  final responseJson = jsonDecode(response.body);
  return BicycleRoutePlan.fromJson(responseJson);
}
