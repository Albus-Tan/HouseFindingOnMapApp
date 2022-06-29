import 'package:app/routes/search_page.dart';
import 'package:app/widgets/carousel.dart';
import 'package:app/widgets/house_list.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

import 'map_navigation_page.dart';

class HouseDetail {
  final String title;
  final int pricePerMonth;
  final double squares;
  final String direction;
  final int shiNumber;
  final int tingNumber;
  final int weiNumber;
  final String image;
  final bool isStatic;

  HouseDetail({
    required this.title,
    required this.pricePerMonth,
    required this.squares,
    required this.shiNumber,
    this.direction = '*',
    this.tingNumber = 0,
    this.weiNumber = 0,
    this.image = "",
    this.isStatic = false,
  });
}

class HouseDetailPage extends StatelessWidget {
  final HouseDetail houseDetail;

  const HouseDetailPage({
    Key? key,
    required this.houseDetail,
  }) : super(key: key);

  /*
  * 绘制标题在上，文字在下的格式化文本
  * */
  Widget _renderWrappedText(String title, String text) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text),
      ],
    );
  }

  /*
  * 绘制AppBar，包含返回按钮，收藏按钮，查找按钮
  * 参考https://bruno.ke.com/page/widgets/brn-app-bar 效果8
  * */
  Widget _renderAppBar(BuildContext context) {
    return BrnAppBar(
      automaticallyImplyLeading: true,
      //多icon
      actions: [
        BrnIconAction(
          iconPressed: () {},
          child: Image.asset(
            'assets/icon/favorite.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
        BrnIconAction(
          iconPressed: () {
            showSearch(context: context, delegate: SearchBarViewDelegate());
          },
          child: Image.asset(
            'assets/icon/search.png',
            scale: 3.0,
            height: 20,
            width: 20,
          ),
        ),
      ],
    );
  }

  /*
  * 绘制标题和价格
  * */

  Widget _renderDetailTexts(HouseDetail houseDetail) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: BrnExpandableText(
            text: houseDetail.title,
            maxLines: 2,
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
        RichText(
          text: TextSpan(
            text: houseDetail.pricePerMonth.toString(),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
            children: const [
              TextSpan(
                text: '元/月',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _renderWrappedText(
                "${houseDetail.shiNumber}室"
                    "${houseDetail.tingNumber}厅"
                    "${houseDetail.weiNumber}卫",
                "房型",
              ),
            ),
            Expanded(
              child: _renderWrappedText(
                "${houseDetail.squares}平",
                "面积",
              ),
            ),
            Expanded(
              child: _renderWrappedText(
                houseDetail.direction,
                "朝向",
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 绘制导航图标
  Widget _renderNavigationIcon(BuildContext context) {
    return BrnBottomButtonPanel(
      mainButtonName: '打电话',
      mainButtonOnTap: () {},
      secondaryButtonName: '跟我聊',
      secondaryButtonOnTap: () {},
      iconButtonList: [
        //构造Icon按钮
        BrnVerticalIconButton(
          name: '导航',
          iconWidget: Image.asset(
            "assets/icon/navigation_icon.png",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MapNavigationPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderAppBar(context),
          renderCarousel(
            List<HouseImage>.generate(
              1,
              (index) => HouseImage(
                  image: houseDetail.image, title: '1', isStatic: houseDetail.isStatic),
            ),
          ),
          _renderDetailTexts(houseDetail),
          const Flexible(
            flex: 4,
            child: HouseList(),
          ),
          _renderNavigationIcon(context),
        ],
      ),
    );
  }
}
