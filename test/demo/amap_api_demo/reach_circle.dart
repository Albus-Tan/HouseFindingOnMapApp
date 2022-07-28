import 'package:app/service/amap_api_service/amap_api_service.dart';


void main() {

  String innerPolyline = "";
  fetchReachCircle('116.434307','39.90909').then((value) => {
    value.polylines.forEach((polyline) => {
      print(polyline.outer),
      polyline.inners.forEach((inner) => {
        print(inner),
        innerPolyline = "$innerPolyline${inner};",
      }),
    }),
    print(innerPolyline.substring(0, innerPolyline.length - 1)),
  });

  // Map<String, dynamic> userMap = jsonDecode(jsonString);
  // var user = User.fromJson(userMap);
  //
  // String json = jsonEncode(user);
}
