import 'package:app/routes/house_detail_page.dart';
import 'package:flutter/material.dart';

import 'house_card.dart';

// 地图找房页面 点击某小区后，从下方弹出的房源详情列表 sheet
class HouseDetailBottomSheet extends StatefulWidget {
  const HouseDetailBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _HouseDetailBottomSheetState();
}

class _HouseDetailBottomSheetState extends State<HouseDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: const Text('点击展开 bottom sheet'),
      onPressed: () {
        _showHouseDetailListSheet(context);
      },
    );
  }
}

void _showHouseDetailListSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // set this to true
    builder: (_) {
      return DraggableScrollableSheet(
        initialChildSize: 0.5,
        // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
        expand: false,
        builder: (_, controller) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                const ListTile(
                  title: Text(
                    '小区名称',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: Text('均价·房源套数等信息'),
                  trailing: Icon(Icons.keyboard_arrow_down),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: controller, // set this too
                    // 长度
                    itemCount: 15,
                    itemBuilder: (_, i) => HouseCard(
                      houseDetail: HouseDetail(
                        title: "title",
                        shiNumber: 3,
                        squares: 33,
                        community: "community",
                        pricePerMonth: 250,
                        image: '',
                        district: "上海",
                        longitude: '0',
                        latitude: '0',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
