import 'dart:convert';

import 'package:app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'house/rent_house.dart';

List<RentHouse> getRentHouseList(List<dynamic> list){
  List<RentHouse> result = [];
  list.forEach((item){
    result.add(RentHouse.fromJson(item));
  });
  return result;
}

Future<List<RentHouse>> fetchAllHouse(
  String district,
  String price1,
  String price2,
  String rentType,
  String rooms,
  String metroLine,
  String metroStation,
) async {
  var url = Uri.parse(
      '${Constants.backend}/house/search/all?price1=$price1&price2=$price2'
      '&rentType=$rentType&rooms=$rooms&metro_station=$metroStation'
      '&district=$district&metro_line=$metroLine');
  var s = url.toString();
  debugPrint(s);
  final response = await http.post(url);
  final responseJson = json.decode(utf8.decode(response.bodyBytes));
  return getRentHouseList(responseJson);
}
