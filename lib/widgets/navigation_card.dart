import 'package:flutter/material.dart';
import '../service/amap_api_service/amap_api_service.dart';

enum NavigationType {
  driving,
  walking,
  public,
  bicycle,
}

class NavigationCard extends StatefulWidget {
  final String polyline; // 当前显示在界面上的
  final ValueChanged<String> onNavigate;

  NavigationCard({
    Key? key,
    this.polyline = "",
    required this.onNavigate,
  }) : super(key: key);

  @override
  createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {

  Map<NavigationType, String> _polylinesMap = {};

  /// 用于表明此时处于哪个的导航页面
  NavigationType _navigationType = NavigationType.driving;

  /// 导航的起始点终止点经纬度
  String _oriLng = "116.434307";
  String _oriLat = "39.90909";
  String _desLng = "116.434446";
  String _desLat = "39.90816";

  /// 导航的起始点终止点名称
  String _oriText = "11111";
  String _desText = "22222";


  void _updateNavigationType(NavigationType newNavigationType) {
    print(_polylinesMap);
    // TODO: finish all types
    switch (newNavigationType) {
      case NavigationType.driving:
        _navigationDriving(_oriLng, _oriLat, _desLng, _desLat);
        break;
      case NavigationType.walking:
        break;
      case NavigationType.public:
        break;
      case NavigationType.bicycle:
        break;
      default:
        break;
    }
  }

  void _navigationDriving(
      String oriLng, String oriLat, String desLng, String desLat) async {
    String drivingPolyline = "";
    if (_polylinesMap.containsKey(NavigationType.driving)) {
      widget.onNavigate(_polylinesMap[NavigationType.driving] ?? '');
    } else {
      await fetchDrivingRoutePlan(oriLng, oriLat, desLng, desLat)
          .then((value) => {
                print("fetchDrivingRoutePlan"),
                print(value.count),
                print(value.route.taxiCost),
                value.route.paths.forEach((path) => {
                      path.steps.forEach((step) => {
                            drivingPolyline =
                                "$drivingPolyline${step.polyline};",
                          }),
                    }),
                // setState(() {
                //
                // }),
                _polylinesMap[NavigationType.driving] =
                drivingPolyline.substring(0, drivingPolyline.length - 1),
                widget.onNavigate(
                    drivingPolyline.substring(0, drivingPolyline.length - 1)),
              });
    }
  }

  void _handleNavigationResultBarChanged(NavigationType newNavigationType) {
    print("_handleNavigationResultBarChanged: $newNavigationType");
    setState(() {
      _navigationType = newNavigationType;
    });
    _updateNavigationType(newNavigationType);
  }

  void _handleOriTextChanged(String newOriText) {
    print("_handleOriTextChanged: $newOriText");
    setState(() {
      _oriText = newOriText;
    });
  }

  void _handleDesTextChanged(String newDesText) {
    print("_handleDesTextChanged: $newDesText");
    setState(() {
      _desText = newDesText;
    });
  }

  Widget buildNavigationForm(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFieldDemo(
                      labelText: '起始点',
                      hintText: '请输入出发地',
                      prefixIconColor: Colors.green,
                      onInputTextChanged: _handleOriTextChanged,
                      inputText: _oriText,
                    ),
                    TextFieldDemo(
                      labelText: '终止点',
                      hintText: '请输入目的地',
                      prefixIconColor: Colors.red,
                      onInputTextChanged: _handleDesTextChanged,
                      inputText: _desText,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  color: Colors.white70,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print("按钮 导航 pressed");
                      _updateNavigationType(_navigationType);
                    },
                    icon: const Icon(Icons.near_me),
                    label: const Text("导航"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      //change background color of button
                      onPrimary: Colors.white,
                      //change text color of button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
      minChildSize: 0.4,
      // 限制child最小高度, minChildSize必须 <= initialChildSize
      maxChildSize: 0.4,
      // 限制child最大高度,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                color: Colors.white,
                child: buildNavigationForm(context),
              ),
              Container(
                height: 200,
                color: Colors.white,
                child: NavigationResultBar(
                  navigationType: _navigationType,
                  onNavigationTypeChanged: _handleNavigationResultBarChanged,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NavigationResultBar extends StatefulWidget {
  const NavigationResultBar(
      {Key? key,
      required this.navigationType,
      required this.onNavigationTypeChanged})
      : super(key: key);

  final NavigationType navigationType;
  final ValueChanged<NavigationType> onNavigationTypeChanged;

  @override
  State<NavigationResultBar> createState() => _NavigationResultBarState();
}

class _NavigationResultBarState extends State<NavigationResultBar> {
  Widget buildNavigationResultTabBar() {
    return TabBar(
      onTap: (int index) {
        print('Selected......$index');
        widget.onNavigationTypeChanged(NavigationType.values[index]);
      },
      unselectedLabelColor: Colors.redAccent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.redAccent,
            Colors.orangeAccent,
          ],
        ),
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(50),
      ),
      tabs: [
        Row(
          children: const [
            Icon(Icons.directions_car),
            SizedBox(width: 10),
            Text("驾车"),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.directions_walk),
            SizedBox(width: 10),
            Text("步行"),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.directions_bus),
            SizedBox(width: 10),
            Text("公交"),
          ],
        ),
        Row(
          children: const [
            Icon(Icons.directions_bike),
            SizedBox(width: 10),
            Text("骑行"),
          ],
        ),
      ],
    );
  }

  Widget buildNavigationResultTabBarView() {
    return TabBarView(
      children: [
        ListView.builder(
          //controller: scrollController,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return buildNavigationResultCard();
          },
        ),
        ListView.builder(
          //controller: scrollController,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return buildNavigationResultCard();
          },
        ),
        ListView.builder(
          //controller: scrollController,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return buildNavigationResultCard();
          },
        ),
        ListView.builder(
          //controller: scrollController,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return buildNavigationResultCard();
          },
        ),
      ],
    );
  }

  Widget buildNavigationResultCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Card(
        color: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        // 抗锯齿
        clipBehavior: Clip.antiAlias,
        elevation: 5.0,
        child: Container(
          height: 80,
          alignment: Alignment.center,

          // 演示 ListTile
          child: const ListTile(
            title: Text("20分钟"),
            subtitle: Text("1003m"),

            // 列表尾部的图标
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: <Widget>[
          //设置选项卡
          Material(
            //这里设置tab的背景色
            color: Colors.white,
            child: buildNavigationResultTabBar(),
          ),
          Expanded(
            flex: 1,
            child: buildNavigationResultTabBarView(), //设置选项卡对应的page
          )
        ],
      ),
    );
  }
}

class TextFieldDemo extends StatefulWidget {
  final String labelText;
  final String hintText;
  final MaterialColor prefixIconColor;

  final String inputText;
  final ValueChanged<String> onInputTextChanged;

  const TextFieldDemo({
    Key? key,
    this.labelText = '',
    this.hintText = '',
    this.prefixIconColor = Colors.grey,
    this.inputText = '',
    required this.onInputTextChanged,
  }) : super(key: key);

  @override
  createState() => _TextFieldDemoState();
}

class _TextFieldDemoState extends State<TextFieldDemo> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: TextField(
        onChanged: (value) {
          widget.onInputTextChanged(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.trip_origin,
            color: widget.prefixIconColor,
            size: 12,
          ),
          //图标
          labelText: widget.labelText,
          //题目
          hintText: widget.hintText,
          //提示文字
          border: InputBorder.none,
          //隐藏边框
          // border: OutlineInputBorder(),//有边框
          filled: true,
          //启用背景颜色边框，可用color属性设置颜色
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
