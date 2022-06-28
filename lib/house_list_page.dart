//房屋列表页面，不存在高度溢出问题
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';

import 'house_list.dart';
import 'selection.dart';

/*
  * 绘制AppBar，包含返回按钮，查找按钮
  * 参考https://bruno.ke.com/page/widgets/brn-app-bar 效果8
  * */
Widget renderAppBar() {
  return BrnAppBar(
    automaticallyImplyLeading: true,
    actions: [
      BrnIconAction(
        iconPressed: () {},
        child: Image.asset(
          'assets/house_detail_page_appbar/search.png',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text(_title)),
      body: Column(
        children: [
          renderAppBar(),
          selectionView(),
          const Expanded(
            child: HouseList(),
          ),
        ],
      ),
    );
  }
}
