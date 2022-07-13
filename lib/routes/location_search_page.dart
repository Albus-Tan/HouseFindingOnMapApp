import 'package:app/constant/enum.dart';
import 'package:app/service/amap_api_service/search/input_tips.dart';
import 'package:flutter/material.dart';

import '../service/amap_api_service/amap_api_service.dart';
import 'map_navigation_page.dart';

class LocationSearchPage extends SearchDelegate {

  /// 表示此处改变的是 0——起始点 还是 1——终止点
  final LocationType type;

  /// 导航的起始点终止点经纬度
  final String oriLng;
  final String oriLat;
  final String desLng;
  final String desLat;

  /// 导航的起始点终止点名称
  final String oriText;
  final String desText;

  String searchHint = "请输入地理位置名称...";

  /// 搜索提示条目
  List<Tips> inputTipsList = [];

  LocationSearchPage({
    required this.type,
    required this.oriLng,
    required this.oriLat,
    required this.desLng,
    required this.desLat,
    required this.oriText,
    required this.desText,
  }) : super(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear',
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  String get searchFieldLabel => searchHint;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  TextInputType get keyboardType => TextInputType.text; //设置输入框输入内容类型

  Future getDatas() async {
    return Future.wait([
      getInputTips(query),
    ]);
  }

  Future<void> getInputTips(String keyword) async {
    if (query == '')
      return;
    else {
      await fetchInputTips(keyword).then((value) => {
            print("fetchInputTips: "),
            print(value),
            inputTipsList.clear(),
            inputTipsList.addAll(value.tips),
          });
    }
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getInputTips(query),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: inputTipsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context){
                                List<String> location = inputTipsList[index].location.split(',');
                                return (type == LocationType.origin) ? MapNavigationPage(
                                  oriLat: location[1],
                                  oriLng: location[0],
                                  desLat: desLat,
                                  desLng: desLng,
                                  oriText: inputTipsList[index].name,
                                  desText: desText,
                                ) :  MapNavigationPage(
                                  oriLat: oriLat,
                                  oriLng: oriLng,
                                  desLat: location[1],
                                  desLng: location[0],
                                  oriText: oriText,
                                  desText: inputTipsList[index].name,
                                );
                              }
                            ),
                            ModalRoute.withName('last_detail'),
                          );
                        },
                        child: ListTile(
                          title: Text(inputTipsList[index].name),
                        ),
                      );
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
