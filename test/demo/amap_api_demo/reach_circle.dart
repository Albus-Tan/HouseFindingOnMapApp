import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:app/service/amap_api_service/amap_api_service.dart';
import 'package:app/utils/amap.dart';


void main() {

  String innerPolyline = "";
  List<LatLng> polylinePoints = [];

  // 可选参数可以再加上通勤圈 分钟数
  fetchReachCircle('116.434307','39.90909').then((value) => {
    value.polylines.forEach((polyline) => {

      print(polyline.outer),

      // 将返回的 polyline str 转换成 LatLng，并加入 List<LatLng>
      polylinePoints.addAll(convertPolylineStr2Points(polyline.outer)),

      // polyline 的拼接
      polyline.inners.forEach((inner) => {
        print(inner),
        innerPolyline = "$innerPolyline${inner};",
      }),
    }),
    print(innerPolyline.substring(0, innerPolyline.length - 1)),

    polylinePoints.forEach((element) {
      print(element.longitude);
      print(element.latitude);
    })
  });

  // Map<String, dynamic> userMap = jsonDecode(jsonString);
  // var user = User.fromJson(userMap);
  //
  // String json = jsonEncode(user);
}
