import 'package:app/service/amap_api_service/amap_api_service.dart';


void main() {
  fetchDrivingRoutePlan('116.434307','39.90909','116.434446','39.90816').then((value) => print(value.count));

  // Map<String, dynamic> userMap = jsonDecode(jsonString);
  // var user = User.fromJson(userMap);
  //
  // String json = jsonEncode(user);
}
