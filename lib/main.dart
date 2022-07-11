import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:app/routes/home_page.dart';
import 'package:app/routes/map_find_page.dart';
import 'package:app/routes/my_profile_page.dart';
import 'package:app/utils/route_observer.dart';
import 'package:app/utils/storage.dart';
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

  //Amap Permission
  AMapFlutterLocation.updatePrivacyAgree(true);
  AMapFlutterLocation.updatePrivacyShow(true, true);
  const AMapPrivacyStatement(hasContains: true, hasShow: true, hasAgree: true);

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

  @override
  void initState() {
    super.initState();
    // Amap location
    AMapFlutterLocation().startLocation();
    AMapFlutterLocation().onLocationChanged().listen(
          (Map<String, Object> result) {
        print(result.toString());
        StorageUtil.setDoubleItem(
          'lat',
          double.parse(
            result['latitude'].toString(),
          ),
        );
        StorageUtil.setDoubleItem(
          'lng',
          double.parse(
            result['longitude'].toString(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    AMapFlutterLocation().stopLocation();
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
