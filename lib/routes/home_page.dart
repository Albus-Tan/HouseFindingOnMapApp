import 'package:app/routes/search_page.dart';
import 'package:app/widgets/house_list.dart';
import 'package:flutter/material.dart';

import '../widgets/carousel.dart';

/// 轮播的广告图片
List advertisement = [
  HouseImage(
    color: Colors.white,
    image: "assets/advertisement/advertisement1.jpg",
    title: '启航租房节',
    isStatic: true,
  ),
  HouseImage(
    color: Colors.white,
    image: "assets/advertisement/advertisement2.jpg",
    title: '海量房源',
    isStatic: true,
  ),
];

class HomePageTabBarView extends StatefulWidget {
  const HomePageTabBarView({Key? key}) : super(key: key);

  @override
  State<HomePageTabBarView> createState() => _HomePageTabBarViewState();
}

class _HomePageTabBarViewState extends State<HomePageTabBarView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = new TabController(
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppBar(
              title: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Container(
                        // padding: EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "搜租房",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: VerticalDivider(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    Expanded(
                      flex: 25,
                      child: TextField(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: SearchBarViewDelegate());
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: '点击搜索小区',
                          border: InputBorder.none,

                          //隐藏边框
                          // border: OutlineInputBorder(),//有边框
                          //启用背景颜色边框，可用color属性设置颜色
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.blueAccent,
              // 背景颜色
              automaticallyImplyLeading: false,
              // 后置控件
              actions: <Widget>[
                // 搜索按钮
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: SearchBarViewDelegate());
                  },
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              child: Carousel(
                key: const Key('home page Carousel'),
                items: advertisement,
                height: 150,
              ),
            ),
            TabBar(
              unselectedLabelColor: Colors.black,
              labelColor: Colors.blueAccent,
              tabs: const [
                Tab(
                  text: '推荐',
                ),
                Tab(
                  text: '附近',
                ),
                Tab(
                  text: '整租',
                ),
                Tab(
                  text: '合租',
                ),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  HouseList(
                    key: Key('recommendTabView'),
                  ),
                  HouseList(
                    key: Key('nearbyTabView'),
                  ),
                  HouseList(
                    key: Key('rentWholeTabView'),
                  ),
                  HouseList(
                    key: Key('rentTogetherTabView'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePageTabBarView();
  }
}
