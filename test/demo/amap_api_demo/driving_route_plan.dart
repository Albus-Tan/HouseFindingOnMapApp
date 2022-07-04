import 'package:app/service/amap_api_service/amap_api_service.dart';


void main() {
  // 116.2,113.3;113.2,112.;...
  // [
  //   {
  //     lat: 116.2,
  //     lng: 116.2,
  //   }
  // ]
  String polyline = "";
  fetchDrivingRoutePlan('116.434307','39.90909','116.434446','39.90816').then((value) => {
    print(value.count),
    print(value.route.taxiCost),
    value.route.paths.forEach((path) => {
      path.steps.forEach((step) => {
        polyline = "$polyline${step.polyline};",
      }),
    }),
    print(polyline.substring(0, polyline.length - 1)),
  });

  // Map<String, dynamic> userMap = jsonDecode(jsonString);
  // var user = User.fromJson(userMap);
  //
  // String json = jsonEncode(user);
}
