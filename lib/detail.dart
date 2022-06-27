import 'package:app/carousel.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const HouseDetailPage());
}

class HouseDetail {
  final String title;
  final int pricePerMonth;
  final int squares;
  final String direction;
  final int shiNumber;
  final int tingNumber;
  final int weiNumber;
  HouseDetail({
    required this.title,
    required this.pricePerMonth,
    required this.squares,
    required this.direction,
    required this.shiNumber,
    required this.tingNumber,
    required this.weiNumber
  });
}

HouseDetail houseDetail = HouseDetail(
    title: '2号线淞虹路地铁站，精装修一房，房东人好，可以随时看房入住',
    pricePerMonth: 3800,
    squares: 40,
    direction: '南',
    shiNumber: 1,
    tingNumber: 1,
    weiNumber: 1,
);

class HouseDetailPage extends StatelessWidget {
  const HouseDetailPage({Key? key}) : super(key: key);

  /*
  * 绘制标题在上，文字在下的格式化文本
  * */
  Widget renderWrappedText(String title, String text) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
            text
        ),
      ],
    );
  }

  /*
  * 绘制AppBar，包含返回按钮，收藏按钮，查找按钮
  * 参考https://bruno.ke.com/page/widgets/brn-app-bar 效果8
  * */
  Widget renderAppBar() {
    return BrnAppBar(
          automaticallyImplyLeading: true,
          //多icon
          actions: <Widget>[
            BrnIconAction(
              iconPressed: () {},
              child: Image.asset(
                'assets/house_detail_page_appbar/favorite.png',
                scale: 3.0,
                height: 20,
                width: 20,
              ),
            ),
            BrnIconAction(
              iconPressed: () {},
              child: Image.asset(
                'assets/house_detail_page_appbar/search.png',
                scale: 3.0,
                height: 20,
                width: 20,
              ),
            )
          ],
        );
  }

  /*
  * 绘制标题和价格
  * */

  Widget renderDetailTexts(HouseDetail houseDetail) {
      return Column(
        children: [
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child:   BrnExpandableText(
                          text: houseDetail.title,
                          maxLines: 2,
                          textStyle: const TextStyle(fontSize: 20),
             )
          ),
          BrnEnhanceNumberCard(
            rowCount: 1,
            itemChildren: [
              BrnNumberInfoItemModel(
                number: houseDetail.pricePerMonth.toString(),
                lastDesc: '元/月',
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: renderWrappedText(
                  "${houseDetail.shiNumber}室${houseDetail.tingNumber}厅${houseDetail.weiNumber}卫", "房型")),
              Expanded(child: renderWrappedText("${houseDetail.squares}平", "面积")),
              Expanded(child: renderWrappedText(houseDetail.direction, "朝向")),
            ],
          )
        ],
      );
  }

  /// 绘制导航图标
  Widget renderNavigationIcon() {
     return BrnVerticalIconButton(
         name: "导航",
         iconWidget: Image.asset(
             "assets/house_detail_page_appbar/navigation_icon.png",
              //fit: BoxFit.cover,
         ),
          onTap: () {},
     );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "appbar",
      home: Scaffold(
        body: Column(
          children: [
            renderAppBar(),
            Expanded(child: renderCarousel()),
            Expanded(child: renderDetailTexts(houseDetail)),
            renderNavigationIcon(),
            //Expanded(child: renderNavigationIcon()),
          ],
        ),
      )
    );
  }
}
