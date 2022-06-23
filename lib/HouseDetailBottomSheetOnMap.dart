import 'package:flutter/material.dart';

class HouseDetailBottomSheet extends StatefulWidget {
  const HouseDetailBottomSheet({Key? key}) : super(key: key);

  @override
  State<HouseDetailBottomSheet> createState() => _HouseDetailBottomSheetState();
}

class _HouseDetailBottomSheetState extends State<HouseDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        child: Text('点击展开 bottom sheet'),
        onPressed: (){_showHouseDetailListSheet(context);},
      ),
    );
  }
}

void _showHouseDetailListSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // set this to true
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5, // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
        expand: false,
        builder: (_, controller) {
          return Container(
            color: Colors.white,
            child: ListView.builder(
              controller: controller, // set this too
              itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
            ),
          );
        },
      );
    },
  );
}

class HouseDetailListOnMap extends StatefulWidget {
  const HouseDetailListOnMap({Key? key}) : super(key: key);

  @override
  State<HouseDetailListOnMap> createState() => _HouseDetailListOnMapState();
}

class _HouseDetailListOnMapState extends State<HouseDetailListOnMap> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
