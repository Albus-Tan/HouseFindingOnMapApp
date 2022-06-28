import 'package:flutter/material.dart';
import 'package:bruno/bruno.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  // 私有方法
  List<Widget> _getData() {
    List<Widget> list = [];
    for (int i = 0; i < 30; i++) {
      // TODO: 修改为 用户收藏的 房屋详情信息卡
      list.add(ListTile(
        title: Text("收藏$i"),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('地图找房'),
      ),
      body: Column(
        children:[
          const ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: CircleAvatar(
              backgroundImage: NetworkImage("https://i-1-lanrentuku.52tup.com"
                  "/2020/11/5/8cc3854a-c8bd-456a-8b36-9209de3ccbfb.png?imageV"
                  "iew2/2/w/1024/"),
            ),
            title: Text("用户名"),
            subtitle: Text(
              "用户信息",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                color: Color(0xFFE8E8E8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE8E8E8),
                    offset: Offset(8, 8),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: BrnShadowCard(
                padding: const EdgeInsets.all(15),
                circular: 10,
                color: Colors.white,
                child: BrnEnhanceNumberCard(
                  rowCount: 2,
                  itemChildren: [
                    BrnNumberInfoItemModel(
                      title: '我的收藏',
                      number: '24',
                    ),
                    BrnNumberInfoItemModel(
                      title: '最近浏览',
                      number: '180',
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 30,
            ),
            child: const Text(
              '我的收藏',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: _getData(),
            ),
          )
        ],
      ),
    );
  }
}
