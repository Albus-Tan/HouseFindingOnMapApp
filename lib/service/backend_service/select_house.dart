import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../utils/constants.dart';
import './select_house/house_page_entity.dart';

Future<HousePageEntity> fetchHousePage(
    String district,
    String price1,
    String price2,
    String rentType,
    String rooms,
    String metroLine,
    String metroStation,
    String keyword,
    int page,
    int pageSize) async {
  var url = Uri.parse(
      '${Constants.backend}/house/search?price1=$price1&price2=$price2'
      '&page=$page&rentType=$rentType&rooms=$rooms&metro_station=$metroStation'
      '&district=$district&pageSize=$pageSize&metro_line=$metroLine&keywords=$keyword');
  var s = url.toString();
  debugPrint(s);
  final response = await http.post(url);
  // final responseJson = jsonDecode(response.body);
  final responseJson = json.decode(utf8.decode(response.bodyBytes));
  return HousePageEntity.fromJson(responseJson);
}

Future<HousePageEntity> fetchHousePageNearBy(
    String lat, String lng, int page, int pageSize) async {
  var url = Uri.parse(
      '${Constants.backend}/house/search/nearby?lat=$lat&lng=$lng&pageSize=$pageSize&page=$page');
  var s = url.toString();
  debugPrint(s);
  final response = await http.post(url);
  // final responseJson = jsonDecode(response.body);
  final responseJson = json.decode(utf8.decode(response.bodyBytes));
  return HousePageEntity.fromJson(responseJson);
}
