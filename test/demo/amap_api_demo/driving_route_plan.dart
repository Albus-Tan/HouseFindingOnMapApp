import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/service/amap_api_service/route_plan/driving_route_plan.dart';
import 'package:http/http.dart' as http;

Future<DrivingRoutePlan> fetchDrivingRoutePlan() async {

  final response = await http.get(
      Uri.parse('https://restapi.amap.com/v5/direction/driving?'
          'key=beba67dedb3de25a4f91da96b33c62c0&'
          'origin=116.481028,39.989643&destination=116.434446,39.90816&'
          'show_fields=polyline'),
  );

  // final response = await http.post(
  //
  //   Uri.parse(
  //       'https://restapi.amap.com/v5/direction/driving'),
  //   headers: <String, String>{
  //     'Content-Type':'application/json',
  //   },
  //   body: jsonEncode(<String,String>{
  //     'key': 'beba67dedb3de25a4f91da96b33c62c0',
  //     'origin': '116.481028,39.989643',
  //     'destination': '116.434446,39.90816',
  //     'show_fields': 'polyline',
  //   }),
  // );

  final responseJson = jsonDecode(response.body);

  return DrivingRoutePlan.fromJson(responseJson);
}

void main() {
  fetchDrivingRoutePlan().then((value) => print(value.count));

  // Map<String, dynamic> userMap = jsonDecode(jsonString);
  // var user = User.fromJson(userMap);
  //
  // String json = jsonEncode(user);
}
