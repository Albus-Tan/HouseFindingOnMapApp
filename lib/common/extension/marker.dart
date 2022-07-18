import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/common/extension/widget.dart';
import 'package:app/widgets/map/type.dart';
import 'package:flutter/cupertino.dart';

extension WidgetMarker on Marker {
  Future<Marker> copyWithWidget({required Widget widget}) async {
    return copyWith(
      iconParam: BitmapDescriptor.fromBytes(
        (await widget.toUint8List())!,
      ),
    );
  }
}

extension WidgetHouseMarker on HouseMarker {
  Future<HouseMarker> copyWithWidget({required Widget widget}) async {
    return copyWithHouses(
      iconParam: BitmapDescriptor.fromBytes(
        (await widget.toUint8List())!,
      ),
    );
  }
}
