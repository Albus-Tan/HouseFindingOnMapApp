import 'package:amap_flutter_base/amap_flutter_base.dart';
import 'package:amap_flutter_map/amap_flutter_map.dart';
import 'package:app/common/extension/marker.dart';
import 'package:app/common/extension/widget.dart';
import 'package:app/widgets/map/action.dart';
import 'package:app/widgets/map_find_marker.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../constant/shanghai_district.dart';
import '../service/amap_api_service/amap_api_service.dart';
import '../service/backend_service/house/rent_house.dart';
import '../service/backend_service/map_find_house.dart';
import '../utils/amap.dart';
import '../utils/district_calculate.dart';
import '../utils/storage.dart';
import '../widgets/house_card.dart';
import '../widgets/house_list/house_data.dart';
import '../widgets/map.dart';
import '../widgets/map/state.dart';
import '../widgets/map/type.dart';
import '../widgets/selection.dart';

class MapFindPage extends StatefulWidget {
  const MapFindPage({Key? key}) : super(key: key);

  @override
  State<MapFindPage> createState() => _MapFindPageState();
}

class _MapFindPageState extends State<MapFindPage> {
  /// 所有房源数据
  List<RentHouse> houses = [];

  /// 地图上房源小区 Marker
  String focusingMarkerId = "";

  /// 在圈内的 markers 的 id
  Set<String> markersIdInPolygon = {};

  /// 被点击过的 markers id 与 相应小区及房源信息 map
  Map<String, HouseMarker?> tappedMarkers = {};

  /// 筛选条件组件
  bool selectionChanged = false;
  late Widget selection;
  bool selectionInitialized = false;
  Map<String, String>? filter;
  String district = "",
      rentType = "",
      rooms = "",
      metroLine = "",
      metroStation = "",
      price1 = "",
      price2 = "";

  /// 位置
  double currentPositionLat = 31.2382;
  double currentPositionLng = 121.4913;

  void callback(
      int menuIndex,
      Map<String, String> filterParams,
      Map<String, String> customParams,
      BrnSetCustomSelectionMenuTitle setCustomTitleFunction) {
    setState(
      () {
        filter = filterParams;
        print(filterParams.toString());
        if (filter != null) {
          district = filter!["region"] ?? "";
          rooms = filter!["户型"] ?? "";
          metroLine = filter!["subway"] ?? "";
          metroStation = filter?["station"] ?? "";
          rentType = filter?["类型"] ?? "";
          if (filter!["price"] != null) {
            String s = filter!["price"]!;
            List<String> x = s.split(':');
            price1 = x[0];
            price2 = x[1];
          } else {
            price1 = "";
            price2 = "";
          }
          selectionChanged = true;
        }
      },
    );
  }

  updateFilteredHouse(Store<MapState> store) {
    int priceLow = (price1 == '')
        ? -1
        : int.parse(
            price1,
          );
    int priceHigh = (price2 == '')
        ? -1
        : int.parse(
            price2,
          );

    int mLine = (metroLine == '')
        ? -1
        : int.parse(
            metroLine,
          );
    //TODO
    List<String> zhan = (metroStation == '')
        ? []
        : metroStation.split(
            ',',
          );

    List<int> shi = [];
    List<String> x = (rooms == '') ? [] : rooms.split(',');
    for (final xi in x) {
      shi.add(int.parse(xi));
    }

    List<int> rType = [];
    List<String> y = (rentType == '') ? [] : rentType.split(',');
    for (final yi in y) {
      rType.add(int.parse(yi));
    }
    final state = store.state;
    final residentialMarkers = keyByHouseMarkerId(
      state.communityMarkers,
    );

    for (final marker in state.oriMarkers) {
      final housesList = marker.houses;
      final filteredHousesList = <RentHouse>[];
      bool residentialHasMeetRequirement = false;
      // 遍历检查是否有符合条件的
      for (final house in housesList) {
        bool houseMeetRequirement = true;

        // region
        if (district != '' && house.district != district) {
          houseMeetRequirement = false;
        }

        // price
        if (priceLow != -1 &&
            (house.price < priceLow || house.price > priceHigh)) {
          houseMeetRequirement = false;
        }

        // shi
        if (shi.isNotEmpty) {
          houseMeetRequirement =
              houseMeetRequirement && shi.any((e) => e == house.shi);
        }

        // type
        if (rType.isNotEmpty) {
          houseMeetRequirement =
              houseMeetRequirement && rType.any((e) => e == house.rentType);
        }

        // metro
        if (mLine != -1 && mLine != house.metroLine) {
          houseMeetRequirement = false;
        }

        if (houseMeetRequirement) {
          filteredHousesList.add(house);
        }
      }

      residentialHasMeetRequirement = filteredHousesList.isNotEmpty;
      late final List<HouseMarker> markersInPolygon;
      switch (state.mapStatus) {
        case MapStatus.normal:
          markersInPolygon = [];
          break;
        case MapStatus.drawing:
        case MapStatus.drawn:
          markersInPolygon = state.markersInDrawingPolygon;
          break;
        case MapStatus.selecting:
        case MapStatus.selected:
        case MapStatus.recommending:
          markersInPolygon = state.markersInReachingPolygon;
          break;
      }
      final markersInPolygonMap = keyByHouseMarkerId(markersInPolygon);
      if (residentialHasMeetRequirement &&
          filteredHousesList.length !=
              residentialMarkers[marker.id]?.houses.length) {
        final residentialMapFindMarker = ResidentialMapFindMarker(
          residential: filteredHousesList[0].residential ?? '',
          num: filteredHousesList.length,
          inPolygon: markersInPolygonMap.containsKey(
            marker.id,
          ),
        );
        residentialMapFindMarker.toUint8List().then(
          (value) {
            store.dispatch(
              UpdateMarker(
                mapId: state.id,
                markerType: MarkerType.community,
                iconParam: BitmapDescriptor.fromBytes(value!),
                id: marker.id,
                visibleParam: residentialHasMeetRequirement,
                housesParam: residentialHasMeetRequirement
                    ? filteredHousesList
                    : housesList,
              ),
            );
          },
        );
      } else {
        store.dispatch(
          UpdateMarker(
            mapId: state.id,
            markerType: MarkerType.community,
            id: marker.id,
            visibleParam: residentialHasMeetRequirement,
            housesParam:
                residentialHasMeetRequirement ? filteredHousesList : housesList,
          ),
        );
      }
    }
  }

  /// 发送请求拿取房源数据
  Future<void> getAllHouses() async {
    await fetchAllHouse(
      district,
      price1,
      price2,
      rentType,
      rooms,
      metroLine,
      metroStation,
    ).then(
      (value) => {
        houses.clear(),
        houses.addAll(value),

        // debugPrint("fetchAllHouse: $page $_houseCards"),
      },
    );
  }

  @override
  void initState() {
    super.initState();
    selectionView('assets/json/selection.json', callback).then(
      (value) => setState(
        () {
          selection = value;
          selectionInitialized = true;
        },
      ),
    );
  }

  Future _updatePos() async {
    await StorageUtil.getDoubleItem('lat').then((res) async => {
          currentPositionLat = res,
        });
    await StorageUtil.getDoubleItem('lng').then((res) async => {
          currentPositionLng = res,
        });
  }

  Future<void> _updateResidentialMarkersOnTap(Store<MapState> store) async {
    final state = store.state;
    for (var m in state.communityMarkers) {
      store.dispatch(
        UpdateMarker(
          mapId: state.id,
          markerType: MarkerType.community,
          id: m.id,
          onTapParam: (id) => _markerOnTap(id!, store, context),
        ),
      );
    }
  }

  Future<void> _initResidentialMarkers(Store<MapState> store) async {
    final state = store.state;
    // 从后端拿取所有数据
    await getAllHouses();

    // 按照小区名将数据放入 map
    /// 按照小区整理的房源数据
    Map<String, List<RentHouse>> residentialList = {};

    // 清空之前各个区房源套数的统计
    resetDistrictHouseNumCalculation();

    for (var house in houses) {
      // 小区名为空，暂时丢弃不进行渲染
      if (house.residential == "" || house.residential == null) continue;
      // 将该房源加入对应小区
      if (!residentialList.containsKey(house.residential)) {
        // 新建小区条目
        residentialList[house.residential ?? ''] = [];
      }
      residentialList[house.residential]?.add(house);

      // 向对应区增加房源数量
      addHouseByDistrictName(house.district);
    }

    // 渲染小区 widget
    residentialList.forEach(
      (key, value) {
        // 使用第一个房源信息的地理位置代表整个小区
        final house = value[0];
        final residentialMarkerWidget = ResidentialMapFindMarker(
          residential: house.residential ?? '',
          num: value.length,
        );
        HouseMarker(
          onTap: (id) => _markerOnTap(id, store, context),
          position: LatLng(
              double.parse(house.latitude), double.parse(house.longitude)),
          draggable: false,
          houses: value,
        )
            .copyWithWidget(
          widget: residentialMarkerWidget,
        )
            .then(
          (value) {
            store.dispatch(
              AddMarker(
                mapId: state.id,
                markerType: MarkerType.community,
                marker: value,
              ),
            );
            store.dispatch(
              AddMarker(
                mapId: state.id,
                markerType: MarkerType.origin,
                marker: value,
              ),
            );
          },
        );
      },
    );

    // 渲染区 widget
    infoShanghaiDistrict.forEach(
      (key, value) {
        final districtMarkerWidget = DistrictMapFindMarker(
          district: value.name,
          num: getHouseNumByDistrict(key) ?? 0,
        );
        final latLng = LatLng(
          double.parse(
            value.lat,
          ),
          double.parse(
            value.lng,
          ),
        );
        HouseMarker(
          onTap: (id) => {
            store.dispatch(
              MoveCamera(
                mapId: state.id,
                cameraPosition: CameraPosition(
                  target: latLng,
                  zoom: state.zoomSwitch,
                ),
              ),
            ),
          },
          position: latLng,
          draggable: false,
          houses: [],
          visible:
              (key != Shanghai.shangHai) && (districtMarkerWidget.num != 0),
        )
            .copyWithWidget(
          widget: districtMarkerWidget,
        )
            .then(
          (value) {
            store.dispatch(
              AddMarker(
                mapId: state.id,
                markerType: MarkerType.district,
                marker: value,
              ),
            );
            // store.dispatch(
            //   AddMarker(
            //     mapId: state.id,
            //     markerType: MarkerType.origin,
            //     marker: value,
            //   ),
            // );
          },
        );
      },
    );
  }

  void _markerOnTap(String id, Store<MapState> store, BuildContext context) {
    final state = store.state;

    /// 依据 id 从 residentialMarkers 中取出对应 widget
    print("onTap$id");

    /// 建立索引
    final residentialMarkers = keyByHouseMarkerId(state.communityMarkers);

    tappedMarkers[id] = residentialMarkers[id];
    focusingMarkerId = id;
    var residentialMapFindMarker = ResidentialMapFindMarker(
      residential: residentialMarkers[id]?.houses[0].residential ?? '',
      num: residentialMarkers[id]?.houses.length ?? 0,
    );
    residentialMapFindMarker.focus = true;
    residentialMapFindMarker.toUint8List().then(
      (value) {
        store.dispatch(
          UpdateMarker(
            mapId: state.id,
            markerType: MarkerType.community,
            id: id,
            iconParam: BitmapDescriptor.fromBytes(value!),
          ),
        );
      },
    );
    _showHouseDetailListSheet(context, residentialMarkers[id]);
  }

  void _showHouseDetailListSheet(
    BuildContext context,
    HouseMarker? houseMarker,
  ) {
    var housesList = houseMarker?.houses;
    var totalPrice = 0;
    var num = housesList?.length;
    var residential = housesList?[0].residential;
    housesList?.forEach(
      (element) {
        totalPrice += element.price;
      },
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // set this to true
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        // 设置父容器的高度 1 ~ 0, initialChildSize必须 <= maxChildSize
        expand: false,
        builder: (_, controller) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    residential ?? '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle:
                      Text('均价${(totalPrice / num!).toStringAsFixed(2)}元/月 · '
                          '共$num套'),
                  trailing: const Icon(Icons.keyboard_arrow_down),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: controller, // set this too
                    // 长度
                    itemCount: num,
                    itemBuilder: (_, i) => HouseCard(
                      houseDetail: toDetail(
                        housesList?[i].title ?? '',
                        housesList?[i].shi ?? -1,
                        housesList?[i].squares ?? -1,
                        housesList?[i].residential ?? '',
                        housesList?[i].price ?? -1,
                        housesList?[i].firstPicUrl ?? '',
                        housesList?[i].latitude ?? '0',
                        housesList?[i].longitude ?? '0',
                        housesList?[i].location ?? "",
                        housesList?[i].id ?? "",
                        housesList?[i].layout ?? "nothing",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _updateMarkersInPolygon(Store<MapState> store) {
    // 建立本次多边形中 markers 的 id 与 相关信息的索引
    late final markersInPolygonMap;
    final state = store.state;

    switch (state.mapStatus) {
      case MapStatus.drawing:
      case MapStatus.drawn:
        markersInPolygonMap = keyByHouseMarkerId(
          state.markersInDrawingPolygon,
        );
        break;

      case MapStatus.normal:
        markersInPolygonMap = {};
        break;
      case MapStatus.selecting:
      case MapStatus.selected:
      case MapStatus.recommending:
        markersInPolygonMap = keyByHouseMarkerId(
          state.markersInReachingPolygon,
        );
        break;
    }

    /// 建立索引
    final residentialMarkers = keyByHouseMarkerId(
      state.communityMarkers,
    );

    // 将上一次在圈内，这一次不在圈内的恢复原样
    for (final id in markersIdInPolygon) {
      if (!markersInPolygonMap.containsKey(id)) {
        final residentialMapFindMarker = ResidentialMapFindMarker(
          residential: residentialMarkers[id]?.houses[0].residential ?? '',
          num: residentialMarkers[id]?.houses.length ?? 0,
        );
        residentialMapFindMarker.inPolygon = false;
        residentialMapFindMarker.toUint8List().then(
          (value) {
            store.dispatch(
              UpdateMarker(
                mapId: state.id,
                markerType: MarkerType.community,
                id: id,
                iconParam: BitmapDescriptor.fromBytes(value!),
              ),
            );
          },
        );
      }
    }

    // 遍历这一次在圈内的
    markersInPolygonMap.forEach(
      (residentialMarkerId, value) {
        // 上一次不在圈内
        if (!markersIdInPolygon.contains(residentialMarkerId)) {
          var residentialMapFindMarker = ResidentialMapFindMarker(
            residential: markersInPolygonMap[residentialMarkerId]
                    ?.houses[0]
                    .residential ??
                '',
            num: markersInPolygonMap[residentialMarkerId]?.houses.length ?? 0,
          );
          residentialMapFindMarker.inPolygon = true;
          residentialMapFindMarker.toUint8List().then(
            (value) {
              store.dispatch(
                UpdateMarker(
                  mapId: state.id,
                  markerType: MarkerType.community,
                  id: residentialMarkerId,
                  iconParam: BitmapDescriptor.fromBytes(value!),
                ),
              );
            },
          );
        }
      },
    );

    // 更新圈内 id 集合
    markersIdInPolygon.clear();
    markersInPolygonMap.forEach(
      (
        residentialMarkerId,
        value,
      ) {
        markersIdInPolygon.add(residentialMarkerId);
      },
    );
  }

  Widget buildOperations(Store<MapState> store) {
    final state = store.state;
    switch (state.mapStatus) {
      case MapStatus.recommending:
        return buildRecommendingOperations(store);
      case MapStatus.normal:
        return buildNormalOperations(store);
      case MapStatus.drawing:
      case MapStatus.drawn:
        return buildDrawingOperations(store);
      case MapStatus.selecting:
      case MapStatus.selected:
        return buildSelectingOperations(store);
    }
  }

  Widget buildDrawingOperations(Store<MapState> store) {
    final state = store.state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '重画',
          iconWidget: const Icon(Icons.gesture),
          onTap: () {
            // _resetAllMarkersInPolygon(store);
            final state = store.state;
            if (state.cameraPosition.zoom < state.zoomSwitch) {
              store.dispatch(
                MoveCamera(
                  mapId: state.id,
                  cameraPosition: CameraPosition(
                    target: state.cameraPosition.target,
                    zoom: state.zoomSwitch,
                  ),
                ),
              );
            }
            store.dispatch(
              ClearDrawingPolygon(
                mapId: state.id,
              ),
            );
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.drawing,
              ),
            );
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '退出',
          iconWidget: const Icon(Icons.arrow_back),
          onTap: () {
            // _resetAllMarkersInPolygon(store);

            store.dispatch(
              ClearDrawingPolygon(
                mapId: state.id,
              ),
            );
            store.dispatch(
              CheckCommunityMarkersInPolygon(
                mapId: state.id,
              ),
            );
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildRecommendingOperations(Store<MapState> store) {
    final state = store.state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '退出',
          iconWidget: const Icon(Icons.arrow_back),
          onTap: () {
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.normal,
              ),
            );
            store.dispatch(
              CheckCommunityMarkersInPolygon(
                mapId: state.id,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildSelectingOperations(Store<MapState> store) {
    final state = store.state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '重选',
          iconWidget: const Icon(
            Icons.pan_tool_alt_outlined,
          ),
          onTap: () {
            // _resetAllMarkersInPolygon(store);
            final state = store.state;
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.selecting,
              ),
            );
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '退出',
          iconWidget: const Icon(Icons.arrow_back),
          onTap: () {
            store.dispatch(
              CheckCommunityMarkersInPolygon(
                mapId: state.id,
              ),
            );
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.normal,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildNormalOperations(Store<MapState> store) {
    final state = store.state;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '画区域',
          iconWidget: const Icon(Icons.gesture),
          onTap: () {
            BrnToast.show('请在地图上绘制区域', context);
            final state = store.state;
            if (state.cameraPosition.zoom < state.zoomSwitch) {
              store.dispatch(
                MoveCamera(
                  mapId: state.id,
                  cameraPosition: CameraPosition(
                    target: state.cameraPosition.target,
                    zoom: state.zoomSwitch,
                  ),
                ),
              );
            }
            store.dispatch(
              ClearDrawingPolygon(mapId: state.id),
            );
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.drawing,
              ),
            );
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '通勤',
          iconWidget: const Icon(
            Icons.alarm_outlined,
          ),
          onTap: () {
            BrnToast.show('请选择通勤起点', context);
            final state = store.state;
            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.selecting,
              ),
            );
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '推荐',
          iconWidget: const Icon(
            Icons.recommend,
          ),
          onTap: () async {
            BrnToast.show('算法向您推荐的周边房源将突出显示', context);
            final state = store.state;
            await _updatePos();
            final currentPosition = LatLng(
              currentPositionLat,
              currentPositionLng,
            );
            store.dispatch(SetMapStatus(
              mapId: state.id,
              mapStatus: MapStatus.recommending,
            ));
            store.dispatch(
              MoveCamera(
                mapId: state.id,
                cameraPosition: CameraPosition(
                  target: currentPosition,
                  zoom: state.cameraPosition.zoom,
                ),
              ),
            );
            store.dispatch(
              SetReachingCenter(
                mapId: state.id,
                reachingCenter: currentPosition,
              ),
            );
            fetchReachCircle(
              centerPosition: currentPosition,
              minutes: '20',
            ).then(
              (reachCircle) {
                store.dispatch(
                  SetReachingPolygon(
                    mapId: state.id,
                    reachingPolygon: reachCircle.polylines
                        .map(
                          (e) => Polygon(
                            points: convertPolylineStr2Points(
                              e.outer,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                );
                store.dispatch(
                  CheckCommunityMarkersInPolygon(
                    mapId: state.id,
                  ),
                );
              },
            );
          },
        ),
        BrnIconButton(
          widgetHeight: 60,
          widgetWidth: 40,
          name: '定位',
          iconWidget: const Icon(Icons.my_location),
          onTap: () async {
            await _updatePos();
            store.dispatch(
              MoveCamera(
                mapId: state.id,
                cameraPosition: CameraPosition(
                  target: LatLng(
                    currentPositionLat,
                    currentPositionLng,
                  ),
                  zoom: state.cameraPosition.zoom,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StoreBuilder<MapState>(
          onInit: (store) {
            final state = store.state;
            if (state.communityMarkers.isEmpty) {
              _initResidentialMarkers(
                store,
              );
            } else {
              _updateResidentialMarkersOnTap(
                store,
              );
              selectionChanged = true;
            }
            store.dispatch(
              UpdateCameraPosition(
                mapId: state.id,
                cameraPosition: const CameraPosition(
                  // 初始化至上海市
                  target: LatLng(
                    31.2382,
                    121.4913,
                  ),
                  zoom: 15,
                ),
              ),
            );
          },
          onDispose: (store) {
            final state = store.state;

            store.dispatch(
              SetMapStatus(
                mapId: state.id,
                mapStatus: MapStatus.normal,
              ),
            );
            store.dispatch(
              ClearDrawingPolygon(
                mapId: state.id,
              ),
            );
            store.dispatch(
              CheckCommunityMarkersInPolygon(
                mapId: state.id,
              ),
            );
            _updateMarkersInPolygon(
              store,
            );
          },
          builder: (
            context,
            store,
          ) {
            _updateMarkersInPolygon(
              store,
            );
            if (selectionChanged) {
              updateFilteredHouse(
                store,
              );
              selectionChanged = false;
            }
            // final state = store.state;
            // final mapStatus = state.mapStatus;
            return MaterialApp(
              home: Scaffold(
                appBar: store.state.mapStatus == MapStatus.recommending
                    ? AppBar(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "周边推荐",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        centerTitle: true,
                        titleSpacing: 0.0,
                      )
                    : AppBar(
                        backgroundColor: Colors.white,
                        title: selectionInitialized ? selection : Container(),
                        centerTitle: true,
                        titleSpacing: 0.0,
                      ),
                body: StoreProvider(
                  store: store,
                  child: Stack(
                    children: [
                      MapWidget(),
                      Positioned(
                        top: 25,
                        right: 20,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(
                                20.0,
                              ),
                            ),
                          ),
                          child: buildOperations(
                            store,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
