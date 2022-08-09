import 'package:app/constant/enum.dart';
import 'package:flutter/material.dart';

import '../service/amap_api_service/amap_api_service.dart';
import '../service/amap_api_service/search/input_tips.dart';
import '../service/backend_service/select_house.dart';
import '../utils/storage.dart';
import 'house_list_page.dart';

class SearchBarViewDelegate extends SearchDelegate<String> {
  String searchHint = "请输入小区名...";

  // final page = const HouseListPage(
  //   needAppBar: false,
  //   keyWord: "",
  // );

  /// 推荐的搜索条目
  var suggestList = ["汤臣一品", "上海交通大学"];

  /// 搜索提示条目
  List<Tips> inputTipsList = [];
  bool onChange = true;

  @override
  String get searchFieldLabel => searchHint;

  Future<void> getInputTips(String keyword) async {
    if(query == ""){
      inputTipsList.clear();
    } else {
      await fetchResidentialInputTips(keyword).then((value) => {
        print("fetchResidentialInputTips: "),
        print(value),
        inputTipsList.clear(),
        inputTipsList.addAll(value.tips),
      });
    }
  }

  // TODO
  /// 尝试修复搜索提示滞后
  // Future<void> getInputTips(String keyword) async {
  //   if (!onChange) {
  //     onChange = true;
  //     return;
  //   }
  //   if (query == '') {
  //     String que;
  //     inputTipsList.clear();
  //     que = query;
  //     query = que;
  //     onChange = false;
  //     return;
  //   } else {
  //     String que;
  //     await fetchResidentialInputTips(keyword).then((value) => {
  //           print("fetchResidentialInputTips: "),
  //           print(value),
  //           inputTipsList.clear(),
  //           inputTipsList.addAll(value.tips),
  //           que = query,
  //           query = que,
  //           onChange = false,
  //         });
  //   }
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    ///显示在最右边的控件列表
    return [
      /// 清除按钮
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";

          ///搜索建议的内容
          showSuggestions(context);
        },
      ),

      /// 搜索按钮
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () => showResults(context),
      )
    ];
  }

  ///左侧带动画的控件，此处是返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),

      ///调用 close 关闭 search 界面
      onPressed: () => close(context, ""),
    );
  }

  @override
  Widget buildResults(BuildContext context) => Container();

  @override
  void showResults(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HouseListPage(
          needAppBar: true,
          keyWord: query,
        ),
      ),
    );
    super.showResults(context);
  }

  // ///展示搜索结果
  // @override
  // Widget buildResults(BuildContext context) {
  //   List<String> result = [];
  //
  //   ///模拟搜索过程
  //   for (var str in sourceList) {
  //     ///query 就是输入框的 TextEditingController
  //     if (query.isNotEmpty && str.contains(query)) {
  //       result.add(str);
  //     }
  //   }
  //
  //   ///展示搜索结果
  //   // return ListView.builder(
  //   //   itemCount: result.length,
  //   //   itemBuilder: (BuildContext context, int index) => ListTile(
  //   //     title: Text(result[index]),
  //   //   ),
  //   // );
  //   // return page;
  //   return HouseListPage(
  //     needAppBar: false,
  //     keyWord: query,
  //   );
  // }

  Widget buildSearchContentView() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '附近推荐',
            style: TextStyle(fontSize: 16),
          ),
          SearchItemView(
              onSearchContentSelect: onSearchContentSelect,
              searchRecommendType: SearchRecommendType.nearby),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: const Text(
              '最新发布',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SearchItemView(
              onSearchContentSelect: onSearchContentSelect,
              searchRecommendType: SearchRecommendType.latest)
        ],
      ),
    );
  }

  onSearchContentSelect(String title) {
    query = title;
  }

  /// 搜索推荐下拉列表
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggest = query.isEmpty
        ? suggestList
        : inputTipsList.map((input) => input.name).toList();
    return FutureBuilder(
        future: getInputTips(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return query.isEmpty
                ? SingleChildScrollView(
                    child: buildSearchContentView(),
                  )
                : ListView.builder(
                    itemCount: suggest.length,
                    itemBuilder: (BuildContext context, int index) => InkWell(
                      child: ListTile(
                        title: RichText(
                          key: Key(suggest[index]),
                          text: TextSpan(
                            text: suggest[index],
                            style: const TextStyle(
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        query.replaceAll("", suggest[index].toString());
                        searchHint = "";
                        query = suggest[index].toString();
                        showResults(context);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => HouseListPage(
                        //       needAppBar: true,
                        //       keyWord: query,
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                  );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}

class SearchItemView extends StatefulWidget {
  const SearchItemView(
      {Key? key, this.onSearchContentSelect, this.searchRecommendType})
      : super(key: key);

  final onSearchContentSelect;
  final searchRecommendType;

  @override
  createState() => _SearchItemViewState();
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> recommendResidentialList = [];

  String lat = '';
  String lng = '';
  int page = 0, pageSize = 30;
  bool hasInit = false;

  Future<void> getHousePages() async {
    switch (widget.searchRecommendType) {
      case SearchRecommendType.nearby:
        await fetchHousePageNearBy(lat, lng, page, pageSize).then((value) => {
              value.content?.forEach((e) {
                if (e.residential != null) {
                  recommendResidentialList.add(e.residential ?? '');
                }
              }),
              recommendResidentialList =
                  recommendResidentialList.toSet().toList().sublist(0, 10),
            });
        break;
      case SearchRecommendType.latest:
        await fetchHousePage("", "", "", "", "", "", "", "", page, pageSize)
            .then((value) => {
                  value.content?.forEach((e) {
                    if (e.residential != null) {
                      recommendResidentialList.add(e.residential ?? '');
                    }
                  }),
                  recommendResidentialList =
                      recommendResidentialList.toSet().toList().sublist(0, 10),
                });
        break;
    }
  }

  Future<void> getPos() async {
    if (lat == '' || lng == '') {
      await StorageUtil.getDoubleItem('lat').then((res) async => {
            lat = res.toString(),
          });
      await StorageUtil.getDoubleItem('lng').then((res) async => {
            lng = res.toString(),
          });
    }
  }

  Future<void> initData() async {
    if (!hasInit) {
      await getPos();
      await getHousePages();
      hasInit = true;
    }
  }

  Widget buildSearchItem(String title) {
    return InkWell(
      child: Chip(
        label: Text(title),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () {
        debugPrint(title);
        widget.onSearchContentSelect(title);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initData(),
        builder: (BuildContext context, AsyncSnapshot snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.blueAccent,
              ),
            );
          } else if (snapShot.connectionState == ConnectionState.done) {
            print(snapShot.hasError);
            return Wrap(
              spacing: 10,
              // runSpacing: 0,
              children: recommendResidentialList.map((item) {
                return buildSearchItem(item);
              }).toList(),
            );
          } else {
            return Center(
              child: Text('Error: ${snapShot.error}'),
            );
          }
        });
  }
}
