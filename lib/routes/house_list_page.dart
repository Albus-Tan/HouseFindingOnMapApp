//房屋列表页面，不存在高度溢出问题
import 'package:app/routes/search_page.dart';
import 'package:app/widgets/house_list.dart';
import 'package:app/widgets/selection.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

/*
  * 绘制AppBar，包含返回按钮，查找按钮
  * 参考https://bruno.ke.com/page/widgets/brn-app-bar 效果8
  * */
Widget _renderAppBar(BuildContext context) {
  return BrnAppBar(
    automaticallyImplyLeading: true,
    actions: [
      BrnIconAction(
        iconPressed: () {
          showSearch(context: context, delegate: SearchBarViewDelegate());
        },
        child: const Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    ],
  );
}

class HouseListPage extends StatefulWidget {
  const HouseListPage({
    Key? key,
    this.needAppBar = true,
  }) : super(key: key);

  final bool needAppBar;

  @override
  createState() => _HouseListPageState();
}

class _HouseListPageState extends State<HouseListPage> {
  late Widget selection;
  bool selectionInitialized = false;
  Map<String, String>? filter;
  String district = "",
      rentType = "",
      rooms = "",
      metroLine = "",
      metroStation = "",
      price1 = "",
      price2 = "";

  void callback(
      int menuIndex,
      Map<String, String> filterParams,
      Map<String, String> customParams,
      BrnSetCustomSelectionMenuTitle setCustomTitleFunction) {
    setState(() {
      filter = filterParams;
      debugPrint(filterParams.toString());
      // debugPrint(filterParams["price"]);
      // debugPrint(filterParams["户型"]);
      // debugPrint(filterParams["region"]);
      if (filter != null) {
        district = filter!["region"] ?? "";
        rooms = filter!["户型"] ?? "";
        metroLine = filter!["subway"] ?? "";
        metroStation = filter?["station"] ?? "";
        rentType = filter?["类型"] ?? "";
        if (filter!["price"] != null) {
          String s = filter!["price"]!;
          List<String> x = s.split(':');
          price1 = x[0];
          price2 = x[1];
        } else {
          price1 = "";
          price2 = "";
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectionView('assets/json/selection.json', callback).then(
      (value) => setState(
        () {
          selection = value;
          selectionInitialized = true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.needAppBar
        ? <Widget>[
            _renderAppBar(context),
          ]
        : <Widget>[];
    if (selectionInitialized) {
      list.add(selection);
    }
    list.add(
      Expanded(
        child: HouseList(
          district: district,
          rentType: rentType,
          rooms: rooms,
          metroLine: metroLine,
          metroStation: metroStation,
          price1: price1,
          price2: price2,
        ),
      ),
    );
    return Scaffold(
      body: Column(
        children: list,
      ),
    );
  }
}
