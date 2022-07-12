import 'package:app/routes/home_page.dart';
import 'package:app/routes/map_find_page.dart';
import 'package:app/routes/my_profile_page.dart';
import 'package:app/service/amap_location_service.dart';
import 'package:app/utils/route_observer.dart';
import 'package:app/widgets/map/reducer.dart';
import 'package:app/widgets/map/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() {
  //Redux State Init
  final store = Store(
    mapReducer,
    initialState: MapState.initialState(),
  );
  runApp(
    StoreProvider(
      store: store,
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(
          key: key,
        );

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  static const String _title = '地图找房';

  var allPages = [
    const HomePage(),
    const MapFindPage(),
    const MyProfilePage(),
  ];
  var currentPageIndex = 0;

  late AmapLocationService amapLocationService;

  @override
  void initState() {
    super.initState();
    amapLocationService = AmapLocationService();
    amapLocationService.init();
    amapLocationService.startLocation();
  }

  @override
  void dispose() {
    amapLocationService.stopLocation();
    amapLocationService.dispose();
    super.dispose(); // This will free the memory space allocated to the page
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [AppNavigatorObserver()],
      title: _title,
      //theme: ThemeData.dark(),
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
