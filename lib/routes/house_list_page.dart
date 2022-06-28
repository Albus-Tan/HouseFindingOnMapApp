//房屋列表页面，不存在高度溢出问题
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

import 'package:app/widgets/house_list.dart';
import 'package:app/widgets/selection.dart';

/*
  * 绘制AppBar，包含返回按钮，查找按钮
  * 参考https://bruno.ke.com/page/widgets/brn-app-bar 效果8
  * */
Widget _renderAppBar() {
  return BrnAppBar(
    automaticallyImplyLeading: true,
    actions: [
      BrnIconAction(
        iconPressed: () {},
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

class HouseListPage extends StatefulWidget {
  const HouseListPage({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _HouseListPageState();
}

class _HouseListPageState extends State<HouseListPage> {
  late final Widget selection;
  bool selectionInitialized = false;

  @override
  Widget build(BuildContext context) {
    selectionView('assets/json/selection.json').then(
      (value) => setState(
        () {
          selection = value;
          selectionInitialized = true;
        },
      ),
    );
    final list = [
      _renderAppBar(),
    ];
    if (selectionInitialized) {
      list.add(selection);
    }
    list.add(
      const Expanded(
        child: HouseList(),
      ),
    );
    return Scaffold(
      body: Column(
        children: list,
      ),
    );
  }
}
