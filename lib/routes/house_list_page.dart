//房屋列表页面，不存在高度溢出问题
import 'package:app/routes/search_page.dart';
import 'package:app/widgets/house_list.dart';
import 'package:app/widgets/selection.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

import '../service/backend_service/select_house.dart';
import '../widgets/house_card.dart';

/*
  * 绘制AppBar，包含返回按钮，查找按钮
  * 参考https://bruno.ke.com/page/widgets/brn-app-bar 效果8
  * */
Widget _renderAppBar(BuildContext context, String keyword) {
  return BrnAppBar(
    title: keyword,
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
    this.keyWord = "",
  }) : super(key: key);

  final bool needAppBar;
  final String keyWord;

  @override
  createState() => _HouseListPageState();
}

class _HouseListPageState extends State<HouseListPage> {
  late Widget selection;
  HouseList houseList = HouseList();
  bool selectionInitialized = false;
  Map<String, String>? filter;
  String district = "",
      rentType = "",
      rooms = "",
      metroLine = "",
      metroStation = "",
      price1 = "",
      price2 = "";

  final _houseCards = <HouseCard>[];
  final hasFetched = <int>{};
  final pageSize = 10;

  var totalElement = 0;
  var fetchedElement = 0;

  void callback(
    int menuIndex,
    Map<String, String> filterParams,
    Map<String, String> customParams,
    BrnSetCustomSelectionMenuTitle setCustomTitleFunction,
  ) {
    setState(
      () {
        filter = filterParams;
        debugPrint(filterParams.toString());
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
      },
    );
    init();
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
    init();
  }

  Future<void> getHouses(int page) async {
    if (_houseCards.length == totalElement) return;
    await fetchHousePage(
      district,
      price1,
      price2,
      rentType,
      rooms,
      metroLine,
      metroStation,
      widget.keyWord,
      page,
      pageSize,
    ).then(
      (value) {
        // debugPrint("fetchHousePage: $page $_houseCards"),
        value.content?.forEach(
          (e) {
            _houseCards.add(
              e.toHouseCard(),
            );
          },
        );
        setState(
          () {
            fetchedElement = _houseCards.length;
          },
        );
      },
    );
  }

  Future<void> init() async {
    await fetchHousePage(
      district,
      price1,
      price2,
      rentType,
      rooms,
      metroLine,
      metroStation,
      widget.keyWord,
      0,
      pageSize,
    ).then(
      (value) {
        _houseCards.clear();
        value.content?.forEach(
          (e) {
            _houseCards.add(
              e.toHouseCard(),
            );
          },
        );
        setState(
          () {
            fetchedElement = _houseCards.length;
            totalElement = value.totalElements ?? 0;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = widget.needAppBar
        ? <Widget>[
            _renderAppBar(context, widget.keyWord),
          ]
        : <Widget>[];
    if (selectionInitialized) {
      list.add(selection);
    }
    list.add(
      Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          //加了这个HouseList外面就不用了加Container或Expanded了
          itemCount: fetchedElement + 1,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            if (index < fetchedElement) {
              return _houseCards[index];
            } else if (index != totalElement) {
              getHouses(_houseCards.length ~/ 10);
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Text("已经到底啦");
            }
          },
          separatorBuilder: (
            BuildContext context,
            int index,
          ) {
            return const Divider();
          },
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
