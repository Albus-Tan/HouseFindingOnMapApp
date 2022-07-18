import 'dart:convert';

import 'package:app/routes/search_page.dart';
import 'package:app/utils/storage.dart';
import 'package:app/widgets/carousel.dart';
import 'package:app/widgets/house_list_nearby.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/result.dart';
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
  final String community;
  final String district;
  final String longitude;
  final String latitude;
  final String location;
  final String hid;

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
    required this.community,
    required this.district,
    required this.longitude,
    required this.latitude,
    required this.location,
    required this.hid,
  });
}

class HouseDetailPage extends StatefulWidget {
  final HouseDetail houseDetail;

  const HouseDetailPage({
    Key? key,
    required this.houseDetail,
  }) : super(key: key);

  @override
  State<HouseDetailPage> createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> {
  var isFavored = false;

  @override
  void initState() {
    _checkFavor(widget.houseDetail.hid).then((value) => {
          setState(() {
            isFavored = value;
          })
        });
    super.initState();
  }

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

  Future<bool> _checkFavor(String hid) async {
    var url =
        Uri.parse('${Constants.backend}/user/checkFavorite?house_id=$hid');
    print(url);
    http.Response response;
    var responseJson;
    Result<String> res2;
    final res = await StorageUtil.getStringItem('token');
    response = await http.post(url, headers: {'Authorization': 'Bearer $res'});
    if (response.statusCode != 200) {
      return false;
    }
    responseJson = json.decode(utf8.decode(response.bodyBytes));
    //print(responseJson);
    res2 = Result.fromJson(responseJson);
    return (res2.code == 200);
  }

  Future<void> _favor(String hid) async {
    var url = Uri.parse('${Constants.backend}/user/favor?house_id=$hid');
    http.Response response;
    var responseJson;
    Result<String> res2;
    StorageUtil.getStringItem('token').then((res) async => {
          if (res == null || res == "")
            {
              Fluttertoast.showToast(
                  msg: "Please login first", gravity: ToastGravity.TOP),
            }
          else
            {
              print('token' + res),
              response = await http
                  .post(url, headers: {'Authorization': 'Bearer $res'}),
              if (response.statusCode != 200)
                {
                  Fluttertoast.showToast(
                      msg: "Login expired! Please login again",
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.TOP,),
                }
              else
                {
                  responseJson = json.decode(utf8.decode(response.bodyBytes)),
                  res2 = Result.fromJson(responseJson),
                  if (res2.detail != null)
                    {
                      StorageUtil.setStringItem('token', res2.detail ?? ''),
                      // update token
                      setState(() {
                        isFavored = true;
                      })
                    }
                }
            }
        });
  }

  Future<void> _unFavor(String hid) async {
    var url = Uri.parse('${Constants.backend}/user/unFavor?house_id=$hid');
    http.Response response;
    var responseJson;
    Result<String> res2;
    StorageUtil.getStringItem('token').then((res) async => {
          if (res == null || res == "")
            {
              Fluttertoast.showToast(
                  msg: "Please login first", gravity: ToastGravity.TOP),
            }
          else
            {
              response = await http
                  .post(url, headers: {'Authorization': 'Bearer $res'}),
              responseJson = json.decode(utf8.decode(response.bodyBytes)),
              res2 = Result.fromJson(responseJson),
              if (res2.detail != null)
                {
                  StorageUtil.setStringItem('token', res2.detail ?? ''),
                  // update token
                  setState(() {
                    isFavored = false;
                  })
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: "Login expired! Please login again"),
                }
            }
        });
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
          key: const ValueKey('detail_favorite_button'),
          iconPressed: () {
            if (isFavored) {
              _unFavor(widget.houseDetail.hid);
            } else {
              _favor(widget.houseDetail.hid);
            }
          },
          child: Icon(
            Icons.star_border_outlined,
            color: isFavored ? Colors.amberAccent : Colors.black,
          ),
        ),
        BrnIconAction(
          key: const ValueKey('detail_search_button'),
          iconPressed: () {
            showSearch(
              context: context,
              delegate: SearchBarViewDelegate(),
            );
          },
          child: const Icon(
            Icons.search,
            color: Colors.black,
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
          constraints: const BoxConstraints(maxWidth: 320),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: houseDetail.title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
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
      key: const ValueKey('detail_bottom_buttons'),
      mainButtonName: '打电话',
      mainButtonOnTap: () {},
      secondaryButtonName: '跟我聊',
      secondaryButtonOnTap: () {},
      iconButtonList: [
        //构造Icon按钮
        BrnVerticalIconButton(
          key: const ValueKey("detail_navigation_icon"),
          name: '导航',
          iconWidget: const Icon(
            Icons.navigation_outlined,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: "navigation"),
                builder: (context) => MapNavigationPage(
                  oriLat: '',
                  oriLng: '',
                  desLat: widget.houseDetail.latitude,
                  desLng: widget.houseDetail.longitude,
                  oriText: '我的位置',
                  desText: widget.houseDetail.community != ""
                      ? widget.houseDetail.community
                      : widget.houseDetail.location,
                ),
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
                  image: widget.houseDetail.image,
                  title: '1',
                  isStatic: widget.houseDetail.isStatic),
            ),
          ),
          _renderDetailTexts(widget.houseDetail),
          Flexible(
            flex: 4,
            child: HouseListNearby(
              lat: widget.houseDetail.latitude,
              lng: widget.houseDetail.longitude,
            ),
          ),
          _renderNavigationIcon(context),
        ],
      ),
    );
  }
}
