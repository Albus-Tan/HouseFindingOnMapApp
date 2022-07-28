import 'dart:async';
import 'dart:convert';

import 'package:app/service/amap_api_service/reach_circle/reach_circle.dart';
import 'package:app/service/amap_api_service/route_plan/bicycle_route_plan.dart';
import 'package:app/service/amap_api_service/route_plan/driving_route_plan.dart';
import 'package:app/service/amap_api_service/route_plan/public_route_plan.dart';
import 'package:app/service/amap_api_service/route_plan/walking_route_plan.dart';
import 'package:app/service/amap_api_service/search/input_tips.dart';
import 'package:http/http.dart' as http;

Future<DrivingRoutePlan> fetchDrivingRoutePlan(
    String oriLng, String oriLat, String desLng, String desLat) async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/driving?'
        'key=beba67dedb3de25a4f91da96b33c62c0&'
        'origin=$oriLng,$oriLat&destination=$desLng,$desLat&'
        'show_fields=polyline,cost'),
  );
  final responseJson = jsonDecode(response.body);
  return DrivingRoutePlan.fromJson(responseJson);
}

Future<WalkingRoutePlan> fetchWalkingRoutePlan(
    String oriLng, String oriLat, String desLng, String desLat) async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/walking?'
        'origin=$oriLng,$oriLat&destination=$desLng,$desLat&'
        'key=beba67dedb3de25a4f91da96b33c62c0&show_fields=polyline,cost'),
  );
  final responseJson = jsonDecode(response.body);
  return WalkingRoutePlan.fromJson(responseJson);
}

Future<PublicRoutePlan> fetchPublicRoutePlan(
    String oriLng, String oriLat, String desLng, String desLat) async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/transit/'
        'integrated?origin=$oriLng,$oriLat&'
        'destination=$desLng,$desLat&'
        'key=beba67dedb3de25a4f91da96b33c62c0&'
        'show_fields=polyline,cost&city1=021&city2=021'),
  ); // citycode 021 is for shanghai
  final responseJson = jsonDecode(response.body);
  return PublicRoutePlan.fromJson(responseJson);
}

Future<BicycleRoutePlan> fetchBicycleRoutePlan(
    String oriLng, String oriLat, String desLng, String desLat) async {
  final response = await http.get(
    Uri.parse('https://restapi.amap.com/v5/direction/bicycling?'
        'origin=$oriLng,$oriLat&destination=$desLng,$desLat&'
        'key=beba67dedb3de25a4f91da96b33c62c0&show_fields=polyline,cost'),
  );
  final responseJson = jsonDecode(response.body);
  return BicycleRoutePlan.fromJson(responseJson);
}

Future<InputTips> fetchInputTips(String keyword, {String city = '021'}) async {
  final response = await http.get(
    Uri.parse(
        'https://restapi.amap.com/v3/assistant/inputtips?keywords=$keyword&key=beba67dedb3de25a4f91da96b33c62c0&city=$city'),
  );
  final responseJson = jsonDecode(response.body);
  return InputTips.fromJson(responseJson);
}

// 搜索住宅小区的提示
Future<InputTips> fetchResidentialInputTips(String keyword,
    {String city = '021'}) async {
  final response = await http.get(
    Uri.parse(
        'https://restapi.amap.com/v3/assistant/inputtips?keywords=$keyword&key=beba67dedb3de25a4f91da96b33c62c0&city=$city&type=120300|120302'),
  );
  final responseJson = jsonDecode(response.body);
  return InputTips.fromJson(responseJson);
}

// 通勤圈
Future<ReachCircle> fetchReachCircle(String lng, String lat, {String minutes = '60'}) async {
  final response = await http.get(
    Uri.parse(
        'https://restapi.amap.com/v3/direction/reachcircle?platform=JS&s=rsv3&key=8b942f01c2c6b908b8594f86c07c1725&location=$lng,$lat&time=$minutes&extensions=all&output=json&strategy=2'),
  );
  final responseJson = jsonDecode(response.body);
  return ReachCircle.fromJson(responseJson);
}
