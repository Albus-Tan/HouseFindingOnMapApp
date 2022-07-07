import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './select_house/house_page_entity.dart';

Future<HousePageEntity> fetchHousePage(
    String district,
    String price1,
    String price2,
    String rentType,
    String rooms,
    String metroLine,
    String metroStation,
    String page,
    String pageSize) async {
  var url = Uri.parse(
      'http://124.71.183.73:8080/house/search?price1=$price1&price2=$price2'
      '&page=$page&rentType=$rentType&rooms=$rooms&metro_station=$metroStation'
      '&district=$district&pageSize=$pageSize&metro_line=$metroLine');
  var s = url.toString();
  debugPrint(s);
  final response = await http.post(url);
  final responseJson = jsonDecode(response.body);
  var x = HousePageEntity.fromJson(responseJson);
  return x;
}
