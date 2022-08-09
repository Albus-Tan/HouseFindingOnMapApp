//HouseCard组件 用于HouseList
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

import '../routes/house_detail_page.dart';
import '../service/image_service.dart';

//TODO:card加收藏按钮
class HouseCard extends StatelessWidget {
  const HouseCard({
    Key? key,
    required this.houseDetail,
    this.onChangeCallback,
  }) : super(key: key);

  final HouseDetail houseDetail;
  final Function? onChangeCallback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: (houseDetail.compressedImage != '')
                  ? getNetWorkImage(houseDetail.compressedImage)
                  : noImage,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: "last_detail"),
                    builder: (context) => HouseDetailPage(
                      houseDetail: houseDetail,
                    ),
                  ),
                ).then((val)=> {
                  onChangeCallback!(),
                });
              },
              title: BrnExpandableText(
                text: houseDetail.title,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 2,
              ),
              subtitle: RichText(
                text: TextSpan(
                  text:
                      '${houseDetail.shiNumber}室·${houseDetail.squares}平·${houseDetail.community}·${houseDetail.district}',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '\n${houseDetail.pricePerMonth}元/月',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
