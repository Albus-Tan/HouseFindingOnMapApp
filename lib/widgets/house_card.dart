//HouseCard组件 用于HouseList
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

import '../routes/house_detail_page.dart';

//TODO:card加收藏按钮
class HouseCard extends StatelessWidget {
  const HouseCard({
    Key? key,
    required this.title, //房子简介
    required this.rooms, //*室
    required this.squares, // *平
    required this.community, // 小区
    required this.price, // 价格：*元/月
    required this.url, //  图片url
  }) : super(key: key);

  final String title;
  final int rooms;
  final double squares;
  final String community;
  final int price;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: (url != '')
                  ? Image.network(url)
                  : Image.asset(
                      'assets/picture/404.jpg',
                    ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name:"last_detail"),
                    builder: (context) => HouseDetailPage(
                      houseDetail: HouseDetail(
                        title: title,
                        pricePerMonth: price,
                        squares: squares,
                        shiNumber: rooms,
                        image: url,
                        isStatic: false,
                      ),
                    ),
                  ),
                );
              },
              title: BrnExpandableText(
                text: title,
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
                maxLines: 2,
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: '$rooms室·$squares平·$community',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '\n$price元/月',
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
