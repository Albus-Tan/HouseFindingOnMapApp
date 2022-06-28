import 'package:app/widgets/house_detail_bottom_sheet_on_map.dart';
import 'package:app/routes/house_list_page.dart';
import 'package:app/routes/my_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/map.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const String _title = '地图找房';

  var allPages = [
    const HouseListPage(),
    Stack(
      children: [
        const MapWidget(),
        Column(
          children: const [
            Text('这是为了占用空间的一行字'),
            HouseDetailBottomSheet(),
          ],
        ),
      ],
    ),
    const MyProfilePage()
  ];
  var currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: allPages[currentPageIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentPageIndex,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "首页",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "地图找房",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              label: "我的",
            ),
          ],
          onTap: (index) {
            setState(() {
              //print("select index is :$index");
              currentPageIndex = index;
            });
          },
        ),
      ),
    );
  }
}
