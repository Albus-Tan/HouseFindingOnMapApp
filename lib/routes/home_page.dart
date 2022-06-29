import 'package:flutter/material.dart';

import 'package:app/widgets/house_list.dart';

class HomePageTabBarView extends StatefulWidget {
  const HomePageTabBarView({Key? key}) : super(key: key);

  @override
  _HomePageTabBarViewState createState() => _HomePageTabBarViewState();
}

class _HomePageTabBarViewState extends State<HomePageTabBarView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: '推荐',
              ),
              Tab(
                text: '附近',
              ),
              Tab(
                text: '整租',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Expanded(
              child: HouseList(),
            ),
            Expanded(
              child: HouseList(),
            ),
            Expanded(
              child: HouseList(),
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
