import 'package:amap_flutter_base/amap_flutter_base.dart';

List<LatLng> convertPolylineStr2Points(String polylineStr){
  List<LatLng> polylinePoints = [];
  List<String> pointsStrs = polylineStr.split(";");
  for (int i = 0; i < pointsStrs.length; ++i) {
    List<String> latlng = pointsStrs[i].split(",");
    double lng = double.parse(latlng[0]);
    double lat = double.parse(latlng[1]);
    polylinePoints.add(LatLng(lat, lng));
  }
  return polylinePoints;
}

