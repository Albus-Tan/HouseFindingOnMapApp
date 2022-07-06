import 'package:app/routes/location_search_page.dart';
import 'package:flutter/material.dart';
import '../constant/enum.dart';
import '../service/amap_api_service/amap_api_service.dart';

class NavigationCard extends StatefulWidget {
  final String polyline; // 当前显示在界面上的
  final ValueChanged<String> onNavigate;

  /// 导航的起始点终止点经纬度
  final String oriLng;
  final String oriLat;
  final String desLng;
  final String desLat;

  /// 导航的起始点终止点名称
  final String oriText;
  final String desText;

  NavigationCard({
    Key? key,
    this.polyline = "",
    required this.onNavigate,
    required this.oriLng,
    required this.oriLat,
    required this.desLng,
    required this.desLat,
    required this.oriText,
    required this.desText,
  }) : super(key: key);

  @override
  createState() => _NavigationCardState();
}

class _NavigationCardState extends State<NavigationCard> {
  /// 路线
  Map<NavigationType, List<String>> _polylinesMap = {};

  /// 用于表明此时处于哪个的导航页面
  NavigationType _navigationType = NavigationType.driving;

  /// 此时处于第几条路径
  int _idx = 0;

  /// 路线所花费的时间距离
  Map<NavigationType, List<int>> _timeCostMap = {};
  Map<NavigationType, List<int>> _distanceCostMap = {};

  /// 导航的起始点终止点经纬度
  late String _oriLng;
  late String _oriLat;
  late String _desLng;
  late String _desLat;

  /// 导航的起始点终止点名称
  late String _oriText;
  late String _desText;

  var _futureBuilderFuture;

  @override
  void initState() {
    _oriLng = widget.oriLng;
    _oriLat = widget.oriLat;
    _desLng = widget.desLng;
    _desLat = widget.desLat;
    _oriText = widget.oriText;
    _desText = widget.desText;
    _futureBuilderFuture = getDatas();
    super.initState();
  }

  Future getDatas() async {
    return Future.wait([
      _navigationDriving(_oriLng, _oriLat, _desLng, _desLat),
      _navigationWalking(_oriLng, _oriLat, _desLng, _desLat),
      _navigationPublic(_oriLng, _oriLat, _desLng, _desLat),
      _navigationBicycle(_oriLng, _oriLat, _desLng, _desLat),
    ]);
  }

  void _updateNavigationType(NavigationType newNavigationType) {
    setState(() {
      _idx = 0;
    });
    switch (newNavigationType) {
      case NavigationType.driving:
        _navigationDriving(_oriLng, _oriLat, _desLng, _desLat);
        break;
      case NavigationType.walking:
        _navigationWalking(_oriLng, _oriLat, _desLng, _desLat);
        break;
      case NavigationType.public:
        _navigationPublic(_oriLng, _oriLat, _desLng, _desLat);
        break;
      case NavigationType.bicycle:
        _navigationBicycle(_oriLng, _oriLat, _desLng, _desLat);
        break;
      default:
        break;
    }
  }

  Future<void> _navigationPublic(
      String oriLng, String oriLat, String desLng, String desLat) async {
    String publicPolyline = "";
    if (_polylinesMap.containsKey(NavigationType.public)) {
      widget.onNavigate(_polylinesMap[NavigationType.public]?[0] ?? '');
    } else {
      await fetchPublicRoutePlan(oriLng, oriLat, desLng, desLat).then(
        (value) => {
          print("fetchPublicRoutePlan"),
          print(value.count),
          _polylinesMap[NavigationType.public] = [],
          _distanceCostMap[NavigationType.public] = [],
          _timeCostMap[NavigationType.public] = [],
          if(value.status == '1'){
            value.route.transits.forEach((path) => {
              publicPolyline = "",
              _distanceCostMap[NavigationType.public]
                  ?.add(int.parse(path.distance)),
              _timeCostMap[NavigationType.public]
                  ?.add(int.parse(path.cost.duration ?? '0')),
              path.segments.forEach((segment) => {
                segment.walking.steps.forEach((step) => {
                  publicPolyline =
                  "$publicPolyline${step.polyline.polyline};",
                }),
                segment.bus.buslines.forEach((step) => {
                  publicPolyline =
                  "$publicPolyline${step.polyline.polyline};",
                }),
              }),
              _polylinesMap[NavigationType.public]?.add(
                  publicPolyline.substring(0, publicPolyline.length - 1)),
            }),
          },
          widget.onNavigate(_polylinesMap[NavigationType.public]?[0] ?? ''),
        },
      );
    }
  }

  Future<void> _navigationDriving(
      String oriLng, String oriLat, String desLng, String desLat) async {
    String drivingPolyline = "";
    if (_polylinesMap.containsKey(NavigationType.driving)) {
      widget.onNavigate(_polylinesMap[NavigationType.driving]?[0] ?? '');
    } else {
      await fetchDrivingRoutePlan(oriLng, oriLat, desLng, desLat).then(
        (value) => {
          print("fetchDrivingRoutePlan"),
          _polylinesMap[NavigationType.driving] = [],
          _distanceCostMap[NavigationType.driving] = [],
          _timeCostMap[NavigationType.driving] = [],
          if(value.status == '1'){
            value.route.paths.forEach((path) => {
              drivingPolyline = "",
              _distanceCostMap[NavigationType.driving]
                  ?.add(int.parse(path.distance)),
              _timeCostMap[NavigationType.driving]
                  ?.add(int.parse(path.cost.duration)),
              path.steps.forEach((step) => {
                drivingPolyline = "$drivingPolyline${step.polyline};",
              }),
              _polylinesMap[NavigationType.driving]?.add(
                  drivingPolyline.substring(0, drivingPolyline.length - 1)),
            }),
          },
          widget.onNavigate(_polylinesMap[NavigationType.driving]?[0] ?? ''),
        },
      );
    }
  }

  Future<void> _navigationWalking(
      String oriLng, String oriLat, String desLng, String desLat) async {
    String walkingPolyline = "";
    if (_polylinesMap.containsKey(NavigationType.walking)) {
      widget.onNavigate(_polylinesMap[NavigationType.walking]?[0] ?? '');
    } else {
      int i;
      await fetchWalkingRoutePlan(oriLng, oriLat, desLng, desLat).then(
        (value) => {
          print("fetchWalkingRoutePlan"),
          _polylinesMap[NavigationType.walking] = [],
          _distanceCostMap[NavigationType.walking] = [],
          _timeCostMap[NavigationType.walking] = [],
          if(value.status == '1'){
            value.route.paths.forEach((path) => {
              walkingPolyline = "",
              _distanceCostMap[NavigationType.walking]
                  ?.add(int.parse(path.distance)),
              _timeCostMap[NavigationType.walking]
                  ?.add(int.parse(path.cost.duration)),
              path.steps.forEach((step) => {
                walkingPolyline = "$walkingPolyline${step.polyline};",
              }),
            }),
            _polylinesMap[NavigationType.walking]
                ?.add(walkingPolyline.substring(0, walkingPolyline.length - 1)),
          },
          widget.onNavigate(_polylinesMap[NavigationType.walking]?[0] ?? ''),
        },
      );
    }
  }

  Future<void> _navigationBicycle(
      String oriLng, String oriLat, String desLng, String desLat) async {
    String bicyclePolyline = "";
    if (_polylinesMap.containsKey(NavigationType.bicycle)) {
      widget.onNavigate(_polylinesMap[NavigationType.bicycle]?[0] ?? '');
    } else {
      await fetchBicycleRoutePlan(oriLng, oriLat, desLng, desLat).then(
        (value) => {
          print("fetchBicycleRoutePlan"),
          _polylinesMap[NavigationType.bicycle] = [],
          _distanceCostMap[NavigationType.bicycle] = [],
          _timeCostMap[NavigationType.bicycle] = [],
          if(value.status == '1'){
            value.route.paths.forEach((path) => {
              bicyclePolyline = "",
              _distanceCostMap[NavigationType.bicycle]
                  ?.add(int.parse(path.distance)),
              _timeCostMap[NavigationType.bicycle]
                  ?.add(int.parse(path.duration)),
              path.steps.forEach((step) => {
                bicyclePolyline = "$bicyclePolyline${step.polyline};",
              }),
            }),
            _polylinesMap[NavigationType.bicycle]
                ?.add(bicyclePolyline.substring(0, bicyclePolyline.length - 1)),
          },
          widget.onNavigate(_polylinesMap[NavigationType.bicycle]?[0] ?? ''),
        },
      );
    }
  }

  void _handleRouteIdxChanged(int newIdx) {
    setState(() {
      _idx = newIdx;
    });
    widget.onNavigate(_polylinesMap[_navigationType]?[newIdx] ?? '');
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
                      labelText: _oriText,
                      hintText: '请输入出发地',
                      prefixIconColor: Colors.green,
                      onInputTextChanged: _handleOriTextChanged,
                      inputText: _oriText,
                      locationType: LocationType.origin,
                      oriLat: widget.oriLat,
                      oriLng: widget.oriLng,
                      desLat: widget.desLat,
                      desLng: widget.oriLng,
                      oriText: widget.oriText,
                      desText: widget.desText,
                    ),
                    TextFieldDemo(
                      labelText: _desText,
                      hintText: '请输入目的地',
                      prefixIconColor: Colors.red,
                      onInputTextChanged: _handleDesTextChanged,
                      inputText: _desText,
                      locationType: LocationType.destination,
                      oriLat: widget.oriLat,
                      oriLng: widget.oriLng,
                      desLat: widget.desLat,
                      desLng: widget.oriLng,
                      oriText: widget.oriText,
                      desText: widget.desText,
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
                      print("按钮 pressed");

                      // TODO 在应用内导航
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
      expand: true,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100,
              color: Colors.white,
              child: buildNavigationForm(context),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Container(
                color: Colors.white,
                child: FutureBuilder(
                    future: _futureBuilderFuture,
                    builder: (BuildContext context, AsyncSnapshot snapShot) {
                      print('connectionState:${snapShot.connectionState}');
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.redAccent,
                          ),
                        );
                      } else if (snapShot.connectionState ==
                          ConnectionState.done) {
                        print(snapShot.hasError);
                        return NavigationResultBar(
                          navigationType: _navigationType,
                          onNavigationTypeChanged:
                              _handleNavigationResultBarChanged,
                          timeCostMap: _timeCostMap,
                          distanceCostMap: _distanceCostMap,
                          scrollController: scrollController,
                          idx: _idx,
                          onRouteIdxChanged: _handleRouteIdxChanged,
                        );
                      } else {
                        return Text('Error: ${snapShot.error}');
                      }
                    }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NavigationResultBar extends StatefulWidget {
  const NavigationResultBar(
      {Key? key,
      required this.navigationType,
      required this.onNavigationTypeChanged,
      required this.timeCostMap,
      required this.distanceCostMap,
      required this.scrollController,
      required this.idx,
      required this.onRouteIdxChanged})
      : super(key: key);

  final NavigationType navigationType;
  final ValueChanged<NavigationType> onNavigationTypeChanged;

  final int idx;
  final ValueChanged<int> onRouteIdxChanged;

  /// 路线所花费的时间距离
  final Map<NavigationType, List<int>> timeCostMap;
  final Map<NavigationType, List<int>> distanceCostMap;

  final ScrollController scrollController;

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

  Widget buildNavigationResultListView(NavigationType type) {
    return (widget.timeCostMap[type]?.length == null) ? const Center(
      child: Text("暂无数据", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 15),),
    ) : ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.timeCostMap[type]?.length,
      itemBuilder: (BuildContext context, int index) {
        return buildNavigationResultCard(
            type,
            widget.timeCostMap[type]?[index] ?? 0,
            widget.distanceCostMap[type]?[index] ?? 0,
            index);
      },
    );
  }

  Widget buildNavigationResultTabBarView() {
    return TabBarView(
      children: [
        buildNavigationResultListView(NavigationType.driving),
        buildNavigationResultListView(NavigationType.walking),
        buildNavigationResultListView(NavigationType.public),
        buildNavigationResultListView(NavigationType.bicycle),
      ],
    );
  }

  //时间转换 将秒转换为小时分钟
  String _durationTransform(int seconds) {
    var d = Duration(seconds: seconds);
    List<String> parts = d.toString().split(':');
    return (parts[0] != '0') ? '${parts[0]}小时${parts[1]}分钟' : '${parts[1]}分钟';
  }

  String _distanceTransform(int meters) {
    if (meters < 1000) {
      return '$meters米';
    } else {
      var km = (meters / 1000.0).toStringAsFixed(2);
      return '$km千米';
    }
  }

  Widget buildNavigationResultCard(
      NavigationType type, int time, int distance, int index) {
    print("buildNavigationResultCard: ");
    print(widget.timeCostMap[type]);
    String timeCost = _durationTransform(time);
    String distanceCost = _distanceTransform(distance);
    return Center(
      child: Container(
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
            child: ListTile(
              title: (index == widget.idx)
                  ? Text(
                      "$timeCost（当前）",
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w900),
                    )
                  : Text(timeCost),
              subtitle: Text(distanceCost),
              onTap: () {
                widget.onRouteIdxChanged(index);
              },
              // 列表尾部的图标
              trailing: Icon(Icons.chevron_right),
            ),
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
  final LocationType locationType;
  final String labelText;
  final String hintText;
  final MaterialColor prefixIconColor;

  final String inputText;
  final ValueChanged<String> onInputTextChanged;

  /// 导航的起始点终止点经纬度
  final String oriLng;
  final String oriLat;
  final String desLng;
  final String desLat;

  /// 导航的起始点终止点名称
  final String oriText;
  final String desText;

  const TextFieldDemo({
    Key? key,
    this.labelText = '',
    this.hintText = '',
    this.prefixIconColor = Colors.grey,
    this.inputText = '',
    required this.onInputTextChanged,
    required this.locationType,
    required this.oriLng,
    required this.oriLat,
    required this.desLng,
    required this.desLat,
    required this.oriText,
    required this.desText,
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
        maxLines: 1,
        readOnly: true,
        onTap: () {
          showSearch(
            context: context,
            delegate: LocationSearchPage(
              type: widget.locationType,
              oriLat: widget.oriLat,
              oriLng: widget.oriLng,
              desLat: widget.desLat,
              desLng: widget.oriLng,
              oriText: widget.oriText,
              desText: widget.desText,
            ),
          );
        },
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
